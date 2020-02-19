import 'package:flutter/material.dart';

enum Sex { male, female }

extension SexExtension on Sex {
  String get name {
    switch (this) {
      case Sex.male:
        return 'Male';
      case Sex.female:
        return 'Female';
      default:
        return null;
    }
  }
}

class BmiResults extends StatelessWidget {
  BmiResults({this.username, this.height, this.weight, this.age, this.sex});

  final String username;
  final double height;
  final double weight;
  final int age;
  final Sex sex;

  @override
  Widget build(BuildContext context) {
    final bmi = (weight / (height * height)) * 10000;
    final state =
        bmi <= 18 ? 'unhealthy thin' : bmi >= 25 ? 'obese' : 'healthy';
    final color =
        bmi <= 18 ? Colors.orange : bmi >= 25 ? Colors.red : Colors.green;
    return Scaffold(
        appBar: AppBar(title: Text('BMI results')),
        body: Center(
            child: Padding(
                padding: const EdgeInsets.all(36),
                child: Card(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Text('$username you are $state',
                        style: TextStyle(
                          color: color,
                        )),
                    Divider(),
                    Text('BMI: ${bmi.toStringAsPrecision(4)}'),
                    Divider(),
                    Text('Gender: ${sex.name}'),
                    Divider(),
                    Text('Height: ${height.floor()}cm'),
                    Divider(),
                    Text('Weight: ${weight.floor()}kg'),
                    Divider(),
                    Text('Age: $age'),
                  ],
                )))));
  }
}
