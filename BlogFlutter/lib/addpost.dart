import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddPostPage extends StatefulWidget {
  final int userId;
  final VoidCallback? onPostAdded;

  const AddPostPage({super.key, required this.userId, this.onPostAdded});

  @override
  State<AddPostPage> createState() => _AddPostPageState();
}

class _AddPostPageState extends State<AddPostPage> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final categoryController = TextEditingController();

  List categories = [];
  bool isSaving = false;

  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse('http://localhost:4444/api/categories'),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      setState(() {
        categories = data['data'];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCategories();
  }

  Future<void> addPost() async {
    setState(() => isSaving = true);

    final response = await http.post(
      Uri.parse('http://localhost:4444/api/posts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'category': categoryController.text,
        'content': descriptionController.text,
        'id_user': widget.userId,
      }),
    );

    setState(() => isSaving = false);

    if (response.statusCode == 200 || response.statusCode == 201) {
      titleController.clear();
      categoryController.clear();
      descriptionController.clear();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Berhasil menyimpan post!')));
      widget.onPostAdded?.call();

    } else {
      final responseData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Gagal: ${responseData['message'] ?? response.statusCode}',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),

      appBar: AppBar(
        title: const Text(
          'Add Blog',
          style: TextStyle(
            fontFamily: "ComicRelief",
            fontWeight: FontWeight.bold,
            color: Colors.blueAccent,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Blog Title',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "ComicRelief",
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 14),

            DropdownButtonFormField<String>(
              menuMaxHeight: 300,
              initialValue: categoryController.text.isEmpty
                  ? null
                  : categoryController.text,
              decoration: InputDecoration(
                labelText: 'Select Category',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "ComicRelief",
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
              items: categories.map((category) {
                return DropdownMenuItem<String>(
                  value: category['name'],
                  child: Text(
                    category['name'],
                    style: const TextStyle(fontFamily: "ComicRelief"),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  categoryController.text = value ?? '';
                });
              },
            ),

            const SizedBox(height: 14),

            TextField(
              controller: descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Blog Content',
                labelStyle: const TextStyle(
                  color: Colors.grey,
                  fontFamily: "ComicRelief",
                ),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),  
              onPressed: isSaving ? null : addPost,
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      'Post',
                      style: TextStyle(
                        fontFamily: "ComicRelief",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
