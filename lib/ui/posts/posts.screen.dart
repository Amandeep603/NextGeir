import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/WeatherScreen/main_page.dart';

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

  void storeSoilData(
      String cropName, int temperature, int moisture, int humidity) {
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
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
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
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.white,
                  ),
                ),
                onChanged: (String value) {
                  setState(() {});
                },
              ),
            ),
            const SizedBox(height: 50),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildCropButton('Fenugreek', 24, 17, 47, 'images/methi.png'),
                    _buildCropButton('Jowar', 35, 14, 50, 'images/jowar.png'),
                    _buildCropButton('Cotton', 36, 75, 50, 'images/cotton.png'),
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

  Widget _buildCropButton(String cropName, int temperature, int moisture,
      int humidity, String cropImage) {
    bool isSelected = cropName == selectedCrop;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedCrop = isSelected ? '' : cropName;
        });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const MainPage ()));
        storeSoilData(cropName, temperature, moisture, humidity);

      },
      child: Container(
        width: double.infinity,
        height: 100,
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blueGrey : Colors.grey,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 220,
                  child: Text(
                    ' $cropName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(width: 100, child: Image.asset(cropImage))
          ],
        ),
      ),
    );
  }
}