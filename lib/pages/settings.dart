import 'package:charger/authenntication/utils.dart';
import 'package:charger/authenntication/log_in.dart';
import 'package:charger/pages/icons_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_settings_screens/flutter_settings_screens.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';




class Settings extends StatefulWidget {
  static const keyLocation = 'key-location';
  static const keyPassword = 'key-password';
  const Settings({super.key});

  @override
  State<Settings> createState() => _SettingsState();

  static init({required cacheProvider}) {}
}

class _SettingsState extends State<Settings> {
  File? _profileImage;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadProfileImage();
    updateLocation();
  }

  Future<void> updateLocation() async {
    setState(() {});
  }

   Future<String> getCurrentLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      //Get readable address from coordinates
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      Placemark placemark = placemarks[0];
      return '${placemark.name}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.administrativeArea}, ${placemark.country}';
    } catch (e) {
      print(e);
      return 'Location not available';
    }
  }

  Future<void> _loadProfileImage() async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.png';
    final File imageFile = File(imagePath);
    if (await imageFile.exists()) {
      setState(() {
        _profileImage = imageFile;
      });
    }
  }

  Future<void> _selectImage() async {
    final XFile? selectedImage = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage != null) {
      final File imageFile = File(selectedImage.path);
      final String imagePath = await saveImageToLocalStorage(imageFile);
      setState(() {
        _profileImage = File(selectedImage.path);
      });
    }
  }

  Widget buildLogout() => SimpleSettingsTile(
    title: 'Log out',
    subtitle: '',
    leading: IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Logout'),
              content: const Text('Are you sure you want to Logout?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () =>
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => LogIn(
                            onClickedSignUp: () {
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Sign-up button clicked')));
                            },
                          ))),
                  child: const Text('Yes'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.logout,
      ),
      color: Colors.orangeAccent,
    ),
  );
  Widget buildLocation() {
    return FutureBuilder<String>(
        future: getCurrentLocation(),
        builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
          if (snapshot.hasData) {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Location:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    snapshot.data!,
                    style: const TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          } else {
            return Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const CircularProgressIndicator(),
            );
          }
        });
  }

  Widget buildDeleteAccount() => SimpleSettingsTile(
    title: 'Delete Account',
    subtitle: '',
    leading: IconButton(
      onPressed: () {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Delete Account'),
              content: const Text(
                  'Are you sure you want to delete your account?'),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () async {
                    try {
                      await FirebaseAuth.instance.currentUser!.delete();
                      // Account deleted successfully
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                    } catch (e) {
                      // Error occurred while deleting account
                      print(e.toString());
                    }
                  },
                  child: const Text('Delete'),
                ),
              ],
            );
          },
        );
      },
      icon: const Icon(
        Icons.delete,
      ),
      color: Colors.red,
    ),
  );
  Future<void> _updatePassword(String newPassword) async {
    try {
      final user = FirebaseAuth.instance.currentUser!;
      await user.updatePassword(newPassword);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
    } on FirebaseAuthException catch (e) {
      print(e.message);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating password: ${e.message}')),
      );
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('An unknown error occurred')));
    }
  }

  Future<String> saveImageToLocalStorage(File imageFile) async {
    final directory = await getApplicationDocumentsDirectory();
    final imagePath = '${directory.path}/profile_image.png';
    await imageFile.copy(imagePath);
    return imagePath;
  }

  Widget buildPassword() {
    final TextEditingController passwordController = TextEditingController();
    return Container(
      padding: EdgeInsets.all(10),
      child: ListTile(
        title: const Text('Change Password'),
        subtitle: TextFormField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(
            labelText: 'New Password',
            hintText: 'Enter new password',
          ),
        ),
        trailing: IconButton(
          onPressed: () {
            if (passwordController.text.isNotEmpty &&
                passwordController.text.length >= 6) {
              _updatePassword(passwordController.text);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Please enter a valid new password')));
            }
          },
          icon: const Icon(
            Icons.save,
            color: Colors.blue,
          ),
        ),
      ),
    );
  }

  Widget buildAccountInfo(context) => SimpleSettingsTile(
    title: 'Account info',
    subtitle: '',
    leading: IconWidget(
      icon: Icons.text_snippet,
      color: Colors.purple,
      onPressed: () async {
        Utils.showSnackBar(
          context as String?,
        );
      },
    ),
  );

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    return Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.blue,
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: GestureDetector(
            child: SingleChildScrollView(
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(
                          'assets/dtb.jpg',
                        ),
                        fit: BoxFit.cover,
                      ),
                    ),
                    padding: const EdgeInsets.only(top: 2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: _selectImage,
                          child: CircleAvatar(
                            radius: 40,
                            backgroundImage: _profileImage != null
                                ? FileImage(_profileImage!)
                                : null,
                            child: _profileImage == null
                                ? const Icon(Icons.person, size: 40)
                                : null,
                          ),
                        ),
                        const Text(
                          'Signed In as',
                          style: TextStyle(fontSize: 16),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          user.email!,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        SettingsGroup(
                          title: 'GENERAL',
                          titleTextStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <Widget>[
                            const SizedBox(height: 6),
                            buildLocation(),
                            const SizedBox(height: 6),
                            buildLogout(),
                            const SizedBox(height: 6),
                            buildDeleteAccount(),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        SettingsGroup(
                          title: 'SECURITY',
                          titleTextStyle: const TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          children: <Widget>[
                            const SizedBox(
                              height: 2,
                            ),
                            const SizedBox(height: 5),
                            buildPassword(),
                            const SizedBox(height: 6),
                            buildAccountInfo(context),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }
}
