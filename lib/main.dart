import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:storem/database_DB/dbcontroller.dart';
import 'package:storem/helper/helper.dart';
import 'package:storem/screens/profile.dart';
import 'package:storem/screens/tabcontent.dart';
import 'package:storem/screens/urlData.dart';
import 'package:storem/screens/urlThumbnail.dart';
import 'database_DB/firebase_options.dart';
import 'screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
   // const Color myCustomColor = Color(0xFFFBBB8F);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Storem App',
      theme: ThemeData(
          //scaffoldBackgroundColor: myCustomColor,
          //brightness: Brightness.light,
          brightness: Brightness.dark,
          primaryColor: Colors.black,
          textTheme: TextTheme(labelLarge: TextStyle(color: Colors.black))),
      home: const MyHomePage(title: 'StoreM'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  int _counter = 0;
  String? _selectedItem = "Entertainment";
  List<Widget> tiles = [];
  User? _currentUser;
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _titleFieldTitleController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();
  List<Tab> tabs = DB.getCategories().map((title) {
    return Tab(
      text: title,
    );
  }).toList();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) => _checkCurrentUser());
    WidgetsBinding.instance?.addObserver(this);
    // ReceiveSharingIntent.instance.getMediaStream().listen((value) {
    //   print(value);
    // });
    // ReceiveSharingIntent.instance.getInitialMedia().then((value){
    //   print(value);
    // });
  }

  @override
  void dispose() {
    // Remove the observer when the state is disposed
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    // Handle app lifecycle state changes
    switch (state) {
      case AppLifecycleState.resumed:
        String? cdata = await Helper.getClipboardData();
        if (cdata != null && cdata.isNotEmpty) {
          //_showCreate();
          _textFieldController.text = cdata;
        }
        print('App resumed');
        break;
      case AppLifecycleState.paused:
        // App paused
        print('App paused');
        break;
      case AppLifecycleState.inactive:
        // App inactive
        print('App inactive');
        break;
      case AppLifecycleState.detached:
        // App detached
        print('App detached');
        break;
      case AppLifecycleState.hidden:
        print('App hidden');
        break;
    }
  }
  Future<void> _checkCurrentUser() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = await auth.currentUser;
    print(_currentUser);
    if (_currentUser == null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    }
    setState(() {});
  }
  void _showCreate() {
    bool _isloading = false;
    List<DropdownMenuItem<String>> categories =
        DB.getCategories().map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      );
    }).toList();
    showModalBottomSheet<void>(
        //backgroundColor: Color(0xFFFBBB8F),
        isScrollControlled: true,
        context: context,
        builder: (
          context,
        ) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    //height:400,
                    padding: EdgeInsetsDirectional.all(20),
                    //child: Align(
                    //  alignment: Alignment.topCenter,
                    child: Container(
                        child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    leading: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                        _textFieldController.text = "";
                                        _titleFieldTitleController.text = "";
                                        _selectedItem = "Entertainment";
                                      },
                                      child: Icon(Icons.close,
                                          color: Colors.white),
                                    ),
                                    title: Text('Add Media',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        )),
                                    trailing: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.red),
                                      icon: _isloading
                                          ? SizedBox(
                                              height: 24,
                                              width: 24,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ))
                                          : Icon(Icons.save,
                                              color: Colors.white),
                                      onPressed: () async {
                                        setState(() {
                                          _isloading = true;
                                        });
                                        await save(_textFieldController.text,
                                            _titleFieldTitleController.text);
                                        setState(() {
                                          _isloading = false;
                                        });
                                      },
                                      label: Text("Save",
                                          style:
                                              TextStyle(color: Colors.white)),
                                    )),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  keyboardType: TextInputType.url,
                                  maxLines: 1,
                                  controller: _textFieldController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.add_link,
                                       // color: Color(0xFF44140F),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: "Url",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      errorStyle:
                                          TextStyle(
                                              color: Colors.red
                                          )),
                                  validator: (value) {
                                    if (value == null ||
                                        value.isEmpty ||
                                        Uri.parse(value).host.isNotEmpty ==
                                            false) {
                                      return 'Please enter a valid URL';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                TextFormField(
                                  maxLines: 1,
                                  controller: _titleFieldTitleController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.title,
                                        //color: Color(0xFF44140F),
                                      ),
                                      border: OutlineInputBorder(),
                                      labelText: "Title",
                                      labelStyle:
                                          TextStyle(color: Colors.white),
                                      errorStyle:
                                          TextStyle(color: Colors.red)),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter a title!';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                DropdownButtonFormField<String>(
                                  isExpanded: true,
                                  value: _selectedItem,
                                  hint: Text('Select One'),
                                  items: categories,
                                  onChanged: (String? newValue) {
                                    _onSelectedItemChanged(newValue, setState);
                                  },
                                  icon: Icon(Icons.arrow_drop_down),
                                  //underline: SizedBox(),
                                  dropdownColor: Colors.black,
                                  borderRadius: BorderRadius.circular(20),
                                  focusColor: Color(0xFF44140F),

                                  decoration: InputDecoration(
                                      errorStyle:
                                          TextStyle(color: Colors.red)),
                                  validator: (value) {
                                    print(value);
                                    if (value == null || value.isEmpty) {
                                      return 'Please enter some text';
                                    }
                                    return null;
                                  },
                                ),
                                SizedBox(height: 10),
                              ],
                            )))
                    // ),
                    ));
          });
        });
  }
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          //backgroundColor: Color(0xFF44140F),
          actions: [
            IconButton(
              onPressed: () async {
                showSearch(context: context, delegate: MySearchDelegate(_currentUser?.uid ?? 'guest'));
              },
              icon: Icon(
                Icons.search,
                color: Colors.white,
                size: 30,
              ),
            ),
            IconButton(
              onPressed: () async {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AccountSettingsScreen()));
              },
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
                size: 30,
              ),
            ),
          ],
          centerTitle: true,
          title: Text(
            'Hello ${_currentUser?.displayName ?? 'Guest'}',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          // title: Text('Hello ' + _currentUser!.displayName!),
          bottom: TabBar(
            isScrollable: true,
            labelColor: Colors.red,
            //labelColor: Color(0xFFFBBB8F),
            labelStyle: TextStyle(fontSize: 22),
            indicatorSize: TabBarIndicatorSize.label,
            unselectedLabelColor: Colors.white,
            indicatorColor: Colors.amber[500],
            //indicatorColor: Color(0xFFFBBB8F),
            tabs: tabs,
            onTap: (index) {
              setState(() {
                _selectedIndex = index; // Update selected tab index
              });
            },
          ),
        ),
        body: TabBarView(
          children: DB
              .getCategories()
              .map((title) => TabContent(
                    category: title,
                    uid: _currentUser?.uid ?? 'guest', // Use a default value
                    updateState: updateState,
                  ))
              .toList(),



          //children: DB.getCategories().map((title) => TabContent(category: title, uid:_currentUser!.uid, updateState: updateState,)).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          //backgroundColor: Color(0xFF44140F),
          backgroundColor: Colors.red,
          shape: CircleBorder(),
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          onPressed: () {
            _showCreate();
          },
        ),
      ),
    );
  }
  void updateState() {
    setState(() {});
  }
  Future<void> save(String url, String title) async {
    final isValidate = _formKey.currentState!.validate();
    if (isValidate) {
      // Assign "guest" as the default user if _currentUser is null
      String userId = _currentUser?.uid ?? "guest";

      UrlData urlData = await UrlData.fetchThumbnailUrl(url);
      await DB.SaveItem(
          url, title, urlData.base64Image, _selectedItem!, userId);
      // await DB.SaveItem(url, title, urlData.thumbnailUrl, _selectedItem!, userId);

      setState(() {
        _textFieldController.text = "";
        _titleFieldTitleController.text = "";
        _selectedItem = "Entertainment";
      });

      Navigator.of(context).pop();
    }
  }
  void _onSelectedItemChanged(String? newValue, StateSetter setState) {
    _selectedItem = newValue;
    setState(() {
      print(newValue);
      _selectedItem = newValue;
    });
  }
}


