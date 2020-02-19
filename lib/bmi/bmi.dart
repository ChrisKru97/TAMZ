import 'package:flutter/material.dart';
import 'package:tamz/bmi/bmi_results.dart' hide State;
import 'package:tamz/custom_button.dart';

class Bmi extends StatefulWidget {
  @override
  _BmiState createState() => _BmiState();
}

class _BmiState extends State<Bmi> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _ageController = TextEditingController();
  Sex _sex = Sex.male;
  double _height = 175;
  double _weight = 80;

  @override
  Widget build(BuildContext context) => Scaffold(
      resizeToAvoidBottomPadding: true,
      appBar: AppBar(title: Text('BMI')),
      body: Center(
          child: Padding(
        padding: const EdgeInsets.all(36).copyWith(bottom: 0),
        child: Form(
            key: _formKey,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(labelText: 'Username'),
                    validator: (value) =>
                        value.isEmpty ? 'Username is required' : null,
                  ),
                  TextFormField(
                    controller: _ageController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: 'Age'),
                    validator: (value) =>
                        value.isEmpty ? 'Age is required' : null,
                  ),
                  ListTile(
                    onTap: () => setState(() {
                      _sex = Sex.male;
                    }),
                    contentPadding: EdgeInsets.all(0),
                    selected: Sex.male == _sex,
                    title: const Text('Male'),
                    trailing: Icon(Icons.people, color: Colors.blue),
                    leading: Radio(
                      value: Sex.male,
                      groupValue: _sex,
                      onChanged: (_) => null,
                    ),
                  ),
                  ListTile(
                    onTap: () => setState(() {
                      _sex = Sex.female;
                    }),
                    contentPadding: EdgeInsets.all(0),
                    selected: Sex.female == _sex,
                    title: const Text('Female'),
                    trailing: Icon(Icons.people, color: Colors.red),
                    leading: Radio(
                      value: Sex.female,
                      groupValue: _sex,
                      onChanged: (_) => null,
                    ),
                  ),
                  Text('Height: ${_height.floor()}cm'),
                  Slider(
                    min: 150,
                    max: 220,
                    divisions: 70,
                    label: '${_height.floor()}cm',
                    onChanged: (double value) => setState(() {
                      _height = value;
                    }),
                    value: _height,
                  ),
                  Text('Weight: ${_weight.floor()}kg'),
                  Slider(
                    min: 50,
                    max: 150,
                    divisions: 100,
                    label: '${_weight.floor()}kg',
                    onChanged: (double value) => setState(() {
                      _weight = value;
                    }),
                    value: _weight,
                  ),
                  CustomButton(
                      onPressed: () => _formKey.currentState.validate()
                          ? Navigator.of(context).push(MaterialPageRoute<void>(
                              builder: (BuildContext context) => BmiResults(
                                    username: _usernameController.text,
                                    age: int.parse(_ageController.text),
                                    height: _height,
                                    weight: _weight,
                                    sex: _sex,
                                  )))
                          : null,
                      text: 'Calculate'),
                ])),
      )));

  @override
  void dispose() {
    _usernameController.dispose();
    _ageController.dispose();
    super.dispose();
  }
}
