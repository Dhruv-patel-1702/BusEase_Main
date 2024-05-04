import 'dart:convert';

import 'package:bus_ease/providers/ticket_provider.dart';
import 'package:bus_ease/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

class TicketCreate extends StatefulWidget {
  final String bus_number;

  TicketCreate({required this.bus_number, Key? key}) : super(key: key);

  @override
  _TicketCreateState createState() => _TicketCreateState();
}

class Place {
  final String name;
  final int distance;

  Place({required this.name, required this.distance});
}

class _TicketCreateState extends State<TicketCreate> {
  bool _loading = true;
  var baseUrl = "https://busease-server.vercel.app";
  final _storage = const FlutterSecureStorage();
  int busPricePerKM = 0;
  List<Place> places = [];
  List<Place> currentPossibleTravelPlaces = [];

  String userID = '';
  String paasID = '';
  String Depot = '';
  String type = '';
  String from = '';
  String to = '';

  var ticketProvider;

  @override
  void initState() {
    super.initState();
    ticketProvider = Provider.of<TicketProvider>(context, listen: false);
    getBusData();
  }

  void showSnackBar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
      ),
    );
  }

// curl --location 'https://busease-server.vercel.app/api/paas/status/' \
// --header 'Authorization: Bearer access_token'

  Future<bool> getPaasInfo() async {
    print('Getting PAAS Info');
    var url = Uri.parse("$baseUrl/api/paas/status/");
    var token = await _storage.read(key: 'access_token');
    try {
      var response =
          await http.get(url, headers: {"Authorization": "Bearer $token"});
      var res = jsonDecode(response.body.toString());
      print(res);
      if (response.statusCode == 200) {
        bool isValid = res['status'];
        List<dynamic> possibleDestinations = res['possibleDestinations'];
        print(possibleDestinations.toString());
        if (isValid) {
          print('PAAS is valid');
          // Implement the logic to get the current possible travel places ( current possible travel places should be the intersection of the possible destinations and the bus route)
          currentPossibleTravelPlaces = places
              .where((place) =>
                  possibleDestinations.contains(place.name.toUpperCase()))
              .toList();
          userID = res['user'];
          paasID = res['paasId'];
          Depot = res['depot'];
          type = res['type'];
          print("Current Possible Travel Places");
          currentPossibleTravelPlaces.forEach((place) {
            print(place.name + " " + place.distance.toString());
          });
          return true;
        } else {
          showSnackBar(context, 'PAAS is not valid', Colors.red);
          return false;
        }
      } else {
        showSnackBar(
            context, 'Error fetching data or PAAS is Invalid', Colors.red);
        return false;
      }
    } catch (e) {
      print(e);
      showSnackBar(context, 'Error fetching data', Colors.red);
      return false;
    }
  }

  // curl --location --request GET 'https://busease-server.vercel.app/api/bus/getBusData' \
  // --header 'Content-Type: application/json' \
  // --data '{
  //     "busNumber" : "GJ-02-FT-1234"
  // }'
  // fetch bus data over http and set the loading state to false
  void getBusData() async {
    var url = Uri.parse("$baseUrl/api/bus/getBusData");
    var body = jsonEncode({
      'busNumber': widget.bus_number,
    });

    try {
      var response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: body,
      );
      var res = jsonDecode(response.body.toString());
      print(res['bus']['busPricePerKilometer']);
      if (response.statusCode == 200) {
        // set the bus price per km and places
        setState(() {
          busPricePerKM = res['bus']['busPricePerKilometer'];
          places = res['bus']['busRoute']
              .map<Place>((place) =>
                  Place(name: place['name'], distance: place['distance']))
              .toList();
        });

        print("Places");
        places.forEach((place) {
          print(place.name + " " + place.distance.toString());
        });

        // get the paas info
        bool isValid = await getPaasInfo();
        if (!isValid) {
          Navigator.pop(context);
        }

        setState(() {
          _loading = false;
        });
      } else {
        // show snackbar if there is an error and pop the screen
        print(res);
        showSnackBar(context, 'Error fetching data', Colors.red);
        Navigator.pop(context);
      }
    } catch (e) {
      // show snackbar if there is an error and pop the screen
      print(e);
      showSnackBar(context, 'Error fetching data', Colors.red);
      Navigator.pop(context);
    }
  }

  // create ticket function to create a ticket
