import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
          appBar: AppBar(
            title: Text("Flutter Firestore CRUD"),
          ),
          body: BookList(),
          // ADD (Create)
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      content: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("Add"),
                          Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Text("Title: ", textAlign: TextAlign.start,),
                          ),
                          TextField(

                            controller: titleController,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 20),
                            child: Text("Author: "),
                          ),
                          TextField(
                            controller: authorController,
                          ),
                        ],
                      ),
                      actions: <Widget>[
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: RaisedButton(
                            color: Colors.red,
                            onPressed: () { Navigator.of(context).pop();},
                            child: Text("Undo", style: TextStyle(color: Colors.white),),),
                        ),

                        //Add Button

                        RaisedButton(

                          onPressed: () {
                            //TODO: Firestore create a new record code

                            Map<String, dynamic> newBook = new Map<String,dynamic>();
                            newBook["title"] = titleController.text;
                            newBook["author"] = authorController.text;

                            Firestore.instance
                                .collection("books")
                                .add(newBook)
                                .whenComplete((){
                              Navigator.of(context).pop();
                            } );

                          },
                          child: Text("save", style: TextStyle(color: Colors.white),),
                        ),

                      ],
                    );
                  }
              );
            } ,
            tooltip: 'Add Title',
            child: Icon(Icons.add),
          ),
        );
  }
}


class BookList extends StatelessWidget {

  TextEditingController titleController = new TextEditingController();
  TextEditingController authorController = new TextEditingController();


  @override
  Widget build(BuildContext context) {
    //TODO: Retrive all records in collection from Firestore
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
                        onTap: (){
                          showDialog(
                              context: context,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  title: Text("Update Dilaog"),
                                  content: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("Title: ", textAlign: TextAlign.start,),
                                      TextField(
                                        controller: titleController,
                                        decoration: InputDecoration(
                                          hintText:  document['title'],
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: 20),
                                        child: Text("Author: "),
                                      ),
                                      TextField(
                                        controller: authorController,
                                        decoration: InputDecoration(
                                          hintText:  document['author'],

                                        ),
                                      ),
                                    ],
                                  ),
                                  actions: <Widget>[
                                    Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 10),
                                      child: RaisedButton(
                                        color: Colors.red,
                                        onPressed: () { Navigator.of(context).pop();},
                                        child: Text("Undo", style: TextStyle(color: Colors.white),),),
                                    ),
                                    // Update Button
                                    RaisedButton(
                                      onPressed: () {

                                         //TODO: Firestore update a record code

                                        Map<String, dynamic> updateBook = new Map<String,dynamic>();
                                        updateBook["title"] = titleController.text;
                                        updateBook["author"] = authorController.text;

                                        // Updae Firestore record information regular way
                                       Firestore.instance
                                           .collection("books")
                                           .document(document.documentID)
                                           .updateData(updateBook)
                                           .whenComplete((){
                                         Navigator.of(context).pop();
                                       });

                                        // Update firestore record information using a transaction to prevent any conflict in data changed from different sources
//                                         Firestore.instance.runTransaction((transaction) async {
// //                                          await transaction.update(document.reference, {'title': titleController.text, 'author': authorController.text })
//                                           await transaction.update(document.reference, updateBook)
//                                               .then((error){
//                                             Navigator.of(context).pop();
//                                           });
//                                         });
                                      },


                                      child: Text("update",
                                        style: TextStyle(color: Colors.white),),),


                                  ],
                                );
                              }
                          );
                        },
                        title: new Text("Title " + document['title']),
                        subtitle: new Text("Author " + document['author']),
                        trailing:
                        // Delete Button
                        InkWell(
                          onTap: (){
                            //TODO: Firestore delete a record code
                      Firestore.instance
                          .collection("books")
                          .document(document.documentID)
                          .delete()
                          .catchError((e){
                        print(e);
                      });


                          }, child:
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          child: Icon(Icons.delete),
                        ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              );
          }
        },
      );
  }
}

