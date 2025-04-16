import 'package:flutter/material.dart';
import 'package:flutter_learning2/pages/homepage.dart';
import 'package:flutter_learning2/pages/registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false; // Tambahkan indikator loading

  Future<void> _validateAndLogin() async {
    // Tutup keyboard sebelum validasi
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true; // Tampilkan indikator loading
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> usersList = prefs.getStringList('users') ?? [];

      String enteredEmail = _emailController.text.trim();
      String enteredPassword = _passwordController.text;
      String? fullName;

      // Cek apakah email dan password cocok dengan data yang tersimpan
      bool userFound = usersList.any((userJson) {
        Map<String, dynamic> user = jsonDecode(userJson);
        if (user['email'] == enteredEmail &&
            user['password'] == enteredPassword) {
          fullName = user['fullName']; // Simpan nama pengguna
          return true;
        }
        return false;
      });

      if (userFound) {
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('fullName', fullName ?? "User");

        // Navigasi ke Home Page setelah login berhasil
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomePage()),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Email atau Password salah!'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      setState(() {
        _isLoading = false; // Sembunyikan indikator loading
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Login to Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Input Email
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email address',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email tidak boleh kosong!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

              // Input Password
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Password',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password tidak boleh kosong!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Tombol Login
              Center(
                child:
                    _isLoading
                        ? const CircularProgressIndicator() // Tampilkan loading jika sedang proses login
                        : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black,
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(20),
                          ),
                          onPressed: _validateAndLogin,
                          child: const Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ),
              ),

              const SizedBox(height: 30),

              // Teks Navigasi ke Register
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RegisterPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Don’t have an account? Sign Up',
                    style: TextStyle(
                      color: Color(0xFF6A0DAD), // Warna UNGU
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
