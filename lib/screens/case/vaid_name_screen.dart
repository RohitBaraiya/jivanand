import 'package:jivanand/app_theme.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/vaid/model/VaidListModel.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/constant.dart';
import 'package:jivanand/utils/model_keys.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../../main.dart';

class VaidNameScreen extends StatefulWidget {

  final Function(String name,String locationName)? onComplete;

  const VaidNameScreen({super.key, required this.onComplete, });

  @override
  VaidNameScreenState createState() => VaidNameScreenState();
}

class VaidNameScreenState extends State<VaidNameScreen> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    init();
  }
  List<String> list=['Select Vaidya'];

  List<VaidListData> mainList=[];

  DateTime currentDateTime = DateTime.now();
  DateTime? finalDate;
  TimeOfDay? pickedTime;
  DateTime? selectedDate;

  Future<void> init() async {
    appStore.setLoading(true);
    await getAllVaidList().then((value) async {
      if (value.statusCode == 200) {
        mainList = value.data.validate();
        List<String> list = [];
        if(value.data.validate().isNotEmpty){
          value.data!.forEach((element) {
            list.add(element.name.validate().toString());
          });
        }
        await 1000.milliseconds.delay;
        appStore.setLoading(false);
        log('aaa${list.length}');

        setState(() {
          this.list.addAll(list);
        });
      }else{
        toast(value.message.validate().toString());
      }
    }).catchError((e) {
      appStore.setLoading(false);
      toast(e.toString());
    });
  }

  Future<void> forgotPwd() async {
    hideKeyboard(context);

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      String id='';
      if(mainList.isNotEmpty){
        mainList.forEach((element) {
          if(element.name.validate().toString() == selectedPadvi){
            id = element.id.validate().toString();
          }
        });
      }
      widget.onComplete!.call(id,selectedLocation);
      finish(context);

    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  bool isSelected = true;
  String selectedPadvi = 'Select Vaidya';

  List<String> locationList = ['Location','Surat','Palitana','Shri Sammed Shikhar'];
  String selectedLocation = 'Location';

  TextEditingController dateTimeCont = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      key: formKey,
      child: SingleChildScrollView(
        child: Container(
          color: bgColor,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16),
                width: context.width(),
                decoration: boxDecorationDefault(
                  color: cardColor,
                  borderRadius: radiusOnly(topRight: defaultRadius, topLeft: defaultRadius),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Today Case ?', style: boldTextStyle(color: textColor)),
                    IconButton(
                      onPressed: () {
                        finish(context);
                      },
                      icon: Icon(Icons.clear, color: textColor, size: 20),
                    )
                  ],
                ),
              ),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Please Fill Out From.', style: secondaryTextStyle()),
                  24.height,
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(context, labelText: 'Location'),
                    isExpanded: true,
                    value: selectedLocation,
                    dropdownColor: context.cardColor,
                    items: locationList.map((String e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: primaryTextStyle(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      );
                    }).toList(),
                    onChanged: (String? value) async {
                      hideKeyboard(context);
                      selectedLocation = value.validate().toString();

                      setState(() {});
                    },
                  ),
                  24.height,
                  Observer(
                    builder:(context) =>  DropdownButtonFormField<String>(
                      decoration: inputDecoration(context, labelText: 'Select Vaidya'),
                      isExpanded: true,
                      value: selectedPadvi,
                      dropdownColor: context.cardColor,
                      items: list.map((String e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(
                            e,
                            style: primaryTextStyle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      }).toList(),
                      onChanged: (String? value) async {
                        hideKeyboard(context);
                        selectedPadvi = value.validate().toString();

                        setState(() {});
                      },
                    ).visible(!appStore.isLoading, defaultWidget: Loader()),
                  ),
                  24.height,
                  AppTextField(
                    textFieldType: TextFieldType.OTHER,
                    controller: dateTimeCont,
                    isValidationRequired: true,
                    validator: (value) {
                      if (value!.isEmpty) return language.requiredText;
                      return null;
                    },
                    readOnly: true,
                    onTap: () {
                      selectDateAndTime(context);
                    },
                    decoration: inputDecoration(context, prefixIcon: Assets.iconsIcCalendar.iconImage(size: 10,color: textColor).paddingAll(14)).copyWith(
                      fillColor: cardColor,
                      filled: true,
                      hintText: 'Select Followup Date',
                      hintStyle: primaryTextStyle(color: textColor),
                    ),
                  ),
                  16.height,
                  AppButton(
                    text: 'Submit',
                    color: primaryColor,
                    textColor: Colors.white,
                    width: context.width() - context.navigationBarHeight,
                    onTap: () {
                      if(selectedPadvi == 'Select Vaidya'){
                        toast('Please Select Vaidya');
                      }else if(selectedLocation == 'Location'){
                        toast('Please Select Location');
                      } else{
                        forgotPwd();
                      }
                    },
                  ),
                ],
              ).paddingAll(16),
            ],
          ),
        ).cornerRadiusWithClipRRect(10),
      ),
    );
  }

  void selectDateAndTime(BuildContext context) async {


    await showDatePicker(
      context: context,
      initialDate: selectedDate ?? currentDateTime,
      firstDate: currentDateTime,
      lastDate: currentDateTime.add(30.days),
      locale: Locale(appStore.selectedLanguageCode),
      cancelText: language.lblCancel,
      confirmText: language.lblOk,
      helpText: language.lblSelectDate,
      builder: (_, child) {
        return Theme(
          data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
          child: child!,
        );
      },
    ).then((date) async {
      if (date != null) {
        await showTimePicker(
          context: context,
          initialTime: pickedTime ?? TimeOfDay.now(),
          cancelText: language.lblCancel,
          confirmText: language.lblOk,
          builder: (_, child) {
            return Theme(
              data: appStore.isDarkMode ? ThemeData.dark() : AppTheme.lightTheme(),
              child: child!,
            );
          },
        ).then((time) {
          if (time != null) {
            finalDate = DateTime(date.year, date.month, date.day, time.hour, time.minute);

            DateTime now = DateTime.now().subtract(1.minutes);
            if (date.isToday && finalDate!.millisecondsSinceEpoch < now.millisecondsSinceEpoch) {
              return toast(language.selectedOtherBookingTime);
            }

            selectedDate = date;
            pickedTime = time;

            dateTimeCont.text = "${formatBookingDate(selectedDate.toString(), format: DATE_FORMAT_32)} ${pickedTime!.format(context).toString()}";
          }
          setState(() {});
        }).catchError((e) {
          toast(e.toString());
        });
      }
    });
  }







}
