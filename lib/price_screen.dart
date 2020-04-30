import 'package:flutter/material.dart';
import 'coin_data.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'text_button.dart';

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  TextButton textButton = TextButton();
  String currency = currenciesList.last;
  String btcPrice = "";
  String ethPrice = "";
  String ltcPrice = "";

  Future<dynamic> getTheBitcoinData(String currencyCode) async {
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=$currencyCode';
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<dynamic> getTheETHData(String currencyCode) async {
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=$currencyCode';
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<dynamic> getTheLTCData(String currencyCode) async {
    String url =
        'https://min-api.cryptocompare.com/data/price?fsym=LTC&tsyms=$currencyCode';
    final response = await http.get(url);
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getBitcoinPrice(String currencyCode) async {
    var bData = await getTheBitcoinData(currencyCode);
    var eData = await getTheETHData(currencyCode);
    var lData = await getTheLTCData(currencyCode);
    Map<String, dynamic> newMap = {"BTC": bData, "ETH": eData, "LTC": lData};
    return newMap;
  }

  DropdownButton<String> androidPicker() {
    List<DropdownMenuItem<String>> newDDItem = [];
    for (String currenci in currenciesList) {
      newDDItem.add(DropdownMenuItem(
        child: Text('$currenci'),
        value: currenci,
      ));
    }

    return DropdownButton<String>(
      value: currency,
      items: newDDItem,
      onChanged: (value) async {
        Map<String, dynamic> getPrice = await getBitcoinPrice(value);
        double bPrice = getPrice["BTC"]["$value"];
        double ePrice = getPrice["ETH"]["$value"];
        double lPrice = getPrice["LTC"]["$value"];
        setState(() {
          currency = value;
          btcPrice = '$bPrice $value';
          ethPrice = '$ePrice $value';
          ltcPrice = '$lPrice $value';
        });
      },
    );
  }

  CupertinoPicker iosPicker() {
    List<Widget> newDDItem = [];
    for (String currenci in currenciesList) {
      newDDItem.add(Text(currenci));
    }
    return CupertinoPicker(
      itemExtent: 32.0,
      onSelectedItemChanged: (index) {
        print(index);
      },
      children: newDDItem,
      backgroundColor: Colors.lightBlue,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              textButton.buildButton(btcPrice, "BTC"),
              textButton.buildButton(ethPrice, "ETH"),
              textButton.buildButton(ltcPrice, "LTC"),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS ? iosPicker() : androidPicker(),
          ),
        ],
      ),
    );
  }
}
