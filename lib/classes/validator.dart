
class Validator {
  static String? validateName({required String? name}) {
    if (name!.isEmpty) {
      return 'Name can\'t be empty';
    }
    return null;
  }

  static String? validateEmail({required String? email}) {
    return null;
  }

  static String? validatePassword({required String? password}) {
    if (password!.isEmpty) {
      return 'Password can\'t be empty';
    } else if (password.length < 6) {
      return 'Enter a password with length at least 6';
    }
    return null;
  }

// static String? validatePassword(
//     {required String? password, String? expectedPassword}) {
//   if (password == null || password.isEmpty) {
//     return 'Password can\'t be empty';
//   } else if (password.length < 6) {
//     return 'Enter a password with length at least 6';
//   } else if (password != expectedPassword) {
//     return 'Password is incorrect';
//   }
//   return null;
// }
}
