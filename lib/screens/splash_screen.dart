import 'dart:io';
import 'package:jivanand/generated/assets.dart';
import 'package:jivanand/main.dart';
import 'package:jivanand/screens/dashboard/dashboard_screen.dart';
import 'package:jivanand/screens/dashboard/fragment/dashboard_fragment.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/configs.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/images.dart';
import 'package:jivanand/utils/permissions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  bool appNotSynced = false;





  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      setStatusBarColor(Colors.transparent, statusBarBrightness: Brightness.dark, statusBarIconBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark);

      init();
      appStore.setUserWalletAmount();
    });
  }

  Future<void> init() async {
    await appStore.setLanguage(getStringAsync(SELECTED_LANGUAGE_CODE, defaultValue: DEFAULT_LANGUAGE));
    int themeModeIndex = getIntAsync(THEME_MODE_INDEX, defaultValue: THEME_MODE_SYSTEM);
    if (themeModeIndex == THEME_MODE_SYSTEM) {
      appStore.setDarkMode(MediaQuery.of(context).platformBrightness == Brightness.dark);
    }

   // int dayId = await getDayId();
    ///Set app configurations
    /*await getAppConfigurations().then((value) {
      if (value.statusCode == 200) {
        gotoNext();
      }else{
        toast(value.message.validate().toString());
      }
    }).catchError((e) async {
      if (!await isNetworkAvailable()) {
        toast(errorInternetNotAvailable);
      }
      log(e);
    });*/

    /*int deviceVersion = int.parse(operatingSystemVersion.split(' ')[1]);
    log(deviceVersion);*/

    Permissions.cameraFilesAndLocationPermissionsGranted()
        .then((value) async {
      await setValue(PERMISSION_STATUS, value);
      if (value) {
         gotoNext();
      }
    });
   // gotoNext();

  }

  void deleteFolder(String path) {
    final folder = Directory(path);

    try {
      // Check if the folder exists before trying to delete
      if (folder.existsSync()) {
        folder.deleteSync(recursive: true);
        print('Folder deleted successfully.');
      } else {
        print('Folder does not exist.');
      }
    } catch (e) {
      print('Failed to delete folder: $e');
    }
  }

  Future<void> gotoNext() async {
    deleteFolder('/data/user/0/com.jito.jivanand/cache/VeerThumbnail');
    await 2000.milliseconds.delay;
   //  AddProductScreen(price: '',id: '',catId: '',catName: '',image: '',name: '',).launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    setValue(AUTO_SLIDER_STATUS, true);
    DashboardFragment().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);

  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        //fit: StackFit.expand,
        children: [
          Image.asset(
            appStore.isDarkMode ? splash_background : splash_light_background,
            height: context.height(),
            width: context.width(),
            fit: BoxFit.cover,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(Assets.jivanandJivanandLogo, height: 230, width: 230).cornerRadiusWithClipRRect(20),
              20.height,
            ],
          ).center(),
          const Align(
            alignment: Alignment.bottomCenter,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                LinearProgressIndicator(
                  minHeight: 3,
                  backgroundColor: white,
                  color: jivanandColor,
                )
              ],
            ),
          ).paddingOnly(bottom: 12),

        ],
      ),
    );
  }
}
