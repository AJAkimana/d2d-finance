const String GET_USER_AUTH_INFO = '''
  query {
    me {
      id
      firstName
      lastName
      userName
      email
      isSuperuser
      householdSet {
        id
        name
      }
    }
    myHouseholdMemberships {
      user {
        id
        email
        userName
      }
      household {
        id
        name
      }
      accessLevel
    }
  }
''';