import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class DB {
  static List<String> getCategories() {
    return ["Entertainment", "Food", "Sports & Fitness", "Travel", "Educational", "Music", "Others"];
  }
  static Future<bool> SaveItemsss(String url, String title, String thumbnailUrl, String category, String userId) async{
    try {
      var uuid = Uuid();
      String id = uuid.v1();
      final firestoreInstance = FirebaseFirestore.instance;
      final CollectionReference collection = firestoreInstance.collection('items');
      await collection.doc(id).set( {
          "id": id,
          "userId": userId,
          "url": url,
          "thumbnailUrl": thumbnailUrl,
          "title": title,
          "category": category,
          "createdAt": Timestamp.now(),
       // "profilepic": ,
        }
      );
    } catch (e) {
      print('Error adding document to Firestore: $e');
      return false;
    }
    return true;
  }
  static Future<bool> SaveItem(String url, String title, String base64Image, String category, String userId) async{
    try {
      var uuid = Uuid();
      String id = uuid.v1();
      final firestoreInstance = FirebaseFirestore.instance;
      final CollectionReference collection = firestoreInstance.collection('items');
      await collection.doc(id).set( {
          "id": id,
          "userId": userId,
          "url": url,
          //"thumbnailUrl": base64Image,
          "thumbnailbase64img": base64Image,
          "title": title,
          "category": category,
          "createdAt": Timestamp.now(),
       // "profilepic": ,
        }
      );
    } catch (e) {
      print('Error adding document to Firestore: $e');
      return false;
    }
    return true;
  }
  static Future<QuerySnapshot> fetchItems(String uid, String category) async {
    print(category);
    return await FirebaseFirestore.instance.collection('items')
                                           .where('userId', isEqualTo: uid)
                                           .where('category', isEqualTo: category)
                                           .orderBy("createdAt", descending: true)
                                           .get();
  }
  static Future<void> deleteItem(String uid, String id) async {
    await FirebaseFirestore.instance.collection('items').doc(id).delete();
  }

  static Future<bool> deleteAllItems(String uid) async {
    try {
      CollectionReference collection = FirebaseFirestore.instance.collection('items');
      QuerySnapshot querySnapshot = await collection.where('userId', isEqualTo: uid).get();
      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        await doc.reference.delete();
      }
      return true;
    }
    catch(e) {
      //log error
    }
    return false;
  }

  static Future<List<String>> fetchAllTitles() async {
    try {
      QuerySnapshot querySnapshot =
      await FirebaseFirestore.instance.collection('items').get();

      for (var doc in querySnapshot.docs) {
        print('Document Data: ${doc.data()}'); // Debugging
      }

      List<String> titles = querySnapshot.docs
          .where((doc) => doc.data() != null && (doc.data() as Map).containsKey('title'))
          .map((doc) => doc['title'].toString())
          .toList();

      return titles;
    } catch (e) {
      print('Error fetching titles: $e');
      return [];
    }
  }


}