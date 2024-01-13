import 'package:charger/authenntication/table_screen.dart';
import 'package:charger/main.dart';
import 'package:charger/pages/home_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import './stream_value.dart';
import './settings.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final items = const [
    Icon(Icons.view_list_sharp, size: 30),
    Icon(Icons.settings, size: 30),
  ];

  int index = 1;
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
          appBar: AppBar(
            title: const Text('Smart Charger'),
            backgroundColor: Colors.blueAccent,
            actions: [
              // Add your buttons here
              IconButton(
                icon: const Icon(Icons.view_list_sharp),
                onPressed: () {
                  // Navigate to Screen1
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => TableScreen() ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.settings),
                onPressed: () {
                  // Navigate to Screen2
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Settings()),
                  );
                },
              ),
            ],
          ),

          body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: GestureDetector(
                  child: Stack(children: <Widget>[
                    Container(
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage(
                              'assets/cool.jpeg',
                            ),
                            fit: BoxFit.cover,
                          ),
                        ),
                        padding: const EdgeInsets.only(top: 50),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(children: [
                                Expanded(
                                  flex: 6,
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 150,
                                    decoration: const BoxDecoration(
                                        image: DecorationImage(
                                            image:
                                            AssetImage('assets/carbatt.jpeg'),
                                            fit: BoxFit.contain)),
                                  ),
                                ),
                                const Expanded(
                                    flex: 5,
                                    child: Text(
                                      'Welcome! '
                                          'Monitor the lifespan of your battery'
                                          ' wherever and whenever you are.',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    )),
                              ]),
                              const Spacer(
                                flex: 2, // <-- SEE HERE
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(25.0),
                                    child: Text(
                                      '% Charge ',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                      child: Container(
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                width: 4.0),
                                            borderRadius: BorderRadius.circular(16),
                                          ),
                                          height: 50,
                                          child: const Center(
                                            child: StreamData(),
                                          ))),
                                  const SizedBox(
                                    width: 50,
                                  )
                                ],
                              ),
                              const Spacer(
                                flex: 1, // <-- SEE HERE
                              ),
                              Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(20.0),
                                    child: Text(
                                      'Estimated time left',
                                      style: TextStyle(
                                        color: Colors.black87,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 50,
                                  ),
                                  Expanded(
                                    child: Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                              color: Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                              width: 4.0),
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                        height: 50,
                                        child: const Center(
                                          child: Text('0300hrs'),
                                        )),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const Spacer(
                                flex: 2, // <-- SEE HERE
                              ),
                            ]

                            )
                    ),

                  ]

                  )
              )
          ),


      );





  }
}