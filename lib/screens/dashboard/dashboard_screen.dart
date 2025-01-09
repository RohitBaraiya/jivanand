import 'package:jivanand/component/image_border_component.dart';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';


class DashboardScreen extends StatefulWidget {
  final bool? redirectToBooking;

  const DashboardScreen({super.key, this.redirectToBooking});

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> with WidgetsBindingObserver {
    int currentIndex = 0;

  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
   // log('Background');
    if (state == AppLifecycleState.resumed) {
      log('Background');
  //    calUserDetailAPI();
      //appStore.setUserWalletAmount();
    }
  }

/*  Future<void> calUserDetailAPI() async {
    await userDetail(context: context).then((value) {
    }).catchError((e) {log(e);});
  }*/


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    /*if (widget.redirectToBooking.validate(value: false)) {
      currentIndex = 1;
    }*/

    afterBuildCreated(() async {
      /// Changes System theme when changed
      if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
        appStore.setDarkMode(context.platformBrightness() == Brightness.dark);
      }

      View.of(context).platformDispatcher.onPlatformBrightnessChanged = () async {
        if (getIntAsync(THEME_MODE_INDEX) == THEME_MODE_SYSTEM) {
          appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.light);
        }
      };
    });


    /// Handle Firebase Notification click and redirect to that Service & BookDetail screen
    LiveStream().on(LIVESTREAM_FIREBASE, (value) {
      if (value == 1) {
        currentIndex = 1;
        setState(() {});
      }
    });

    /*Firebase.initializeApp().then((value) {
      //When the app is in the background and opened directly from the push notification.
      FirebaseMessaging.onMessageOpenedApp.listen((message) async {
        //Handle onClick Notification
        log("data 1 ==> ${message.data}");
        handleNotificationClick(message);
      });

      FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
        //Handle onClick Notification
        if (message != null) {
          log("data 2 ==> ${message.data}");
          handleNotificationClick(message);
        }
      });
    }).catchError(onError);*/

    init();
  }

  void init() async {
    if (isMobile && appStore.isLoggedIn) {
      /// Handle Notification click and redirect to that Service & BookDetail screen
      ///
      /// TODO check if handled with firebase
      /*OneSignal.Notifications.addClickListener((notification) async {
        if (notification.notification.additionalData == null) return;

        if (notification.notification.additionalData!.containsKey('id')) {
          String? notId = notification.notification.additionalData!["id"].toString();
          if (notId.validate().isNotEmpty) {
            BookingDetailScreen(bookingId: notId.toString().toInt()).launch(context);
          }
        } else if (notification.notification.additionalData!.containsKey('service_id')) {
          String? notId = notification.notification.additionalData!["service_id"];
          if (notId.validate().isNotEmpty) {
            ServiceDetailScreen(serviceId: notId.toInt()).launch(context);
          }
        } else if (notification.notification.additionalData!.containsKey('sender_uid')) {
          String? notId = notification.notification.additionalData!["sender_uid"];
          if (notId.validate().isNotEmpty) {
            currentIndex = 3;
            setState(() {});
          }
        }
      });*/

    // calUserDetailAPI();
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
    LiveStream().dispose(LIVESTREAM_FIREBASE);
  }

  @override
  Widget build(BuildContext context) {
    return DoublePressBackWidget(
      message: language.lblBackPressMsg,
      child: Scaffold(
        backgroundColor: bgColor,
        body: [
          const DashboardFragment(),
          const DashboardFragment(),
          const DashboardFragment(),
          const DashboardFragment(),
          const DashboardFragment(),
        ][currentIndex],
        bottomNavigationBar: Blur(
          blur: 30,
          borderRadius: radius(0),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: cardColor.withOpacity(0.9),
              indicatorColor: context.primaryColor.withOpacity(0.1),
              labelTextStyle: WidgetStateProperty.all(primaryTextStyle(size: 12)),
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
            ),
            child: NavigationBar(
              selectedIndex: currentIndex,
              destinations: [
                NavigationDestination(
                  icon: Assets.appIconHome1.iconImage(color: appTextSecondaryColor,size: 22),
                  selectedIcon: Assets.appIconHome2.iconImage(color: context.primaryColor,size: 22),
                  label: language.home,
                ),
                NavigationDestination(
                  icon: Assets.appIconBallot1.iconImage(color: appTextSecondaryColor,size: 22),
                  selectedIcon: Assets.appIconBallot.iconImage(color: context.primaryColor,size: 22),
                  label: 'Title-2',
                ),
                NavigationDestination(
                  icon: Assets.appIconBallot1.iconImage(color: appTextSecondaryColor,size: 22),
                  selectedIcon: Assets.appIconBallot.iconImage(color: context.primaryColor,size: 22),
                  label: 'Title-3',
                ),
                NavigationDestination(
                  icon: Assets.appIconBallot1.iconImage(color: appTextSecondaryColor,size: 22),
                  selectedIcon: Assets.appIconBallot.iconImage(color: context.primaryColor,size: 22),
                  label: 'Title-4',
                ),
                Observer(builder: (context) {
                  return NavigationDestination(
                    icon: (appStore.isLoggedIn && appStore.userProfileImage.isNotEmpty)
                        ? IgnorePointer(ignoring: true, child: ImageBorder(src: appStore.userProfileImage, height: 26))
                        : Assets.appIconBallot1.iconImage(color: appTextSecondaryColor,size: 22),
                    selectedIcon: (appStore.isLoggedIn && appStore.userProfileImage.isNotEmpty)
                        ? IgnorePointer(ignoring: true, child: ImageBorder(src: appStore.userProfileImage, height: 26))
                        : Assets.appIconBallot.iconImage(color: context.primaryColor,size: 22),
                    label: 'Title-5',
                  );
                }),
              ],
              onDestinationSelected: (index) {
                currentIndex = index;
                setState(() {});
              },
            ),
          ),
        ),
      ),
    );
  }
}
