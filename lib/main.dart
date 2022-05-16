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
  String result = '';
  String input1 = '';
  String opr = '';
  String localUserinput = '0';

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
    if (char == 'AC') {
      setState(() {
        userInput = '0';
        input1 = '';
        localUserinput = '0';
        result = '';
      });
    }

    if (char == 'CE') {
      if (userInput.length == 1) {
        setState(() {
          userInput = '0';
          result = '';
          input1 = '';
        });
      } else {
        setState(() {
          userInput = userInput.substring(0, userInput.length - 1);
          calculate();
        });
      }
    }

    if (isDigit(char)) {
      if (userInput == '' || localUserinput == '') {
        localUserinput += char;
        setState(() {
          userInput += char;
          calculate();
        });
      } else if (localUserinput[0] == '0') {
        if (localUserinput.length > 1) {
          if (localUserinput[1] == '.') {
            setState(() {
              localUserinput += char;
              userInput += char;
              calculate();
            });
          }
        } else {
          localUserinput = char;
          setState(() {
            userInput = char;
          });
        }
      } else {
        localUserinput += char;
        // userInput+=char;
        setState(() {
          print('isDigit localUserInput $localUserinput');

          userInput = '$input1$localUserinput';
          print('isDigit userInput $userInput');
          calculate();
        });
      }
    }

    if (char == '=') {
      setState(() {
        userInput = result;
        result = '';
      });
    }

    if (isOperator(char)) {
      if (!isOperator(userInput[userInput.length - 1])) {
        setState(() {
          print('! isOperator local userinput $localUserinput ..');
          userInput += char;
          input1 = userInput;
          localUserinput = '';

          print('! isOperator $input1');
          print('! isOperator userinput $userInput');
          print('! isOperator local userinput $localUserinput ..');
        });
      } else {
        setState(() {
          userInput = userInput.substring(0, userInput.length - 1);
          userInput += char;
          input1 = userInput;
          localUserinput = '';

          print('!! isOperator $input1');
          print('!! isOperator userinput $userInput');
          print('!! isOperator local userinput $localUserinput ..');
        });
      }
    }

    if (char == '.') {
      if (localUserinput.contains('.')) {
        setState(() {
          localUserinput =
              localUserinput.substring(0, localUserinput.length - 1);
          userInput = localUserinput;
        });
      } else {
        setState(() {
          localUserinput += char;
          userInput = '$input1$localUserinput';
          print('... $localUserinput');
        });
      }
    }
  }

  calculate() {
    userInput = userInput.replaceAll('x', '*');
    userInput = userInput.replaceAll("\u00f7", '/');

    Parser parser = Parser();
    Expression expression = parser.parse(userInput);
    ContextModel contextModel = ContextModel();
    double answer = expression.evaluate(EvaluationType.REAL, contextModel);
    userInput = userInput.replaceAll('/', '\u00f7');
    userInput = userInput.replaceAll('*', 'x');
    String ans = answer.toString();

    print('Calculate $ans');

    if (userInput.contains('x') ||
        userInput.contains('+') ||
        userInput.contains('\u00f7') ||
        userInput.contains('-')) {
      setState(() {
        result = ans;
      });
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
