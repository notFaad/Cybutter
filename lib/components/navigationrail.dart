import 'package:flutter/material.dart';

class Navigationrail extends StatefulWidget {
  late int selected;
  late void Function(int value)? callback;
  Navigationrail({Key? key, required this.selected, required this.callback})
      : super(key: key);

  @override
  _NavigationrailState createState() => _NavigationrailState();
}

class _NavigationrailState extends State<Navigationrail> {
  @override
  Widget build(BuildContext context) {
    return NavigationRail(
        leading: Image.asset("assets/anim.gif"),
        labelType: NavigationRailLabelType.all,
        backgroundColor: Theme.of(context).backgroundColor.withBlue(55),
        useIndicator: false,
        elevation: 5,
        selectedLabelTextStyle:
            TextStyle(color: Theme.of(context).primaryColor),
        unselectedLabelTextStyle:
            TextStyle(color: Color.fromARGB(255, 149, 149, 149)),
        groupAlignment: 0,
        minWidth: 100,
        unselectedIconTheme:
            IconThemeData(color: Color.fromARGB(255, 149, 149, 149)),
        selectedIconTheme: IconThemeData(color: Theme.of(context).primaryColor),
        destinations: <NavigationRailDestination>[
          NavigationRailDestination(
            icon: Icon(Icons.download),
            label: Text('Downloader'),
          ),
          NavigationRailDestination(
            icon: Icon(Icons.video_library),
            label: Text('Media'),
          ),
        ],
        trailing: Padding(
          padding:
              EdgeInsets.only(top: MediaQuery.of(context).size.height / 2.6),
          child: Center(
            child: Text(
              "Made\nwith\nlove\nby\n NotFaad",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        selectedIndex: widget.selected,
        onDestinationSelected: widget.callback);
  }
}
