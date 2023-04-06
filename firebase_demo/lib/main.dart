import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

final db = FirebaseFirestore.instance;
String? value;

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firebase Demo',
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.pink,
      ),
      home: const MyHomePage(title: 'Todo list'),
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
  String? newTask = "";
  bool isUpdating = false;
  final TextEditingController _taskInputController = TextEditingController();

  Future _showInputTaskDialog(
      BuildContext context, DocumentSnapshot? documentSnapshot) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              isUpdating ? const Text("Edit task") : const Text("Add new todo"),
          content: TextField(
            onChanged: (String value) {
              setState(
                () {
                  newTask = value;
                },
              );
            },
            controller: _taskInputController,
            decoration: const InputDecoration(
              hintText: "Enter you todo task",
              labelText: "Task",
            ),
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                _taskInputController.clear();
                Navigator.pop(context);
              },
              child: const Text("Cancel"),
            ),
            MaterialButton(
              onPressed: () {
                if (isUpdating) {
                  db.collection('todos').doc(documentSnapshot?.id).update({
                    "task": newTask,
                  });
                  setState(() {
                    isUpdating = false;
                  });
                } else {
                  db.collection('todos').add({"task": newTask});
                }

                _taskInputController.clear();
                Navigator.pop(context);
              },
              child: isUpdating ? const Text("Update") : const Text("Add"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder(
        stream: db.collection('todos').snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data?.docs.length,
            itemBuilder: (context, int index) {
              DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
              String content = documentSnapshot['task'].toString();

              return ListTile(
                title: Text(content),
                onTap: () {
                  setState(() {
                    isUpdating = true;
                  });
                  _taskInputController.text = content;
                  _showInputTaskDialog(context, documentSnapshot);
                },
                trailing: IconButton(
                  onPressed: () {
                    db.collection('todos').doc(documentSnapshot.id).delete();
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showInputTaskDialog(context, null);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
