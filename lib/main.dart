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
  Map data = {
    "duty_time": {
      "Monday": [
        {
          "time_start": "09:25 AM",
          "time_end": "10:25 AM",
          "time_shift": "morning"
        },
        {
          "time_start": "09:25 PM",
          "time_end": "10:25 PM",
          "time_shift": "night"
        }
      ],
      "Tuesday": [
        {
          "time_start": "09:30 AM",
          "time_end": "10:30 AM",
          "time_shift": "morning"
        },
        {
          "time_start": "09:30 PM",
          "time_end": "10:30 PM",
          "time_shift": "night"
        }
      ],
      "Wednesday": [
        {
          "time_start": "09:35 AM",
          "time_end": "10:35 AM",
          "time_shift": "morning"
        },
        {
          "time_start": "09:35 PM",
          "time_end": "10:35 PM",
          "time_shift": "night"
        }
      ]
    }
  };

  List finalData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(data['duty_time'].values); // arrays

    algo();
  }

  void algo() {
    List schedules = [];
    //Loop through the object key value pair
    Map dataMap = data['duty_time'];
    dataMap.keys.toList().forEach((key) {
      print("checking the key:" + key);
      List dutyTime = dataMap[key];
      print("checking duty time" + dutyTime.toString());

      dutyTime.forEach((duty_time) {
        Map obj = {...duty_time};
        obj["day"] = key; //key = day

        //Store bus schedule into the schedules array
        schedules.add(obj);
      });

      print("checking schedules array:" + schedules.toString());
    });

    setState(() {
      finalData = schedules;
    });
  }

  Widget showResult() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...finalData.map((e) => ListTile(
                title: Text('${e['time_start']} to ${e['time_end']}',
                    style: TextStyle(color: Colors.black)),
                subtitle: Text(
                  '(${e['day']}) [${e['time_shift']}]',
                  style: TextStyle(color: Colors.black),
                ),
              ))
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: showResult(),
        ),
      ),
    );
  }
}
