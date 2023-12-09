import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({Key? key}) : super(key: key);

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final ref = FirebaseDatabase.instance.ref();
  final auth = FirebaseAuth.instance;
  final searchFilter = TextEditingController();
  String selectedCrop = '';


  void storeSoilData(String cropName, int temperature, int moisture, int humidity) {
    ref.child('Data').child('Soil Data').update({
      'temperature': temperature,
      'moisture': moisture,
      'humidity': humidity,
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crops'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.grey.shade500],
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: TextFormField(
                controller: searchFilter,
                decoration: const InputDecoration(
                  hintText: 'Search Crop',
                  border: OutlineInputBorder(),
                  hintStyle: TextStyle(
                    color: Colors.white,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.white,),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCropButton('Fenugreek', 25, 60, 80, 'images/methi.png'),
                    _buildCropButton('Jowar', 28, 55, 75, 'images/jowar.png'),
                    _buildCropButton('Cotton', 23, 70, 85, 'images/cotton.png'),
                    _buildCropButton('Gram', 30, 50, 70, 'images/methi.png'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCropButton(String cropName, int temperature, int moisture, int humidity, String cropImage) {
    bool isSelected = cropName == selectedCrop;

    return GestureDetector(
      onTap: () {

        setState(() {
          selectedCrop = isSelected ? '' : cropName;
        });
        storeSoilData(cropName, temperature, moisture, humidity);
      },
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(' $cropName', style:  TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : Colors.black,
                ),),
              ],
            ),
            SizedBox(width: 100,),
            SizedBox(width: 30,),
            Image.asset(cropImage)
          ],
        ),
      ),
    );
  }
}
