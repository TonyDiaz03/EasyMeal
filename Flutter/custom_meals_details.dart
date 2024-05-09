import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CustomMealDetails extends StatelessWidget {
  final DocumentSnapshot meal;

  const CustomMealDetails({Key? key, required this.meal}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlue,
        title: Text(meal['name'],
            style: TextStyle(fontSize: 34),
      ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildBox(
                title: 'Ingredients',
                color: Colors.blue,
                items: meal['ingredients'].cast<String>(),
              ),
              const SizedBox(height: 20),
              _buildBox(
                title: 'Directions',
                color: Colors.green,
                items: meal['directions'].cast<String>(),
              ),
              const SizedBox(height: 20),
              _buildBox(
                title: 'Nutrition',
                color: Colors.orange,
                items: meal['nutrients'].map<String>((nutrient) =>
                '${nutrient['name']}: ${nutrient['value']}').toList(),
              ),
              const SizedBox(height: 20),
              // Add more boxes or content here
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBox({
    required String title,
    required Color color,
    List<String>? items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          if (items != null)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items
                    .map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    item,
                    style: const TextStyle(color: Colors.white),
                  ),
                ))
                    .toList(),
              ),
            ),
        ],
      ),
    );
  }
}
