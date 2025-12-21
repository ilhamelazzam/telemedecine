class UserProfile {
  final String userId;
  final String firstName;
  final String lastName;
  final String email;
  final String? phone;
  final String? address;
  final String? region;
  final String? chronicDiseases;
  final String? allergies;
  final String language;

  UserProfile({
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phone,
    this.address,
    this.region,
    this.chronicDiseases,
    this.allergies,
    this.language = 'fr',
  });

  String get fullName => '$firstName $lastName';

  String get initials {
    return '${firstName.substring(0, 1).toUpperCase()}${lastName.substring(0, 1).toUpperCase()}';
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['userId']?.toString() ?? json['user_id']?.toString() ?? '',
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      address: json['address'],
      region: json['region'],
      chronicDiseases: json['chronicDiseases'] ?? json['chronic_diseases'],
      allergies: json['allergies'],
      language: json['language'] ?? 'fr',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phone': phone,
      'address': address,
      'region': region,
      'chronicDiseases': chronicDiseases,
      'allergies': allergies,
      'language': language,
    };
  }

  UserProfile copyWith({
    String? userId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? address,
    String? region,
    String? chronicDiseases,
    String? allergies,
    String? language,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      region: region ?? this.region,
      chronicDiseases: chronicDiseases ?? this.chronicDiseases,
      allergies: allergies ?? this.allergies,
      language: language ?? this.language,
    );
  }
}



