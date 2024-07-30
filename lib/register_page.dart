import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:unshelf_seller/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _sellerNameController = TextEditingController();
  final TextEditingController _storeNameController = TextEditingController();

  // Function to save user data
  Future<void> saveUserData(
      User user, String name, String phoneNumber, String storeName) async {
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': user.email,
        'phone_number': phoneNumber,
        'store_name': storeName,
      });
    } catch (e) {
      // Handle error
      print('Error saving user data: $e');
    }
  }

  void _register() async {
    if (_formKey.currentState!.validate()) {
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );

        User user = userCredential.user!;
        await saveUserData(user, _sellerNameController.text,
            _phoneNumberController.text, _storeNameController.text);

        // User created successfully
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Registration Successful')),
        );

        // Go to login page
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => SignInPage()));
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'The password provided is too weak.';
        } else if (e.code == 'email-already-in-use') {
          message = 'The account already exists for that email.';
        } else {
          message = 'An error occurred: ${e.message}. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } catch (e) {
        // Handle other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('An error occurred: $e. Please try again.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _confirmPasswordController,
                decoration:
                    const InputDecoration(labelText: 'Confirm Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please confirm your password';
                  } else if (value != _passwordController.text) {
                    return 'Passwords do not match';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneNumberController,
                decoration: const InputDecoration(labelText: 'Phone Number'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  } else if (value.length < 11) {
                    return 'Phone number must be at least 11 characters';
                  } else if (value[0] != '0' && value[1] != '9') {
                    return 'Phone number must start with 09';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellerNameController,
                decoration: const InputDecoration(labelText: 'Seller Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your seller name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _storeNameController,
                decoration: const InputDecoration(labelText: 'Store Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your store name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Sign Up'),
              ),
              const Text(
                  "By signing up, you agree to Unshelf's Terms of Use and Privacy Policy"),
              const SizedBox(height: 20),
              const Text('Already have an account?'),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SignInPage()));
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
