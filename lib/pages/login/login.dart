import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/login.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  List<dynamic> schoolOptions = [];
  List<dynamic> filteredSchools = [];
  dynamic selectedSchool;

  @override
  void initState() {
    super.initState();
    fetchSchools();
  }

  Future<void> fetchSchools() async {
    try {
      final response = await http.get(
        Uri.parse(
          'https://kretaglobalapi.e-kreta.hu/intezmenyek/kreta/publikus',
        ),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        setState(() {
          schoolOptions = data;
        });
      } else {
        throw Exception('Hiba a KRÉTA API elérése közben');
      }
    } catch (err) {
      print('Hiba történt az iskolák betöltése során: $err');
    }
  }

  void filterSchools(String input) {
    if (input.length >= 3) {
      setState(() {
        filteredSchools = schoolOptions.where((school) {
          final name = (school['nev'] ?? "").toLowerCase();
          final id = (school['azonosito'] ?? "").toLowerCase();
          final omKod = (school['omKod'] ?? "").toLowerCase();
          final query = input.toLowerCase();

          return name.contains(query) ||
              id.contains(query) ||
              omKod.contains(query);
        }).toList();
      });
    } else {
      setState(() {
        filteredSchools = [];
      });
    }
  }

  void _login() async {
    final result = await ApiService.loginToKreta(
      userName: idController.text,
      instituteCode: instituteController.text,
      password: passwordController.text,
    );

    print(result.accessToken);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                "Bejelentkezés",
                style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),
              TextField(
                controller: idController,
                decoration: const InputDecoration(
                  labelText: "Azonosító",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Jelszó",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: instituteController,
                onChanged: filterSchools,
                autocorrect: false,
                decoration: const InputDecoration(
                  labelText: "Iskola",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 15),
              if (filteredSchools.isNotEmpty)
                Container(
                  height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black, width: 1, style: BorderStyle.solid),
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: ListView(
                    padding: EdgeInsets.all(0.0),
                    children: filteredSchools
                        .map(
                          (school) => ListTile(
                            title: Text(school['nev'] ?? ''),
                            subtitle: Text(
                              "Azonosító: ${school['azonosito']} | OM: ${school['omKod']}",
                            ),
                            onTap: () {
                              setState(() {
                                selectedSchool = school;
                                instituteController.text = school['nev'];
                                filteredSchools = [];
                              });
                            },
                          ),
                        )
                        .toList(),
                  ),
                ),
              const SizedBox(height: 15),
              ElevatedButton.icon(
                onPressed: _login,
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(800, 50),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                label: const Text("Bejelentkezés"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
