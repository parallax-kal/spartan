import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:spartan/constants/firebase.dart';
import 'package:spartan/constants/global.dart';
import 'package:go_router/go_router.dart';
import 'package:spartan/notifiers/CountryTermsNotifier.dart';

class CountryScreen extends StatefulWidget {
  const CountryScreen({super.key});

  @override
  State<CountryScreen> createState() => _CountryScreenState();
}

class _CountryScreenState extends State<CountryScreen> {
  List<Map<String, List<String>>> sortCountries(List<String> countries) {
    List<Map<String, List<String>>> sortedCountries = [];
    List<String> sorted = [];
    List<String> temp = [];
    String firstLetter = countries[0][0];
    for (int i = 0; i < countries.length; i++) {
      if (countries[i][0] == firstLetter) {
        temp.add(countries[i]);
      } else {
        if (temp.isNotEmpty) {
          sorted.add(firstLetter);
          sortedCountries.add({firstLetter: temp});
        }
        temp = [];
        firstLetter = countries[i][0];
        temp.add(countries[i]);
      }
    }
    if (temp.isNotEmpty) {
      sorted.add(firstLetter);
      sortedCountries.add({firstLetter: temp});
    }
    return sortedCountries;
  }

  String search = '';

  String? selectedCountry;

  @override
  Widget build(BuildContext context) {
    CountryAndTermsNotifier usermodel =
        Provider.of<CountryAndTermsNotifier>(context, listen: false);

    return Scaffold(
      backgroundColor: const Color(0xFF908E8E),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(top: 18.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const Text(
                'Select a region',
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w600,
                  fontSize: 17,
                ),
              ),
              Image.asset('assets/images/map.png')
            ],
          ),
        ),
      ),
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
                Positioned(
                  right: 20,
                  top: 45,
                  child: SvgPicture.asset(
                    'assets/icons/location.svg',
                    width: 15,
                    height: 15,
                  ),
                ),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 30, left: 30, right: 40),
                      child: TextFormField(
                        onChanged: (value) {
                          setState(() {
                            search = value;
                          });
                        },
                        decoration: const InputDecoration(
                          contentPadding: EdgeInsets.only(
                            right: 18,
                            left: 25,
                          ),
                          hintText: 'Search',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            borderSide:
                                BorderSide(color: Color(0xFFDDDDDD), width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                            borderSide:
                                BorderSide(color: Color(0xFF0C3D6B), width: 1),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: sortCountries(countries).length,
                        padding: const EdgeInsets.only(bottom: 70),
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
                                  bottom: 8.0,
                                ),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    key,
                                    style: const TextStyle(
                                      color: Color(0XFF908E8E),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: filteredValue.length,
                                padding: const EdgeInsets.only(left: 30),
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            selectedCountry =
                                                filteredValue[index];
                                          });
                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              selectedCountry == filteredValue[index] ?
                                              'assets/icons/checked.svg' :
                                                'assets/icons/circle.svg'),
                                            const SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              filteredValue[index],
                                              style: const TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w400,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                    ],
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
                        context.push('/terms-of-service');
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
