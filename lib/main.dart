import 'package:flutter/material.dart';
import 'database.dart';
import 'todo_item.dart';
import 'todo_dao.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = await $FloorAppDatabase.databaseBuilder('app_database.db').build();
  runApp(MyApp(database: database));
}

class MyApp extends StatelessWidget {
  final AppDatabase database;

  const MyApp({Key? key, required this.database}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ToDoPage(title: 'Flutter Demo Home Page', database: database),
    );
  }
}

class ToDoPage extends StatefulWidget {
  final String title;
  final AppDatabase database;

  const ToDoPage({Key? key, required this.title, required this.database}) : super(key: key);

  @override
  State<ToDoPage> createState() => _ToDoPageState();
}

class _ToDoPageState extends State<ToDoPage> {
  final TextEditingController _todoController = TextEditingController();
  late ToDoDao todoDao;
  List<ToDoItem> _todoItems = [];
  ToDoItem? _selectedItem;

  @override
  void initState() {
    super.initState();
    todoDao = widget.database.todoDao;
    _loadTodos();
  }

  Future<void> _loadTodos() async {
    final todos = await todoDao.findAllToDos();
    setState(() {
      _todoItems = todos;
    });
  }

  Future<void> _addTodoItem() async {
    if (_todoController.text.isNotEmpty) {
      final todo = ToDoItem(task: _todoController.text);
      await todoDao.insertToDoItem(todo);
      _todoController.clear();
      _loadTodos();
    } else {
      print('Text field is empty');
    }
  }

  Future<void> _removeTodoItem(ToDoItem todo) async {
    await todoDao.deleteToDoItem(todo);
    _selectedItem = null;
    _loadTodos();
  }

  Future<void> _showDeleteDialog(ToDoItem todo) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Todo Item'),
          content: Text('Are you sure you want to delete this item?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                _removeTodoItem(todo);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTap(ToDoItem item) {
    setState(() {
      _selectedItem = item;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isLargeScreen = constraints.maxWidth > 600;
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Theme.of(context).colorScheme.inversePrimary,
            title: Text(widget.title),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: isLargeScreen
                ? Row(
              children: [
                Expanded(child: _buildTodoList()),
                VerticalDivider(),
                if (_selectedItem != null)
                  Expanded(child: _buildDetailsPage(_selectedItem!)),
              ],
            )
                : _selectedItem == null
                ? _buildTodoList()
                : _buildDetailsPage(_selectedItem!),
          ),
        );
      },
    );
  }

  Widget _buildTodoList() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: TextField(
                controller: _todoController,
                decoration: InputDecoration(
                  labelText: 'Enter a todo item',
                ),
              ),
            ),
            SizedBox(width: 10),
            ElevatedButton(
              onPressed: _addTodoItem,
              child: Text('Add'),
            ),
          ],
        ),
        SizedBox(height: 20),
        Expanded(
          child: _todoItems.isEmpty
              ? Center(child: Text('There are no items in the list'))
              : ListView.builder(
            itemCount: _todoItems.length,
            itemBuilder: (context, index) {
              final todo = _todoItems[index];
              return GestureDetector(
                onTap: () => _onItemTap(todo),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text('Row number: ${index + 1}'),
                      Text(todo.task),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsPage(ToDoItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Item Name: ${item.task}', style: TextStyle(fontSize: 20)),
        Text('Database ID: ${item.id}', style: TextStyle(fontSize: 16)),
        SizedBox(height: 20),
        ElevatedButton(
          onPressed: () => _removeTodoItem(item),
          child: Text('Delete'),
        ),
      ],
    );
  }
}
