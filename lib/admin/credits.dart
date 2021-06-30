import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class credits {
  List<String> cred = [
    "Created By: Oliver Eielson",
    "Squash Icons: Oliver Eielson"
  ];
}

class credit_page extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        elevation: 0,
        leading: Text(""),
      ),
      body: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Expanded(
                child: Container(
                  color: Colors.white.withOpacity(0.1),

                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.builder(

                      itemCount: credits().cred.length,
                      itemBuilder: (BuildContext context, int index) {

                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(child: Text(credits().cred[index],style: TextStyle(color: Colors.white),),),
                        );

                      },


                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 0),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
