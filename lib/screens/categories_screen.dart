import 'package:flutter/material.dart';
import 'package:mu_todo_list/models/category.dart';
import 'package:mu_todo_list/services/category_service.dart';
import 'package:mu_todo_list/utils/colors.dart';
import 'package:mu_todo_list/widgets/customed_appbar.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  final FocusNode _focusNode = FocusNode();
  final CategoryService cs = CategoryService();
  final TextEditingController _categoryNameController = TextEditingController();
  List<Category> _categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomedAppBar(title: "Categories"),
      body: FutureBuilder(
        future: cs.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(color: HColor.secondary),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: TextStyle(color: Colors.red, fontSize: 18),
              ),
            );
          } else if (!snapshot.hasData ||
              (snapshot.data as List<Category>).isEmpty) {
            return Center(
              child: Text(
                'No categories available',
                style: TextStyle(color: Colors.grey.shade600, fontSize: 20),
              ),
            );
          } else {
            _categories = snapshot.data as List<Category>;
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 29, vertical: 16),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: _categories.isEmpty ? 1 : _categories.length,
                separatorBuilder:
                    (context, index) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (_categories.isEmpty) {
                    return Center(
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.4,
                        ),
                        child: Text(
                          'No categories available',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    );
                  }
                  var category = _categories[index];
                  return ListTile(
                    trailing: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                                side: const BorderSide(
                                  color: Colors.red,
                                  width: 2,
                                ),
                              ),
                              titlePadding: const EdgeInsets.fromLTRB(
                                24,
                                24,
                                24,
                                12,
                              ),
                              contentPadding: const EdgeInsets.fromLTRB(
                                24,
                                0,
                                24,
                                18,
                              ),
                              actionsPadding: const EdgeInsets.fromLTRB(
                                24,
                                0,
                                24,
                                24,
                              ),
                              backgroundColor: Colors.white,
                              title: const Text("Category Delete Alert"),
                              titleTextStyle: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                color: HColor.primary,
                              ),
                              contentTextStyle: const TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                                color: Colors.black54,
                              ),
                              content: Text(
                                "Are you sure you want to delete the category '${category.name}'? This action cannot be undone.",
                              ),
                              actions: [
                                Row(
                                  spacing: 10,
                                  children: [
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () => Navigator.pop(context),
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          fixedSize: const Size(
                                            double.infinity,
                                            45,
                                          ),
                                          overlayColor: Colors.green.withAlpha(
                                            100,
                                          ),
                                        ),
                                        child: const Text(
                                          "Cancel",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: TextButton(
                                        onPressed: () {
                                          cs.deleteCategory(category);
                                          setState(() {
                                            _categories.remove(category);
                                          });
                                          Navigator.pop(context);
                                        },
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          backgroundColor: Colors.red,
                                          fixedSize: const Size(
                                            double.infinity,
                                            45,
                                          ),
                                        ),
                                        child: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            fontFamily: 'Cairo',
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                        );
                      },
                      icon: Icon(Icons.delete, color: Colors.red),
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),

                    tileColor: HColor.secondary.withAlpha(50),
                    title: Text(
                      category.name,
                      style: TextStyle(color: HColor.primary),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: Colors.white,
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  spacing: 18,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Add New Category',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: HColor.primary,
                      ),
                    ),
                    TextField(
                      controller: _categoryNameController,
                      focusNode: _focusNode,
                      onTapOutside: (event) {
                        if (FocusScope.of(context).hasFocus) {
                          _focusNode.unfocus();
                        }
                      },
                      cursorColor: HColor.secondary,
                      decoration: InputDecoration(
                        labelText: 'Category Name',
                        labelStyle: TextStyle(color: Colors.grey.shade600),
                        floatingLabelStyle: TextStyle(
                          color: HColor.secondary,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: Colors.grey.shade300,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide(
                            color: HColor.secondary,
                            width: 2,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: HColor.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        fixedSize: Size(double.infinity, 45),
                        minimumSize: Size(double.infinity, 45),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        var categoryName = _categoryNameController.text.trim();
                        if (categoryName.isNotEmpty) {
                          var newCategory = Category(name: categoryName);
                          cs.storeCategory(newCategory);
                          setState(() {
                            _categories.add(newCategory);
                          });
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a category name'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        'Add Category',
                        style: TextStyle(color: HColor.secondary),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        backgroundColor: HColor.primary,
        child: Icon(Icons.add, color: HColor.secondary),
      ),
    );
  }
}
