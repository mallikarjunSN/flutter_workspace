import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DemoPage extends StatefulWidget {
  @override
  _DemoPageState createState() => _DemoPageState();
}

class Movies {
  Movies({this.name, this.director, this.year});
  String name;
  String director;
  Timestamp year;

  void getyear() {}
}

class _DemoPageState extends State<DemoPage> {
  Stream docStream =
      FirebaseFirestore.instance.collection("messages").snapshots();
  @override
  void initState() {
    super.initState();
  }

  String data = "Hello";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo page"),
        centerTitle: true,
        actions: [
          Semantics(
            onTapHint: "view the items in the cart",
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {},
              tooltip: "shopping cart",
            ),
          ),
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
            tooltip: "search items",
          ),
        ],
      ),
      body: Center(
        child: StreamBuilder<QuerySnapshot>(
          stream: docStream,
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data.docs);
              // List<String> movies = [];
              // snapshot.data.docs.map((e) {
              //   movies.add(e['name']);
              //   print(e["name"]);
              // }).toList();

              return ListView(
                children: snapshot.data.docs.map((DocumentSnapshot doc) {
                  Map<String, dynamic> data =
                      doc.data() as Map<String, dynamic>;

                  return Container(
                      alignment: Alignment.center,
                      color: Colors.grey,
                      margin: EdgeInsets.all(10),
                      padding: EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(data['senderId']),
                          Text(data['content']),
                          // Text(
                          //     data['year'].toDate().toString().substring(0, 4)),
                        ],
                      ));
                }).toList(),
                // Card(
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //     children: [Text("Name: "), Text(movies[index])],
                //   ),
                // );
              );
            } else
              return Text("still loading");
          },
        ),
      ),
    );
  }
}
