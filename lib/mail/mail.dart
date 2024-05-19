import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';
import 'package:mailer/smtp_server/hotmail.dart';

class Mail extends StatefulWidget {
  const Mail({super.key});

  @override
  State<Mail> createState() => _MailState();
}

class _MailState extends State<Mail> {

  Future<void>sendMail()async{
    try{
    var userEmail="flexgod080@gmail.com";
    var message= Message();
    message.subject="Mail from flutter";
    message.text="thank you for your boooking hope you enjoy your movie ";
    message.from=Address(userEmail,"QFLIX");
    message.recipients.add(userEmail);
    var smtpServer=gmail(userEmail,'sook uaji eafh xoqo');
    send(message, smtpServer);
    print("message sent");
    var adminEmail="flexgod080@gmail.com";
    var messages= Message();
    message.subject="Qflix Booking";
    message.text="thank you for your boooking hope you enjoy your movie ";
    message.from=Address(adminEmail,"QFLIX ADMIN");
    message.recipients.add("vinaythapa762@gmail.com");
    var smtpServerr=gmail(userEmail,'sook uaji eafh xoqo');
    send(messages, smtpServerr);
    print("message sent");
    
    }
    catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Example to send email"),
        leading:Icon(Icons.mail,
        size: 20,
        color: Colors.pinkAccent,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.mail,
          size: 30,
          color: Color.fromARGB(255, 46, 117, 241),),
          Center(
            child: ElevatedButton(onPressed: (){
            sendMail();
            }, child:Text("Send us Mail here!")),
          ),
        ],
      ),

    );
  }
}