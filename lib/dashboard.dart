import 'package:dostapp/Navigators/AddCasesNavigator.dart';
import 'package:dostapp/Navigators/AddEventsNavigator.dart';
import 'package:dostapp/Navigators/CasesNavigator.dart';
import 'package:dostapp/Navigators/EventsNavigator.dart';
import 'package:dostapp/Navigators/HomeNavigator.dart';
import 'package:dostapp/SimpleNavigationWidget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;
  bool addCaseClick=false,addEventClick=false;
  static List<Widget> _widgetOptions = <Widget>[
    HomeNavigator(),
    CasesNavigator(),
    SimpleNavigationWidget(),
    EventsNavigator()
  ];
  void _onItemTapped(int index) {
    setState(() {
      addCaseClick=false;
      addEventClick=false;
      _selectedIndex = index;
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("init state");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center( //On Will Pop lagana hai yahan with Do you want to sign out option
        child: addCaseClick?AddCasesNavigator():addEventClick?AddEventsNavigator(): _widgetOptions.elementAt(_selectedIndex),
      ),
      floatingActionButton: SpeedDial(
        backgroundColor: Colors.purple,
        activeBackgroundColor: Colors.purpleAccent,
        //animatedIcon: AnimatedIcons.add_event,
        //animatedIconTheme: IconThemeData(size: 22.0),
        child: Icon(Icons.add,size: 25,),
        activeChild: Icon(Icons.close),
        //icon: Icons.add,
        //activeIcon: Icons.close,
        spacing: 3,
        childPadding: EdgeInsets.all(5),
        tooltip: 'Add',
        heroTag: 'Add',
        useRotationAnimation: true,
        //elevation: 8.0,
        isOpenOnStart: false,
        animationSpeed: 200,
        renderOverlay: true,
        overlayColor: Colors.black,
        overlayOpacity: 0.5,
        children: [
          SpeedDialChild(
            child: Icon(Icons.cases),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            label: 'Add Case',
            onTap: () {
              setState(() {
                addCaseClick=true;
                addEventClick=false;
                //_selectedIndex=4;
              });
            }
          ),
          SpeedDialChild(
            child: Icon(Icons.event),
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            label: 'Add Event',
            onTap: () {
              setState(() {
                addEventClick=true;
                addCaseClick=false;
                //_selectedIndex=4;
              });
            }
          ),
        ],
      ),
      /*SpeedDial(
        // animatedIcon: AnimatedIcons.menu_close,
        // animatedIconTheme: IconThemeData(size: 22.0),
        // / This is ignored if animatedIcon is non null
        // child: Text("open"),
        // activeChild: Text("close"),
        icon: Icons.add,
        activeIcon: Icons.close,
        spacing: 3,
        openCloseDial: isDialOpen,
        childPadding: EdgeInsets.all(5),
        spaceBetweenChildren: 4,
        dialRoot: customDialRoot
            ? (ctx, open, toggleChildren) {
          return ElevatedButton(
            onPressed: toggleChildren,
            style: ElevatedButton.styleFrom(
              primary: Colors.blue[900],
              padding:
              EdgeInsets.symmetric(horizontal: 22, vertical: 18),
            ),
            child: Text(
              "Custom Dial Root",
              style: TextStyle(fontSize: 17),
            ),
          );
        }
            : null,
        buttonSize: 56, // it's the SpeedDial size which defaults to 56 itself
        // iconTheme: IconThemeData(size: 22),
        label: extend ? Text("Open") : null, // The label of the main button.
        /// The active label of the main button, Defaults to label if not specified.
        activeLabel: extend ? Text("Close") : null,

        /// Transition Builder between label and activeLabel, defaults to FadeTransition.
        // labelTransitionBuilder: (widget, animation) => ScaleTransition(scale: animation,child: widget),
        /// The below button size defaults to 56 itself, its the SpeedDial childrens size
        childrenButtonSize: 56.0,
        visible: visible,
        direction: speedDialDirection,
        switchLabelPosition: switchLabelPosition,

        /// If true user is forced to close dial manually
        closeManually: closeManually,

        /// If false, backgroundOverlay will not be rendered.
        renderOverlay: renderOverlay,
        // overlayColor: Colors.black,
        // overlayOpacity: 0.5,
        onOpen: () => print('OPENING DIAL'),
        onClose: () => print('DIAL CLOSED'),
        useRotationAnimation: useRAnimation,
        tooltip: 'Open Speed Dial',
        heroTag: 'speed-dial-hero-tag',
        // foregroundColor: Colors.black,
        // backgroundColor: Colors.white,
        // activeForegroundColor: Colors.red,
        // activeBackgroundColor: Colors.blue,
        elevation: 8.0,
        isOpenOnStart: false,
        animationSpeed: 200,
        shape: customDialRoot ? RoundedRectangleBorder() : StadiumBorder(),
        // childMargin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        children: [
          SpeedDialChild(
            child: !rmicons ? Icon(Icons.accessibility) : null,
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            label: 'First',
            onTap: () => print("FIRST CHILD"),
          ),
          SpeedDialChild(
            child: !rmicons ? Icon(Icons.brush) : null,
            backgroundColor: Colors.deepOrange,
            foregroundColor: Colors.white,
            label: 'Second',
            onTap: () => print('SECOND CHILD'),
          ),
          SpeedDialChild(
            child: !rmicons ? Icon(Icons.margin) : null,
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            label: 'Show Snackbar',
            visible: true,
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(("Third Child Pressed")))),
            onLongPress: () => print('THIRD CHILD LONG PRESS'),
          ),
        ],
      ),*/
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        clipBehavior: Clip.antiAlias,
        notchMargin: 5,
        child: BottomNavigationBar(
          showUnselectedLabels: true,
          type: BottomNavigationBarType.fixed,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.announcement_outlined),
              activeIcon: Icon(Icons.announcement),
              label: 'Cases',
            ),
            /*BottomNavigationBarItem(
              backgroundColor: Colors.transparent,
                icon: Icon(Icons.add_circle_outline,color: Colors.transparent,),
                label: ""
            ),*/
            BottomNavigationBarItem(
              icon: Icon(Icons.add_alert_outlined),
              activeIcon: Icon(Icons.add_alert),
              label: 'Alerts',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.event_note_outlined),
              activeIcon: Icon(Icons.event_note),
              label: 'Events',
            ),
          ],
          unselectedItemColor: Colors.purple,
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.purple,
          onTap: _onItemTapped,
        ),
      )
    );
  }
}
