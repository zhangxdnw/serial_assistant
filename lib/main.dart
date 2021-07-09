import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

import 'util/serial_config.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  late SerialPort serialPort;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _portName = "";
  var _serialConfig = SerialPortConfig();
  bool _serialFlowControl = false;
  bool _portIsOpen = false;

  @override
  void initState() {
    _serialConfig.baudRate = BaudRates[4];
    _serialConfig.parity = Parity.None.index;
    _serialConfig.bits = DataBits[3];
    _serialConfig.stopBits = StopBits.One.value;
    super.initState();
  }

  @override
  void dispose() {
    _serialConfig.dispose();
    if (widget.serialPort.isOpen) {
      widget.serialPort.close();
    }
    widget.serialPort.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      body: Center(
          child: Container(
              width: 300,
              color: Colors.red,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text("Serial Port"),
                        Spacer(),
                        initSerialPortWidget(),
                      ],
                    ),
                  ), //PortName Select
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(children: [
                      Text("Baud Rate"),
                      Spacer(),
                      DropdownButton(
                          value: _serialConfig.baudRate,
                          items: BaudRates.map((item) => DropdownMenuItem(
                                child: Text(item.toString()),
                                value: item,
                              )).toList(),
                          onChanged: (value) {
                            setState(() {
                              _serialConfig.baudRate = value as int;
                            });
                          })
                    ]),
                  ), //BaudRate Select
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text('Parity'),
                        Spacer(),
                        DropdownButton(
                          value: _serialConfig.parity,
                          items: Parity.values
                              .map((item) => DropdownMenuItem(
                                    child: Text(item.name),
                                    value: item.index,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _serialConfig.parity = value as int;
                            });
                          },
                        )
                      ],
                    ),
                  ), //Parity
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text("Data Bits"),
                        Spacer(),
                        DropdownButton(
                          value: _serialConfig.bits,
                          items: DataBits.map((item) => DropdownMenuItem(
                              child: Text(item.toString()),
                              value: item)).toList(),
                          onChanged: (value) {
                            setState(() {
                              _serialConfig.bits = value as int;
                            });
                          },
                        )
                      ],
                    ),
                  ), // DataBit
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        Text("Stop Bits"),
                        Spacer(),
                        DropdownButton(
                          value: _serialConfig.stopBits,
                          items: StopBits.values
                              .map((item) => DropdownMenuItem(
                                    child: Text(item.name),
                                    value: item.value,
                                  ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _serialConfig.stopBits = value as int;
                            });
                          },
                        )
                      ],
                    ),
                  ), //StopBit
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text('Flow'),
                            Checkbox(
                                value: _serialFlowControl,
                                onChanged: (value) {
                                  setState(() {
                                    _serialFlowControl = value!;
                                    _serialConfig.setFlowControl(
                                        _serialFlowControl ? 1 : 0);
                                  });
                                })
                          ],
                        ),
                        Row(
                          children: [
                            Text('RTS'),
                            Checkbox(
                                value: _serialConfig.rts > 0,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _serialConfig.rts = 1;
                                    } else {
                                      _serialConfig.rts = 0;
                                    }
                                  });
                                })
                          ],
                        ),
                        Row(
                          children: [
                            Text('DTR'),
                            Checkbox(
                                value: _serialConfig.dtr > 0,
                                onChanged: (value) {
                                  setState(() {
                                    if (value!) {
                                      _serialConfig.dtr = 1;
                                    } else {
                                      _serialConfig.dtr = 0;
                                    }
                                  });
                                })
                          ],
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SizedBox(
                      width: double.infinity,
                      height: 40,
                      child: ElevatedButton(
                        child: Text(_portIsOpen ? "Close" : "Open"),
                        onPressed: () {
                          if (!_portIsOpen) {
                            widget.serialPort = SerialPort(_portName);
                            widget.serialPort.config = _serialConfig;
                            widget.serialPort
                                .open(mode: SerialPortMode.readWrite);
                            if (widget.serialPort.isOpen) {
                              setState(() {
                                _portIsOpen = widget.serialPort.isOpen;
                              });
                            } else {
                              print(SerialPort.lastError);
                            }
                          } else {
                            widget.serialPort.close();
                            if (!widget.serialPort.isOpen) {
                              setState(() {
                                _portIsOpen = widget.serialPort.isOpen;
                              });
                            } else {
                              print(SerialPort.lastError);
                            }
                          }
                        },
                      ),
                    ),
                  )
                ],
              ))),
    );
  }

  Widget initSerialPortWidget() {
    if (SerialPort.availablePorts.isEmpty) {
      return Text("");
    } else {
      _portName = SerialPort.availablePorts.first;
      return DropdownButton(
        value: _portName,
        items: SerialPort.availablePorts
            .map((item) => DropdownMenuItem(child: Text(item), value: item))
            .toList(),
        onChanged: (value) {
          setState(() {
            _portName = value as String;
          });
        },
      );
    }
  }
}
