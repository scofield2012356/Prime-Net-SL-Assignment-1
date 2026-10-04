import 'dart:io';

class ClientInquiry {
  final int id;
  final String clientName;
  final String email;
  final String service;
  final String subject;
  final String message;
  String status;

  ClientInquiry({
    required this.id,
    required this.clientName,
    required this.email,
    required this.service,
    required this.subject,
    required this.message,
    this.status = 'New',
  });
}

final List<ClientInquiry> inquiries = [];
int nextId = 1;

void main() {
  while (true) {
    print('\n=== PrimeTrack: Client Inquiry Tracker ===');
    print('1. Record an inquiry');
    print('2. View all inquiries');
    print('3. Search by inquiry ID');
    print('4. Update inquiry status');
    print('5. View inquiry summary');
    print('0. Exit');
    stdout.write('Choose an option: ');

    final choice = stdin.readLineSync()?.trim();

    switch (choice) {
      case '1':
        recordInquiry();
        break;
      case '2':
        viewInquiries();
        break;
      case '3':
        searchInquiry();
        break;
      case '4':
        updateInquiryStatus();
        break;
      case '5':
        showSummary();
        break;
      case '0':
        print('PrimeTrack closed.');
        return;
      default:
        print('Invalid choice. Please select an option from the menu.');
    }
  }
}

String askForRequiredValue(String prompt) {
  while (true) {
    stdout.write(prompt);
    final value = stdin.readLineSync()?.trim() ?? '';

    if (value.isNotEmpty) {
      return value;
    }

    print('This field is required. Please enter a value.');
  }
}

void recordInquiry() {
  print('\n--- Record a Client Inquiry ---');

  final clientName = askForRequiredValue('Client name: ');
  final email = askForRequiredValue('Email address: ');
  final service = askForRequiredValue('Service requested: ');
  final subject = askForRequiredValue('Subject: ');
  final message = askForRequiredValue('Message: ');

  final inquiry = ClientInquiry(
    id: nextId,
    clientName: clientName,
    email: email,
    service: service,
    subject: subject,
    message: message,
  );

  inquiries.add(inquiry);
  print('Inquiry recorded. The inquiry ID is ${inquiry.id}.');
  nextId++;
}

void viewInquiries() {
  if (inquiries.isEmpty) {
    print('No inquiries have been recorded.');
    return;
  }

  for (final inquiry in inquiries) {
    displayInquiry(inquiry);
  }
}

void searchInquiry() {
  stdout.write('Enter inquiry ID: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '');

  if (id == null) {
    print('Please enter a valid number.');
    return;
  }

  for (final inquiry in inquiries) {
    if (inquiry.id == id) {
      displayInquiry(inquiry);
      return;
    }
  }

  print('No inquiry found with ID $id.');
}

void updateInquiryStatus() {
  stdout.write('Enter inquiry ID: ');
  final id = int.tryParse(stdin.readLineSync()?.trim() ?? '');

  if (id == null) {
    print('Please enter a valid number.');
    return;
  }

  final matches = inquiries.where((inquiry) => inquiry.id == id).toList();
  if (matches.isEmpty) {
    print('No inquiry found with ID $id.');
    return;
  }
  final inquiry = matches.first;

  print('Choose the new status:');
  print('1. New');
  print('2. Under Review');
  print('3. Responded');
  print('4. Closed');
  stdout.write('Enter status number: ');

  final choice = stdin.readLineSync()?.trim();

  switch (choice) {
    case '1':
      inquiry.status = 'New';
      break;
    case '2':
      inquiry.status = 'Under Review';
      break;
    case '3':
      inquiry.status = 'Responded';
      break;
    case '4':
      inquiry.status = 'Closed';
      break;
    default:
      print('Invalid status. The inquiry was not changed.');
      return;
  }

  print('Inquiry ${inquiry.id} updated to ${inquiry.status}.');
}

void showSummary() {
  var newCount = 0;
  var underReviewCount = 0;
  var respondedCount = 0;
  var closedCount = 0;

  for (final inquiry in inquiries) {
    switch (inquiry.status) {
      case 'New':
        newCount++;
        break;
      case 'Under Review':
        underReviewCount++;
        break;
      case 'Responded':
        respondedCount++;
        break;
      case 'Closed':
        closedCount++;
        break;
    }
  }

  print('\n--- Inquiry Summary ---');
  print('Total inquiries: ${inquiries.length}');
  print('New: $newCount');
  print('Under Review: $underReviewCount');
  print('Responded: $respondedCount');
  print('Closed: $closedCount');
}

void displayInquiry(ClientInquiry inquiry) {
  print('\nInquiry ID: ${inquiry.id}');
  print('Client: ${inquiry.clientName}');
  print('Email: ${inquiry.email}');
  print('Service: ${inquiry.service}');
  print('Subject: ${inquiry.subject}');
  print('Message: ${inquiry.message}');
  print('Status: ${inquiry.status}');
}
