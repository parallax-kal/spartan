import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/constants/global.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/models/User.dart';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key}) : super(key: key);

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  List<Map<String, List<String>>> sortCountries(List<String> countries) {
    List<Map<String, List<String>>> sortedCountries = [];
    List<String> sorted = [];
    List<String> temp = [];
    String firstLetter = countries[0][0];
    for (int i = 0; i < countries.length; i++) {
      if (countries[i][0] == firstLetter) {
        temp.add(countries[i]);
      } else {
        sorted.add(firstLetter);
        sortedCountries.add({firstLetter: temp});
        temp = [];
        firstLetter = countries[i][0];
        temp.add(countries[i]);
      }
    }
    sorted.add(firstLetter);
    sortedCountries.add({firstLetter: temp});
    return sortedCountries;
  }

  String search = '';

  String? selectedCountry;

  @override
  Widget build(BuildContext context) {

    UserModel usermodel = Provider.of<UserModel>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF908E8E),
      body: Container(),
      bottomNavigationBar: DraggableScrollableSheet(
        minChildSize: .80,
        maxChildSize: .80,
        initialChildSize: .80,
        expand: false,
        builder: (context, scrollController) {
          return Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(67),
                topRight: Radius.circular(67),
              ),
            ),
            child: Stack(
              children: [
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 20, right: 20),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 18,
                          ),
                          hintText: 'Search',
                          prefixIcon: Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Color(0xFFDDDDDD)),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(6)),
                            borderSide: BorderSide(color: Color(0xFF0C3D6B)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: sortCountries(countries).length,
                        itemBuilder: (context, index) {
                          String key =
                              sortCountries(countries)[index].keys.first;
                          List<String> value =
                              sortCountries(countries)[index][key]!;
                          List<String> filteredValue = value
                              .where((country) => country
                                  .toLowerCase()
                                  .contains(search.toLowerCase()))
                              .toList();
                          if (filteredValue.isEmpty) {
                            return const SizedBox();
                          }
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0,
                                    top: 8.0,
                                    right: 8.0,
                                    bottom: 8.0),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      color: Color(0XFF908E8E),
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredValue.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    onTap: () {
                                      setState(() {
                                        selectedCountry = filteredValue[index];
                                      });
                                    },
                                    title: Text(filteredValue[index]),
                                    leading: Radio(
                                      value: filteredValue[index],
                                      groupValue: selectedCountry,
                                      onChanged: (value) {
                                        setState(() {
                                          selectedCountry = value.toString();
                                        });
                                      },
                                    ),
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 10,
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: selectedCountry == null
                            ? const Color(0XFF93CACA)
                            : const Color(0xFF0C3D6B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      onPressed: () {
                        if (selectedCountry == null) {
                          return;
                        }
                        if (auth.currentUser == null) {
                          context.go('/login');
                          return;
                        }
                        usermodel.setCountry(selectedCountry!);
                        context.push('/terms');
                      },
                      child: const Text(
                        'Save',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
