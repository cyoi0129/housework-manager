import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Header extends StatefulWidget with PreferredSizeWidget {
  const Header({super.key, required this.title});
  final String title;
  @override
  State<Header> createState() => _HeaderState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _HeaderState extends State<Header> {

  @override
  Widget build(BuildContext context) {
    final _user = FirebaseAuth.instance.currentUser;
    return AppBar(
        title: Text('${widget.title}'),
        actions: [
          IconButton(onPressed: () => {Navigator.of(context).pushNamed("/user")}, icon: (_user == null)? Icon(Icons.login) : Icon(Icons.supervised_user_circle))
        ],
      );
  }
}