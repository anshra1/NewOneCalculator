import 'package:flutter/material.dart';
import 'calc_button.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Testing());
}

class Testing extends StatefulWidget {
  const Testing({Key? key}) : super(key: key);

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final List<String> buttonsList = [
    'AC', // 0
    '+/-', // 1
    '%', // 2
    '\u00f7', // 3
    '7', //4
    '8', //5
    '9', //6
    'x', //7
    '4', //8
    '5', //9
    '6', //10
    '-', //11
    '1', //12
    '2', //13
    '3', //14
    '+', //15
    'CE', //16
    '0', //17
    '.', //18
    '=', //19
  ];

  String userInput = '0';
  String result = '0';

  String input1 = '';
  String opr = '';

  isOperator(String char) {
    if (char == '+' || char == '-' || char == 'x' || char == '\u00f7') {
      return true;
    } else {
      return false;
    }
  }

  isDigit(String char) {
    if (char == 'AC' ||
        char == '+/-' ||
        char == '%' ||
        char == 'CE' ||
        char == '=' ||
        char == '.' ||
        isOperator(char)) {
      return false;
    } else {
      return true;
    }
  }

  void updateInput(String char) {
    if (isDigit(char)) {
      if (userInput == '') {
        setState(() {
          userInput += char;
        });
      } else {
        if (userInput[0] == '0') {
          if (userInput.length > 1) {
            if (userInput[1] == '.') {
              userInput += char;
            }
          } else {
            setState(() {
              userInput = char;
            });
          }
        } else if (isOperator(userInput[0])) {
          setState(() {
            opr = userInput[0];
            userInput = char;
          });
        }else if(userInput[0] == '%'){
          setState((){
            userInput = char;
          });
        }

        else {
          setState(() {
            userInput += char;
            print('Second else $userInput');
          });
        }
      }
    }

    if (isOperator(char)) {
      if (!isOperator(userInput[0])) {
        input1 = userInput;
        setState(() {
          print('is Operator $userInput');
          userInput = char;
          print('is Operator $userInput');
        });
      } else if (isOperator(userInput[0]) && userInput.length > 1) {
        input1 = userInput;
        setState(() {
          userInput = char;
        });
      } else {
        setState(() {
          userInput = char;
        });
      }
    }

    if (char == '%') {
      if (userInput.isNotEmpty) {

        double v1 = double.parse(userInput)/100;
        input1 = v1.toString();
        opr = 'x';

        setState((){
          userInput = '%';
        });

      }
    }

    if (char == "+/-") {
      if (userInput[0] == "-") {
        setState(() {
          userInput = userInput.substring(1, userInput.length);
        });
      } else {
        if (userInput[0] != "-") {
          setState(() {
            userInput = "-$userInput";
          });
        }
      }
    }

    if (char == 'AC') {
      setState(() {
        userInput = '';
      });
    }

    if (char == 'CE') {
      setState(() {
        userInput = userInput.substring(0, userInput.length - 1);
      });
    }

    if (char == '.' && !userInput.contains('.')) {
      setState(() {
        userInput += char;
      });
    } else {
      if (userInput.contains('.')) {
        setState(() {
          //result = 'You already have . in userinput';
        });
      }
    }

    if (char == '=') {
      calculate();
    }
  }

  calculate() {
    try {
      String r1 = input1;
      String op = opr;
      String r2 = userInput;

      String resultPhase = r1 + op + r2;
      print('r1 $r1  ............... opr $op  r2 $r2');

      resultPhase = resultPhase.replaceAll('x', '*');
      resultPhase = resultPhase.replaceAll('\u00f7', '/');

      Parser parser = Parser();
      Expression expression = parser.parse(resultPhase);
      ContextModel contextModel = ContextModel();
      double answer = expression.evaluate(EvaluationType.REAL, contextModel);
      setState(() {
        userInput = answer.toString();
        input1 = '';
      });
    } on Exception {
      print("Error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.lightBlueAccent,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  color: Colors.white,
                  child: (Text(
                    userInput,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  )),
                ),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.only(top: 30, right: 20),
                  color: Colors.white,
                  child: (Text(
                    result,
                    style: const TextStyle(
                        fontSize: 30, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.right,
                  )),
                ),
              ),
              Expanded(
                  flex: 4,
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4),
                    itemBuilder: (BuildContext context, int index) {
                      return Button(
                          onTap: () {
                            updateInput(buttonsList[index]);
                          },
                          text: buttonsList[index],
                          buttonColor: Colors.white);
                    },
                    itemCount: 20,
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
