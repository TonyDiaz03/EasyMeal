import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:my_first_flutter_project/custom_meals_details.dart';


class CustomMeals extends StatefulWidget {
  const CustomMeals({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<CustomMeals> createState() => _CustomMealsState();
}

class _CustomMealsState extends State<CustomMeals> {
  late Stream<List<DocumentSnapshot>> _mealsStream;

  @override
  void initState() {
    super.initState();
    _mealsStream = _fetchMeals();
  }

  Stream<List<DocumentSnapshot>> _fetchMeals() {
    final user = FirebaseAuth.instance.currentUser;
    return FirebaseFirestore.instance
        .collection('meals')
        .where('userId', isEqualTo: user?.uid)
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  void _deleteMeal(String mealId) {
    FirebaseFirestore.instance.collection('meals').doc(mealId).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(
          "Custom Meals",
          style: TextStyle(fontSize: 34),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<List<DocumentSnapshot>>(
        stream: _mealsStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            print('Error: ${snapshot.error}');
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final meals = snapshot.data!;
          print('Number of meals: ${meals.length}');
          if (meals.isEmpty) {
            return Center(child: Text('No meals found.'));
          }
          return ListView.builder(
            itemCount: meals.length,
            itemBuilder: (context, index) {
              final meal = meals[index];
              return GestureDetector(
                onTap: () {
                  // Navigate to meal details page
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomMealDetails(meal: meal),
                    ),
                  );
                },
                child: ListTile(
                  title: Text(meal['name']),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text('Delete Meal'),
                          content: Text('Are you sure you want to delete this meal?'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                _deleteMeal(meal.id);
                                Navigator.of(context).pop();
                              },
                              child: Text('Delete'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
