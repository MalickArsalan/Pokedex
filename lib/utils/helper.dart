String? emailValidator(String? email) {
  // email regex
  final emailRegex = RegExp(r'^[a-zA-Z0-9.]+@[a-zA-Z0-9]+\.[a-zA-Z]+');

  // validate email
  if (email == null || email == '') {
    return 'Email is required';
  } else if (!emailRegex.hasMatch(email.toString())) {
    return 'Email is invalid';
  } else {
    return null;
  }
}

String? passwordValidator(String? password) {
  if (password == null || password.length < 8) {
    return 'Password must be at least 8 characters';
  }
  return null;
}
