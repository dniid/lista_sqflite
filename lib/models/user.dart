class User {
  int? id;
  String? email;
  String? password;

  // Init
  User(this.id, this.email, this.password);

  // FromMap
  User.fromMap(Map<String, dynamic> userInfo) {
    id = userInfo['id'];
    email = userInfo['email'];
    password = userInfo['password'];
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> userInfo = {
      'email': email,
      'password': password,
    };

    if (id != null) {
      userInfo['id'] = id;
    }

    return userInfo;
  }
}