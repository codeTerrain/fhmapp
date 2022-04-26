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
    if (pass!.isEmpty) {
      return 'Please provide your password';
    }
  }
}
