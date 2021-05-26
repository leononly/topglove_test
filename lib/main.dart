import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Top Glove Test'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  Map data = {
    "bus_schedule": {
      "Night Shift": [
        {
          "schedule_trip": "Return",
          "start_time": "06.30 am",
          "end_time": "07.59 am"
        },
        {
          "schedule_trip": "Departure",
          "start_time": "06.30 pm",
          "end_time": "07.00 pm"
        }
      ],
      "Night Overtime": [
        {
          "schedule_trip": "Return",
          "start_time": "08.00 am",
          "end_time": "08.30 am"
        }
      ],
      "Morning Shift": [
        {
          "schedule_trip": "Departure",
          "start_time": "05.30 am",
          "end_time": "06.00 am"
        },
        {
          "schedule_trip": "Return",
          "start_time": "06.30 pm",
          "end_time": "07.59 pm"
        }
      ],
      "Morning Overtime": [
        {
          "schedule_trip": "Return",
          "start_time": "08.00 pm",
          "end_time": "08.30 pm"
        }
      ]
    },
  };

  List finalData = [];
  Map selected;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(data['bus_schedule'].values); // arrays

    algo();
  }

  void algo() {
    List schedules = [];
    //Loop through the object key value pair
    int i = 0;
    Map dataMap = data['bus_schedule'];
    dataMap.keys.toList().forEach((key) {
      print("checking the key:" + key);
      List busSchedules = dataMap[key];
      print("checking bus schedules" + busSchedules.toString());

      busSchedules.forEach((busSchedule) {
        Map obj = {...busSchedule};
        obj["shift"] = key; //key = shift
        double totalTime = 0;
        String startTime = busSchedule["start_time"];
        String endTime = busSchedule["end_time"];

        print(endTime.split(' ')[0]);
        double formattedStartTime =
            double.parse(startTime.split(' ')[0].toString());
        double formattedEndTime = double.parse(endTime.split(' ')[0]);

        if (formattedStartTime != 12 && startTime.contains("pm")) {
          //12pm => 12:00 in 24 hours format
          formattedStartTime += 12.0;
        }

        if (formattedEndTime != 12 && endTime.contains("pm")) {
          formattedEndTime += 12.0;
        }

        totalTime += formattedStartTime +
            1 /
                formattedEndTime /
                1000; // + 1 / formattedEndTime as for same start time, the one with later end time will be shown first
        obj["total_time"] = totalTime;

        //Store bus schedule into the schedules array
        schedules.add(obj);
      });
      schedules.sort((a, b) {
        return a['total_time'].compareTo(b['total_time']);
      });

      print("checking schedules array:" + schedules.toString());
    });

    setState(() {
      finalData = schedules;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            DropdownButton<dynamic>(
              focusColor: Colors.white,
              value: selected,
              elevation: 5,
              style: TextStyle(color: Colors.white),
              iconEnabledColor: Colors.black,
              items: finalData.map<DropdownMenuItem>((value) {
                return DropdownMenuItem(
                  value: value,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${value['start_time']} to ${value['end_time']}',
                          style: TextStyle(color: Colors.black)),
                      Text(
                        '[${value['schedule_trip']}] (${value['shift']})',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),
              hint: Text(
                "Please choose a schedule",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              onChanged: (value) {
                print(value.toString());
                setState(() {
                  selected = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
