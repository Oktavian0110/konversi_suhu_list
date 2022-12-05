import 'package:flutter/material.dart';
//import 'package:flutter/services.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyConverter',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'MyConverter'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputController = TextEditingController();
  double inputUser = 0;
  String newValue = "Kelvin";
  double result = 0;
  ValueNotifier<double> _result = ValueNotifier<double>(0);

  List<String> listHistory = <String>[];

  var listItem = [
    'Kelvin',
    'Reamur',
  ];

  external static double? tryParse(String inputController);

  void dropdownOnChanged() {
    setState(() {
      if (inputController.text == "") {
        inputUser = double.parse("0");
      } else {
        inputUser = double.parse(inputController.text);
      }

      if (newValue == "Kelvin") {
        result = (4 / 5) * inputUser;
        _result.value = result;
        if (result != 0) {
          listHistory.add(newValue.toString() + " : " + result.toString());
        }
      } else {
        result = ((9 / 5) * inputUser) + 32;
        _result.value = result;
        if (result != 0) {
          listHistory.add(newValue.toString() + " : " + result.toString());
        }
      }
    });
  }

  void makeListHistory() {
    listHistory.add(result.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        flex: 3,
                        child: TextFormField(
                          controller: inputController,
                          keyboardType: TextInputType.number,
                          //inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          onChanged: (String value) {
                            dropdownOnChanged();
                          },
                          decoration: const InputDecoration(
                            hintText: "Input Temperature in Celcius",
                            suffixText: "C",
                          ),
                        ),
                      ),
                      const Expanded(
                        flex: 1,
                        child: Icon(
                          Icons.ac_unit,
                          color: Colors.blue,
                          size: 40,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: SizedBox(
                        width: 200.0,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton(
                              items: listItem.map((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                              value: newValue,
                              onChanged: (changeValue) {
                                setState(() {
                                  newValue = changeValue.toString();
                                });
                                dropdownOnChanged();
                              },
                            ),
                            Container(
                              color: Colors.black,
                              alignment: Alignment.center,
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                result.toString() + " " + newValue.toString(),
                                style: const TextStyle(
                                  fontSize: 17,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Container(
                        child: const Text(
                          " Riwayat Konversi",
                          style: TextStyle(
                            fontSize: 17,
                          ),
                        ),
                      ),
                      Container(
                        child: ValueListenableBuilder(
                          valueListenable: _result,
                          builder: (context, value, child) {
                            return Expanded(
                              child: Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 20,
                                ),
                                child: ListView.builder(
                                  itemCount: listHistory.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      listHistory[index],
                                      style: const TextStyle(fontSize: 17),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}