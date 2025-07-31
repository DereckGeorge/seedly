import 'package:url_launcher/url_launcher.dart';

class PhoneService {
  // Make phone call
  static Future<bool> makePhoneCall(String phoneNumber) async {
    try {
      final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

      if (await canLaunchUrl(phoneUri)) {
        return await launchUrl(phoneUri);
      } else {
        throw Exception('Could not launch phone call');
      }
    } catch (e) {
      print('Phone call error: $e');
      return false;
    }
  }

  // Send SMS
  static Future<bool> sendSMS(String phoneNumber, String message) async {
    try {
      final Uri smsUri = Uri(
        scheme: 'sms',
        path: phoneNumber,
        queryParameters: {'body': message},
      );

      if (await canLaunchUrl(smsUri)) {
        return await launchUrl(smsUri);
      } else {
        throw Exception('Could not launch SMS');
      }
    } catch (e) {
      print('SMS error: $e');
      return false;
    }
  }

  // Format phone number for display
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

    // Format based on length
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    }

    return phoneNumber;
  }

  // Validate phone number
  static bool isValidPhoneNumber(String phoneNumber) {
    final digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    return digits.length >= 10 && digits.length <= 15;
  }
}
