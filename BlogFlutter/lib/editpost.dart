import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditPostPage extends StatefulWidget {
  final Map post;
  const EditPostPage({super.key, required this.post});

  @override
  State<EditPostPage> createState() => _EditPostPageState();
}

class _EditPostPageState extends State<EditPostPage> {

  late final titleController = TextEditingController(text: widget.post['Judul']);
  List categories = []; int? selectedCategoryId;
  late final descriptionController = TextEditingController(text: widget.post['content']);

  bool isSaving = false;

//////////////////////////////GetCategories///////////////////////////////////
  Future<void> getCategories() async {
    final response = await http.get(Uri.parse('http://localhost:4444/api/categories'),
    );

    if (response.statusCode == 200) {

      final data = jsonDecode(response.body);
      setState(() {
        categories = data['data'];
      });
    }
  }
/////////////Manggil Function//////////////////////
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategories();
  }

  
  
///////////////////////////UpdatePost////////////////////////////////
 Future<void> updatePost() async {
    setState(() => isSaving = true);

    final selectedCategory = categories.firstWhere(
    (category) => category['id'] == selectedCategoryId,
    );

    final id = widget.post['id'];
    final response = await http.put(
      Uri.parse('http://localhost:4444/api/posts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'title': titleController.text,
        'category': selectedCategory['name'],
        'content': descriptionController.text,
        'id_user': widget.post['id_user'],
      }),
    );
    

    setState(() => isSaving = false);

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Berhasil memperbarui post!')),
      );
      Navigator.pop(context);
    } else {
      final responseData = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal: ${responseData['message'] ?? response.statusCode}')),
      );
    }

    
  }


  @override
Widget build(BuildContext context) {
  return Scaffold(
    backgroundColor: const Color(0xFFF6F5FA),

    appBar: AppBar(
      title: const Text(
        'Edit Blog',
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

          DropdownButtonFormField<int>(
            menuMaxHeight: 300,
            initialValue: selectedCategoryId,
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
              return DropdownMenuItem<int>(
                value: category['id'],
                child: Text(
                  category['name'],
                  style: const TextStyle(
                    fontFamily: "ComicRelief",
                  ),
                ),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                selectedCategoryId = value;
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
            onPressed: isSaving ? null : updatePost,
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
                    'Update',
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
