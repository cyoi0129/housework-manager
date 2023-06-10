import 'package:flutter/material.dart';
import '../features/Util.dart';
import 'package:go_router/go_router.dart';

class Footer extends StatefulWidget with PreferredSizeWidget {
  const Footer({super.key, required this.current});
  final int current;
  @override
  State<Footer> createState() => _FooterState();
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

class _FooterState extends State<Footer> {
  @override
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    var tabs = ['/', '/calendar', '/tasks', '/masters'];
    setState(() {
      _selectedIndex = index;
      Navigator.of(context).pushNamedAndRemoveUntil(tabs[index], (route) => false);
      // GoRouter.of(context).push(tabs[index]);
    });
  }
  Widget build(BuildContext context) {
    final names = LangPackage().getNameString();
    setState(() {
      _selectedIndex = widget.current;
    });
    return BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.orange,
            icon: Icon(Icons.graphic_eq),
            label: names['summary'],
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orange,
            icon: Icon(Icons.calendar_month),
            label: names['calendar'],
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orange,
            icon: Icon(Icons.task),
            label: names['task'],
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.orange,
            icon: Icon(Icons.category),
            label: names['master'],
          ),
        ],
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
    );
  }
}