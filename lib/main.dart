import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        DateTime.now(),
        DateTime.now().add(Duration(hours: 1)),
        5,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class PickerWidget extends StatefulWidget {
  final DateTime initialStartTime;
  final DateTime initialEndTime;
  final int interval;
  final Function(DateTime dateTime) onStartDateChanged;
  final Function(DateTime dateTime) onEndDateChanged;

  PickerWidget(this.initialStartTime, this.initialEndTime, this.interval,
      {Key key, this.onStartDateChanged, this.onEndDateChanged})
      : super(key: key);

  _PickerWidgetState createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<PickerWidget>
    with SingleTickerProviderStateMixin {
  DateTime startDate;
  DateTime endDate;
  bool startVisible = false;
  bool endVisible = false;

  //TextEditingController _startDateController;

  @override
  void initState() {
    super.initState();

    widget.initialStartTime != null
        ? startDate = widget.initialStartTime
        : startDate = DateTime.now();

    // Remove minutes and seconds
    startDate = startDate.subtract(
        Duration(minutes: startDate.minute, seconds: startDate.second));

    widget.initialEndTime != null
        ? endDate = widget.initialEndTime
        : endDate = startDate.add(Duration(days: 0, hours: 1));

    endDate = endDate
        .subtract(Duration(minutes: endDate.minute, seconds: endDate.second));

    //_startDateController = TextEditingController(text: DateFormat.yMMMMd("en_US").add_jm().format(start));
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
          child: IOSDateField(
            label: 'Starts:',
            dateTime: startDate,
          ),
        ),
        Visibility(
          visible: startVisible,
          child: SizedBox(
            height: 160,
            child: IOSDatePicker(
              minuteInterval: widget.interval,
              initialDateTime: startDate,
              onDateChanged: (DateTime newDateTime) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    startDate = newDateTime;
                    if (widget.onStartDateChanged != null)
                      widget.onStartDateChanged(newDateTime);
                    //_startDateController.text = DateFormat.yMMMMd("en_US").add_jm().format(newDateTime);
                  });
                });
              },
            ),
          ),
        ),
        GestureDetector(
          onTap: () {
            setState(() {
              endVisible = !endVisible;
            });
          },
          child: IOSDateField(
            label: 'Ends:',
            dateTime: endDate,
          ),
        ),
        Visibility(
          visible: endVisible,
          child: SizedBox(
            height: 160,
            child: IOSDatePicker(
              minuteInterval: widget.interval,
              initialDateTime: endDate,
              onDateChanged: (DateTime newDateTime) {
                Future.delayed(const Duration(milliseconds: 1000), () {
                  setState(() {
                    endDate = newDateTime;
                    if (widget.onEndDateChanged != null)
                      widget.onEndDateChanged(newDateTime);
                    //_startDateController.text = DateFormat.yMMMMd("en_US").add_jm().format(newDateTime);
                  });
                });
              },
            ),
          ),
        ),
      ],
    );
  }
}

final Color kColor_lightGrey_text_bg = new Color.fromRGBO(11, 17, 45, 0.3);
final Color kColor_dark_text = Colors.black87;
final Color kColor_seperator_bg = Colors.black87;

TextStyle textStyle(Color color, FontWeight weight, double size,
    {FontStyle style = FontStyle.normal, double lineHeight = 1}) {
  return new TextStyle(
      color: color, fontWeight: weight, fontSize: size, height: lineHeight);
}

class IOSDatePicker extends StatelessWidget {
  final int minuteInterval;
  final DateTime initialDateTime;
  final Function(DateTime dateTime) onDateChanged;

  IOSDatePicker({
    this.minuteInterval,
    this.initialDateTime,
    this.onDateChanged,
  })  : assert(minuteInterval != null),
        assert(initialDateTime != null),
        assert(onDateChanged != null);

  @override
  Widget build(BuildContext context) {
    return CupertinoDatePicker(
      mode: CupertinoDatePickerMode.dateAndTime,
      minuteInterval: minuteInterval,
      initialDateTime: initialDateTime,
      onDateTimeChanged: (DateTime newDateTime) {
        onDateChanged(newDateTime);
      },
    );
  }
}

class IOSDateField extends StatelessWidget {
  final String label;
  final DateTime dateTime;

  IOSDateField({this.label, this.dateTime})
      : assert(dateTime != null),
        assert(label != null);

  @override
  Widget build(BuildContext context) {
    return Padding(
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
            Text(
              label,
              textAlign: TextAlign.left,
              style: textStyle(kColor_dark_text, FontWeight.w600, 16),
            ),
            Container(
              height: 30.0,
              width: 1.0,
              color: kColor_seperator_bg,
              margin: const EdgeInsets.symmetric(vertical: 9),
            ),
            Text(
              DateFormat.yMMMMd("en_US").add_jm().format(dateTime),
              textAlign: TextAlign.right,
              style: textStyle(kColor_dark_text, FontWeight.w600, 16),
            ),
          ],
        ),
      ),
    );
  }
}
