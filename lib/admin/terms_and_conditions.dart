import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class terms {
  String terms_text =
      'Believed to be the second draft of the speech, President Lincoln gave this copy to John Hay, a White House assistant. Hay accompanied Lincoln to Gettysburg and briefly referred to the speech in his diary: "the President, in a fine, free way, with more grace than is his wont, said his half dozen words of consecration." The Hay copy, which includes Lincolns handwritten changes, also is owned by the Library of Congress. Four score and seven years ago our fathers brought forth, upon this continent, a new nation, conceived in Liberty, and dedicated to the proposition that all men are created equal. Now we are engaged in a great civil war, testing whether that nation, or any nation so conceived, and so dedicated, can long endure. We are met here on a great battlefield of that war. We have come to dedicate a portion of it, as a final resting place for those who here gave their lives that that nation might live. It is altogether fitting and proper that we should do this. But in a larger sense, we can not dedicate we can not consecrate we can not hallow this ground. The brave men, living and dead, who struggled here, have consecrated it far above our poor power to add or detract. The world will little note, nor long remember, what we say here, but can never forget what they did here. It is for us, the living, rather to be dedicated here to the unfinished work which they have, thus far, so nobly carried on. It is rather for us to be here dedicated to the great task remaining before us that from these honored dead we take increased devotion to that cause for which they gave the last full measure of devotion that we here highly resolve that these dead shall not have died in vain; that this nation shall have a new birth of freedom; and that this government of the people, by the people, for the people, shall not perish from the earth.';
}

class terms_page extends StatelessWidget {

  terms_page(this.analytics,this.observer);
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;


  Future<void> _testSetCurrentScreen() async {
    print("Logged Page");
    await analytics.setCurrentScreen(
      screenName: 'Terms Page',
      screenClassOverride: 'Terms_Page',
    );
  }


  @override
  Widget build(BuildContext context) {
    _testSetCurrentScreen();
    return Scaffold(
      backgroundColor: Theme.of(context).splashColor,
      appBar: AppBar(
        title: Text("Terms and Conditions"),
        elevation: 0,
        leading: Text(""),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
          child: Column(
            children: [
              Expanded(
                child: Container(
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.1), border: Border.all(color: Colors.transparent), borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ListView(
                        children: [
                          Text(
                            terms().terms_text,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 50),
                child: CupertinoButton(
                  color: Colors.white,
                  onPressed: () {
                    analytics.logEvent(name: "Terms_Accepted");
                    Navigator.pop(context);
                  },
                  child: Text(
                    "Accept",
                    style: TextStyle(color: Colors.grey),
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
