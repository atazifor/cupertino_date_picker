import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef PickerConfirmCallback = void Function(DateTime start, DateTime end);

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
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

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: PickerWidget(
          DateTime.now(), DateTime.now().add(Duration(days: 20)), 5,
          onConfirm: (start, end) {}),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class PickerWidget extends StatefulWidget {
  DateTime initialStartTime;
  DateTime initialEndTime;

  final VoidCallback onCancel;
  final PickerConfirmCallback onConfirm;

  final int interval;

  PickerWidget(this.initialStartTime, this.initialEndTime, this.interval,
      {this.onCancel, this.onConfirm, Key key})
      : super(key: key);

  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget>
    with SingleTickerProviderStateMixin {
  DateTime start;
  DateTime end;
  bool startVisible = false;
  bool endVisible = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialStartTime == null) {
      widget.initialStartTime = DateTime.now();
    }

    // Remove minutes and seconds
    widget.initialStartTime = widget.initialStartTime.subtract(Duration(
        minutes: widget.initialStartTime.minute,
        seconds: widget.initialStartTime.second));

    if (widget.initialEndTime == null) {
      widget.initialEndTime =
          widget.initialStartTime.add(Duration(days: 0, hours: 2));
    }

    widget.initialEndTime = widget.initialEndTime.subtract(Duration(
        minutes: widget.initialEndTime.minute,
        seconds: widget.initialEndTime.second));
    start = widget.initialStartTime;
    end = widget.initialEndTime;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            setState(() {
              startVisible = !startVisible;
            });
          },
          child: Padding(
            padding: EdgeInsets.only(top: 20, left: 16, right: 16),
            child: Container(
              alignment: Alignment.center,
              height: 64,
              decoration: BoxDecoration(
                  border: Border.all(width: 1, color: Colors.black),
                  borderRadius: BorderRadius.circular(6)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text('Starts:', textAlign: TextAlign.left),
                  Container(
                    height: 16.0,
                    width: 1.0,
                    color: Colors.black,
                    margin: const EdgeInsets.only(left: 10.0, right: 10.0),
                  ),
                  Text(DateFormat.yMMMMd("en_US").add_jm().format(start),
                      textAlign: TextAlign.right)
                ],
              ),
            ),
          ),
        ),
        Visibility(
          visible: startVisible,
          child: SizedBox(
            height: 160,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              minuteInterval: widget.interval,
              initialDateTime: start,
              onDateTimeChanged: (DateTime newDateTime) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    start = newDateTime;
                  });
                });
              },
            ),
          ),
        ),
        Visibility(
          visible: endVisible,
          child: SizedBox(
            height: 160,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.dateAndTime,
              minuteInterval: widget.interval,
              initialDateTime: end,
              onDateTimeChanged: (DateTime newDateTime) {
                setState(() {
                  end = newDateTime;
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}
