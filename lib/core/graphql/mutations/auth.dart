const String LOGIN_MUTATION = """
  mutation Login(\$email: String!, \$password: String!) {
    loginUser(email: \$email, password: \$password) {
      message
      token
      restToken
      user {
        id
        email
        firstName
        lastName
      }
    }
  }
""";

const String RESET_PASSWORD_MUTATION = """
  mutation ResetPassword(\$oldPassword: String!, \$newPassword: String!, \$email: String!) {
    resetPassword(oldPassword: \$oldPassword, newPassword: \$newPassword, email: \$email) {
      message
    }
  }
""";
