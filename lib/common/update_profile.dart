import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hello/services/user_service.dart';

class UpdateProfile extends StatefulWidget {
  const UpdateProfile({key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String fullName = "";

  Future<void> _submit(BuildContext context) async {
    if (fullName.isEmpty || fullName.length < 1) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text("Name can't be empty..!!"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("OK"))
          ],
        ),
      );
    } else {
      await UserService()
          .updateProfile(FirebaseAuth.instance.currentUser.uid, fullName);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("profile updated successfully..!!")));

      setState(() {
        fullName = "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update Profile"),
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                style: TextStyle(fontSize: 18),
                decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.person,
                      color: Colors.blue,
                      size: 25,
                    ),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(30))),
                    filled: true,
                    labelStyle: TextStyle(fontSize: 18),
                    hintText: "Enter updated name",
                    errorStyle: TextStyle(fontSize: 14),
                    contentPadding: EdgeInsets.all(10)),
                validator: (value) {
                  if (value.isEmpty) {
                    return "Name cannot be empty";
                  }
                  return null;
                },
                onChanged: (name) => setState(() {
                  fullName = name.trim();
                }),
              ),
              ElevatedButton(
                  onPressed: () => _submit(context), child: Text("Submit"))
            ],
          ),
        ),
      ),
    );
  }
}
