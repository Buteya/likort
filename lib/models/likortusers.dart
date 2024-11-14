class User {
  final String id;
  final String firstname;
  final String lastname;
  final String email;
  final String password;
  final String usertype;
  final double latitude;
  final double longitude;

  User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.password,
    this.usertype = 'basic user',
    required this.latitude,
    required this.longitude,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      firstname: json['firstname'],
      lastname: json['lastname'],
      email: json['email'],
      password: json['password'],
      usertype: json['usertype'],
      latitude: json['latitude'],
      longitude: json['longitude'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstname': firstname,
      'lastname': lastname,
      'email': email,
      'password':password,
      'usertype':usertype,
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}
