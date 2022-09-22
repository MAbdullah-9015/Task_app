import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // var msgController = TextEditingController();
  final fieldText = TextEditingController();

  List<String> list = [];
  var value = '';

  @override
  void initState() {
    load();
  }

  void load() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list = prefs.getStringList('items')!;
    });
  }

  void addTask() async {
    setState(() {
      if (value != '') {
        list.add(value);
      }
    });
    final prefs = await SharedPreferences.getInstance();

    await prefs.setStringList('items', list);
    clearText();
  }

  void deleteTask(deleteIndex) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      list.removeAt(deleteIndex);
    });
    await prefs.setStringList('items', list);
  }

  void clearText() {
    fieldText.clear();
    value = "";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Center(
            child: SizedBox(
              width: 350,
              height: 700,
              child: Card(
                elevation: 10,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.only(top: 20),
                      child: Icon(
                        Icons.check_box,
                        color: Colors.green,
                        size: 30.0,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.only(top: 10),
                      child: const Center(
                          child: Text(
                        "Task App",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 25, bottom: 10),
                      padding: const EdgeInsets.only(
                        bottom: 4,
                      ),
                      width: 250,
                      height: 40,
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: TextField(
                        textAlign: TextAlign.center,
                        onChanged: (text) {
                          value = text;
                        },
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: " Enter Task Here!",
                          hintStyle: TextStyle(
                            fontSize: 15,
                          ),
                        ),
                        controller: fieldText,
                      ),
                    ),
                    Container(
                      width: 250,
                      height: 30,
                      margin: const EdgeInsets.only(top: 10),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        child: const Text("Add Task"),
                        onPressed: () {
                          addTask();
                        },
                      ),
                    ),
                    Container(
                      // margin: EdgeInsets.only(top: 10, left: 10),
                      width: 250,
                      height: 470,
                      child: ListView(
                        shrinkWrap: true,
                        children: [
                          for (int i = 0; i < list.length; i++) ...[
                            Container(
                              width: 250,
                              height: 45,
                              decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              margin: const EdgeInsets.only(
                                top: 10,
                              ),
                              child: ListTile(
                                trailing: MouseRegion(
                                  cursor: SystemMouseCursors.click,
                                  child: GestureDetector(
                                    onTap: () => deleteTask(i),
                                    child: const Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                                title: Text(
                                  list[i],
                                  style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ]
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
