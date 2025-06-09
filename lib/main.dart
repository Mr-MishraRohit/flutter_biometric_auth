import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:developer';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

final firebaseAuth = FirebaseAuth.instance;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Biometric Auth Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AuthPage(),
    );
  }
}

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final storage = SecureStorage();

  Future<void> _saveUser(String email, String password) async {
    await storage.setEmail(email);
    await storage.setPassword(password);
  }

  Future<void> _loginWithEmailPassword() async {
    try {
      await firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      await _saveUser(_emailController.text, _passwordController.text);
      _showMessage('Logged in with Email/Password!');
    } catch (e) {
      _showMessage('Login failed: $e');
    }
  }

  Future<void> _loginWithBiometrics() async {
    final localAuth = LocalAuthentication();
    try {
      final isAuthenticated = await localAuth.authenticate(
        localizedReason: 'Authenticate to log in',
        options: const AuthenticationOptions(sensitiveTransaction: true,stickyAuth: true,useErrorDialogs: true),
      );

      if (isAuthenticated) {
        final email = await storage.getEmail();
        final password = await storage.getPassword();
        if (email != null && password != null) {
          await firebaseAuth.signInWithEmailAndPassword(
            email: email,
            password: password,
          );
          _showMessage('Logged in with Biometrics!');
        } else {
          _showMessage('No credentials saved!');
        }
      }
    } catch (e) {
      log('Biometric error: $e');
      _showMessage('Biometric login failed.');
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Biometric Auth Demo')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(controller: _emailController, decoration: const InputDecoration(labelText: 'Email')),
            TextField(controller: _passwordController, decoration: const InputDecoration(labelText: 'Password'), obscureText: true),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: _loginWithEmailPassword, child: const Text('Login with Email')),
            ElevatedButton(onPressed: _loginWithBiometrics, child: const Text('Login with Biometrics')),
          ],
        ),
      ),
    );
  }
}

class SecureStorage {
  final _storage = const FlutterSecureStorage();

  Future<void> setEmail(String email) async => await _storage.write(key: 'email', value: email);
  Future<String?> getEmail() async => await _storage.read(key: 'email');

  Future<void> setPassword(String password) async => await _storage.write(key: 'password', value: password);
  Future<String?> getPassword() async => await _storage.read(key: 'password');

  Future<void> clear() async => await _storage.deleteAll();
}
