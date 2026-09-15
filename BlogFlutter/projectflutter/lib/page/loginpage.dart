import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:projectflutter/page/registpage.dart';

class Loginpage extends StatefulWidget {
  const Loginpage({super.key});

  @override
  State<Loginpage> createState() => _LoginpageState();
}

class _LoginpageState extends State<Loginpage> {
  final usernameController = TextEditingController();
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ClipOval(child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcT34J5tYXsFg0dvaFbU6jpaHVgz2ZvwnTieoLQCtdUHrQ&s=10', width: 200, height: 200, fit: BoxFit.cover,)),
          Row(
            children: [
              Text('Login', style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold
              ), ),
            ],
          ),
          Row(
            children: [
              Text('Please Sign in to continue', style: TextStyle(
                fontWeight: FontWeight.bold
              ),),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Masukan Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),  
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Password',
                hintText: 'Masukan Password',
                prefixIcon: Icon(Icons.lock),
                suffixIcon: Icon(Icons.remove_red_eye),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
              ),
              obscureText: true,  
            ),
          ),
          
          
          CheckboxListTile(
            title: Text('Remember me'), 
            value: isChecked,
            onChanged: (val) {
              setState(() {
                isChecked = val!;
              });
            }
            ),
            ElevatedButton( 
              onPressed: () {
                Navigator.pushNamed(context, "/home", arguments: {
                  'nama' : 'Habibi',
                  'umur' : 16
                } );
              },
              child: Text('Sign In', style: TextStyle(
                color: Colors.white
              ),),
              
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                minimumSize: Size(400, 50),
                
              )
              
              ),
              Row(children: [
                Text("Don't Have Account?"),
                TextButton(onPressed: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Registpage()));
                }, child: Text('Sign Up'))
              ],
              )
        ],
      ),
    );
  }
}