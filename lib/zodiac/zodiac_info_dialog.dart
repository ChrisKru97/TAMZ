import 'package:flutter/material.dart';
import 'package:tamz/custom_button.dart';
import 'package:url_launcher/url_launcher.dart';

class Symbol {
  Symbol({this.name, this.info, this.start, this.end, this.id});

  String name;
  String info;
  DateTime start;
  DateTime end;
  String id;
}

class ZodiacInfoDialog extends StatelessWidget {
  ZodiacInfoDialog({this.symbol});

  final Symbol symbol;

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
