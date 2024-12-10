class ContactResponse {
  final List<Contact> contacts;
  final int total;
  final int totalPages;

  ContactResponse({
    required this.contacts,
    required this.total,
    required this.totalPages,
  });

  factory ContactResponse.fromJson(Map<String, dynamic> json) {
    return ContactResponse(
      contacts: (json['data'] as List)
          .map((contactJson) => Contact.fromJson(contactJson))
          .toList(),
      total: json['total'],
      totalPages: json['total_pages'],
    );
  }
}

class Contact {
  final int id;
  final String email;
  final String firstName;
  final String lastName;
  final String avatar;

  Contact({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.avatar,
  });

  factory Contact.fromJson(Map<String, dynamic> json) {
    return Contact(
      id: json['id'],
      email: json['email'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      avatar: json['avatar'],
    );
  }
}
