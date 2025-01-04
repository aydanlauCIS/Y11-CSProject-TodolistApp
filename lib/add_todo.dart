import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y11cs_todolistapp/models/todo.dart';

class TodoForm extends StatefulWidget {
  const TodoForm({super.key});

  @override
  State<TodoForm> createState() => _TodoFormState();
}

class _TodoFormState extends State<TodoForm> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _dateController = TextEditingController();
  String _title = "";
  String _description = "";
  DateTime _date = DateTime.now();

  Future<void> selectDate() async {
    DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if (selectedDate != null) {
      setState(() {
        _dateController.text = DateFormat.yMMMEd().format(selectedDate);
      });
      _date = selectedDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: Form(
          key: _formKey,
          child: Column(
            spacing: 13,
            children: <Widget>[
              const SizedBox(height: 40),
              TextFormField(
                maxLength: 25,
                decoration: const InputDecoration(
                  label: Text("Task title"),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a value for the title.";
                  }
                  return null;
                },
                onSaved: (value) {
                  _title = value!;
                },
              ),
              TextFormField(
                maxLength: 100,
                decoration: const InputDecoration(
                  label: Text("Task description"),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onSaved: (value) {
                  _description = value!;
                },
              ),
              TextFormField(
                controller: _dateController,
                decoration: const InputDecoration(
                  label: Text("Date"),
                  filled: true,
                  prefixIcon: Icon(Icons.calendar_today),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                readOnly: true,
                onTap: () => selectDate(),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please select a due date for this task.";
                  }
                  return null;
                },
              ),
              Align(
                alignment: Alignment.topRight,
                child: FilledButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Todo newTodo = Todo(
                        title: _title,
                        description: _description,
                        dueDate: _date,
                        isOverdue: Todo.isDateOverdue(_date),
                      );

                      newTodo.updateState();

                      _formKey.currentState!.reset();

                      Navigator.pop(
                        context,
                        newTodo,
                      );
                    }
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    textStyle: const TextStyle(
                      fontSize: 17,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text("Add task"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
