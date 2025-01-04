import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:y11cs_todolistapp/models/todo.dart';

class TodoList extends StatefulWidget {
  const TodoList({required this.todos, required this.toggleArchiveTodo, required this.state, required this.deleteTodo, super.key});

  final List<Todo> todos;
  final void Function(int) toggleArchiveTodo;
  final TaskState state;
  final void Function(int) deleteTodo;

  @override
  State<TodoList> createState() => _TodoListState();
}

class _TodoListState extends State<TodoList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.todos.length,
      itemBuilder: (_, int i) {
        if (widget.todos[i].state == widget.state) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: switch (widget.todos[i].state) { TaskState.current => Colors.blue[600], TaskState.overdue => Colors.red[600], TaskState.archived => Colors.grey[600] },
              ),
              padding: const EdgeInsets.only(left: 12, right: 12, top: 12, bottom: 23),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              child: ExpandablePanel(
                header: Row(
                  children: [
                    Text(
                      widget.todos[i].title,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      softWrap: true,
                    ),
                    const Expanded(child: SizedBox()),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 3),
                      constraints: const BoxConstraints(),
                      style: const ButtonStyle(
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      onPressed: () => widget.deleteTodo(i),
                    ),
                    SizedBox(
                      height: 15,
                      width: 35,
                      child: Checkbox(
                          checkColor: switch (widget.todos[i].state) { TaskState.current => Colors.blue[600], TaskState.overdue => Colors.red[600], TaskState.archived => Colors.grey[600] },
                          activeColor: Colors.white,
                          side: const BorderSide(color: Colors.white, width: 1.7),
                          value: widget.todos[i].state == TaskState.archived,
                          onChanged: (bool? value) => widget.toggleArchiveTodo(i)),
                    )
                  ],
                ),
                collapsed: Text(
                  "Due: ${DateFormat.MMMEd().format(widget.todos[i].dueDate)}",
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                expanded: Text(
                  "Due: ${DateFormat.MMMEd().format(widget.todos[i].dueDate)}\n${widget.todos[i].description}",
                  softWrap: true,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontStyle: FontStyle.italic,
                  ),
                ),
                theme: const ExpandableThemeData(
                  iconColor: Colors.white,
                  iconPlacement: ExpandablePanelIconPlacement.right,
                  iconPadding: EdgeInsets.only(top: 8, right: 5),
                ),
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
