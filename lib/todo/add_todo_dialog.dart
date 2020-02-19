import 'package:flutter/material.dart';
import 'package:tamz/custom_button.dart';

enum Priority { low, medium, high }

extension PriorityExtension on Priority {
  String get name {
    switch (this) {
      case Priority.low:
        return 'Low';
      case Priority.medium:
        return 'Medium';
      case Priority.high:
        return 'High';
      default:
        return null;
    }
  }
}

class Todo {
  Todo(
      {this.title,
      this.date,
      this.notes,
      this.priority,
      this.volume,
      this.vibrate});

  int date;
  String title;
  String notes;
  Priority priority;
  int volume;
  bool vibrate;

  Map<String, dynamic> toJson() => {
        'date': date,
        'title': title,
        'notes': notes,
        'priority': priority.index,
        'volume': volume,
        'vibrate': vibrate,
      };
}

class AddTodoDialog extends StatefulWidget {
  AddTodoDialog({this.save, this.todo});

  final void Function(Map<String, dynamic>, {bool saveToLocal}) save;
  final Todo todo;

  @override
  _AddTodoDialogState createState() => _AddTodoDialogState();
}

class _AddTodoDialogState extends State<AddTodoDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selected = DateTime.now().add(Duration(days: 1));
  Priority _priority = Priority.low;
  bool _vibrate = false;
  double _volume = 5;

  @override
  void initState() {
    if (widget.todo != null) {
      _titleController.text = widget.todo.title;
      _noteController.text = widget.todo.notes ?? '';
      _selected = DateTime.fromMillisecondsSinceEpoch(widget.todo.date);
      _priority = widget.todo.priority ?? Priority.low;
      _vibrate = widget.todo.vibrate ?? false;
      _volume = widget.todo.volume.toDouble() ?? 5;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        contentPadding: EdgeInsets.all(36),
        title: Center(child: Text('Add new TODO')),
        children: <Widget>[
          Form(
              key: _formKey,
              child: Column(children: <Widget>[
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(labelText: 'What to do ...'),
                  validator: (value) =>
                      value.isEmpty ? 'TODO is required' : null,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CustomButton(
                      onPressed: () async {
                        final date = await showDatePicker(
                            context: context,
                            initialDate: _selected,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2030));
                        if (date != null) {
                          setState(() {
                            _selected = date;
                          });
                        }
                      },
                      text:
                          '${_selected.day} / ${_selected.month} / ${_selected.year}',
                      big: true),
                ),
                TextField(
                  controller: _noteController,
                  minLines: 1,
                  maxLines: 3,
                  decoration: InputDecoration(labelText: 'Notes'),
                ),
                ListTile(
                  onTap: () => setState(() {
                    _priority = Priority.low;
                  }),
                  contentPadding: EdgeInsets.all(0),
                  selected: Priority.low == _priority,
                  title: const Text('Low'),
                  trailing:
                      Icon(Icons.sentiment_satisfied, color: Colors.green),
                  leading: Radio(
                    value: Priority.low,
                    groupValue: _priority,
                    onChanged: (_) => null,
                  ),
                ),
                ListTile(
                  onTap: () => setState(() {
                    _priority = Priority.medium;
                  }),
                  contentPadding: EdgeInsets.all(0),
                  selected: Priority.medium == _priority,
                  title: const Text('Medium'),
                  trailing: Icon(
                    Icons.sentiment_neutral,
                    color: Colors.blue,
                  ),
                  leading: Radio(
                    value: Priority.medium,
                    groupValue: _priority,
                    onChanged: (_) => null,
                  ),
                ),
                ListTile(
                  onTap: () => setState(() {
                    _priority = Priority.high;
                  }),
                  contentPadding: EdgeInsets.all(0),
                  selected: Priority.high == _priority,
                  title: const Text('High'),
                  trailing: Icon(
                    Icons.sentiment_dissatisfied,
                    color: Colors.red,
                  ),
                  leading: Radio(
                    value: Priority.high,
                    groupValue: _priority,
                    onChanged: (_) => null,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text('Vibrate'),
                    Switch(
                      value: _vibrate,
                      onChanged: (bool value) => setState(() {
                        _vibrate = value;
                      }),
                    ),
                  ],
                ),
                Text('Volume'),
                Slider(
                  value: _volume,
                  max: 100,
                  onChanged: (double value) => setState(() {
                    _volume = value;
                  }),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            widget.save({
                              'title': _titleController.text,
                              'date': _selected.millisecondsSinceEpoch,
                              'notes': _noteController.text,
                              'volume': _volume.floor(),
                              'vibrate': _vibrate,
                              'priority': _priority
                            }, saveToLocal: true);
                            Navigator.pop(context);
                          }
                        },
                        text: 'Submit',
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CustomButton(
                        onPressed: () => Navigator.pop(context),
                        text: 'Close',
                      ),
                    ),
                  ],
                ),
              ]))
        ],
      );
}
