import 'package:ct312h_project/views/login.dart';
import 'package:flutter/material.dart';
import '../components/colors.dart';
import '../components/button.dart';


class Profile extends StatelessWidget{
  const Profile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 45, horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: primaryColor,
                  radius: 77,
                  child: CircleAvatar(
                    backgroundImage: AssetImage("assets/no_user.jpg"),
                    radius: 75,
                  ),
                ),
                  
                SizedBox(height: 10,),
                Text("Thanh Tam", style: TextStyle(fontSize: 25, color: primaryColor),),
                Text("ngothuythanhtam@gmail.com", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 123, 152, 148)),),
                  
                Button(label: "SIGN UP", press: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen())
                  );
                }),
                  
                const ListTile(
                  leading: Icon(Icons.person, size: 30, color: Color.fromARGB(255, 53, 88, 78)),
                  title: Text("Full Name",style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text("Ngo Thuy Thanh Tam", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                const ListTile(
                  leading: Icon(Icons.email, size: 30, color: Color.fromARGB(255, 53, 88, 78)),
                  title: Text("Email", style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text("ngothuythanhtam@gmail.com", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                const ListTile(
                  leading: Icon(Icons.account_circle, size: 30, color: Color.fromARGB(255, 53, 88, 78)  ),
                  title: Text("User Name", style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text("admin", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                  
              ],
                    ),
          )
        ),
      ),
    );
  }
}