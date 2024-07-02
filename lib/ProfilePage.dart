import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'UserRepository.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    await UserRepository.loadData();
    setState(() {
      _firstNameController.text = UserRepository.firstName;
      _lastNameController.text = UserRepository.lastName;
      _phoneController.text = UserRepository.phoneNumber;
      _emailController.text = UserRepository.email;
    });
  }

  @override
  void dispose() {
    _saveUserData();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _saveUserData() async {
    UserRepository.firstName = _firstNameController.text;
    UserRepository.lastName = _lastNameController.text;
    UserRepository.phoneNumber = _phoneController.text;
    UserRepository.email = _emailController.text;
    await UserRepository.saveData();
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('This URL is not supported on your device.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _firstNameController,
              decoration: InputDecoration(labelText: 'First Name'),
              onChanged: (value) => _saveUserData(),
            ),
            TextField(
              controller: _lastNameController,
              decoration: InputDecoration(labelText: 'Last Name'),
              onChanged: (value) => _saveUserData(),
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _phoneController,
                    decoration: InputDecoration(labelText: 'Phone Number'),
                    onChanged: (value) => _saveUserData(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.phone),
                  onPressed: () => _launchURL('tel:${_phoneController.text}'),
                ),
                IconButton(
                  icon: Icon(Icons.message),
                  onPressed: () => _launchURL('sms:${_phoneController.text}'),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                Flexible(
                  child: TextField(
                    controller: _emailController,
                    decoration: InputDecoration(labelText: 'Email Address'),
                    onChanged: (value) => _saveUserData(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.email),
                  onPressed: () => _launchEmail(_emailController.text),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: 'subject=Example Subject&body=Hello, this is an example email.',
    );

    final String url = emailLaunchUri.toString();

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text('This URL is not supported on your device.'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }
}
