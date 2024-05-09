import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_flutter_project/custom_meals.dart';
import 'package:my_first_flutter_project/login_page.dart';
import 'package:my_first_flutter_project/add_meal.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "EasyMeal",
          style: TextStyle(fontSize: 34),
        ),
        centerTitle: true,
        titleSpacing: 0,
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            onPressed: () async {
              // Show a dialog to confirm account deletion
              bool confirmDelete = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Cancel deletion
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () async {
                          // Delete the user account
                          User? user = FirebaseAuth.instance.currentUser;
                          if (user != null) {
                            try {
                              await user.delete();
                              print('User account deleted successfully.');
                              Navigator.of(context).pop(true); // Confirm deletion
                            } catch (e) {
                              print('Failed to delete user account: $e');
                              // Handle error
                            }
                          }
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  );
                },
              );

              // If the user confirms deletion, sign out
              if (confirmDelete == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login Page')),
                );
              }
            },
            icon: const Icon(Icons.delete),
          ),
          IconButton(
            onPressed: () async {
              // Show a dialog to confirm logout
              bool confirmLogout = await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Logout'),
                    content: const Text('Are you sure you want to logout?'),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(false); // Confirm logout
                        },
                        child: const Text('No'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop(true); // Cancel logout
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  );
                },
              );

              // If the user confirms logout, sign out
              if (confirmLogout == true) {
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage(title: 'Login Page')),
                );
              }
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomMeals(title: 'Custom Meal Page'),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), // Change the color here
                ),
                child: const Text('Custom Meals',
                  style: TextStyle(fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 100,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const AddMeal(title: 'Add Meal Page'),
                    ),
                  );
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.lightBlue), // Change the color here
                ),
                child: const Text(
                  'Add Meal',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

