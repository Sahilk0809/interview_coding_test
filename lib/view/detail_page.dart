import 'package:flutter/material.dart';

import '../modal/contact_modal.dart';

class ContactDetailPage extends StatelessWidget {
  final Contact contact;

  const ContactDetailPage({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.indigo,
        title: Text(
          '${contact.firstName} ${contact.lastName}',
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 70,
                backgroundImage: NetworkImage(contact.avatar),
                backgroundColor: Colors.grey[300],
              ),
              SizedBox(height: screenSize.height * 0.026),
              Text(
                '${contact.firstName} ${contact.lastName}',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: screenSize.height * 0.011),
              Text(
                contact.email,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: screenSize.height * 0.028),
              Divider(color: Colors.grey[300], thickness: 1),
              SizedBox(height: screenSize.height * 0.018),
              _buildDetailRow(
                icon: Icons.face,
                title: 'User ID',
                value: 'ID: ${contact.id}',
              ),
              SizedBox(height: screenSize.height * 0.018),
              _buildDetailRow(
                icon: Icons.account_circle,
                title: 'Full Name',
                value: '${contact.firstName} ${contact.lastName}',
              ),
              SizedBox(height: screenSize.height * 0.018),
              _buildDetailRow(
                icon: Icons.email,
                title: 'Email',
                value: contact.email,
              ),
              SizedBox(height: screenSize.height * 0.038),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
                ),
                onPressed: () {},
                child: const Text(
                  'Send Email',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Row(
      children: [
        Icon(icon, color: Colors.indigo, size: 28),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black54,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
