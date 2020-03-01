import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tamz/todo/add_todo_dialog.dart';

class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  final List<Todo> data = <Todo>[];
  SharedPreferences _preferences;

  void appendToList(dynamic entry, {bool saveToLocal = false}) {
    data.add(Todo(
        title: entry['title'].toString(),
        date:
            entry['date'] is String ? int.parse(entry['date']) : entry['date'],
        notes: entry['notes'],
        priority: entry['priority'] is int
            ? Priority.values.elementAt(entry['priority'])
            : entry['priority'],
        vibrate: entry['vibrate'],
        volume: entry['volume']));
    if (saveToLocal) {
      _preferences.setString('todo', jsonEncode(data));
    }
    setState(() {});
  }

  void Function(dynamic entry, {bool saveToLocal}) editInList(int index) =>
      (dynamic entry, {bool saveToLocal}) {
        data[index] = Todo(
            title: entry['title'].toString(),
            date: entry['date'] is String
                ? int.parse(entry['date'])
                : entry['date'],
            notes: entry['notes'],
            priority: entry['priority'],
            vibrate: entry['vibrate'],
            volume: entry['volume']);
        _preferences.setString('todo', jsonEncode(data));
        setState(() {});
      };

  void removeFromList(int index) {
    data.removeAt(index);
    _preferences.setString('todo', jsonEncode(data));
    setState(() {});
  }

  void optionSelected(int index) {
    switch (index) {
      case 0:
        data.removeRange(0, data.length);
        _preferences.remove('todo');
        setState(() {});
    }
  }

  @override
  void initState() {
    SharedPreferences.getInstance().then((SharedPreferences prefs) {
      setState(() {
        _preferences = prefs;
      });
      final dataString = _preferences.getString('todo');
      if (dataString?.isNotEmpty ?? false) {
        (jsonDecode(dataString) as List<dynamic>).forEach(appendToList);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => showDialog(
              context: context,
              child: AddTodoDialog(
                save: appendToList,
              )),
        ),
        appBar: AppBar(
          title: Text('TODO list'),
          actions: <Widget>[
            PopupMenuButton(
              onSelected: optionSelected,
              itemBuilder: (BuildContext context) =>
                  [PopupMenuItem(value: 0, child: Text('Delete all'))],
            )
          ],
        ),
        body: Center(
            child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final todo = data.elementAt(index);
                  return InkWell(
                    onLongPress: () => showDialog(
                        context: context,
                        child: AddTodoDialog(
                          todo: todo,
                          save: editInList(index),
                        )),
                    child: Dismissible(
                      direction: DismissDirection.startToEnd,
                      background: Container(
                          color: Colors.red,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 24),
                              child: Icon(
                                Icons.delete_forever,
                                color: Colors.white,
                              ),
                            ),
                          )),
                      key: Key(todo.title),
                      onDismissed: (_) => removeFromList(index),
                      child: ExpansionTile(
                        title: Text(
                            '${todo.title}: ${DateTime.fromMillisecondsSinceEpoch(todo.date).toString().split(' ')[0]}'),
                        children: <Widget>[
                          Text('Note: ${todo.notes}'),
                          Text('Priority: ${todo.priority.name}'),
                          Text(
                              'Vibration: ${todo.vibrate ? 'enabled' : 'disabled'}'),
                          Text('Volume: ${todo.volume}')
                        ],
                      ),
                    ),
                  );
                })),
      );
}
