# Flutter Firestore CRUD

This is a simple Flutter project that demonstrate all the CRUD functionality: 

- **Create** / **insert** from firestore
- **Retrive** / **View** from firestore
- **Update** / **Edit** from firestore
- **Delete** / **Remove** from firestore

This source code is designed for beginners in Firebase Firestore, and it demonstrates the simplest way to the basic functionalities above.

## Demo

<img height="480px" src="screenshots\animatedscreenshot.gif">

## Screenshots

<img height="380px" src="screenshots\Screenshot_1569803907.png"
     alt="Home Page"
     style="float: left; margin-right: 10px;" />
<img height="380px" src="screenshots\Screenshot_1569803932.png"
     alt="Add Page"
     style="float: left; margin-right: 10px; " />
<img height="380px" src="screenshots\Screenshot_1569803958.png"
     alt="Add Page"
     style="float: left; margin-right: 10px; " />
<img height="380px" src="screenshots\Screenshot_1569804024.png "
     alt="Update Page"
     style="float: left; margin-right: 10px;" />


# Getting Started

To get started with this project, you should do the following steps: 
1. Sign in/up to firebase 
2. Go to console 
3. Start a new project 
4. Create a Firestore database 
5. Create a "books" collection 
6. Add a new record with "title" and "author" fields    
7. Download and input google-service.json to the correct location 
8. Run flutter pub get 

---
If you are new to flutter and firebase, check the video below to get more information on how to connect your flutter app with the firebase project. 


[![How to connect your flutter app with firebase project](https://img.youtube.com/vi/DqJ_KjFzL9I/0.jpg)](https://www.youtube.com/watch?v=DqJ_KjFzL9I)

# Insert a row to Firestore (Create)

```dart
Map<String, dynamic> newBook = new Map<String,dynamic>();
    newBook["title"] = "title value";
    newBook["author"] = "author value";

Firestore.instance
        .collection("books")
        .add(newBook)
        .whenComplete((){
        // You can add your desire action after the row is added
      } );
```

# Edit a row in firestore (Update)

Basic Update function

```dart
Map<String, dynamic> updateBook = new Map<String,dynamic>();
 updateBook["title"] = "title value";
 updateBook["author"] = "author value";
 // Updae Firestore record information regular way
Firestore.instance
    .collection("books")
    .document(document.documentID)
    .updateData(updateBook)
    .whenComplete((){
         // You can add your desire action after the row is updated 
});
```

Or update using a transaction. 

```dart
Map<String, dynamic> updateBook = new Map<String,dynamic>();
 updateBook["title"] = "title value";
 updateBook["author"] = "author value";
Firestore.instance.runTransaction((transaction) async {
    await transaction.update(document.reference, updateBook)
        .then((error){
     // You can add your desire action after the row is updated 
    });
  });
},
```

# Delete a row in firestore (Delete)

```dart
Firestore.instance
     .collection("books")
     .document(document.documentID) // Replace the document.documentID with the row id that you need to delete
     .delete()
     .catchError((e){
   print(e);
 });

```

# View all the rows in a collection from firestore (Retrieve)

```dart
 @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: Firestore.instance.collection('books').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError)
            return new Text('Error: ${snapshot.error}');
          switch (snapshot.connectionState) {
            case ConnectionState.waiting: return Center(child: CircularProgressIndicator(),);
            default:
              return new ListView(
                padding: EdgeInsets.only(bottom: 80),
                children: snapshot.data.documents.map((DocumentSnapshot document) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 10),
                    child: Card(
                      child: ListTile(
                        title: new Text("Title " + document['title']),
                        subtitle: new Text("Author " + document['author']),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      );
  }
```
