import 'package:flutter/material.dart';
import 'package:projectflutter/page/loginpage.dart';

class Registpage extends StatefulWidget {
  const Registpage({super.key});

  @override
  State<Registpage> createState() => _RegistpageState();
}

class _RegistpageState extends State<Registpage> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ClipOval(child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSAFP_ggbaoXPl8iI0MqASnRx0-4bIeSSIexmJlLebi6Q&s=10', width: 200, height: 200, fit: BoxFit.cover,),
          )),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Register', style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold
                ), ),
              ),
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('Please Register to login', style: TextStyle(
                  fontWeight: FontWeight.bold
                ),),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Username',
                hintText: 'Masukan Username',
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15),),

                
              ),  
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Mobile Number',
                hintText: 'Masukan Mobile Number',
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
              ),
              obscureText: true,  
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
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
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
              onPressed: () {},
              child: Text('Sign Up', style: TextStyle(
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
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Loginpage()));
                }, child: Text('Sign In'))
              ],
              )
        ],
      ),
    );
  }
}