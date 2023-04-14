class Validation {
  String? validateEmpty(String? value) {
    if (value!.isEmpty) {
      return "This field cannot be empty";
    }

    return null;
  }

  dynamic validateDropDown(dynamic value) {
    if (value == null) {
      return "This field must be selected";
    }
    return null;
  }

  String? validateEmail(String? value) {
    if (value!.isEmpty) {
      return "Email Address cannot be empty";
    }
    if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)) {
      return 'Please enter a valid Email';
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value!.isEmpty) {
      return "The password cannot be empty";
    }
    if (value.length < 6 || value.length > 20) {
      return 'At least 6 characters and not more than 20 characters';
    }
  }

  String? validateContact(String? value) {
    if (value!.isEmpty) {
      return "The contact no cannot be empty";
    }
    if (!RegExp(r'^01\d-\d{7,8}$').hasMatch(value)) {
      return 'Please enter a valid contact no';
    }
    return null;
  }
}
