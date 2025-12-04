import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../services/login.dart';
import '../../services/auth_controller.dart';
import 'package:get/get.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController idController = TextEditingController();
  final TextEditingController instituteController = TextEditingController();
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
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (_) => LoginWebviewWidget(
          username: idController.text,
          schoolId: selectedSchool != null ? selectedSchool['azonosito'] : null,
        ),
      ),
    );

    if (result != null) {
      final auth = Get.find<AuthController>();
      auth.login(
        accessToken: result['access_token'],
        refreshToken: result['refresh_token'],
        instituteCode: selectedSchool['azonosito'],
        expiresInSeconds: result['expires_in'] ?? 3600,
      );
    } else {
      print("Login canceled or failed");
    }
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
              Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  color: Colors.blue[800],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.school, size: 70, color: Colors.white),
              ),
              const SizedBox(height: 20),
              const Text(
                "E-Kréta Bejelentkezés",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.w900),
              ),
              const Text(
                "Jelentkezz be az E-kréta fiókodba",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w300),
              ),
              const SizedBox(height: 30),
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.8),
                      spreadRadius: 2,
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  spacing: 15,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Azonosító",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextField(
                      controller: idController,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(vertical: 10.0),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Iskola",
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    TextField(
                      controller: instituteController,

                      onChanged: filterSchools,
                      autocorrect: false,
                      decoration: const InputDecoration(
                         contentPadding: EdgeInsets.symmetric(vertical: 10.0),

                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6.0)),
                        ),
                      ),
                    ),
                    if (filteredSchools.isNotEmpty)
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.blue[900]!,
                            width: 1,
                            style: BorderStyle.solid,
                          ),
                          borderRadius: BorderRadius.circular(10),
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
                    ElevatedButton.icon(
                      onPressed: _login,

                      icon: const Icon(Icons.login, size: 20),
                      style: ElevatedButton.styleFrom(
                        fixedSize: Size(800, 50),
                        backgroundColor: Colors.blue[800],
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        textStyle: TextStyle(
                          fontSize: 18,
                          letterSpacing: 1.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      label: const Text("Bejelentkezés"),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "Az alkalmazás nem hivatalos, és nem áll kapcsolatban az e-Kréta Informatikai Zrt.-vel.",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w300),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
