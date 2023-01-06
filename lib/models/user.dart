class User {
  final String? _id;
  final String? userName;

  User(this._id, this.userName);

  factory User.fromJson(Map<String, dynamic>? json) {
    {
      return User(
        json?['_id'],
        json?['user_name'],
      );
    }
  }
}
