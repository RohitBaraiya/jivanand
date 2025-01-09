import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:jivanand/component/base_scaffold_widget.dart';
import 'package:jivanand/network/rest_apis.dart';
import 'package:jivanand/screens/patients/model/PatientsListModel.dart';
import 'package:jivanand/screens/vaid/model/VaidListModel.dart';
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

class AddVaidscreen extends StatefulWidget {


  AddVaidscreen({super.key, });

  @override
  _AddVaidscreenState createState() => _AddVaidscreenState();
}

class _AddVaidscreenState extends State<AddVaidscreen> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameCont = TextEditingController();
  TextEditingController mobileCont = TextEditingController();
  TextEditingController addressCont = TextEditingController();
  TextEditingController pinCodeCont = TextEditingController();
  TextEditingController emailCont = TextEditingController();

  FocusNode nameFocus = FocusNode();
  FocusNode mobileFocus = FocusNode();
  FocusNode addressFocus = FocusNode();
  FocusNode pinCodeFocus = FocusNode();
  FocusNode emailFocus = FocusNode();


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

      VaidListData model = VaidListData(
        id: 0,
        gender: selectedPadvi,
        name: nameCont.text.validate().toString(),
        email: emailCont.text.validate().toString(),
        address: addressCont.text.validate().toString(),
        pinCode: pinCodeCont.text.validate().toString(),
        mobileNo: mobileCont.text.validate().toString(),
      );
      log(jsonEncode(model));

        appStore.setLoading(true);
        await addVaid(model: model).then((value) async {
          appStore.setLoading(false);
          toast(value.message.validate().toString());
          if (value.statusCode == 200) {
            LiveStream().emit(LIVESTREAM_VAID_SCREEN);
            finish(context);
          }
        }).catchError((e) {
          appStore.setLoading(false);
          toast(e.toString());
        });

    }
  }


  List<String> padaviList = ['Gender','Male','Female'];

  String selectedPadvi = 'Gender';

  //endregion
  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      appBarTitle: 'Add Vaidya',
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
              10.width,
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: nameCont,
                focus: nameFocus,
                nextFocus: mobileFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Name'),
                suffix: Assets.iconsIcProfile2.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              DropdownButtonFormField<String>(
                decoration: inputDecoration(context, labelText: 'Gender'),
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
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: mobileCont,
                focus: mobileFocus,
                nextFocus: addressFocus,
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
              AppTextField(
                textFieldType: TextFieldType.NAME,
                controller: addressCont,
                focus: addressFocus,
                nextFocus: pinCodeFocus,
                maxLines: 3,
                minLines: 3,
                // nextFocus: mobileFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Address'),
                suffix: Assets.iconsIcServicesAddress.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.NUMBER,
                controller: pinCodeCont,
                focus: pinCodeFocus,
                nextFocus: emailFocus,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
                maxLength: 6,
                buildCounter: (_, {required int currentLength, required bool isFocused, required int? maxLength}) {
                  return const Offstage().visible(false);
                },
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'PinCode'),
                suffix: Assets.iconsIcServicesAddress.iconImage(size: 10).paddingAll(14),
              ),
              16.height,
              AppTextField(
                textFieldType: TextFieldType.EMAIL_ENHANCED,
                controller: emailCont,
                focus: emailFocus,
                errorThisFieldRequired: language.requiredText,
                decoration: inputDecoration(context, labelText: 'Email'),
                suffix: Assets.iconsIcMessage.iconImage(size: 10).paddingAll(14),
              ),


              30.height,
              AppButton(
                  width: context.width(),
                  text:  'SAVE',
                  color: primaryColor,
                  textColor: Colors.white,
                  onTap: () async {
                      if(selectedPadvi != 'Gender'){
                        adduser();
                      }else{
                        toast('Please Select Gender');
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
