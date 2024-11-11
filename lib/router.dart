import 'package:flutter/material.dart';
import 'package:reddit/features/auth/screens/login_screen.dart';
import 'package:reddit/features/community/screens/add_mods_screen.dart';
import 'package:reddit/features/community/screens/community_details.dart';
import 'package:reddit/features/community/screens/community_screen.dart';
import 'package:reddit/features/community/screens/edit_community.dart';
import 'package:reddit/features/community/screens/mod_tool_screen.dart';
import 'package:reddit/features/home/screens/home_screen.dart';
import 'package:reddit/features/profile/screens/edit_profile_screen.dart';
import 'package:reddit/features/profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: LoginScreen()),
});

final loggedInRoute = RouteMap(routes: {
  '/': (_) => const MaterialPage(child: HomeScreen()),
  '/create-community': (_) => const MaterialPage(child: CommunityScreen()),
  '/community/:name': (route) => MaterialPage(
      child:
          CommunityDetailsScreen(communityname: route.pathParameters['name']!)),
  '/mod-tools/:name': (route) =>
      MaterialPage(child: ModToolScreen(name: route.pathParameters['name']!)),
  '/add-mods/:name': (route) =>
      MaterialPage(child: AddModsScreen(name: route.pathParameters['name']!)),
  '/edit-community/:name': (route) => MaterialPage(
      child: EditCommunityScreen(name: route.pathParameters['name']!)),
  '/u/:uid': (route) => MaterialPage(
          child: UserProfileScreen(
        uid: route.pathParameters['uid']!,
      )),
  '/edit-profile/:uid': (route) => MaterialPage(
          child: EditProfile(
        uid: route.pathParameters['uid']!,
      )),
});
