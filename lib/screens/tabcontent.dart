// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:storem/helper/helper.dart';
// import 'package:storem/screens/urlThumbnail.dart';
// import '../database_DB/dbcontroller.dart';
//
// class TabContent extends StatelessWidget {
//   final String category;
//   final String uid;
//   final VoidCallback updateState;
//
//   const TabContent(
//       {Key? key,
//       required this.category,
//       required this.uid,
//       required this.updateState})
//       : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<QuerySnapshot>(
//         future: DB.fetchItems(uid, category),
//         builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//           if (snapshot.hasError) {
//             print(snapshot.error);
//             return Center(
//               child: Text('Error: ${snapshot.error}'),
//             );
//           }
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           }
//           // If there are no documents found
//           if (snapshot.data!.docs.isEmpty) {
//             return Center(
//               child: Text('No Content'),
//             );
//           }
//           return GridView.builder(
//             itemCount: snapshot.data!.docs.length, // Number of grid items
//             gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//               crossAxisCount: MediaQuery.of(context).size.width > 600
//                   ? 3
//                   : 2, // Number of columns in the grid
//               mainAxisSpacing: 16.0, // Spacing between rows
//               crossAxisSpacing: 16.0, // Spacing between columns
//               childAspectRatio: 1.0, // Aspect ratio (square boxes)
//             ),
//             padding: EdgeInsets.all(8),
//             itemBuilder: (context, index) {
//               Map<String, dynamic> data =
//                   snapshot.data!.docs[index].data() as Map<String, dynamic>;
//               return SizedBox(
//                   height: 350,
//                   child: Container(
//                     child: Card(
//                         color: Color(0xFFFBBB8F),
//                         child: Column(
//                           children: <Widget>[
//                             SizedBox(
//                               height: 120,
//                               width: double.infinity,
//                               child: URLThumbnail(data["url"],
//                                   data["thumbnailUrl"], data["title"]),
//                             ),
//                             SizedBox(
//                               height: 5,
//                             ),
//                             Text(data["title"],
//                                 maxLines: 1, overflow: TextOverflow.ellipsis),
//                             SizedBox(
//                               height: 10,
//                               child:Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.more_horiz),
//                                     onPressed: () {
//                                       print("onTap triggered!"); // Debugging
//                                       _showShare(context, data["url"], uid, data["id"]);
//                                     },
//                                   ),
//                                 ],
//                               ),
//
//                               // ButtonBar(
//                               //   buttonMinWidth: 0,
//                               //   alignment: MainAxisAlignment.end,
//                               //   children: <Widget>[
//                               //     GestureDetector(
//                               //       child: Icon(Icons.more_horiz),
//                               //       onTap: () {
//                               //         _showShare(context, data["url"], uid,
//                               //             data["id"]);
//                               //       },
//                               //     ),
//                               //   ],
//                               // ),
//                             ),
//                             // SizedBox(
//                             //   height: 10,
//                             //   child: IconButton(
//                             //       onPressed: () {
//                             //         _showShare(
//                             //             context, data["url"], uid, data["id"]);
//                             //       },
//                             //       icon: Icon(Icons.more_horiz_rounded)),
//                             // )
//                           ],
//                         )),
//                   ));
//             },
//           );
//         });
//   }
//
//   void _showShare(BuildContext context, String url, String uid, String id) {
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//     showModalBottomSheet(
//         context: context,
//         backgroundColor: Color(0xFFFBBB8F),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
//         ),
//         builder: (BuildContext context) {
//           return Container(
//             width: double.infinity,
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: <Widget>[
//                 ListTile(
//                   leading: Icon(Icons.copy, color: Color(0xFF44140F)),
//                   title: Text(
//                     'Copy',
//                     style: TextStyle(
//                         fontWeight: FontWeight.bold, color: Color(0xFF44140F)),
//                   ),
//                   onTap: () {
//                     Helper.copyToClipboard(url);
//                     Helper.showSnackbar(context, "Copied!!!");
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.share, color: Color(0xFF44140F)),
//                   title: Text('Share',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF44140F))),
//                   onTap: () async {
//                     ShareResult sr = await Helper.share(url);
//                     if (sr.status == ShareResultStatus.success) {
//                       Helper.showSnackbar(context, "Shared!!!");
//                     }
//                     Navigator.pop(context);
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(
//                     Icons.delete,
//                     color: Color(0xFF44140F),
//                   ),
//                   title: Text('Delete',
//                       style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Color(0xFF44140F))),
//                   onTap: () async {
//                     await DB.deleteItem(uid, id);
//                     Helper.showSnackbar(context, "Deleted!!!");
//                     updateState();
//                     Navigator.pop(context);
//                   },
//                 ),
//               ],
//             ),
//           );
//         });
//     });
//         }
// }


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:storem/helper/helper.dart';
import 'package:storem/screens/urlThumbnail.dart';
import '../database_DB/dbcontroller.dart';

class TabContent extends StatelessWidget {
  final String category;
  final String uid;
  final VoidCallback updateState;

  const TabContent({
    Key? key,
    required this.category,
    required this.uid,
    required this.updateState,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('items')
            .where('userId', isEqualTo: uid)  // Ensure 'uid' exists in Firestore
            .where('category', isEqualTo: category)
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    //return FutureBuilder<QuerySnapshot>(
     // future: DB.fetchItems(uid, category),
    //  builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          print(snapshot.error);
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(child: Text('No Content'));
        }

        return GridView.builder(
          itemCount: snapshot.data!.docs.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: MediaQuery.of(context).size.width > 600 ? 3 : 2,
            mainAxisSpacing: 16.0,
            crossAxisSpacing: 16.0,
            childAspectRatio: 1.0,
          ),
          padding: EdgeInsets.all(8),
          itemBuilder: (context, index) {
            Map<String, dynamic> data =
            snapshot.data!.docs[index].data() as Map<String, dynamic>;
            return SizedBox(
              height: 350,
              child: Card(
                //color: Color(0xFFFBBB8F),
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
                          IconButton(
                            icon: Icon(Icons.edit, color:Colors.white,),
                            onPressed: () {
                              print("Three dots clicked!");
                              _showEditTitleDialog(context, data["id"], data["title"]);                              //_showShare(context, data["url"], uid, data["id"]);
                            },
                          ),
                          IconButton(
                            icon: Icon(Icons.more_horiz, color: Colors.white,),
                            onPressed: () {
                              print("Three dots clicked!"); // Debugging
                              _showShare(context, data["url"], uid, data["id"]);
                            },
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
  void _showShare(BuildContext context, String url, String uid, String id) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!context.mounted) return; // Prevents calling after unmount
      showModalBottomSheet(
        context: context,
       // backgroundColor: Color(0xFFFBBB8F),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return Container(
            width: double.infinity,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.copy , color: Colors.white),
                  title: Text(
                    'Copy Link',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () {
                    Helper.copyToClipboard(url);
                    Helper.showSnackbar(context, "Link copied to clip board!!!");
                    //Helper.showSnackbar(context, "Copied!!!");
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.share, color: Colors.white),
                  title: Text(
                    'Share',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  onTap: () async {
                    ShareResult sr = await Helper.share(url);
                    if (sr.status == ShareResultStatus.success) {
                      Helper.showSnackbar(context, "Shared!!!");
                    }
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: Icon(Icons.delete, color: Colors.white),
                  title: Text(
                    'Delete',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color:Colors.white),
                  ),
                  onTap: () async {
                    // await DB.deleteItem(uid, id);
                    //  Helper.showSnackbar(context, "Deleted!!!");
                    // updateState();
                     Navigator.pop(context);
                    _showDeleteConfirmationDialog(context,uid,id);
                  },
                ),
              ],
            ),
          );
        },
      );
    });
  }
  void _showDeleteConfirmationDialog(BuildContext context, String uid, String id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          //backgroundColor: Color(0xFFFBBB8F),
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel',style: TextStyle(color: Colors.white),),
            ),
            TextButton(
              child: const Text('Delete',style: TextStyle(color: Colors.red),),
              onPressed: () async {
                Navigator.pop(context);
                _handleDeleteResult(context);
                await DB.deleteItem(uid, id);
                //Helper.showSnackbar(context, "Deleted!!!");
                updateState();
              },
            ),
          ],
        );
      },
    );
  }
  void _handleDeleteResult(context) {
    // Successfully deleted
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.check_circle,
                color: Colors.green,
                size: 60,
              ),
              const SizedBox(height: 16),
              const Text(
                "Deleted successfully",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(50),
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
  void _showEditTitleDialog(BuildContext context, String id, String currentTitle) {
    TextEditingController _titleController = TextEditingController(text: currentTitle);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          //backgroundColor: Color(0xFFFBBB8F),
          title: const Text("Edit Title"),
          content: TextField(
            controller: _titleController,
            decoration: const InputDecoration(
              hintText: "Enter new title",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              //style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF44140F)),
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.white)),
            ),
            ElevatedButton(
              //style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF44140F)),
              onPressed: () async {
                String newTitle = _titleController.text.trim();
                if (newTitle.isEmpty || newTitle == currentTitle) {
                  Navigator.pop(context);
                  return; // Do nothing if empty or unchanged
                }

                await FirebaseFirestore.instance.collection('items')
                    .doc(id)
                    .update({"title": newTitle}); // Update Firestore

                Navigator.pop(context); // Close dialog
              },
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

}



