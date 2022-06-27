class Validator {
  static String? isValidEmail(String? email) {
    bool res = RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(email!);

    if (res) {
      return null;
    } else {
      return 'Check your email';
    }
  }

  static String? isValidPassword(String? password) {
    var pass = password?.trim();
    if (pass!.isEmpty || pass.length < 8) {
      return 'Please provide a password with at least 8 characters';
    } else {
      return null;
    }
  }

  static String? validField(String? field, String fieldName) {
    var x = field?.trim();
    if (x!.isEmpty) {
      return 'Please enter your $fieldName';
    } else {
      return null;
    }
  }
}
