enum Parity { None, Odd, Even, Mark, Space }

extension ParityExtension on Parity {
  String get name {
    switch (this) {
      case Parity.None:
        return 'None';
      case Parity.Odd:
        return 'Odd';
      case Parity.Even:
        return 'Even';
      case Parity.Mark:
        return 'Mark';
      case Parity.Space:
        return 'Space';
    }
  }
}

enum StopBits { None, One, OnePointFive, Two }

extension StopBitsExtension on StopBits {
  int get value {
    switch (this) {
      case StopBits.One:
        return 1;
      case StopBits.OnePointFive:
        return 3;
      case StopBits.Two:
        return 2;
      case StopBits.None:
        return 0;
    }
  }

  String get name {
    switch (this) {
      case StopBits.One:
        return "One";
      case StopBits.OnePointFive:
        return "OnePointFive";
      case StopBits.Two:
        return "Two";
      case StopBits.None:
        return "None";
    }
  }
}

const BaudRates = [300, 1200, 2400, 4800, 9600, 19200, 38400, 115200];
const DataBits = [5, 6, 7, 8];
