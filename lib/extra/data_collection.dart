import 'package:firebase_analytics/firebase_analytics.dart';

class Data_Sender{




  Future<void> testSetCurrentScreen(FirebaseAnalytics analytics, String screenName, String screenClassOverride ) async {
    await analytics.setCurrentScreen(
      screenName: screenName,
      screenClassOverride: screenClassOverride,
    );
  }





}