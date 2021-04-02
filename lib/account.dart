import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Acount extends StatefulWidget {
  @override
  _AcountState createState() => _AcountState();
}

class _AcountState extends State<Acount> {
  String name = "name";
  String gender = "name";
  String location = "name";
  String email = "name";
  Color main = Color.fromRGBO(4, 12, 128, 1);

  bool edit = false;

  name_dialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Enter Name', fillColor: Colors.blue, hintText: "joe smith"),
            onSubmitted: (value) async {
              setState(() {
                name = value;
              });

              Navigator.of(context).pop();
              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString("first_name", value);
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  email_dialog() async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: new TextField(
            autofocus: true,
            decoration: new InputDecoration(labelText: 'Enter Email', fillColor: Colors.blue, hintText: "joe_smith@gmail.com"),
            onSubmitted: (value) async {
              setState(() {
                email = value;
              });
              Navigator.of(context).pop();

              SharedPreferences prefs = await SharedPreferences.getInstance();

              prefs.setString("email", value);
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
          ],
        );
      },
    );
  }

  @override
  void initState() {
    SharedPreferences.setMockInitialValues({"first_name": "Joe", "email": "joe.com", "gender": "male", "location": "use"});

    get_pref();
  }

  Future<void> get_pref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString('first_name');
      email = prefs.getString('email');
      gender = prefs.getString('gender');
      location = prefs.getString('location');
    });
  }

  Widget info() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              name_dialog();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(18),
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(name)
                      ],
                    ),

                    Spacer(),

                    Icon(Icons.navigate_next, color: Colors.black) // This Icon
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: GestureDetector(
            onTap: () {
              email_dialog();
            },
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                Radius.circular(18),
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                        Text(email)
                      ],
                    ),

                    Spacer(),

                    Icon(Icons.navigate_next, color: Colors.black) // This Icon
                  ],
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
              Radius.circular(18),
            )),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Password",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      Text("**********")
                    ],
                  ),

                  Spacer(),

                  Icon(Icons.navigate_next, color: Colors.black) // This Icon
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        Column(
          children: [
            Container(
              height: 250,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.3, 0.5, 0.9],
                  colors: [
                    Color.fromRGBO(4, 12, 160, 1),
                    Color.fromRGBO(4, 12, 150, 1),
                    Color.fromRGBO(4, 12, 140, 1),
                    Color.fromRGBO(4, 12, 130, 1),
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        width: 100,
                        decoration: new BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                            child: Text(
                          name.substring(0, 1),
                          style: TextStyle(fontSize: 70, color: Colors.grey),
                        ))),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(
                        name,
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    "Basic Information",
                    style: TextStyle(color: main, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 2,
            ),
            info()
          ],
        ),
        Positioned(
            top: 10,
            right: 20,
            child: SafeArea(
                child: GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.edit,
                color: Colors.white,
              ),
            )))
      ],
    ));
  }
}
