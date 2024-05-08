import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

void main() {
  runApp(EventManagementApp());
}

class EventManagementApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Event Management',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: EventListScreen(),
    );
  }
}

class EventListScreen extends StatefulWidget {
  @override
  _EventListScreenState createState() => _EventListScreenState();
}

class _EventListScreenState extends State<EventListScreen> {
  List<Event> events = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event List'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(events[index].name),
            subtitle: Text(events[index].personName),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDetailScreen(event: events[index]),
                ),
              );
              if (result != null && result is Event) {
                setState(() {
                  events[index] = result;
                });
              } else if (result != null && result is bool && result) {
                setState(() {
                  events.removeAt(index);
                });
              }
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EventCreationScreen(existingEvents: events),
            ),
          ).then((newEvent) {
            if (newEvent != null) {
              setState(() {
                events.add(newEvent);
              });
            }
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class EventDetailScreen extends StatelessWidget {
  final Event event;

  EventDetailScreen({required this.event});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Event Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Event Name: ${event.name}'),
            Text('Person Name: ${event.personName}'),
            Text('Contact: ${event.contact}'),
            Text('Venue: ${event.venue}'),
            Text(
                'Start Time: ${DateFormat.yMd().add_jm().format(event.startTime)}'),
            Text(
                'End Time: ${DateFormat.yMd().add_jm().format(event.endTime)}'),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    final editedEvent = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EventEditScreen(event: event),
                      ),
                    );
                    if (editedEvent != null && editedEvent is Event) {
                      Navigator.pop(context, editedEvent);
                    }
                  },
                  child: Text('Edit'),
                ),
                SizedBox(width: 20),
                ElevatedButton(
                  onPressed: () {
                    _showDeleteDialog(context, event);
                  },
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.red),
                  ),
                  child: Text('Delete'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Delete Event"),
          content: Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("CANCEL"),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(
                    context, true); // Pass true if user confirms delete
              },
              child: Text("DELETE"),
            ),
          ],
        );
      },
    ).then((value) {
      if (value != null && value) {
        Navigator.pop(context, true); // Pass true if user confirmed delete
      }
    });
  }
}

class EventEditScreen extends StatefulWidget {
  final Event event;

  EventEditScreen({required this.event});

  @override
  _EventEditScreenState createState() => _EventEditScreenState();
}

class _EventEditScreenState extends State<EventEditScreen> {
  late String _eventName;
  late String _personName;
  late String _contact;
  late String _venue;
  late DateTime _startTime;
  late DateTime _endTime;

  @override
  void initState() {
    super.initState();
    _eventName = widget.event.name;
    _personName = widget.event.personName;
    _contact = widget.event.contact;
    _venue = widget.event.venue;
    _startTime = widget.event.startTime;
    _endTime = widget.event.endTime;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _eventName,
                decoration: InputDecoration(labelText: 'Event Name'),
                onChanged: (value) {
                  setState(() {
                    _eventName = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _personName,
                decoration: InputDecoration(labelText: 'Person Name'),
                onChanged: (value) {
                  setState(() {
                    _personName = value;
                  });
                },
              ),
              TextFormField(
                initialValue: _contact,
                decoration: InputDecoration(labelText: 'Contact'),
                onChanged: (value) {
                  setState(() {
                    _contact = value;
                  });
                },
              ),
              Row(
                children: [
                  Radio<String>(
                    value: 'Banquet Hall',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Banquet Hall'),
                  Radio<String>(
                    value: 'Court',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Court'),
                  Radio<String>(
                    value: 'Theatre',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Theatre'),
                ],
              ),
              DateTimePicker(
                labelText: 'Start Time',
                selectedDate: _startTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _startTime = date;
                  });
                },
              ),
              DateTimePicker(
                labelText: 'End Time',
                selectedDate: _endTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _endTime = date;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_endTime.difference(_startTime).inHours > 4) {
                    _showMessageDialog(context,
                        'Event duration should be less than or equal to 4 hours.');
                  } else if (_endTime.difference(_startTime).inHours < 2) {
                    _showMessageDialog(context,
                        'Event duration should be greater than or equal to 2 hours.');
                  } else if (_startTime.hour < 8 || _startTime.hour >= 23) {
                    _showMessageDialog(
                        context, 'Event must start between 8am and 11pm');
                  } else {
                    Event editedEvent = Event(
                      name: _eventName,
                      personName: _personName,
                      contact: _contact,
                      venue: _venue,
                      startTime: _startTime,
                      endTime: _endTime,
                    );
                    Navigator.pop(context, editedEvent);
                  }
                },
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }
}

class DateTimePicker extends StatelessWidget {
  final String labelText;
  final DateTime selectedDate;
  final Function(DateTime) selectDate;