//   curl --location 'https://busease-server.vercel.app/api/ticket/create/' \
// --header 'Content-Type: application/json' \
// --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJfaWQiOiI2NjAxMWJiOTA0MGYyZjViZjQ4ODg3M2EiLCJyb2xlIjoidXNlciIsImlhdCI6MTcxNDQ4MTc4MywiZXhwIjoxNzE0NTY4MTgzfQ.O8g7G83qUgaYGw-gOTDOWpGX_5xeLYrMpcayoWLEfaI' \
// --data '{
//     "userID": "66011bb9040f2f5bf488873a",
//     "paasId": "6630edd23b4ff2156d92fdcb",
//     "passengerName": "Mahavir Patel",
//     "Depot": "UNJHA",
//     "type": "Student",
//     "from": "UNJHA",
//     "to": "MEHSANA",
//     "ticketQuantity": 1,
//     "ticketPrice": 100
// }'

  bool validateTicketData() {
    if (from == '' || to == '') {
      showSnackBar(context, 'Please select the from and to', Colors.red);
      return false;
    }
    if (userID == '' || paasID == '' || Depot == '' || type == '') {
      showSnackBar(context, 'Error fetching data', Colors.red);
      return false;
    }
    if (from == to) {
      showSnackBar(context, 'From and To cannot be same', Colors.red);
      return false;
    }
    return true;
  }

  void createTicket() async {
    var url = Uri.parse("$baseUrl/api/ticket/create/");
    var token = await _storage.read(key: 'access_token');

    String userName =
        '${Provider.of<UserProvider>(context, listen: false).user!.firstName} ${Provider.of<UserProvider>(context, listen: false).user!.middleName.substring(0, 1)}.  ${Provider.of<UserProvider>(context, listen: false).user!.lastName}';

    // var body = jsonEncode({
    //   'userID': await _storage.read(key: 'user_id'),
    //   'paasId': await _storage.read(key: 'paas_id'),
    //   'passengerName': await _storage.read(key: 'name'),
    //   'Depot': await _storage.read(key: 'depot'),
    //   'type': await _storage.read(key: 'type'),
    //   'from': 'UNJHA',
    //   'to': 'MEHSANA',
    //   'ticketQuantity': 1,
    //   'ticketPrice': 100,
    // });

    if (!validateTicketData()) {
      return;
    }

    // calculate ticket price (to distance - from distance) * bus price per km
    int ticketPrice = (currentPossibleTravelPlaces
                .firstWhere((place) => place.name == to)
                .distance -
            currentPossibleTravelPlaces
                .firstWhere((place) => place.name == from)
                .distance) *
        busPricePerKM;

    var body = jsonEncode({
      'userID': userID,
      'paasId': paasID,
      'passengerName': userName,
      'Depot': Depot,
      'type': type,
      'from': from,
      'to': to,
      'ticketQuantity': 1,
      'ticketPrice': ticketPrice,
    });

    try {
      var response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: body,
      );
      var res = jsonDecode(response.body.toString());
      print(res);
      if (response.statusCode == 200) {
        showSnackBar(context, 'Ticket Created Successfully', Colors.green);
        // update the ticket provider
        ticketProvider.setTicketData(
            res["userID"],
            res["paasId"],
            res["_id"],
            res["from"],
            res["to"],
            res["Date"],
            res["passengerName"],
            res["Depot"],
            res["type"],
            res["ticketQuantity"],
            res["ticketPrice"]);
        // navigate to the home screen
        Navigator.popAndPushNamed(context, "/home");
      } else {
        showSnackBar(context, 'Error creating ticket', Colors.red);
      }
    } catch (e) {
      print(e);
      showSnackBar(context, 'Error creating ticket', Colors.red);
    }
  }

  @override
  @override
  @override
  @override
  Widget build(BuildContext context) {
    // show the circular progress indicator along with text that getting data while the bus data is being fetched and display the hello text after
    return _loading
        ? Scaffold(
            appBar: AppBar(
              title: const Text('Ticket Create',
                  style: TextStyle(color: Colors.white)),
              backgroundColor:
                  const Color(0xFF383E48), // Set app bar background color
            ),
            backgroundColor:
                const Color(0xFF383E48), // Set scaffold background color
            body: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text(
                    'Getting data...',
                    style: TextStyle(
                        color: Colors.white), // Set text color to white
                  ),
                ],
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: const Text('Ticket Create',
                  style: TextStyle(
                      color: Colors
                          .white)), // Set app bar title text color to white
              backgroundColor:
                  const Color(0xFF383E48), // Set app bar background color
              iconTheme: IconThemeData(
                  color: Colors.white), // Set back arrow color to white
            ),
            backgroundColor:
                const Color(0xFF383E48), // Set scaffold background color
            body: Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 20), // Add top margin
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Hello, ',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 24, // Adjust the font size as needed
                            ),
                          ),
                          Text(
                            widget.bus_number,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24, // Adjust the font size as needed
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Bus Price Per KM: $busPricePerKM',
                        style: const TextStyle(
                            color: Colors.white), 
                             // Set text color to white
                      ),
                      SizedBox(
                          height: 20), // Add space between form and list boxes
                      Container(
                        width: MediaQuery.of(context).size.width *
                            0.8, // Adjust the width as needed
                        padding: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors
                              .black, // Set container background color to black
                          borderRadius:
                              BorderRadius.circular(10), // Round the corners
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                DropdownButton<Place>(
                                  dropdownColor: Colors
                                      .grey, // Set dropdown background color to gray
                                  hint: from == ''
                                      ? const Text('From',
                                          style: TextStyle(color: Colors.white))
                                      : Text(from,
                                          style: const TextStyle(
                                              color: Colors
                                                  .white)), // Set text color to white
                                  value: null,
                                  items: currentPossibleTravelPlaces
                                      .map((place) => DropdownMenuItem(
                                            child: Text(place.name,
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white)), // Set text color to white
                                            value: place,
                                          ))
                                      .toList(),
                                  onChanged: (Place? value) {
                                    setState(() {
                                      from = value!.name;
                                    });
                                  },
                                ),
                                SizedBox(
                                    width: 20), // Add space between dropdowns
                                DropdownButton<Place>(
                                  dropdownColor: Colors
                                      .grey, // Set dropdown background color to gray
                                  hint: to == ''
                                      ? const Text('To',
                                          style: TextStyle(color: Colors.white))
                                      : Text(to,
                                          style: const TextStyle(
                                              color: Colors
                                                  .white)), // Set text color to white
                                  value: null,
                                  items: currentPossibleTravelPlaces
                                      .map((place) => DropdownMenuItem(
                                            child: Text(place.name,
                                                style: const TextStyle(
                                                    color: Colors
                                                        .white)), // Set text color to white
                                            value: place,
                                          ))
                                      .toList(),
                                  onChanged: (Place? value) {
                                    setState(() {
                                      to = value!.name;
                                    });
                                  },
                                ),
                              ],
                            ),
                            SizedBox(
                                height:
                                    20), // Add space between dropdowns and button
                            ElevatedButton(
                              onPressed: () {
                                createTicket();
                              },
                              child: Text('Create Ticket',
                                  style: TextStyle(
                                      color: Colors
                                          .black)), // Set text color to black
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty
                                    .all<Color>(const Color(
                                        0xFFFBC420)), // Set button background color to fbc420
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
