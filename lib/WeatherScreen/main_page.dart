import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/WeatherScreen/weather_screen.dart';
import 'package:flutter_firebase/ui/posts/add_post.dart';
import 'package:flutter_firebase/ui/posts/posts.screen.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final navigationKey = GlobalKey<CurvedNavigationBarState>();
  int index = 0;
  final screens = [
    const WeatherScreen(),
    const AddPostScreen(),
    const PostScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        key: navigationKey,
        height: 60,
        backgroundColor: Colors.grey.shade500,
        index: index,
        items: const [
         Icon(Icons.home, color: Colors.white),
         Icon(Icons.add_to_photos ,  color: Colors.white),
          Icon(Icons.post_add,  color: Colors.white),
        ],
        onTap: (index) => setState(() => this.index = index),
        color: Colors.deepPurple,
        animationDuration:const Duration(milliseconds: 300),

      ),
    );
  }
}
