class User {
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;

  User({this.firstName, this.lastName, this.email, this.phoneNumber});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
    );
  }
}
