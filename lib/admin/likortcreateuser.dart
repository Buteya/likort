import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class LikortCreateUser extends StatefulWidget {
  const LikortCreateUser({super.key});

  @override
  State<LikortCreateUser> createState() => _LikortCreateUserState();
}

class _LikortCreateUserState extends State<LikortCreateUser> {
  final _formKey = GlobalKey<FormState>();
  final _firstnameController = TextEditingController();
  final _lastnameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _phoneController = TextEditingController();
  PhoneNumber _phoneNumber = PhoneNumber(isoCode: 'KE');

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _firstnameController,
                  decoration: const InputDecoration(
                    labelText: 'Firstname',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your firstname';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _lastnameController,
                  decoration: const InputDecoration(
                    labelText: 'Lastname',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your lastname';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+')
                        .hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      } else if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    }),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: InternationalPhoneNumberInput(
                  textFieldController: _phoneController,
                  onInputChanged: (PhoneNumber number) {
                    _phoneNumber = number;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                  selectorTextStyle: TextStyle(
                    color:
                    isDark ? Colors.white54 : Colors.black54,
                  ), // Change hint color based on theme
                  selectorConfig: const SelectorConfig(
                    selectorType:
                    PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  initialValue: _phoneNumber,
                  inputDecoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Phone Number',
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Process data
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
                    }
                  },
                  child: const Text('Submit'),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Hello, John',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            Text('user'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.person_add_alt_rounded),
              title: const Text('create user'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context)
                    .pushReplacementNamed('/likortcreateuser')
                    .then((_) {
                  // Then close the drawer
                  Navigator.pop(context);
                });
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('view all users'),
              onTap: () {
                // Update the state of the app
                Navigator.of(context)
                    .pushReplacementNamed('/likortviewallusers')
                    .then((_) {
                  // Then close the drawer
                  Navigator.pop(context);
                });
              },
            ),
            Text('store'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.store_outlined),
              title: const Text('create store'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.store_rounded),
              title: const Text('view all store'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('order'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.playlist_add),
              title: const Text('create order'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.list_rounded),
              title: const Text('view all orders'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('payments'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.payment_rounded),
              title: const Text('view all payments'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            const Text('role'),
            const Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services_outlined),
              title: const Text('create role'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.miscellaneous_services_rounded),
              title: const Text('view all roles'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            Text('permission'),
            Divider(
              color: Colors.grey, // Set the color of the line
              thickness: 1.0, // Set the thickness of the line
              height: 10.0, // Set the height of the line (including spacing)
              indent: 20.0, // Set the indent from the leading edge
              endIndent: 20.0, // Set the indent from the trailing edge
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_outlined),
              title: const Text('create permission'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_accessibility_sharp),
              title: const Text('view all permissions'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
