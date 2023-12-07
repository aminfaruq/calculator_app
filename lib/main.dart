import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String screenText = '0';
  String firstOperand = '';
  String secondOperand = '';
  String operator = '';
  bool isOperatorPressed = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          buildExpanded(context),
          GridView.count(
            padding: const EdgeInsets.all(0),
            shrinkWrap: true,
            crossAxisCount: 4,
            physics: const NeverScrollableScrollPhysics(),
            children: buildCalculatorButtons(context),
          ),
        ],
      ),
    );
  }

  List<Widget> buildCalculatorButtons(BuildContext context) {
    final List<String> buttonTexts = [
      'C',
      '+/-',
      '%',
      'Backspace',
      '7',
      '8',
      '9',
      '/',
      '4',
      '5',
      '6',
      'x',
      '1',
      '2',
      '3',
      '-',
      '0',
      '.',
      '=',
      '+'
    ];

    return buttonTexts.map((text) {
      if (text == 'Backspace') {
        return buildCalculatorButton(context, text, () {
          setState(() {
            if (screenText == '0' ||
                screenText == '' ||
                screenText.length == 1) {
              screenText = '0';
            } else {
              screenText = screenText.substring(0, screenText.length - 1);
            }
          });
        }, icon: Icons.backspace);
      } else if (text == '+' || text == '-' || text == 'x' || text == '/') {
        return buildCalculatorButton(context, text, () {
          handleOperatorPressed(text);
        });
      } else if (text == '=') {
        return buildCalculatorButton(context, text, () {
          handleEqualsPressed();
        });
      } else {
        return onNumberPressed(context, text);
      }
    }).toList();
  }

  Widget onNumberPressed(BuildContext context, String text) {
    return buildCalculatorButton(context, text, () {
      handleNumberPressed(text);
    });
  }

  Widget buildCalculatorButton(
      BuildContext context, String text, VoidCallback onTap,
      {IconData? icon}) {
    return CalculatorButton(
      backgroundColor:
          icon != null ? Theme.of(context).primaryColorDark : Colors.white,
      foregroundColor: icon != null
          ? Theme.of(context).primaryColorLight
          : Theme.of(context).primaryColorDark,
      text: text,
      icon: icon,
      onTap: onTap,
    );
  }

  void pressNumber(int number) {
    setState(() {
      if (screenText == '0' || isOperatorPressed) {
        screenText = '$number';
        isOperatorPressed = false;
      } else {
        screenText = '$screenText$number';
      }
    });
  }

  void handleNumberPressed(String text) {
    if (text == '.' && screenText.contains('.')) {
      return; // Avoid multiple decimal points
    }

    if (isOperatorPressed) {
      screenText = text;
      isOperatorPressed = false;
    } else {
      screenText = (screenText == '0') ? text : '$screenText$text';
    }
  }

  void handleOperatorPressed(String newOperator) {
    if (firstOperand.isEmpty) {
      firstOperand = screenText;
    } else {
      secondOperand = screenText;
      performCalculation();
      firstOperand = screenText;
      secondOperand = '';
    }
    operator = newOperator;
    isOperatorPressed = true;
  }

  void handleEqualsPressed() {
    if (firstOperand.isNotEmpty && secondOperand.isEmpty) {
      secondOperand = screenText;
    }
    performCalculation();
    operator = '';
    isOperatorPressed = true;
  }

  void performCalculation() {
    if (operator.isEmpty || firstOperand.isEmpty || secondOperand.isEmpty) {
      return;
    }

    double num1 = double.parse(firstOperand);
    double num2 = double.parse(secondOperand);
    double result = 0;

    switch (operator) {
      case '+':
        result = num1 + num2;
        break;
      case '-':
        result = num1 - num2;
        break;
      case 'x':
        result = num1 * num2;
        break;
      case '/':
        if (num2 != 0) {
          result = num1 / num2;
        } else {
          // Handle division by zero
          result = 0;
        }
        break;
    }

    setState(() {
      screenText = result.toString();
    });
  }

  Expanded buildExpanded(BuildContext context) {
    return Expanded(
      child: Container(
        color: Theme.of(context).primaryColor,
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              screenText,
              style: Theme.of(context)
                  .textTheme
                  .headline3!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class CalculatorButton extends StatelessWidget {
  final Color backgroundColor;
  final Color foregroundColor;
  final String text;
  final IconData? icon;
  final VoidCallback onTap;

  const CalculatorButton({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.onTap,
    this.icon,
  }) : super(key: key);

  const CalculatorButton.icon({
    Key? key,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.text,
    required this.onTap,
    required this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        color: backgroundColor,
        child: Center(
          child: icon == null
              ? Text(
                  text,
                  style: Theme.of(context)
                      .textTheme
                      .headline4!
                      .copyWith(color: foregroundColor),
                )
              : Icon(
                  icon,
                  color: foregroundColor,
                ),
        ),
      ),
    );
  }
}
