import 'package:app/screens/home.dart';
import 'package:app/screens/login/login.dart';
import 'package:app/services/authentication.dart';
import 'package:app/utils/constants.dart';
import 'package:app/widgets/customized_text_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pin_put/pin_put.dart';

class OTPScreen extends StatefulWidget {
  String code, phone;
  OTPScreen({Key? key, required this.code, required this.phone})
      : super(key: key);

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  ValueNotifier<bool> _isOTPSent = ValueNotifier(false);
  ValueNotifier<bool> _didVerificationFail = ValueNotifier(false);
  ValueNotifier<bool> _isVerifying = ValueNotifier(false);

  bool otpEntered = false;
  String _verificationCode = '';
  final TextEditingController _pinPutController = TextEditingController();

  final decoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(8.0),
    border: Border.all(color: Colors.grey),
  );

  @override
  void initState() {
    _verifyPhone();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: AnimatedBuilder(
              animation: Listenable.merge([_isOTPSent, _didVerificationFail]),
              builder: (context, child) {
                return _didVerificationFail.value
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Verification Failed',
                              style: TextStyle(
                                  color: offWhiteColor,
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600),
                            ),
                            24.verticalSpace,
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: CustomizedButton(
                                  height: 42,
                                  color: Colors.transparent,
                                  onTap: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                        (route) => false);
                                  },
                                  textStyle: TextStyle(
                                    color: offWhiteColor,
                                  ),
                                  borderColor: brandColor,
                                  text: 'Re Enter Phone Number'),
                            )
                          ],
                        ),
                      )
                    : _isOTPSent.value
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 24.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                48.verticalSpace,
                                Text('Verify Phone Number',
                                    style: TextStyle(
                                        color: brandColor,
                                        fontSize: 24.sp,
                                        fontWeight: FontWeight.w600)),
                                24.verticalSpace,
                                PinPut(
                                  autofocus: true,
                                  fieldsCount: 6,
                                  textStyle: TextStyle(
                                      fontSize: 24.sp,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500),
                                  eachFieldWidth: 47.h,
                                  eachFieldHeight: 49.h,
                                  enableInteractiveSelection: false,
                                  controller: _pinPutController,
                                  onChanged: (_) {
                                    // if (_pinPutController.text.length < 6) {
                                    //   otpEntered = false;
                                    //   _allowToVerify.value = false;
                                    // }
                                  },
                                  submittedFieldDecoration: decoration
                                    ..copyWith(
                                        border: Border.all(color: Colors.grey)),
                                  selectedFieldDecoration: decoration.copyWith(
                                      border: Border.all(color: Colors.grey)),
                                  followingFieldDecoration: decoration,
                                  pinAnimationType: PinAnimationType.fade,
                                  onSubmit: (pin) async {},
                                ),
                                48.verticalSpace,
                                ValueListenableBuilder<bool>(
                                    valueListenable: _isVerifying,
                                    builder: (context, isVerifying, child) {
                                      return CustomizedButton(
                                          height: 42,
                                          color: Colors.transparent,
                                          onTap: () async {
                                            _isVerifying.value = true;
                                            UserCredential? userCredential =
                                                await Authentication.signIn(
                                                    verificationCode:
                                                        _verificationCode,
                                                    smsCode:
                                                        _pinPutController.text,
                                                    phoneNumber: widget.code +
                                                        widget.phone);
                                            _isVerifying.value = false;
                                            if (userCredential?.user != null) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          HomeScreen()));
                                            } else {
                                              print('could not authenticate');
                                            }
                                          },
                                          borderColor: brandColor,
                                          textStyle: TextStyle(
                                            color: offWhiteColor,
                                          ),
                                          widget: isVerifying
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    height: 24.h,
                                                    width: 24.h,
                                                    child:
                                                        CircularProgressIndicator(
                                                            color:
                                                                offWhiteColor),
                                                  ),
                                                )
                                              : null,
                                          text: 'Verify');
                                    })
                              ],
                            ),
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  color: brandColor,
                                ),
                                48.verticalSpace,
                                Text(
                                  'Please wait while we send you the OTP',
                                  style: TextStyle(
                                      color: offWhiteColor, fontSize: 16.sp),
                                )
                              ],
                            ),
                          );
              }),
        ));
  }

  void _verifyPhone() async {
    _isOTPSent.value = false;
    _didVerificationFail.value = false;
    await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: widget.code + widget.phone,
        verificationCompleted: (PhoneAuthCredential credential) async {
          UserCredential? userCredential = await Authentication.signIn(
              verificationCode: _verificationCode,
              smsCode: credential.smsCode,
              phoneNumber: widget.code + widget.phone);
        },
        verificationFailed: (FirebaseAuthException e) {
          _didVerificationFail.value = true;
          if (e.message != null) Fluttertoast.showToast(msg: e.message!);
        },
        codeSent: (String verficationID, int? resendToken) {
          _verificationCode = verficationID;
          // _otpResendToken = resendToken;
          _isOTPSent.value = true;
          // if (otpEntered) _allowToVerify.value = true;
          // if (resendOTP) {
          //   SentryService.log(
          //       type: SentryLogType.info, message: 'counter restart');
          //   Fluttertoast.showToast(msg: 'OTP sent');
          //   countdownController.restart();
          //   _pinPutController.clear();
          // } else {
          //   SentryService.log(
          //       type: SentryLogType.info, message: 'counter start');
          //   countdownController.start();
          // }
          // canGoBack = true;
          // _refresh();
        },
        codeAutoRetrievalTimeout: (String verificationID) {
          // _verificationCode = verificationID;
          // SentryService.log(
          //     type: SentryLogType.info,
          //     message: 'code auto retrieval timeout callback hit ');
          // _refresh();
        },
        // forceResendingToken: resendOTP ? _otpResendToken : null,
        timeout: Duration(seconds: 120));
  }
}
