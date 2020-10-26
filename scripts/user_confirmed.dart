import 'dart:io';

bool userConfirmed() {
  print('Answer Y or N:');
  var userAnswer = stdin.readLineSync().toUpperCase();

  while (true) {
    switch (userAnswer) {
      case 'Y':
      case 'N':
        break;
      default:
        print('You have to answer Y or N');
        userAnswer = stdin.readLineSync().toUpperCase();
        break;
    }
    if (userAnswer == 'Y') {
      return true;
    }
    if (userAnswer == 'N') {
      return false;
    }
  }
}
