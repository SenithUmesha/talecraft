import 'package:get/get.dart';

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) {
    return 'Please enter a email';
  } else if (!GetUtils.isEmail(email)) {
    return 'Please enter a valid email';
  } else {
    return null;
  }
}

String? validatePasswordLogin(String? password) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  } else {
    return null;
  }
}

bool isValidNameAndDiacritics(String value) {
  final regex =
      RegExp(r"^[\p{L} ]*$", caseSensitive: false, unicode: true, dotAll: true);
  return regex.hasMatch(value);
}

String? validateName(String? name) {
  if (name == null || name.isEmpty) {
    return 'Please enter a name';
  } else if (!isValidNameAndDiacritics(name)) {
    return 'Please enter a valid name';
  } else {
    return null;
  }
}

bool isValidPassword(String value) {
  final regex = RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9]).{8,}');
  return regex.hasMatch(value);
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) {
    return 'Please enter a password';
  } else if (password.length < 8) {
    return 'Password must be higher than 8 characters';
  } else if (!isValidPassword(password)) {
    return 'Password must have at least one uppercase letter, one lowercase letter, one number, and 8 digits long';
  } else {
    return null;
  }
}

String? validateConfirmPasswordRegistration(
    String? password, String? confirmPassword) {
  if (confirmPassword == null || confirmPassword.isEmpty) {
    return 'Please confirm your password';
  } else if (confirmPassword != password) {
    return 'Please make sure your passwords match';
  } else {
    return null;
  }
}

String? validateSearch(String? text) {
  if (text == null || text.isEmpty) {
    return 'Please enter some text';
  } else {
    return null;
  }
}
