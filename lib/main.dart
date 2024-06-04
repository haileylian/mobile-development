import 'package:flutter/material.dart';
import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const LoginPage(title: 'Flutter Demo Login Page'),
    );
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final EncryptedSharedPreferences _preferences = EncryptedSharedPreferences();
  String imageSource = 'images/question-mark.png'; // Placeholder image link

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    String? savedUsername = await _preferences.getString('username');
    String? savedPassword = await _preferences.getString('password');
    if (savedUsername != null && savedPassword != null) {
      setState(() {
        _loginController.text = savedUsername;
        _passwordController.text = savedPassword;
      });
      _showSnackbarWithAction();
    }
  }

  void _showSnackbarWithAction() {
    final snackBar = SnackBar(
      content: Text('Previous login data loaded'),
      action: SnackBarAction(
        label: 'Clear Saved Data',
        onPressed: _clearSavedData,
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  Future<void> _clearSavedData() async {
    await _preferences.clear();
    _loginController.clear();
    _passwordController.clear();
  }

  Future<void> _saveData(String username, String password) async {
    await _preferences.setString('username', username);
    await _preferences.setString('password', password);
  }

  Future<void> _showSaveDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Save Login Data'),
          content: Text('Would you like to save your username and password for next time?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                _clearSavedData();
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _saveData(_loginController.text, _passwordController.text);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _login() {
    String enteredPassword = _passwordController.text;
    setState(() {
      if (enteredPassword == 'QWERTY123') {
        imageSource = 'images/idea.png';
      } else {
        imageSource = 'images/stop.png';
      }
    });
    _showSaveDialog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: _loginController,
              decoration: InputDecoration(
                labelText: 'Login',
              ),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 20),
            Image.asset(
              imageSource,
              width: 300,
              height: 300,
            ),
          ],
        ),
      ),
    );
  }
}
