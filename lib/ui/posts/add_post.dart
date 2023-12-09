import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/WeatherScreen/main_page.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/round_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  final temperatureController = TextEditingController();
  final moistureController = TextEditingController();
  final humidityController = TextEditingController();
  bool loading = false;
  final databaseRef = FirebaseDatabase.instance.ref('Data');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:const Text('Add Data'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.deepPurple, Colors.grey.shade500],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              TextFormField(

                style:const TextStyle(
                  color: Colors.white,
                ),
                controller: temperatureController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                          width: 2.0,
                        )
                    ),
                  prefixIcon:const  Icon(EvaIcons.thermometerOutline, size: 30 , color: Colors.white),
                  hintText: 'Enter Temperature',
                  border:const OutlineInputBorder(),
                  hintStyle:const TextStyle(
                    color: Colors.white,
                  )
                ),
              ),
              const SizedBox(height: 15),
              TextFormField(
                style:const TextStyle(
                  color: Colors.white,
                ),
                controller: moistureController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.grey.shade800,
                          width: 2.0,
                        )
                    ),
                  prefixIcon:const Icon(EvaIcons.dropletOutline, size: 30),
                  prefixIconColor: Colors.white,
                  hintText: 'Enter Moisture',
                  border:const OutlineInputBorder(),
                    hintStyle:const TextStyle(
                      color: Colors.white,
                    )
                ),
              ),
             const SizedBox(height: 15),
              TextFormField(

                style:const TextStyle(
                  color: Colors.white,
                ),
                controller: humidityController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.grey.shade800,
                        width: 2.0,
                    )
                  ),

                  prefixIcon :const  Icon(Icons.cloud_outlined, size: 30),
                  hintText: 'Enter Humidity',
                    prefixIconColor: Colors.white,
                  border:const OutlineInputBorder(),
                    hintStyle:const TextStyle(color: Colors.white)
                ),
              ),
             const SizedBox(height: 30),
              RoundButton(
                title: 'Add',
                loading: loading,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const MainPage()));
                  setState(() {
                    loading = true;
                  });

                  databaseRef.child('Soil Data').set({
                    'temperature': temperatureController.text.toString(),
                    'moisture': moistureController.text.toString(),
                    'humidity': humidityController.text.toString(),
                    //'id': DateTime.now().millisecondsSinceEpoch.toString(),
                  }).then((value) {
                    Utils().toastMessage('Data added');
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });


                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
