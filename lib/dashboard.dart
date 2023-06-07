import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'add_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  var maindata = [];

  int items = 0;
  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getData();
    super.initState();
  }

  CollectionReference _collectionRef =
      FirebaseFirestore.instance.collection('meals');

  Future<void> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot = await _collectionRef.get();

    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
    setState(() {
      maindata = allData;
      items = allData.length;
    });
    print(allData);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Widget listItem(BuildContext context, int index) {
    var data1 = maindata[index];
    DateTime parseDate = maindata[index]["datetime"].toDate();
    var inputDate = DateTime.parse(parseDate.toString());
    var outputFormat = DateFormat('MMM');
    var outputMonth = outputFormat.format(inputDate);
    outputFormat = DateFormat('HH:mm');
    var outputTime = outputFormat.format(inputDate);
    outputFormat = DateFormat('d');
    var outputDate = outputFormat.format(inputDate);
    return Container(
      margin: EdgeInsets.all(5),
      padding: EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(10))),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topRight,
              child: Column(children: [
                Text(
                  outputMonth,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  outputDate,
                  style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 239, 85, 59)),
                ),
                Text(
                  outputTime,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ]),
            ),
          ),
          Container(
            margin: EdgeInsets.all(10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data1["name"],
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      child: Row(
                        children: [
                          Text(
                            "              ",
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(width: 110),
                          Text(
                            "Call: " + data1["contact"],
                            style: TextStyle(
                                fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: 250,
                      child: Text(
                        data1["location"] + ", " + data1["city"],
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "Donor: " + data1["donor"],
                      style:
                          TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        OutlinedButton(
                          onPressed: () {},
                          child: Text(
                            'View Details',
                            style: TextStyle(
                                color: Color.fromARGB(255, 239, 85, 59)),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                                color: Color.fromARGB(255, 239, 85, 59)),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            debugPrint('Received click');
                            final Uri _url =
                                Uri.parse('tel:' + data1["contact"]);
                            if (!await launchUrl(
                              _url,
                              mode: LaunchMode.externalApplication,
                            )) {
                              throw 'Could not launch $_url';
                            }
                          },
                          child: const Text('Call the Donor'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color.fromARGB(255, 239, 85, 59),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 2,
        child: Container(
          child: Scaffold(
            body: Container(
              color: Color.fromARGB(255, 34, 34, 52),
              child: Column(
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.restaurant,
                        size: 25,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text("Waste Not",
                          style: TextStyle(fontSize: 20, color: Colors.white)),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              color: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      const AddDataScreen(title: 'Add Data'),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.refresh,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          getData();
                        },
                      ),
                    ],
                  ),
                  TabBar(
                    indicatorColor: Color.fromARGB(255, 239, 85, 59),
                    unselectedLabelColor:
                        const Color.fromARGB(255, 255, 255, 255),
                    labelColor: Color.fromARGB(255, 239, 85, 59),
                    tabs: [
                      Tab(
                        text: 'Meals',
                      ),
                      Tab(
                        text: 'My Meals',
                      )
                    ],
                    controller: _tabController,
                    indicatorSize: TabBarIndicatorSize.tab,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: ListView.separated(
                        padding: EdgeInsets.all(10.0),
                        //physics: const AlwaysScrollableScrollPhysics(),
                        physics: const NeverScrollableScrollPhysics(),
                        //scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: items,
                        itemBuilder: (BuildContext context, int index) {
                          return listItem(context, index);
                        },
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<String> get_data() async {
  final url = Uri.parse('http://test.api.boxigo.in/sample-data/');
  final response = await get(url);
  //print(response.body);
  return response.body;
}
