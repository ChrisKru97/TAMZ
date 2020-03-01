import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:sse_client/sse_client.dart';

import '../custom_button.dart';

class Currency {
  Currency(this.country, this.label, this.unit, this.code, this.rate);

  String country;
  String label;
  int unit;
  String code;
  double rate;

  factory Currency.fromJson(Map<String, dynamic> json) => Currency(
      json['country_label'],
      json['curr_label'],
      int.parse(json['unit']),
      json['code'],
      double.parse(json['rate']));
}

class ConverterState {
  int firstCurrencyIndex = 0;
  int secondCurrencyIndex = 1;
  double firstCurrencyValue = 0;
}

class Converter extends StatefulWidget {
  @override
  _ConverterState createState() => _ConverterState();
}

class _ConverterState extends State<Converter> {
  final TextEditingController _firstCurrencyText = TextEditingController();
  final TextEditingController _secondCurrencyText = TextEditingController();
  StreamController<ConverterState> _streamController =
      StreamController<ConverterState>();
  StreamController<String> _searchController = StreamController<String>();
  DateTime _date = DateTime.now();
  bool _english = true;

  Future<List<Currency>> loadData() async {
    final client = SseClient.connect(
        Uri.https('homel.vsb.cz', '/~mor03/TAMZ/cnb_json.php', <String, String>{
      'date': _date.toString().split(' ')[0],
      'lang': _english ? 'en' : 'cs',
      'sse': 'y'
    }));
    final data = await client.stream.first;
    if ((data?.length ?? 0) > 0) {
      return (jsonDecode(data)['data'] as List<dynamic>)
          .map((dynamic currency) => Currency.fromJson(currency))
          .toList()
            ..insert(
                0,
                _english
                    ? Currency('Czech', 'crown', 1, 'CZK', 1)
                    : Currency('Česko', 'koruna', 1, 'CZK', 1));
    }
    return null;
  }

