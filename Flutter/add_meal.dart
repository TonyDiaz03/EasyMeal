import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'home_page.dart';


class AddMeal extends StatefulWidget {
  const AddMeal({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<AddMeal> createState() => AddMealState();
}

class AddMealState extends State<AddMeal> {
  TextEditingController mealNameController =  TextEditingController();
  List<String> ingredients = []; // List to store ingredients
  List<String> directions = [];
  List<Map<String, dynamic>> nutrients = [
    {'name': 'Calories', 'value': ''},
    {'name': 'Protein', 'value': ''},
    {'name': 'Carbs', 'value': ''},
    {'name': 'Fats', 'value': ''},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: const Text(
          "Add Meal",
          style: TextStyle(fontSize: 34),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            TextField(
              controller: mealNameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Meal Name',
              ),
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Ingredients:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: ingredients.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0), // Add padding only to the top
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                ingredients[index] = value; // Update ingredient in list
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Ingredient ${index + 1}',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                ingredients.removeAt(index); // Remove ingredient from list
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      ingredients.add('');
                    });
                  },
                  child: const Text('Add Ingredient'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Directions:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: directions.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0), // Add padding only to the top
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                directions[index] = value; // Update direction in list
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: 'Direction ${index + 1}',
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.remove),
                            onPressed: () {
                              setState(() {
                                directions.removeAt(index); // Remove direction from list
                              });
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      directions.add(''); // Add empty direction to the list
                    });
                  },
                  child: const Text('Add Direction'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Nutrients:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: nutrients.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 10.0), // Add padding only to the top
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              onChanged: (value) {
                                setState(() {
                                  nutrients[index]['value'] = value; // Update nutrient value in map
                                });
                              },
                              decoration: InputDecoration(
                                border: const OutlineInputBorder(),
                                labelText: nutrients[index]['name'], // Use nutrient name as label
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                FirebaseAuth auth = FirebaseAuth.instance;
                User? user = auth.currentUser;
                String? userId = user?.uid;
                FirebaseFirestore.instance.collection("meals").add(
                    {
                      "userId": userId,
                      "name": mealNameController.text,
                      "ingredients": ingredients,
                      "directions": directions,
                      "nutrients": nutrients,
                    }
                ).then((value) {
                  print("Successfully added collection");
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(title: 'Home Page'),
                    ),
                  );
                }).catchError((error) {
                  print("failed to add collection");
                  print(error.toString());
                });
                // Implement logic to save meal details
              },
              child: const Text('Add Meal'),
            ),
          ],
        ),
      ),
    );



  }
}

