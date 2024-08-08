import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class NotificationMethods{
  Future<void> showNotification(String sender,String receptorEmail,String chat,String message) async {
    final smtpServer = gmail('wikidiscuss@gmail.com', 'ovzmskogzvcwybuw');
    final message_ = Message()
      ..from = Address('wikidiscuss@gmail.com' ,'WikiDiscuss')
      ..recipients.add(receptorEmail)
      ..subject = '${sender} sent a message to ${chat} chat'
      ..text = '${sender}: ${message}';
    try {
      final sendReport = await send(message_, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}