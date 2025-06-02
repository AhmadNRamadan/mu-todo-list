import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mu_todo_list/models/category.dart';
import 'package:mu_todo_list/models/todo.dart';
import 'package:mu_todo_list/services/category_service.dart';
import 'package:mu_todo_list/services/todo_service.dart';
import 'package:mu_todo_list/utils/colors.dart';

class AddTodoScreen extends StatefulWidget {
  const AddTodoScreen({super.key});
  @override
  State<AddTodoScreen> createState() => _AddTodoScreenState();
}

class _AddTodoScreenState extends State<AddTodoScreen> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();
  final FocusNode _categoryFocusNode = FocusNode();
  DateTime? _selectedDate;
  String? _selectedCategory;
  final TodoService _todoService = TodoService();
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final categories = await _categoryService.getCategories();
      setState(() {
        _categories = categories;
      });
      if (_categories.isNotEmpty) {
        _selectedCategory = _categories.first.name;
      }
    });
  }

  void _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: HColor.primary,
              onPrimary: Colors.white,
              onSurface: HColor.primary,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty ||
        _selectedCategory == null ||
        _selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all required fields',
            style: TextStyle(color: HColor.primary),
          ),
          backgroundColor: HColor.secondary,
        ),
      );
      return;
    }
    final todo = Todo(
      title: _titleController.text,
      description: _descriptionController.text,
      categoryId:
          _categories
              .where((element) => element.name == _selectedCategory!)
              .first
              .id,
      todoDate: DateFormat.yMMMd().format(_selectedDate!),
    );

    await _todoService.storeTodo(todo);
    Navigator.pop(context, todo);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: HColor.primary,
      appBar: AppBar(
        backgroundColor: HColor.primary,
        title: const Text('Create New Task'),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: GestureDetector(
        onTap: () {
          if (_categoryFocusNode.hasFocus) {
            _categoryFocusNode.unfocus();
          }
        },
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  padding: const EdgeInsets.all(20),
                  child: Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        spacing: 12,
                        children: [
                          Text(
                            'New Todo',
                            style: TextStyle(
                              color: HColor.primary,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            controller: _titleController,
                            cursorColor: HColor.secondary,
                            focusNode: _titleFocusNode,
                            onTapOutside: (event) {
                              if (_titleFocusNode.hasFocus) {
                                _titleFocusNode.unfocus();
                              }
                            },
                            decoration: InputDecoration(
                              labelText: 'Title',
                              floatingLabelStyle: TextStyle(
                                color: HColor.secondary,
                              ),
                              prefixIcon: Icon(
                                Icons.title,
                                color: HColor.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: HColor.secondary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          TextField(
                            controller: _descriptionController,
                            focusNode: _descriptionFocusNode,
                            onTapOutside: (event) {
                              if (_descriptionFocusNode.hasFocus) {
                                _descriptionFocusNode.unfocus();
                              }
                            },
                            maxLines: 3,
                            cursorColor: HColor.secondary,
                            decoration: InputDecoration(
                              labelText: 'Description',
                              floatingLabelStyle: TextStyle(
                                color: HColor.secondary,
                              ),
                              prefixIcon: Icon(
                                Icons.description,
                                color: HColor.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: HColor.secondary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            focusNode: _categoryFocusNode,

                            value: _selectedCategory,
                            items:
                                _categories.map((cat) {
                                  return DropdownMenuItem(
                                    value: cat.name,
                                    child: Text(cat.name),
                                  );
                                }).toList(),
                            onChanged:
                                (val) =>
                                    setState(() => _selectedCategory = val),
                            decoration: InputDecoration(
                              labelText: 'Category *',
                              floatingLabelStyle: TextStyle(
                                color: HColor.secondary,
                              ),
                              prefixIcon: Icon(
                                Icons.category,
                                color: HColor.primary,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: HColor.secondary,
                                  width: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          InkWell(
                            onTap: _pickDate,
                            child: InputDecorator(
                              decoration: InputDecoration(
                                labelText: 'Due Date *',
                                prefixIcon: Icon(
                                  Icons.date_range,
                                  color: HColor.primary,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                _selectedDate != null
                                    ? DateFormat.yMMMd().format(_selectedDate!)
                                    : 'Tap to select date',
                                style: TextStyle(
                                  color:
                                      _selectedDate != null
                                          ? Colors.black
                                          : Colors.grey[600],
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: HColor.secondary,
                                foregroundColor: HColor.primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              icon: const Icon(Icons.check_circle_outline),
                              label: const Text(
                                'Save Todo',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onPressed: _submit,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
