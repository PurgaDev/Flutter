class User {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phoneNumber;
  String? role;

  User({this.id, this.firstName, this.lastName, this.email, this.phoneNumber, this.role});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id:json['id'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      role:json['role']
    );
  }
}