class MySearchDelegate extends SearchDelegate {
  User? _currentUser;
  final String uid; // Store user ID

  MySearchDelegate(this.uid);

  //checkCurrentUserdata();
  Future<void> checkCurrentUserdata() async {
    final FirebaseAuth auth = FirebaseAuth.instance;
    _currentUser = await auth.currentUser;
    print(_currentUser);
    if (_currentUser == null) {
    }
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          if (query.isEmpty) {
            close(context, null);
          } else {
            query = "";
          }
        },
        icon: Icon(Icons.clear, color: Colors.white),
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      onPressed: () => close(context, null),
      icon: Icon(Icons.arrow_back_outlined),
    );
  }
  @override
  Widget buildResults(BuildContext context) {
    return FutureBuilder<QuerySnapshot>(
      future: FirebaseFirestore.instance
          .collection('items')
          .where('userId', isEqualTo: uid)
          .get(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));

        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final List<QueryDocumentSnapshot> filteredDocs = snapshot.data!.docs
            .where((doc) {
          final title = doc['title']?.toString().toLowerCase() ?? '';
          return title.contains(query.toLowerCase());
        }).toList();

        if (filteredDocs.isEmpty) {
          return Center(child: Text('No results found'));
        }

        return GridView.builder(
          itemCount: filteredDocs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
            filteredDocs[index].data() as Map<String, dynamic>;
            return SizedBox(
              height: 350,
              child: Card(
                color: Colors.black,
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 120,
                      width: double.infinity,
                      child: URLThumbnail(
                        data["url"],
                        data["thumbnailbase64img"] ?? data["thumbnailUrl"] ?? "",
                        data["title"],
                      ),
                    ),
                    SizedBox(height: 5),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data["title"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }


  // @override
  // Widget buildResults(BuildContext context) {
  //   return StreamBuilder<QuerySnapshot>(
  //     stream: FirebaseFirestore.instance.collection('items')
  //         .where('userId', isEqualTo: uid)
  //         .where('title', isGreaterThanOrEqualTo: query)
  //         //.where('title', isLessThanOrEqualTo: query + '\uf8ff')// Ensure 'uid' exists in Firestore
  //         .snapshots(),
  //     builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
  //       if (snapshot.hasError) {
  //         print(snapshot.error);
  //         return Center(child: Text('Error: ${snapshot.error}'));
  //       }
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       }
  //       if (snapshot.data!.docs.isEmpty) {
  //         return Center(child: Text('No Content'));
  //       }
  //
  //       return GridView.builder(
  //         itemCount: snapshot.data!.docs.length,
  //         gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
  //           crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
  //           mainAxisSpacing: 16.0,
  //           crossAxisSpacing: 16.0,
  //           childAspectRatio: 1.0,
  //         ),
  //         padding: EdgeInsets.all(8),
  //         itemBuilder: (context, index) {
  //           Map<String, dynamic> data =
  //           snapshot.data!.docs[index].data() as Map<String, dynamic>;
  //           return SizedBox(
  //             height: 350,
  //             child: Card(
  //               color: Colors.black,
  //               child: Column(
  //                 children: <Widget>[
  //                   SizedBox(
  //                     height: 120,
  //                     width: double.infinity,
  //                     child: URLThumbnail(
  //                       data["url"],
  //                       data["thumbnailUrl"] ?? data["thumbnailbase64img"] ?? " ",
  //                       data["title"],
  //                     ),
  //                   ),
  //                   SizedBox(height: 5),
  //                   Padding(
  //                     padding: const EdgeInsets.symmetric(horizontal: 8.0),
  //                     child: Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Expanded(
  //                           child: Text(
  //                             data["title"],
  //                             maxLines: 1,
  //                             overflow: TextOverflow.ellipsis,
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                   ),
  //                 ],
  //               ),
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }

  @override
  Widget buildSuggestions(BuildContext context) {
    return Container(); // You can modify this if you need suggestions
  }
}
