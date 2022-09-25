import 'package:app/utils/constants.dart';
import 'package:app/widgets/customized_text_button.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _controller = TextEditingController();

  final ValueNotifier<Country> _selectedCountry =
      ValueNotifier(Country.from(json: {
    "e164_cc": "91",
    "iso2_cc": "IN",
    "e164_sc": 0,
    "geographic": true,
    "level": 1,
    "name": "India",
    "example": "9123456789",
    "display_name": "India (IN) [+91]",
    "full_example_with_plus_sign": "+919123456789",
    "display_name_no_e164_cc": "India (IN)",
    "e164_key": "91-IN-0"
  }));

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Scaffold(
        backgroundColor: backgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                'Netflix',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: brandColor,
                    fontSize: 48.sp,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.w700),
              ),
            ),
            24.verticalSpace,
            Container(
              // padding: EdgeInsets.symmetric(horizontal: 24.w),
              decoration:
                  BoxDecoration(color: greyColor, borderRadius: borderRadius),
              width: 280.w,
              child: Row(
                children: [
                  ValueListenableBuilder<Country>(
                      valueListenable: _selectedCountry,
                      builder: (context, selectedCountry, child) {
                        return InkWell(
                          onTap: () {
                            showCountryPicker(
                                context: context,
                                onSelect: (Country country) {
                                  _selectedCountry.value = country;
                                });
                          },
                          child: Row(
                            children: [
                              8.horizontalSpace,
                              Text(
                                selectedCountry.phoneCode,
                                style: TextStyle(
                                    color: offWhiteColor, fontSize: 16.sp),
                              ),
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: offWhiteColor,
                                size: 24.sp,
                              )
                            ],
                          ),
                        );
                      }),
                  Expanded(
                    child: TextFormField(
                      style: TextStyle(color: offWhiteColor, fontSize: 16.sp),
                      keyboardType: TextInputType.number,
                      controller: _controller,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Phone Number',
                        hintStyle:
                            TextStyle(color: offWhiteColor.withOpacity(0.1)),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            24.verticalSpace,
            CustomizedButton(
                text: 'Sign In',
                height: 42.h,
                width: 280.w,
                color: Colors.transparent,
                borderColor: offWhiteColor,
                textStyle: TextStyle(fontSize: 16.sp, color: offWhiteColor),
                onTap: () {
                  print(_selectedCountry.value.phoneCode);
                  print(_controller.text);
                })
          ],
        ),
      ),
    );
  }
}
