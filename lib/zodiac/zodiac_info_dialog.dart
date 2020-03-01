import 'package:flutter/material.dart';
import 'package:tamz/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Symbol {
  Symbol(this.name, this.info, this.startDay, this.startMonth, this.endDay,
      this.endMonth, this.id);
  factory Symbol.from(
          {String name,
          String info,
          DateTime start,
          DateTime end,
          String id}) =>
      Symbol(name, info, start.day, start.month, end.day, end.month, id);

  String name;
  String info;
  int startMonth;
  int startDay;
  int endMonth;
  int endDay;
  String id;
}

class ZodiacInfoDialog extends StatelessWidget {
  ZodiacInfoDialog({this.symbol, this.date});

  final Symbol symbol;
  final DateTime date;

  int getLifeNumber(String number) {
    final result = number
        .split('')
        .map((element) => int.parse(element))
        .reduce((int total, int current) => total + current);
    if (result < 10 || result == 22 || result == 11) {
      return result;
    } else {
      return getLifeNumber(result.toString());
    }
  }

  @override
  Widget build(BuildContext context) => SimpleDialog(
        contentPadding: EdgeInsets.all(36),
        title: Center(child: Text(symbol.name)),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(symbol.info),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
                'Tvé životní číslo je ${getLifeNumber(date.toString().split(' ')[0].replaceAll('-', '').replaceAll('0', ''))}'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
              text: 'Zavřít',
              onPressed: () => Navigator.pop(context),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomButton(
                text: 'Více info',
                onPressed: () async =>
                    await canLaunch('https://www.horoskopy.cz/${symbol.id}')
                        ? launch('https://www.horoskopy.cz/${symbol.id}')
                        : null),
          )
        ],
      );
}
