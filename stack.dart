import 'dart:io';

int precedence(String op) {
  if (op == "+" || op == "-") {
    return 1;
  }
  if (op == "*" || op == "/") {
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

void evaluate(String tokens) {
  int i, flag = 0;
  var values = new List();
  List<String> ops = List();
  for (i = 0; i < tokens.length; i++) {
    if (flag == 1) {
      break;
    }
    if (tokens[i] == " ") {
      continue;
    } else if (tokens == "(") {
      ops.add(tokens[i]);
    } else if (isNumeric(tokens[i])) {
      var val = 0;
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
            res = val1 + val2;
            break;
          case "-":
            res = val1 - val2;
            break;
          case "*":
            res = val1 * val2;
            break;
          case "/":
            {
              try {
                if (val1 % val2 == 0) {
                  res = val1 ~/ val2;
                  break;
                } else {
                  res = val1 / val2;
                  break;
                }
              } on IntegerDivisionByZeroException {
                print("Cannot divide by zero");
                flag = 1;
              }
            }
        }
        if (flag == 1) {
          break;
        }
        values.add(res);
      }
      if (ops.isNotEmpty) {
        ops.removeLast();
      }
    } else {
      while (ops.isNotEmpty && precedence(ops.last) >= precedence(tokens[i])) {
        var val2 = values.last;
        values.removeLast();

        var val1 = values.last;
        values.removeLast();

        String op = ops.last;
        ops.removeLast();

        var res;
        switch (op) {
          case "+":
            res = val1 + val2;
            break;
          case "-":
            res = val1 - val2;
            break;
          case "*":
            res = val1 * val2;
            break;
          case "/":
            {
              try {
                if (val1 % val2 == 0) {
                  res = val1 ~/ val2;
                  break;
                } else {
                  res = val1 / val2;
                  break;
                }
              } on IntegerDivisionByZeroException {
                print("Cannot divide by zero");
                flag = 1;
              }
            }
        }
        if (flag == 1) {
          break;
        }
        values.add(res);
      }
      ops.add(tokens[i]);
    }
  }

  while (ops.isNotEmpty) {
    var val2 = values.last;
    print(values);
    values.removeLast();

    var val1 = values.last;
    print(values);
    values.removeLast();

    String op = ops.last;
    ops.removeLast();

    var res;
    switch (op) {
      case "+":
        res = val1 + val2;
        break;
      case "-":
        res = val1 - val2;
        break;
      case "*":
        res = val1 * val2;
        break;
      case "/":
        {
          try {
            if (val1 % val2 == 0) {
              res = val1 ~/ val2;
              break;
            } else {
              res = val1 / val2;
              break;
            }
          } on IntegerDivisionByZeroException {
            print("Cannot divide by zero");
            flag = 1;
          }
        }
    }
    if (flag == 1) {
      break;
    }
    values.add(res);
  }
  if (flag == 1) {
    var status = "Done";
  } else if (values.last == values.last.toInt()) {
    print(values.last);
  } else {
    print((values.last).toStringAsFixed(2));
  }
}

void main() {
  evaluate("10+5*2+3-2/3");
}
