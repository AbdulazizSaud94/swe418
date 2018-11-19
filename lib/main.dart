import 'package:flutter/material.dart';
import 'package:map_view/map_view.dart';
//pages
import 'Screens/Auth/LoginPage.dart';
import 'Screens/Student/HomePage.dart';
import 'Screens/Admin/AdminTabs.dart';
import 'Screens/Student/ProfilePage.dart';
import 'Screens/Admin/AddUserPage.dart';
import 'Screens/Admin/UsersList.dart';
import 'Screens/Student/RequestsPage.dart';
import 'Screens/Student/UnlockDoor.dart';
import 'Screens/Student/RequestPairing.dart';
import 'Screens/Student/SUnlockDoorList.dart';
import 'Screens/Housing/HousingRequestsPage.dart';
import 'Screens/Housing/HUnlockDoorList.dart';
import 'Screens/Student/RequestMaintenance.dart';
import 'Screens/Housing/SingleRoomRequestList.dart';
import 'Screens/Housing/PairingRequest.dart';
import 'Screens/Housing/HMaintenanceList.dart';
import 'Screens/Student/SingleRoomRequestPage.dart';
import 'Screens/Student/Complaints.dart';
import 'Screens/Housing/HComplaintsList.dart';
import 'Screens/Student/EditProfile.dart';
import 'Screens/Housing/InspectionForm.dart';
import 'Screens/Shared/BuildingList.dart';
import 'Screens/Housing/HKeyList.dart';
import 'Screens/Student/RoomContract.dart';
import 'Screens/Admin/Announcements.dart';
import 'Screens/Student/AnnouncementsList.dart';
import 'Screens/Student/change_room_request.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'Screens/Shared/ViewBuilding.dart';
import 'Screens/Shared/ViewRoom.dart';

import 'Screens/Shared/StudentProfile.dart';
import 'Screens/Student/RequestSwap.dart';


import 'screens/Student/posts.dart';

void main() {
  MapView.setApiKey('AIzaSyCKMhiABoRdSTWZ15iwRkhqCwJtShqQZGQ');
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  FirebaseMessaging fb = new FirebaseMessaging();

  void initState() {

    fb.configure(
      onLaunch: (Map<String, dynamic> msg) {

      },
      onMessage: (Map<String, dynamic> msg) {
      },
      onResume: (Map<String, dynamic> msg) {},
    );
    fb.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    fb.onIosSettingsRegistered.listen((IosNotificationSettings setting) {});

  }
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
      routes: <String, WidgetBuilder>{
        '/LoginPage': (BuildContext context) => new MyApp(),
        '/AdminTabs': (BuildContext context) => new AdminTabs(),
        '/HomePage' : (BuildContext context) => new HomePage(),
        '/ProfilePage': (BuildContext context) => new ProfilePage(),
        '/AddUserPage': (BuildContext context) => new AddUserPage(),
        '/UsersList': (BuildContext context) => new UsersList(),
        '/RequestsPage': (BuildContext context) => new RequestsPage(),
        '/UnlockDoor' : (BuildContext context) => new UnlockDoor(),
        '/RequestPairing': (BuildContext context) => new RequestPairing(),
        '/UnlockDoorList': (BuildContext context) => new SUnlockDoorList(),
        '/HousingPage': (BuildContext context) => new HousingRequestsPage(),
        '/HUnlockDoorList': (BuildContext context) => new HUnlockDoorList(),
        '/RequestMaintenance': (BuildContext context) => new RequestMaintenance(),
        '/SingleRoomRequestList': (BuildContext context) => new SingleRoomRequestList(),
        '/SingleRoomRequestPage': (BuildContext context) => new SingleRoomRequestPage(),
        '/HMaintenanceList': (BuildContext context) => new HMaintenanceList(),
        '/PairingRequest': (BuildContext context) => new PairingRequest(),
        '/Complaints': (BuildContext context) => new Complaints(),
        '/HComplaintsList': (BuildContext context) => new HComplaintsList(),
        '/EditProfile': (BuildContext context) => new EditProfile(),
        '/BuildingList': (BuildContext context) => new BuildingList(),
        '/InspectionForm':(BuildContext context) => new InspectionForm(),
        '/HKeyList': (BuildContext context) => new HKeyList(),
        '/RoomContract':(BuildContext context) => new RoomContract(),
        '/Announcements': (BuildContext context) => new Announcements(),
        '/AnnouncementsList': (BuildContext context) => new AnnouncementsList(),
        '/ChangeRoomPage': (BuildContext context) => new ChangeRoomPage(),
        '/ViewBuilding':  (BuildContext context) => new ViewBuilding(),
        '/ViewRoom': (BuildContext context) => new ViewRoom(),
        '/StudentProfile': (BuildContext context) => new StudentProfile(),
        '/SwapRequest': (BuildContext context) => new RequestSwap(),


        '/PostPage': (BuildContext context) => new PostPage(),

      },
    );
  }
}
