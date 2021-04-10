import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Calculator',
      theme: ThemeData(
        primarySwatch: Colors.green,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String textDisplay = "", result = "";
  var pre = "", f = 0, g = 0;
  var values = new List();
  var ops = new List();

  int precedence(String op) {
    if (op == "+" || op == "-") {
      return 1;
    }
    if (op == "x" || op == "/") {
      return 2;
    }
    return 0;
  }

  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return double.tryParse(s) != null;
  }

  void btnClicked(String btnnum) {
    if (btnnum == "C") {
      textDisplay = "";
      result = "";
      pre = "";
      g = 0;
      values.clear();
      ops.clear();
    } else if (btnnum == "=") {
      String tokens = result;
      int i, flag = 0;

      for (i = 0; i < tokens.length; i++) {
        if (flag == 1 || g == 2) {
          break;
        }
        if (tokens[i] == " ") {
          continue;
        } else if (tokens == "(") {
          ops.add(tokens[i]);
        } else if (isNumeric(tokens[i])) {
          var val = 0;
          g = 0;
          while (i < tokens.length && isNumeric(tokens[i])) {
            val = (val * 10) + int.parse(tokens[i]);
            i++;
          }
          values.add(val);
          i--;
        } else if (tokens[i] == ")") {
          while (ops.isNotEmpty && ops.last != "(") {
            var val2 = values.last;
            values.removeLast();

            var val1 = values.last;
            values.removeLast();

            String op = ops.last;
            ops.removeLast();

            var res;
            switch (op) {
              case "+":
                {
                  res = val1 + val2;
                  break;
                }
              case "-":
                {
                  res = val1 - val2;
                  break;
                }
              case "x":
                {
                  res = val1 * val2;
                  break;
                }
              case "/":
                {
                  if (val2 == 0) {
                    flag = 1;
                    break;
                  } else if (val1 % val2 == 0) {
                    res = val1 ~/ val2;
                    break;
                  } else {
                    res = val1 / val2;
                    break;
                  }
                }
            }
            values.add(res);
            if (flag == 1 || g == 2) {
              break;
            }
          }
          if (ops.isNotEmpty) {
            ops.removeLast();
          }
        } else {
          if (flag == 1 || g == 2) {
            break;
          }
          while (
              ops.isNotEmpty && precedence(ops.last) >= precedence(tokens[i])) {
            var val2 = values.last;
            values.removeLast();

            var val1 = values.last;
            values.removeLast();

            String op = ops.last;
            ops.removeLast();

            var res;
            switch (op) {
              case "+":
                {
                  res = val1 + val2;
                  break;
                }
              case "-":
                {
                  res = val1 - val2;
                  break;
                }
              case "x":
                {
                  res = val1 * val2;
                  break;
                }
              case "/":
                {
                  if (val2 == 0) {
                    flag = 1;
                    break;
                  } else if (val1 % val2 == 0) {
                    res = val1 ~/ val2;
                    break;
                  } else {
                    res = val1 / val2;
                    break;
                  }
                }
            }
            if (flag == 1 || g == 2) {
              break;
            }
            values.add(res);
          }
          g += 1;
          if (g == 2) {
            break;
          }
          ops.add(tokens[i]);
        }
      }

      while (ops.isNotEmpty) {
        if (flag == 1 || g == 2) {
          break;
        }
        var val2 = values.last;
        values.removeLast();

        var val1 = values.last;
        values.removeLast();

        String op = ops.last;
        ops.removeLast();

        var res;
        switch (op) {
          case "+":
            {
              res = val1 + val2;
              break;
            }
          case "-":
            {
              res = val1 - val2;
              break;
            }
          case "x":
            {
              res = val1 * val2;
              break;
            }
          case "/":
            {
              if (val2 == 0) {
                flag = 1;
                break;
              } else if (val1 % val2 == 0) {
                res = val1 ~/ val2;
                break;
              } else {
                res = val1 / val2;
                break;
              }
            }
        }
        values.add(res);
        if (flag == 1 || g == 2) {
          break;
        }
      }
      if (flag == 1 || g == 2) {
        if (g == 2) {
          result = "Wrong Expression";
        } else {
          result = "Cannot divide by zero";
        }
        pre = "";
        f = 1;
        values.clear();
        ops.clear();
        flag = 0;
        g = 0;
      } else if (values.last == (values.last).toInt()) {
        result = (values.last).toString();
        pre = result;
        f = 1;
      } else {
        result = (values.last).toStringAsFixed(2);
        pre = (values.last).toStringAsFixed(0);
        f = 1;
      }
    } else {
      result = result + btnnum;
    }

    setState(() {
      textDisplay = result;
      if (f == 1) {
        f = 0;
        result = pre;
      }
    });
  }

  Widget numbutton(String btnnum) {
    return Expanded(
      child: OutlineButton(
        padding: EdgeInsets.all(25.0),
        onPressed: () => btnClicked(btnnum),
        child: Text(
          "$btnnum",
          style: TextStyle(fontSize: 25.0),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            "Calculator",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(10.0),
                alignment: Alignment.bottomRight,
                child: Text(
                  "$textDisplay",
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                numbutton("9"),
                numbutton("8"),
                numbutton("7"),
                numbutton("+"),
              ],
            ),
            Row(
              children: <Widget>[
                numbutton("6"),
                numbutton("5"),
                numbutton("4"),
                numbutton("-"),
              ],
            ),
            Row(
              children: <Widget>[
                numbutton("3"),
                numbutton("2"),
                numbutton("1"),
                numbutton("x"),
              ],
            ),
            Row(
              children: <Widget>[
                numbutton("C"),
                numbutton("0"),
                numbutton("="),
                numbutton("/"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
