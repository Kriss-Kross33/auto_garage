class LoginWithEmailAndPasswordFailure implements Exception {
  LoginWithEmailAndPasswordFailure({
    this.errorMessage = 'Unknown Error',
    this.code = 'Unknown code',
  });

  final String errorMessage;

  final String code;

  factory LoginWithEmailAndPasswordFailure.fromCode(String code) {
    return switch (code) {
      'invalid-email' => LoginWithEmailAndPasswordFailure(
          errorMessage: 'Email is not valid or badly formatted'),
      'user-disabled' => LoginWithEmailAndPasswordFailure(
          errorMessage:
              'This user has been disabled. Please contact customer support'),
      'wrong-password' => LoginWithEmailAndPasswordFailure(
          errorMessage:
              'Incorrect password. Please provide the correct password for this account'),
      'user-not-found' => LoginWithEmailAndPasswordFailure(
          errorMessage: 'User not found',
          code: code,
        ),
      _ => LoginWithEmailAndPasswordFailure()
    };
  }
}
