class Person {
  Person({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.address,
    required this.birthdate,
    required this.gender,
    required this.occupation,
    required this.maritalStatus,
    required this.country,
    required this.createdAt,
  });

  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String address;
  final String birthdate;
  final String gender;
  final String occupation;
  final String maritalStatus;
  final String country;
  final String createdAt;

  factory Person.fromJson(Map<String, dynamic> json) {
    return Person(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      birthdate: json['birthdate'],
      gender: json['gender'],
      occupation: json['occupation'],
      maritalStatus: json['maritalStatus'],
      country: json['country'],
      createdAt: json['createdAt'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'birthdate': birthdate,
      'gender': gender,
      'occupation': occupation,
      'maritalStatus': maritalStatus,
      'country': country,
      'createdAt': createdAt,
    };
  }
}