  void openSelector(
      BuildContext context, List<Currency> currencies, ConverterState old,
      {bool first = false}) {
    Scaffold.of(context).showBottomSheet((context) => Card(
          elevation: 8,
          margin: EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height / 2),
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24)
                      .copyWith(top: 12),
                  child: TextField(
                    textAlign: TextAlign.center,
                    onChanged: (String value) {
                      _searchController.sink.add(value);
                      final index = currencies.indexWhere((element) => element
                          .country
                          .toLowerCase()
                          .startsWith(value.toLowerCase()));
                      if (index >= 0) {
                        if (first) {
                          old.firstCurrencyIndex = index;
                        } else {
                          old.secondCurrencyIndex = index;
                        }
                        _streamController.sink.add(old);
                      }
                    },
                    autofocus: true,
                    decoration: InputDecoration(
                        labelText: 'Search', border: OutlineInputBorder()),
                  ),
                ),
                Expanded(
                  child: StreamBuilder<String>(
                      stream: _searchController.stream,
                      builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) =>
                          CupertinoPicker(
                            itemExtent: 28,
                            scrollController: FixedExtentScrollController(
                                initialItem: first
                                    ? old.firstCurrencyIndex
                                    : old.secondCurrencyIndex),
                            onSelectedItemChanged: (int value) {
                              if (first) {
                                old.firstCurrencyIndex = value;
                              } else {
                                old.secondCurrencyIndex = value;
                              }
                              _streamController.sink.add(old);
                            },
                            children: (snapshot.data != null
                                    ? currencies.where((currency) => currency
                                        .country
                                        .toLowerCase()
                                        .startsWith(
                                            snapshot.data.toLowerCase()))
                                    : currencies)
                                .map((currency) => Text(currency.country))
                                .toList(),
                            looping: true,
                          )),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 32),
                  child: CustomButton(
                    text: 'Select',
                    onPressed: () {
                      _searchController.close();
                      _searchController = StreamController<String>();
                      Navigator.pop(context);
                    },
                  ),
                )
              ],
            ),
          ),
        ));
  }

  String convert(double value, Currency first, Currency second) =>
      ((value * first.rate / first.unit) * second.unit / second.rate)
          .toString();

  Future<void> Function(int) optionSelected(BuildContext context) =>
      (int index) async {
        switch (index) {
          case 0:
            final date = await showDatePicker(
                context: context,
                initialDate: _date,
                firstDate: DateTime(2019, 1, 1),
                lastDate: DateTime.now());
            if (date != null) {
              setState(() {
                _date = date;
              });
            }
            break;
          case 1:
            setState(() {
              _english = !_english;
            });
        }
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          title: Text('Currency exchange'),
          actions: <Widget>[
            PopupMenuButton(
                onSelected: optionSelected(context),
                itemBuilder: (BuildContext context) => [
                      PopupMenuItem(value: 0, child: Text('Select date')),
                      PopupMenuItem(
                          value: 1,
                          child: Text(
                              'Switch to ${_english ? 'czech' : 'english'}'))
                    ])
          ],
        ),
        body: Center(
            child: FutureBuilder<List<Currency>>(
          future: loadData(),
          builder: (BuildContext context,
                  AsyncSnapshot<List<Currency>> currenciesSnapshot) =>
              currenciesSnapshot.hasData
                  ? StreamBuilder<ConverterState>(
                      stream: _streamController.stream,
                      initialData: ConverterState(),
                      builder: (BuildContext context,
                          AsyncSnapshot<ConverterState> snapshot) {
                        final firstCurrency = currenciesSnapshot
                            .data[snapshot.data?.firstCurrencyIndex];
                        final secondCurrency = currenciesSnapshot
                            .data[snapshot.data?.secondCurrencyIndex];
                        _secondCurrencyText.text = convert(
                            snapshot.data.firstCurrencyValue,
                            firstCurrency,
                            secondCurrency);
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: TextField(
                                      controller: _firstCurrencyText,
                                      keyboardType: TextInputType.number,
                                      onChanged: (String value) {
                                        try {
                                          final doubleValue = value.length > 0
                                              ? double.parse(value)
                                              : 0;
                                          final old = snapshot.data;
                                          old.firstCurrencyValue = doubleValue;
                                          _streamController.sink.add(old);
                                        } on Exception catch (e) {
                                          print(e.toString());
                                        }
                                      },
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelText:
                                              '${firstCurrency.label} (${firstCurrency.country})'),
                                    )),
                                Builder(
                                    builder: (BuildContext context) =>
                                        CustomButton(
                                          text: firstCurrency.code,
                                          onPressed: () => openSelector(
                                              context,
                                              currenciesSnapshot.data,
                                              snapshot.data,
                                              first: true),
                                        ))
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.swap_vert),
                              iconSize: MediaQuery.of(context).size.width / 6,
                              color: Colors.green[700],
                              onPressed: () {
                                final temp = snapshot.data?.secondCurrencyIndex;
                                final currencyState = snapshot.data;
                                currencyState.secondCurrencyIndex =
                                    currencyState.firstCurrencyIndex;
                                currencyState.firstCurrencyIndex = temp;
                                _streamController.sink.add(currencyState);
                              },
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Container(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                    child: TextField(
                                      controller: _secondCurrencyText,
                                      keyboardType: TextInputType.number,
                                      readOnly: true,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                          labelText:
                                              '${secondCurrency.label} (${secondCurrency.country})'),
                                    )),
                                Builder(
                                    builder: (BuildContext context) =>
                                        CustomButton(
                                          text: secondCurrency.code,
                                          onPressed: () => openSelector(
                                              context,
                                              currenciesSnapshot.data,
                                              snapshot.data),
                                        ))
                              ],
                            ),
                          ],
                        );
                      })
                  : CircularProgressIndicator(),
        )),
      );

  @override
  void dispose() {
    _streamController.close();
    _searchController.close();
    super.dispose();
  }
}
