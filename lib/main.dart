import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo list',
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
          // primarySwatch: Colors.purple,
          ),
      home: const MyHomePage(title: 'Flutter Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

enum Importance {
  none,
  low,
  medium,
  high,
}

class Todo {
  Todo({
    required this.content,
    required this.checked,
    required this.importance,
    required this.id,
  });
  final String content;
  bool checked;
  Importance importance;
  final String id;
}

class TodoItem extends StatelessWidget {
  TodoItem({
    required this.todo,
    required this.onTodoChanged,
  }) : super(key: ObjectKey(todo));

  final Todo todo;
  final onTodoChanged;

  TextStyle? _getTextStyle(bool checked) {
    if (!checked) return null;

    return const TextStyle(
      color: Colors.black54,
      decoration: TextDecoration.lineThrough,
    );
  }

  Text _getText(Importance importance) {
    switch (importance) {
      case Importance.high:
        return const Text("!!!", style: TextStyle(color: Colors.red));
      case Importance.medium:
        return const Text("!!", style: TextStyle(color: Colors.red));
      case Importance.low:
        return const Text("!", style: TextStyle(color: Colors.red));
      default:
        return const Text("", style: TextStyle(color: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: ((value) => onTodoChanged()),
      value: todo.checked,
      title: Text(todo.content, style: _getTextStyle(todo.checked)),
      controlAffinity: ListTileControlAffinity.leading,
      secondary: _getText(todo.importance),
      checkboxShape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    );
  }
}

class _MyHomePageState extends State<MyHomePage> {
  final List<Todo> _todos = <Todo>[];

  void _handleTodoChange(Todo todo) {
    setState(() {
      todo.checked = !todo.checked;
    });
  }

  void _addTodoItem(String content, Importance importance) {
    setState(() {
      _todos.add(Todo(
          content: content,
          checked: false,
          importance: importance,
          id: DateTime.now().toString()));
    });
  }

  void _show(BuildContext ctx) {
    final _formKey = GlobalKey<FormState>();

    final contentController = TextEditingController();

    Importance importance = Importance.none;

    void _save(String content, Importance importance) {
      if (_formKey.currentState!.validate()) {
        _addTodoItem(content, importance);
        Navigator.pop(context);
      }
    }

    showModalBottomSheet(
        elevation: 10,
        backgroundColor: Colors.white,
        context: ctx,
        builder: (ctx) => StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  // width: 300,
                  height: 300,
                  // color: Colors.white,
                  alignment: Alignment.center,
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          IconButton(
                              onPressed: () => Navigator.pop(context),
                              icon: const Icon(Icons.close)),
                          IconButton(
                              onPressed: () =>
                                  _save(contentController.text, importance),
                              icon: const Icon(Icons.save)),
                        ],
                      ),
                      Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Column(children: [
                                const Align(alignment: Alignment.centerLeft, child: Text("Content"), ),
                                TextFormField(
                                  key: const Key('content'),
                                    controller: contentController,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    }),
                              ]),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(top: 16, bottom: 16),
                                    child: Align(alignment: Alignment.centerLeft, child: Text("Importance"))
                                  ),
                                  SegmentedButton<Importance>(
                                    showSelectedIcon: false,
                                    segments: const [
                                      ButtonSegment<Importance>(
                                          value: Importance.none,
                                          label: Text('None')),
                                      ButtonSegment<Importance>(
                                          value: Importance.low,
                                          label: Text('Low')),
                                      ButtonSegment<Importance>(
                                          value: Importance.medium,
                                          label: Text('Medium')),
                                      ButtonSegment<Importance>(
                                          value: Importance.high,
                                          label: Text('High')),
                                    ],
                                    selected: <Importance>{importance},
                                    onSelectionChanged:
                                        (Set<Importance> newSelection) {
                                      setState(() {
                                        importance = newSelection.first;
                                      });
                                    },
                                  )
                                ],
                              )
                            ],
                          )),
                    ],
                  ),
                );
              },
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Todo List',
            style: TextStyle(color: Colors.black),
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        children: _todos.map((Todo todo) {
          return Dismissible(
              background: Container(
                color: Colors.red,
                alignment: Alignment.centerRight,
                padding: const EdgeInsets.only(right: 16),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              onDismissed: (DismissDirection direction) {
                setState(() {
                  _todos.remove(todo);
                });
              },
              key: ValueKey(todo.id),
              child: TodoItem(
                todo: todo,
                onTodoChanged: () => _handleTodoChange(todo),
              ));
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          onPressed: () => _show(context),
          tooltip: 'Add Item',
          child: const Icon(Icons.add)),
    );
  }
}
