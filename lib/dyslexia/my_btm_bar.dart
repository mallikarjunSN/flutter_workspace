import 'package:flutter/material.dart';
import 'package:hello/custom_widgets/cool_color.dart';
import 'package:hello/custom_widgets/sine_curve.dart';

class MyBottomBar extends StatefulWidget {
  const MyBottomBar({key, @required this.currentIdx, @required this.onTap})
      : super(key: key);

  final int currentIdx;

  final onTap;

  @override
  _MyBottomBarState createState() => _MyBottomBarState();
}

class _MyBottomBarState extends State<MyBottomBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedIconTheme: IconThemeData(color: Colors.white),
      selectedLabelStyle: TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w500),
      currentIndex: widget.currentIdx,
      selectedItemColor: Colors.white,
      backgroundColor: CoolColor().getColor(0x00b294),
      iconSize: 35,
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            Icons.home,
            size: 30,
          ),
          label: "HOME",
          activeIcon: AnimeIcon(
            icon: Icons.home,
          ),
        ),
        BottomNavigationBarItem(
          icon: Icon(
            Icons.directions_bike_sharp,
            size: 30,
          ),
          label: "EXERCISES",
          activeIcon: AnimeIcon(icon: Icons.directions_bike_sharp),
        ),
        BottomNavigationBarItem(
            icon: Icon(
              Icons.trending_up_rounded,
              size: 30,
            ),
            label: "PROGRESS",
            activeIcon: AnimeIcon(icon: Icons.trending_up_rounded),
            backgroundColor: Colors.amber),
      ],
      onTap: widget.onTap,
    );
  }
}

class AnimeIcon extends StatelessWidget {
  AnimeIcon({@required this.icon});

  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: -8),
      curve: SineCurve(),
      duration: Duration(milliseconds: 200000),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, value),
          child: Icon(
            icon,
            size: 35,
          ),
        );
      },
    );
  }
}
