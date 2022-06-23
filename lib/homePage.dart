// ignore_for_file: file_names, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sky_auth/constants.dart';
import 'package:qrscan/qrscan.dart' as scanner;
import 'dart:convert';
import 'package:shimmer/shimmer.dart';
import 'package:connectivity/connectivity.dart';
import 'API/ApiFunctions.dart';
import 'components/drawerWidget.dart';
import 'components/homePageStatusCodesList.dart';

import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();

  Duration get transitionDuration => const Duration(milliseconds: 0);
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  final ValueNotifier<bool> _online = ValueNotifier(false);
  var selectedIndex = 0;
  var barcode;

  var items = [
    const Text(
      'Logout',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
    )
  ];
  var title;

  @override
  void initState() {
    super.initState();
    getProgramsForIdentifier();
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  Future<void> _checkConnectivityState() async {
    final ConnectivityResult result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile) {
      await getStatusCodes();
      _online.value = true;
    } else {
      //await getStatusCodes();
      _online.value = false;
    }
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        await activateCodes();
        await getAllStatusCodes();
        Navigator.of(context).pushReplacementNamed('/homePage');
        break;
      case AppLifecycleState.inactive:
        // TODO: Handle this case.
        break;
      case AppLifecycleState.paused:
        await deactivateCodes();
        // TODO: Handle this case.
        break;
      case AppLifecycleState.detached:
        // TODO: Handle this case.
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    final ThemeData mode = Theme.of(context);
    var whichMode = mode.brightness;
    // ignore: non_constant_identifier_names
    Color COLOR = Colors.white;
    if (whichMode == Brightness.dark) {
      COLOR = Colors.black;
    }

    //if (individualIdentifier == "") {
    if (true) {
      title = const Text(
        "SKY AUTH",
        style: TextStyle(
          fontSize: 20,
        ),
      );
    }

    _checkConnectivityState();
    return ValueListenableBuilder(
      valueListenable: _online,
      builder: (context, takenSurvey, child) {
        if (_online.value == true) {
          return SafeArea(
            child: Scaffold(
              drawer: const DrawerWidget(),
              appBar: AppBar(
                toolbarHeight: size.height * 0.1,
                backgroundColor: kPrimary,
                centerTitle: true,
                elevation: 10,
                title: SizedBox(
                  child: title,
                ),
                actions: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                    child: FocusedMenuHolder(
                      blurBackgroundColor: Colors.blueGrey[900],
                      openWithTap: true,
                      onPressed: () {},
                      animateMenuItems: true,
                      menuItems: items
                          .map((e) => FocusedMenuItem(
                              title: e,
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text(
                                        "Are you sure you want to logout?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          "No",
                                          //style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          prefs.setString('user_id', "");
                                          prefs.setString('ip_address', "");
                                          prefs.setString('access_token', "");
                                          prefs.setString('username', "");

                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }))
                          .toList(),
                      child: CircleAvatar(
                        radius: size.height * 0.035,
                        backgroundColor: Colors.brown.shade800,
                        child: Text(INITIALS),
                      ),
                    ),
                  ),
                ],
              ),
              body: Container(
                margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                child: StreamBuilder(
                    stream: Connectivity().onConnectivityChanged,
                    builder: (BuildContext ctxt,
                        AsyncSnapshot<ConnectivityResult> snapShot) {
                      var result = snapShot.data;
                      switch (result) {
                        case ConnectivityResult.none:
                          return Shimmer.fromColors(
                            baseColor: kPrimaryLightColor,
                            highlightColor: Colors.grey,
                            enabled: true,
                            child: ListView.builder(
                              itemBuilder: (_, __) => Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 8.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 48.0,
                                      height: 48.0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(24),
                                        color: Colors.white,
                                      ),
                                    ),
                                    const Padding(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 8.0),
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            width: size.width * 0.7,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: size.width * 0.5,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                          ),
                                          Container(
                                            width: 40.0,
                                            height: 8.0,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              itemCount: 10,
                            ),
                          );
                        case ConnectivityResult.mobile:
                        case ConnectivityResult.wifi:
                          return Stack(
                            children: [
                              RefreshIndicator(
                                child: const HomepageStatusCodesList(),
                                onRefresh: () async {
                                  await getStatusCodes();
                                  await Future.delayed(
                                      const Duration(seconds: 2));
                                },
                              ),
                              //const HomepageStatusCodesList(),
                            ],
                          );
                        default:
                          return RefreshIndicator(
                            child: const HomepageStatusCodesList(),
                            onRefresh: () async {
                              await getStatusCodes();
                              await Future.delayed(const Duration(seconds: 2));
                            },
                          );
                      }
                    }),
              ),
              floatingActionButton: ExpandableFab(
                distance: 90.0,
                children: [
                  Row(
                    children: [
                      const Text("Scan QR Code"),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      ActionButton(
                        onPressed: scan,
                        icon: Icon(
                          Icons.qr_code,
                          color: COLOR,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Add Program"),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      ActionButton(
                        onPressed: () {
                          show = true;
                          Navigator.pushReplacementNamed(
                              context, '/identifiers');
                        },
                        icon: Icon(
                          Icons.add,
                          color: COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        } else {
          return SafeArea(
            child: Scaffold(
              drawer: const DrawerWidget(),
              appBar: AppBar(
                toolbarHeight: size.height * 0.1,
                backgroundColor: kPrimary,
                elevation: 10,
                title: SizedBox(
                  width: size.width * 0.6,
                  child: title,
                ),
                actions: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: FocusedMenuHolder(
                      blurBackgroundColor: Colors.blueGrey[900],
                      openWithTap: true,
                      onPressed: () {},
                      animateMenuItems: true,
                      menuItems: items
                          .map((e) => FocusedMenuItem(
                              title: e,
                              onPressed: () async {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    content: const Text(
                                        "Are you sure you want to logout?"),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text(
                                          "No",
                                          //style: TextStyle(color: Colors.black),
                                        ),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                      TextButton(
                                        child: const Text(
                                          "Yes",
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () async {
                                          final SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();

                                          prefs.setString('user_id', "");
                                          prefs.setString('ip_address', "");
                                          prefs.setString('access_token', "");
                                          prefs.setString('username', "");

                                          Navigator.pop(context);
                                          Navigator.pushReplacementNamed(
                                              context, '/login');
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }))
                          .toList(),
                      child: CircleAvatar(
                        radius: size.height * 0.035,
                        backgroundColor: Colors.brown.shade800,
                        child: Text(INITIALS),
                      ),
                    ),
                  ),
                ],
              ),
              body: Shimmer.fromColors(
                baseColor: kPrimaryLightColor,
                highlightColor: Colors.grey,
                enabled: true,
                child: ListView.builder(
                  itemBuilder: (_, __) => Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(24),
                            color: Colors.white,
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                width: size.width * 0.7,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: size.width * 0.5,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  itemCount: 10,
                ),
              ),
              floatingActionButton: ExpandableFab(
                distance: 90.0,
                children: [
                  Row(
                    children: [
                      const Text("Scan QR Code"),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      ActionButton(
                        onPressed: scan,
                        icon: Icon(
                          Icons.qr_code,
                          color: COLOR,
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Identifiers"),
                      SizedBox(
                        width: size.width * 0.03,
                      ),
                      ActionButton(
                        onPressed: () => Navigator.of(context)
                            .pushReplacementNamed("/identifiers"),
                        icon: Icon(
                          Icons.add,
                          color: COLOR,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  scan() async {
    var status = await Permission.camera.request();

    if (status.isGranted) {
      // Either the permission was already granted before or the user just granted it.
      var cameraScanResult = await scanner.scan();
      //Map identToken
      var qrData = jsonDecode(cameraScanResult!);

      var ident = qrData["identifier"];
      var identType = qrData["identifierType"];
      var token = qrData["token"];
      var exists = false;

      try {
        if (constantIdentifiers.isNotEmpty) {
          for (int i = 0; i < constantIdentifiers.length; i++) {
            try {
              if (constantIdentifiers[i]["identifier"] == ident) {
                exists = true;
                break;
              }
            } catch (e) {
              exists = false;
            }
          }
        }
        if (exists) {
          await confirmIdentifier(ident, identType, token);
          Get.off(const HomePage());
          return;
        } else {
          await addIdentifierToDB(ident, identType);
          await confirmIdentifier(ident, identType, token);
          Get.off(const HomePage());
          return;
        }
      } catch (e) {
        Fluttertoast.showToast(
            msg: "Unknown QR code",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 14.0);
        return;
      }
    }
  }
}

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: kPrimaryLightColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    var distance = 60.0;
    var count = widget.children.length;
    for (var i = 0; i < count; i++) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: 90,
          maxDistance: distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );

      distance = distance + 60;
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            onPressed: _toggle,
            child: const Icon(Icons.add),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (3.142 / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * 3.142 / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}

@immutable
class ActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Widget icon;

  const ActionButton({
    Key? key,
    this.onPressed,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      shape: const CircleBorder(),
      clipBehavior: Clip.antiAlias,
      color: theme.colorScheme.secondary,
      elevation: 4.0,
      child: IconButton(
        onPressed: onPressed,
        icon: icon,
        iconSize: 25,
      ),
    );
  }
}