  const DateTimePicker({
    Key? key,
    required this.labelText,
    required this.selectedDate,
    required this.selectDate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(labelText: labelText),
            controller: TextEditingController(
              text: DateFormat.yMd().add_jm().format(selectedDate),
            ),
            onTap: () {
              _selectDate(context, selectedDate);
            },
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: TextFormField(
            readOnly: true,
            decoration: InputDecoration(labelText: 'End Time'),
            controller: TextEditingController(
              text: DateFormat.jm().format(selectedDate),
            ),
            onTap: () {
              _selectTime(context, selectedDate);
            },
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(BuildContext context, DateTime initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != initialDate) {
      selectDate(DateTime(
        picked.year,
        picked.month,
        picked.day,
        initialDate.hour,
        initialDate.minute,
      ));
    }
  }

  Future<void> _selectTime(BuildContext context, DateTime initialTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(initialTime),
    );
    if (picked != null) {
      selectDate(DateTime(
        initialTime.year,
        initialTime.month,
        initialTime.day,
        picked.hour,
        picked.minute,
      ));
    }
  }
}

class EventCreationScreen extends StatefulWidget {
  final List<Event> existingEvents;

  EventCreationScreen({required this.existingEvents});

  @override
  _EventCreationScreenState createState() => _EventCreationScreenState();
}

class _EventCreationScreenState extends State<EventCreationScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _eventName;
  late String _personName;
  late String _contact;
  late String _venue = ''; // Initialize with an empty string
  late DateTime _startTime = DateTime.now(); // Initialize with current time
  late DateTime _endTime = DateTime.now()
      .add(Duration(hours: 2)); // Initialize with current time plus 2 hours

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Event Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter event name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _eventName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Person Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter person name';
                  }
                  return null;
                },
                onSaved: (value) {
                  _personName = value!;
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Contact'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter contact';
                  }
                  return null;
                },
                onSaved: (value) {
                  _contact = value!;
                },
              ),
              SizedBox(height: 20),
              Text('Select Venue'),
              Row(
                children: [
                  Radio<String>(
                    value: 'Banquet Hall',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Banquet Hall'),
                  Radio<String>(
                    value: 'Court',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Court'),
                  Radio<String>(
                    value: 'Theatre',
                    groupValue: _venue,
                    onChanged: (String? value) {
                      setState(() {
                        _venue = value!;
                      });
                    },
                  ),
                  Text('Theatre'),
                ],
              ),
              DateTimePicker(
                labelText: 'Start Time',
                selectedDate: _startTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _startTime = date;
                  });
                },
              ),
              DateTimePicker(
                labelText: 'End Time',
                selectedDate: _endTime,
                selectDate: (DateTime date) {
                  setState(() {
                    _endTime = date;
                  });
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_endTime.difference(_startTime).inHours > 4) {
                    _showMessageDialog(context,
                        'Event duration should be less than or equal to 4 hours.');
                  } else if (_endTime.difference(_startTime).inHours < 2) {
                    _showMessageDialog(context,
                        'Event duration should be greater than or equal to 2 hours.');
                  } else if (_startTime.hour < 8 || _startTime.hour >= 23) {
                    _showMessageDialog(
                        context, 'Event must start between 8am and 11pm');
                  } else if (_eventsOverlap()) {
                    _showMessageDialog(
                        context, 'The event clashes with another event.');
                  } else {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      Event newEvent = Event(
                        name: _eventName,
                        personName: _personName,
                        contact: _contact,
                        venue: _venue,
                        startTime: _startTime,
                        endTime: _endTime,
                      );
                      Navigator.pop(context, newEvent);
                    }
                  }
                },
                child: Text('Create Event'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showMessageDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Warning"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        );
      },
    );
  }

  bool _eventsOverlap() {
    for (Event event in widget.existingEvents) {
      if (_startTime.isBefore(event.endTime) &&
          _endTime.isAfter(event.startTime)) {
        return true;
      }
    }
    return false;
  }
}

class Event {
  final String name;
  final String personName;
  final String contact;
  final String venue;
  final DateTime startTime;
  final DateTime endTime;

  Event({
    required this.name,
    required this.personName,
    required this.contact,
    required this.venue,
    required this.startTime,
    required this.endTime,
  });
}
