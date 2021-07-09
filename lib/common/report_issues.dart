import 'package:flutter/material.dart';
import 'package:hello/services/other_services.dart';

class FeedbackAndIssues extends StatefulWidget {
  const FeedbackAndIssues({key}) : super(key: key);

  @override
  _FeedbackAndIssuesState createState() => _FeedbackAndIssuesState();
}

class _FeedbackAndIssuesState extends State<FeedbackAndIssues> {
  String userType;

  List<String> items = ["Feedback", "Issues"];

  String category;
  String title;
  String content;

  void _alert(String msg) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Alert"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg),
            ],
          ),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        );
      },
    );
  }

  bool waiting = false;

  void submit() {
    if (category == null || category.isEmpty) {
      _alert("Select feedback category");
    } else if (content == null || content.isEmpty) {
      _alert("Content cannot be empty");
    } else {
      setState(() {
        waiting = true;
      });
      OtherServices().reportIssue({
        "category": category.toLowerCase(),
        "title": title,
        "content": content,
        "userType": "dds"
      }).then((value) {
        setState(() {
          waiting = false;
          category = null;
        });
        textEditingController1.clear();
        textEditingController2.clear();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("$category reported successfully 🎉🎉🎉🎉")));
      });
    }
  }

  TextEditingController textEditingController1 = TextEditingController();
  TextEditingController textEditingController2 = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Feedback / Report Issues"),
      ),
      // resizeToAvoidBottomInset: false,

      body: Center(
        child: Container(
          padding: EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              DropdownButton<String>(
                icon: Icon(
                  Icons.arrow_drop_down,
                  size: 30,
                ),
                hint: Text("category"),
                value: category,
                items: items
                    .map(
                      (item) => DropdownMenuItem(
                        child: Text(item),
                        value: item,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    category = value;
                  });
                },
              ),
              TextField(
                controller: textEditingController1,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    hintText: "title"),
                onChanged: (value) {
                  setState(() {
                    title = value;
                  });
                },
              ),
              TextField(
                controller: textEditingController2,
                keyboardType: TextInputType.multiline,
                minLines: 5,
                maxLines: 10,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    alignLabelWithHint: true,
                    hintText: "content"),
                onChanged: (value) {
                  setState(() {
                    content = value;
                  });
                },
              ),
              (waiting ? CircularProgressIndicator() : SizedBox()),
              ElevatedButton(onPressed: submit, child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
