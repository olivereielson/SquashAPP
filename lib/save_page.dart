import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';

import 'hive_classes.dart';
import 'main.dart';

class SavedData extends StatefulWidget {
  SavedData();

  @override
  SavedDataState createState() => new SavedDataState();
}

class SavedDataState extends State<SavedData> {
  Color main = Color.fromRGBO(4, 12, 128, 1);

  var solo_storage_box;

  Future<void> load_hive() async {
    Hive.registerAdapter(Solo_stroage_Adapter());

    solo_storage_box = await Hive.openBox<Solo_stroage>("SoloStorage");
    print(Hive.box<Solo_stroage>("SoloStorage").values);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Saved Solo Workouts",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Divider(
                color: main,
                thickness: 3,
              ),

              Container(height: 10,),

              FutureBuilder(
                future: load_hive(),
                builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                  if (Hive.isBoxOpen("SoloStorage")) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: Hive.box<Solo_stroage>("SoloStorage").length,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 80,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,

                                    children: [
                                      Text("1:04",style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: main)),
                                      Icon(Icons.chevron_right)
                                    ],
                                  ),
                                  Text(DateFormat.yMMMMd('en_US').format(DateTime.parse(Hive.box<Solo_stroage>("SoloStorage").getAt(index).date)),style: TextStyle()),
                                  Divider(
                                    thickness: 2,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  } else {
                    return Text("not");
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
