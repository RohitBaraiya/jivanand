import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/utils/colors.dart';
import 'package:jivanand/utils/common.dart';
import 'package:jivanand/utils/images.dart';
import 'package:jivanand/utils/string_extensions.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter/material.dart';
import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../generated/assets.dart';
import '../../main.dart';
import '../../utils/constant.dart';

class AddPatientscreen extends StatefulWidget {


  AddPatientscreen({super.key, });

  @override
  _AddPatientscreenState createState() => _AddPatientscreenState();
}

class _AddPatientscreenState extends State<AddPatientscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController samudayCont = TextEditingController();
  TextEditingController ageCont = TextEditingController();
  TextEditingController sevakNameCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode samudayFocus = FocusNode();
  FocusNode ageFocus = FocusNode();
  FocusNode sevakNameFocus = FocusNode();


  @override
  void initState() {
    super.initState();
    initializeDateFormatting();
    setStatusColor();
    init();
  }

  void init() async {
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }




  void adduser() async {
    hideKeyboard(context);
    if (appStore.isLoading) return;
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      PatientsListData model = PatientsListData(
        id: 0,
        padvi: selectedPadvi,
        name: nameCont.text.validate().toString(),
        age: ageCont.text.validate().toInt(),
        samudai: samudayCont.text.validate().toString(),
        sevak: sevakNameCont.text.validate().toString(),
        mobileNo: mobileCont.text.validate().toString(),
        location: selectedLocation,
      );
      log(jsonEncode(model));

        appStore.setLoading(true);
        await addPatient(model: model).then((value) async {
          appStore.setLoading(false);
          toast(value.message.validate().toString());
          if (value.statusCode == 200) {
            LiveStream().emit(LIVESTREAM_PATIENT_SCREEN);
            finish(context);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });

    }
  }


  List<String> padaviList = ['Padvi','Gacchadhipati','Acharya','Panyas','Muni','SadhviJi','Mr.','Mrs.',];
  List<String> locationList = ['Location','Surat','Palitana','Shri Sammed Shikhar'];

  String selectedPadvi = 'Padvi';
  String selectedLocation = 'Location';
  //endregion
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Add Patients',
      scaffoldBackgroundColor: bgColor,
      child: Form(
        key: formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  DropdownButtonFormField<String>(
                    decoration: inputDecoration(context, labelText: 'Padvi'),
                    isExpanded: true,
                    value: selectedPadvi,
                    dropdownColor: context.cardColor,
                    items: padaviList.map((String e) {
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
                  ).expand(flex: 3),
                  10.width,
                  AppTextField(
                    textFieldType: TextFieldType.NAME,
                    controller: nameCont,
                    focus: nameFocus,
                    nextFocus: ageFocus,
                    errorThisFieldRequired: language.requiredText,
                    decoration: inputDecoration(context, labelText: 'Name'),
                    suffix: Assets.iconsIcProfile2.iconImage(size: 10).paddingAll(14),
                  ).expand(flex: 7),
                ],
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: ageCont,
                focus: ageFocus,
                nextFocus: samudayFocus,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                // nextFocus: mobileFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Age'),
                suffix: Assets.iconsAge.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: samudayCont,
                focus: samudayFocus,
                nextFocus: sevakNameFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Samudai'),
                suffix: Assets.iconsCommunity.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: sevakNameCont,
                focus: sevakNameFocus,
                nextFocus: mobileFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Sevak Name'),
                suffix: Assets.iconsCommunity.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: mobileCont,
                focus: mobileFocus,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 10,
                buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
                  return const Offstage().visible(false);
                },
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Mobile Number'),
                suffix: Assets.iconsIcCalling.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
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
              30.height,
              AppButton(
                  width: context.width(),
                  text:  'SAVE',
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: () async {
                      if(selectedPadvi == 'Padvi'){
                        toast('Please Select Padvi');
                      }else if(selectedLocation == 'Location'){
                        toast('Please Select Location');
                      } else{
                        adduser();
                      }
                  }
              ),
              10.height,
              /*RohitButtonWidget(title: 'Create', color:white, grident: 2, padding: 12,buttonWidth: context.width()- context.navigationBarHeight ,buttonheight: 50,).onTap((){
                registerUser();
              }).center(),*/
            ],
          ),
        ),
      ),
    );
  }


}
