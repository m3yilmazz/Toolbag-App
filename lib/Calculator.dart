import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:math_expressions/math_expressions.dart';
import 'AppSettings.dart';

/// Hesaplama islemi icin kullanilan fonksiyonlar icin
/// "math_expressions" isimli kütüphaneden yararlanilmistir.
/// Fonksiyonlarin kullanim ornekleri de yine kütüphanenin
/// kendi internet sayfasindan alinmistir.
/// https://pub.dev/packages/math_expressions

const String clearAllSymbol = "C",
    deleteSymbol = "DEL",
    openParenthesisSymbol = "(",
    closeParenthesisSymbol = ")",
    sinusSymbol = "sin",
    cosineSymbol = "cos",
    powerSymbol = "^",
    moduloSymbol = "%",
    doubleZeroSymbol = "00",
    addOperation = "+",
    subtractionOperation = "-",
    multiplicationOperation = "*",
    divisionOperation = "/",
    floatingPoint = ".",
    equationOperation = "=",
    numberZero = "0",
    numberOne = "1",
    numberTwo = "2",
    numberThree = "3",
    numberFour = "4",
    numberFive = "5",
    numberSix = "6",
    numberSeven = "7",
    numberEight = "8",
    numberNine = "9";

class Calculator extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalculatorState();
  }
}

class _CalculatorState extends State<Calculator> {
  String operationString = "0";
  String resultString = "0";
  bool _isDarkTheme;

  @override
  void initState(){
    operationString = clearString(operationString);
    resultString = clearString(resultString);
    _isDarkTheme = isDarkTheme;
  }

  String clearString(String input){
    if (input != null && input.length > 0) {
      input = input.substring(0, input.length - 1);
    }
    return input;
  }

  void setOperationString(String input){
    setState(() {
      if(input == addOperation || input == subtractionOperation || input == multiplicationOperation ||
          input == divisionOperation || input == sinusSymbol || input == cosineSymbol ||
          input == powerSymbol || input == moduloSymbol){
        if(resultString.length > 0) {
          operationString = resultString + input;
        } else {
          operationString += input;
        }
      } else {
        operationString += input;
      }
    });
  }

  void deleteLastCharacter(String input){
    if (input != null && input.length > 0) {
      input = input.substring(0, input.length - 1);
      setState(() {
        operationString = input;
      });
    }
  }

  void calculationOperation(String input){
    if(input != null){
      Parser parser = Parser();
      ContextModel contextModel = ContextModel();

      Expression expression = parser.parse(input);
      double result = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        resultString = result.toString();
      });
    }
  }

  FlatButton flatButtonCreator(String text) {
    switch(text){
      case clearAllSymbol: {
        return FlatButton(
          color: _isDarkTheme ? Colors.grey[800] : Colors.blue,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
          child: Text(text, style: TextStyle(fontSize: 20),),
          onPressed: () {
            setState(() {
              operationString = "0";
              operationString = clearString(operationString);
              resultString = "0";
              resultString = clearString(operationString);
            });
          },
        );
      }
      case deleteSymbol: {
        return FlatButton(
          color: _isDarkTheme ? Colors.grey[800] : Colors.blue,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
          child: Text(text, style: TextStyle(fontSize: 20),),
          onPressed: () => deleteLastCharacter(operationString),
        );
      }
      case equationOperation: {
        return FlatButton(
          color: _isDarkTheme ? Colors.grey[800] : Colors.blue,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
          child: Text(text, style: TextStyle(fontSize: 20),),
          onPressed: () => calculationOperation(operationString),
        );
      }
      case moduloSymbol: {
        return FlatButton(
          color: _isDarkTheme ? Colors.grey[800] : Colors.blue,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
          child: Text("mod", style: TextStyle(fontSize: 18),),
          onPressed: () => setOperationString(text),
        );
      }
      default: {
        return FlatButton(
          color: _isDarkTheme ? Colors.grey[800] : Colors.blue,
          textColor: Colors.white,
          shape: new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(50.0)),
          child: Text(text, style: TextStyle(fontSize: 20),),
          onPressed: () => setOperationString(text),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _isDarkTheme ? Colors.black : Colors.white,
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
                Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.popUntil(context, ModalRoute.withName("/")
            )
        ),
        title: Text("Calculator"),
        backgroundColor: _isDarkTheme ? Colors.black : Colors.blue,
      ),
      body: Column(
        children: <Widget>[
          Container(
            height: 40,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                operationString,
                style: TextStyle(fontSize: 20, color: _isDarkTheme ? Colors.white : Colors.black,),
              ),
            ),
          ),
          Container(
            height: 60,
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                resultString,
                style: TextStyle(fontSize: 30, color: _isDarkTheme ? Colors.white : Colors.black,),
              ),
            ),
          ),
          Flexible(
            child: GridView.count(
              primary: false,
              padding: EdgeInsets.all(10),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              crossAxisCount: 5,
              childAspectRatio: 1,
              children: <Widget>[
                flatButtonCreator(clearAllSymbol),
                flatButtonCreator(deleteSymbol),
                flatButtonCreator(openParenthesisSymbol),
                flatButtonCreator(closeParenthesisSymbol),
                flatButtonCreator(doubleZeroSymbol),
                flatButtonCreator(numberSeven),
                flatButtonCreator(numberEight),
                flatButtonCreator(numberNine),
                flatButtonCreator(addOperation),
                flatButtonCreator(sinusSymbol),
                flatButtonCreator(numberFour),
                flatButtonCreator(numberFive),
                flatButtonCreator(numberSix),
                flatButtonCreator(subtractionOperation),
                flatButtonCreator(cosineSymbol),
                flatButtonCreator(numberOne),
                flatButtonCreator(numberTwo),
                flatButtonCreator(numberThree),
                flatButtonCreator(multiplicationOperation),
                flatButtonCreator(powerSymbol),
                flatButtonCreator(floatingPoint),
                flatButtonCreator(numberZero),
                flatButtonCreator(equationOperation),
                flatButtonCreator(divisionOperation),
                flatButtonCreator(moduloSymbol),
              ],
            ),
          ),
        ],
      ),
    );
  }
}