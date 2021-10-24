// import 'dart:io';

// import 'package:bookario/app.locator.dart';
// import 'package:bookario/components/constants.dart';
// import 'package:bookario/components/loading.dart';
// import 'package:bookario/components/networking.dart';
// import 'package:bookario/screens/club_UI_screens/home/components/add_club.dart';
// import 'package:bookario/screens/club_UI_screens/home/components/own_clubs.dart';
// import 'package:bookario/screens/sign_in/sign_in_screen.dart';
// import 'package:bookario/services/local_storage_service.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';

// import '../../../components/size_config.dart';

// class ClubHomeScreen extends StatefulWidget {
//   static String routeName = "/clubHome";

//   @override
//   _ClubHomeScreenState createState() => _ClubHomeScreenState();
// }

// class _ClubHomeScreenState extends State<ClubHomeScreen> {
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   User user;
//   File coverPhoto;
//   bool hasClubs = false,
//       homeLoading = true,
//       loadMore = false,
//       loadingMore = false;
//   int offset, limit;
//   List<dynamic> clubData;

//   final LocalStorageService _localStorageService =
//       locator<LocalStorageService>();

//   checkAuthentification() async {
//     _auth.authStateChanges().listen((user) {
//       if (user == null) {
//         Navigator.pushAndRemoveUntil(
//           context,
//           MaterialPageRoute(
//             builder: (context) => SignInScreen(),
//           ),
//           (Route<dynamic> route) => false,
//         );
//       }
//     });
//   }

//   @override
//   void initState() {
//     checkAuthentification();
//     offset = 0;
//     limit = 10;
//     getMyClubs();
//     super.initState();
//   }

//   getMyClubs() async {
//     final String uid = await _localStorageService.getter('uid');
//     print("club " + uid);
//     final response = await Networking.getData('clubs/get-user-club', {
//       "userId": uid,
//       "limit": limit.toString(),
//       "offset": offset.toString(),
//     });
//     if (response['data'].length > 0) {
//       setState(() {
//         hasClubs = true;
//         loadMore = true;
//         loadingMore = false;
//         clubData = response['data'];
//       });
//     } else {
//       setState(() {
//         homeLoading = false;
//         loadMore = false;
//       });
//     }
//   }

//   Future<bool> _exitApp(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(5),
//             ),
//           ),
//           title: Text(
//             "Want to exit?",
//             style: Theme.of(context).textTheme.headline6.copyWith(
//                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               splashColor: Colors.red[50],
//               child: Text(
//                 "No",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//             MaterialButton(
//               onPressed: () => exit(0),
//               splashColor: Colors.red[50],
//               child: Text(
//                 "Yes",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     SizeConfig().init(context);
//     return WillPopScope(
//       onWillPop: () => _exitApp(context),
//       child: Scaffold(
//           appBar: AppBar(
//             leading: Container(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(50),
//                 color: Colors.white,
//               ),
//               child: Image.asset(
//                 "assets/images/onlylogo.png",
//                 fit: BoxFit.cover,
//               ),
//             ),
//             title: Text("Home"),
//             actions: [
//               IconButton(
//                   onPressed: () => _logout(context),
//                   icon: Icon(Icons.exit_to_app))
//             ],
//           ),
//           body: hasClubs
//               ? showClubs(context)
//               : homeLoading
//                   ? Loading()
//                   : Container(
//                       alignment: Alignment.center,
//                       child: Text(
//                         'Register your club by\nclicking on \'+\' button below.',
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//           floatingActionButton: FloatingActionButton(
//               elevation: 10,
//               backgroundColor: kPrimaryLightColor,
//               onPressed: () async {
//                 final bool clubAdded = await Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => AddNewClub()),
//                 );
//                 if (clubAdded) {
//                   getMyClubs();
//                   clubAddedAlert(context);
//                 }
//               },
//               child: Icon(Icons.add, color: kTextColor))),
//     );
//   }

//   SafeArea showClubs(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(height: getProportionateScreenHeight(5)),
//               OwnClubs(clubData: clubData),
//               SizedBox(height: getProportionateScreenWidth(10)),
//               loadMore
//                   ? loadingMore
//                       ? Loading()
//                       : MaterialButton(
//                           onPressed: () {
//                             setState(() {
//                               loadingMore = true;
//                               offset += limit;
//                             });
//                             getMyClubs();
//                           },
//                           splashColor: Theme.of(context).primaryColorLight,
//                           child: Text(
//                             'load more',
//                             style: TextStyle(color: kTextColor),
//                           ),
//                         )
//                   : Container(),
//               SizedBox(height: getProportionateScreenWidth(10)),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<bool> _logout(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(5),
//             ),
//           ),
//           title: Text(
//             "Want to logout?",
//             style: Theme.of(context).textTheme.headline6.copyWith(
//                 fontSize: 17, fontWeight: FontWeight.bold, color: Colors.white),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               onPressed: () => Navigator.of(context).pop(false),
//               splashColor: Colors.red[50],
//               child: Text(
//                 "No",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//             MaterialButton(
//               onPressed: () async {
//                 _localStorageService.deleteStore('userType');
//                 await _auth.signOut();
//               },
//               splashColor: kPrimaryColor,
//               child: Text(
//                 "Yes",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }

//   Future<bool> clubAddedAlert(BuildContext context) {
//     return showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor: Colors.grey[900],
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.all(
//               Radius.circular(5),
//             ),
//           ),
//           title: Text(
//             "Club Added Successully",
//             style: Theme.of(context)
//                 .textTheme
//                 .headline6
//                 .copyWith(fontSize: 17, color: Colors.white),
//           ),
//           actions: <Widget>[
//             MaterialButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               splashColor: Colors.red[50],
//               child: Text(
//                 "Ok",
//                 style: Theme.of(context)
//                     .textTheme
//                     .bodyText1
//                     .copyWith(color: kSecondaryColor),
//               ),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
