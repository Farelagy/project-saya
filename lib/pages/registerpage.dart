import 'package:flutter/material.dart';
import 'package:flutter_learning2/pages/loginpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _registerUser() async {
    // **Tutup keyboard sebelum validasi**
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Ambil daftar user yang sudah tersimpan
      List<String> usersList = prefs.getStringList('users') ?? [];

      // Cek apakah email sudah terdaftar sebelumnya
      String enteredEmail = _emailController.text.trim();
      bool emailExists = usersList.any((userJson) {
        Map<String, dynamic> user = jsonDecode(userJson);
        return user['email'] == enteredEmail;
      });

      if (emailExists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email sudah terdaftar! Gunakan email lain.'),
            backgroundColor: Colors.red,
          ),
        );
        return; // Stop proses registrasi
      }

      // **Tambahkan print() untuk debugging**
      print("Proses registrasi...");

      // Buat user baru dalam bentuk Map
      Map<String, String> newUser = {
        'fullName': _fullNameController.text.trim(),
        'email': enteredEmail,
        'password': _passwordController.text,
      };

      // Tambahkan user baru ke dalam list
      usersList.add(jsonEncode(newUser));

      // Simpan kembali ke SharedPreferences
      await prefs.setStringList('users', usersList);

      // **Tambahkan print() untuk debugging**
      print("Registrasi berhasil!");

      // Tampilkan pesan sukses
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registrasi Berhasil! Silakan login.'),
          backgroundColor: Colors.green,
        ),
      );

      // **Tunggu sebentar agar Snackbar terlihat**
      await Future.delayed(const Duration(seconds: 1));

      // **Pindah ke halaman login setelah registrasi berhasil**
      if (mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
          (route) => false, // Menghapus semua halaman sebelumnya dari stack
        );
      }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              // Input Nama
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full name',
                  labelStyle: const TextStyle(color: Colors.grey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Nama tidak boleh kosong!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 20),

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
                  } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                    return 'Format email tidak valid!';
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
                  } else if (value.length < 6) {
                    return 'Password minimal 6 karakter!';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 40),

              // Tombol Register
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                  ),
                  onPressed: _registerUser,
                  child: const Icon(Icons.arrow_forward, color: Colors.white),
                ),
              ),

              const SizedBox(height: 30),

              // Teks Navigasi ke Login
              Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                  child: const Text(
                    'Already have an account? Sign In',
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
