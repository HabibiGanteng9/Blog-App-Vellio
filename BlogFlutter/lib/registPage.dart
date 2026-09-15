import 'package:flutter/material.dart';
import 'package:latihan_rpl_2/loginPage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Registpage extends StatefulWidget {
  const Registpage({super.key});

  @override
  State<Registpage> createState() => _RegistpageState();
}

class _RegistpageState extends State<Registpage> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  Future<void> register() async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:4444/api/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "username": _usernameController.text.trim(),
          "email": _emailController.text.trim(),
          "password": _passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const Loginpage()),
        );
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(data['message'])));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Tidak dapat terhubung ke server")),
      );
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF6F5FA),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // NAMA APP
                Text(
                  'Vellio',
                  style: TextStyle(
                    fontSize: 36,
                    fontFamily: "Mistar",
                    fontWeight: FontWeight.w200,
                    color: Colors.blueAccent,
                    shadows: [
                      Shadow(
                        color: Colors.blueAccent,
                        blurRadius: 35,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 36),

                // CARD
                Container(
                  width: 350,
                  margin: const EdgeInsets.symmetric(horizontal: 50),
                  padding: const EdgeInsets.fromLTRB(35, 55, 35, 45),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        blurRadius: 10,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [

                        Text(
                          'Create Your Account',
                          style: TextStyle(
                            fontSize: 20,
                            fontFamily: "ComicRelief",
                            fontWeight: FontWeight.bold,
                            color: Colors.blueAccent,
                          ),
                        ),

                        const SizedBox(height: 40),

                        // USERNAME
                        TextFormField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            labelText: 'Username',
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            prefixIcon: Icon(
                              Icons.person_outline,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) =>
                              value == null || value.trim().isEmpty
                              ? 'Username wajib diisi'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        // EMAIL
                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(
                            labelText: 'Email',
                            filled: true,
                            fillColor: Color(0xFFFAFAFA),
                            prefixIcon: Icon(
                              Icons.email_outlined,
                              color: Colors.grey,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return 'Email wajib diisi';
                            }
                            if (!value.contains('@')) {
                              return 'Email tidak valid';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 16),

                        // PASSWORD
                        _passwordField(
                          controller: _passwordController,
                          label: 'Password',
                          obscureText: _obscurePassword,
                          onVisibilityPressed: () => setState(
                            () => _obscurePassword = !_obscurePassword,
                          ),
                          validator: (value) =>
                              value == null || value.isEmpty
                              ? 'Password wajib diisi'
                              : null,
                        ),

                        const SizedBox(height: 16),

                        // CONFIRM PASSWORD
                        _passwordField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          obscureText: _obscureConfirmPassword,
                          onVisibilityPressed: () => setState(
                            () => _obscureConfirmPassword =
                                !_obscureConfirmPassword,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Konfirmasi password wajib diisi';
                            }

                            if (value != _passwordController.text) {
                              return 'Password tidak sama';
                            }

                            return null;
                          },
                        ),

                        const SizedBox(height: 30),

                        // REGISTER BUTTON
                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                FocusScope.of(context).unfocus();
                                register();
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              textStyle: TextStyle(
                                fontFamily: "ComicRelief",
                              ),
                            ),
                            child: const Text('Register'),
                          ),
                        ),

                        // LOGIN
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const Loginpage(),
                              ),
                            );
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "Already have an account?",
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => const Loginpage(),
                                    ),
                                  );
                                },
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.blueAccent,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _passwordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onVisibilityPressed,
    required String? Function(String?) validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Color(0xFFFAFAFA),
        prefixIcon: Icon(
          Icons.lock_outline,
          color: Colors.grey,
        ),
        suffixIcon: IconButton(
          tooltip: obscureText
              ? 'Tampilkan password'
              : 'Sembunyikan password',
          icon: Icon(
            obscureText
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            color: Colors.grey,
          ),
          onPressed: onVisibilityPressed,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }
}
