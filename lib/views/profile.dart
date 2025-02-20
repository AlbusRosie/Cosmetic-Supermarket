import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences
import '../components/colors.dart';
import '../components/button.dart';
import '../JSON/users.dart';
import '../views/login.dart';

class Profile extends StatelessWidget{
  final Users? profile;
  const Profile({super.key, this.profile});

  // Log Out Function
  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear stored user data (if used)

    // Navigate to LoginScreen and remove all previous routes
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

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
                Text(profile!.uname??"", style: TextStyle(fontSize: 25, color: primaryColor),),
                Text(profile!.phone, style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 123, 152, 148)),),
                  
                Button(label: "LOG OUT", press: () => logout(context)),
                  
                ListTile(
                  leading: Icon(Icons.person, size: 30, color: Color.fromARGB(255, 53, 88, 78)),
                  title: Text("User Name",style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text(profile!.uname ?? "", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                ListTile(
                  leading: Icon(Icons.phone, size: 30, color: Color.fromARGB(255, 53, 88, 78)),
                  title: Text("Phone Number", style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text(profile!.phone, style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                ListTile(
                  leading: Icon(Icons.location_pin, size: 30, color: Color.fromARGB(255, 53, 88, 78)  ),
                  title: Text("Address", style: TextStyle(fontSize: 13, color: Color.fromARGB(255, 123, 152, 148))),
                  subtitle: Text(profile!.address??"", style: TextStyle(fontSize: 16, color: Color.fromARGB(255, 53, 88, 78))),
                ),
                  
              ],
                    ),
          )
        ),
      ),
    );
  }
}