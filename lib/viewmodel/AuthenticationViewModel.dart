import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:utmletgo/app/_route.dart';
import 'package:utmletgo/constants/enum_constants.dart';
import 'package:utmletgo/services/_services.dart';
import 'package:utmletgo/shared/Exception.dart';
import 'package:utmletgo/view/Authentication/RegisterScreen.dart';
import 'package:utmletgo/model/User.dart' as dbUser;

class AuthenticationViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _authService = locator<FirebaseAuthenticationService>();
  final _dialogService = locator<DialogService>();
  final _userService = locator<UserService>();
  final _dataPassingService = locator<DataPassingService>();
  void navigateToLogin() {
    _navigationService.navigateTo(Routes.loginScreen);
  }

  void navigateToRegister() {
    _navigationService.navigateTo(Routes.registerScreen);
  }

  void navigateToResetPassword() {
    _navigationService.navigateTo(Routes.resetPasswordScreen);
  }

  Future<void> navigateToMainScreen(dbUser.User currentUser) async {
    _dataPassingService.addToDataPassingList(
        'current_user_guid', currentUser.guid);
    if (currentUser.userType == UserType.user.name) {
      _navigationService.navigateTo(Routes.mainScreen);
    } else {
      _navigationService.navigateToAdminVisibilityScreen();
    }
  }

  Future<void> login(String email, String password) async {
    User? result = await _authService.signIn(email, password);
    dbUser.User currentUser = await _userService.getCurrentUser();
    if (currentUser.visibility == VisibilityType.allow.name) {
      navigateToMainScreen(currentUser);
    } else {
      throw GeneralException(
          title: "Your account has been temporarily suspended",
          message:
              "To recover your account, you can send an appeal email to the admin - haoyangkong@gmail.com");
    }
  }

  // Future<void> loginWithSocialMedia() async {
  //   UserCredential? result = await _authService.signInWithToken();
  //   var user = await _userService.getUserByDocumentId(result.user!.uid);
  //   if (user == null) {
  //     _navigationService.navigateToView(RegisterScreen(
  //       isEmailSignUp: false,
  //     ));
  //   } else {
  //     if (user.visibility == VisibilityType.allow.name) {
  //       navigateToMainScreen(user);
  //     } else {
  //       throw GeneralException(
  //           title: "Your account has been temporarily suspended",
  //           message:
  //               "To recover your account, you can send an appeal email to the admin\n email: haoyangkong@gmail.com");
  //     }
  //   }
  // }

  Future<void> resetPassword(String email) async {
    await _authService.resetPassword(email);
  }

  Future<void> registerWithEmailPassword(
    String email,
    String password,
    String confirm,
    String name,
    String gender,
    String status,
    String campus,
    String contact,
  ) async {
    bool isSuccess = await _authService.signUp(email, password);

    if (isSuccess) {
      await _userService.addUser(_authService.getUID(), email, password,
          confirm, name, gender, status, campus, contact);
      navigateToLogin();
    } else {
      _dialogService.showDialog(
        title: "Failed To Sign Up",
        description: "Please makesure all fields are filled completely",
      );
    }
  }

  bool validateFields(GlobalKey<FormState>? key) {
    return key!.currentState!.validate();
  }
}
