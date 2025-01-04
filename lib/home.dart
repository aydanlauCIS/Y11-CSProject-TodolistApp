import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:y11cs_todolistapp/add_todo.dart';
import "package:y11cs_todolistapp/models/todo.dart";
import 'package:y11cs_todolistapp/todo_list.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  late TabController tabController;
  SharedPreferences? sharedPreferences;

  List<Todo> todos = [];

  @override
  void initState() {
    tabController = TabController(length: 3, vsync: this);
    initSharedPreferences();

    for (Todo t in todos) {
      t.updateState();
    }

    super.initState();
  }

  void initSharedPreferences() async {
    sharedPreferences = await SharedPreferences.getInstance();
    loadTodolistData();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  void toggleArchiveTodo(int todoIndex) {
    setState(() => todos[todoIndex].toggleArchived());
    saveTodolistData();
  }

  void deleteTodo(int todoIndex) {
    setState(() => todos.removeAt(todoIndex));
    saveTodolistData();
  }

  void saveTodolistData() {
    List<String> data = todos.map((t) => json.encode(t.createMapFromTodo())).toList();
    sharedPreferences!.setStringList("data", data);
    // print(data);
  }

  void loadTodolistData() {
    List<String>? data = sharedPreferences!.getStringList("data");
    setState(() {
      todos = data!.map((t) => Todo.createTodoFromMap(json.decode(t))).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: Colors.white,
          onPressed: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.search),
            color: Colors.white,
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.person),
            color: Colors.white,
            onPressed: () {},
          )
        ],
        title: const Text("Todolist App",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            )),
        backgroundColor: Colors.blue[500],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: 60,
            decoration: const BoxDecoration(
              color: Colors.blueGrey,
            ),
            child: TabBar(
              unselectedLabelColor: Colors.white,
              labelColor: Colors.white,
              indicatorColor: Colors.white,
              dividerColor: Colors.blueGrey,
              labelStyle: const TextStyle(
                fontSize: 18,
              ),
              controller: tabController,
              tabs: [
                const Tab(text: "Current"),
                const Tab(text: "Overdue"),
                const Tab(text: "Archived"),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 280,
            child: TabBarView(
              controller: tabController,
              children: [
                TodoList(
                  todos: todos,
                  toggleArchiveTodo: toggleArchiveTodo,
                  state: TaskState.current,
                  deleteTodo: deleteTodo,
                ),
                TodoList(
                  todos: todos,
                  toggleArchiveTodo: toggleArchiveTodo,
                  state: TaskState.overdue,
                  deleteTodo: deleteTodo,
                ),
                TodoList(
                  todos: todos,
                  toggleArchiveTodo: toggleArchiveTodo,
                  state: TaskState.archived,
                  deleteTodo: deleteTodo,
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 15, top: 30),
              child: ElevatedButton(
                onPressed: () async {
                  final Todo newTodo = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TodoForm(),
                    ),
                  );

                  setState(() => todos.add(newTodo));
                  saveTodolistData();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[400],
                  elevation: 10,
                  minimumSize: const Size(60, 60),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                child: const Text(
                  "+",
                  style: TextStyle(
                    fontSize: 22,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
