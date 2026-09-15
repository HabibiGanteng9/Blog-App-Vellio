import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:latihan_rpl_2/detailpost.dart';
import 'package:latihan_rpl_2/editpost.dart';

class Homepage extends StatefulWidget {
  final int userId;

  const Homepage({super.key, required this.userId,});

  @override
  State<Homepage> createState() => HomepageState();
}

class HomepageState extends State<Homepage> {
  List categories = [];
  List posts = [];
  bool liked = false;
  bool comented = false;
  bool shared = false;
  bool isLoading = true;
  List filteredPosts = [];
  String searchText = '';
  String selectedCategory = 'All';
  IconData getCategoryIcon(int id) {
    switch (id) {
      case 1:
        return Icons.computer;
      case 2:
        return Icons.sports_esports;
      case 3:
        return Icons.movie;
      case 4:
        return Icons.school;
      case 5:
        return Icons.newspaper;
      case 6:
        return Icons.account_balance;
      case 7:
        return Icons.self_improvement;
      case 8:
        return Icons.restaurant;
      case 9:
        return Icons.camera_alt;
      case 10:
        return Icons.sports_soccer;
      case 11:
        return Icons.checkroom;
      case 12:
        return Icons.flight;
      case 13:
        return Icons.health_and_safety;
      case 14:
        return Icons.pets;
      case 15:
        return Icons.park;
      case 16:
        return Icons.history_edu;
      case 17:
        return Icons.code;
      case 18:
        return Icons.smart_toy;
      case 19:
        return Icons.palette;
      case 20:
        return Icons.science;
      case 21:
        return Icons.category;
      default:
        return Icons.category_outlined;
    }
  }

  Future<void> getPosts() async {
    try {
      final response = await http.get(
        Uri.parse("http://localhost:4444/api/posts"),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        setState(() {
          posts = responseData['data'];
          filteredPosts = posts;
          isLoading = false;
        });
      } else {
        print('Data gagal diambil: ${response.statusCode}');
        setState(() => isLoading = false);
      }
    } catch (e) {
      print('Terjadi kesalahan jaringan: $e');
      setState(() => isLoading = false);
    }
  }

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

  Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('http://localhost:4444/api/posts/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"id_user": widget.userId}),
      );

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ?? 'Post Berhasil Dihapus'),
          ),
        );

        setState(() {
          posts.removeWhere((item) => item['id'] == id);
          filteredPosts.removeWhere((item) => item['id'] == id);
        });
      } else {
        final responseData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              responseData['message'] ?? 'Tidak bisa menghapus post',
            ),
          ),
        );
      }
    } catch (e) {
      print('Terjadi kesalahan saat menghapus: $e');
    }
  }

  void filterPosts() {
    setState(() {
      filteredPosts = posts.where((post) {
        final title = (post['Judul'] ?? '').toString().toLowerCase();
        final category = (post['Kategori'] ?? '').toString();

        final matchSearch = title.contains(searchText.toLowerCase());

        final matchCategory =
            selectedCategory == 'All' || category == selectedCategory;

        return matchSearch && matchCategory;
      }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    getPosts();
    getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: false,
        title: const Text(
          "Vellio",
          style: TextStyle(
            fontFamily: "Mistar",
            fontSize: 28,
            fontWeight: FontWeight.w500,
            color: Colors.blueAccent,
          ),
        ),
      ),

      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Colors.blueAccent),
            )
          : posts.isEmpty
          ? const Center(
              child: Text(
                "Belum ada postingan.",
                style: TextStyle(fontFamily: "ComicRelief", color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // SEARCH
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari blog...',
                      hintStyle: const TextStyle(
                        color: Colors.grey,
                        fontFamily: "ComicRelief",
                      ),
                      prefixIcon: const Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      searchText = value;
                      filterPosts();
                    },
                  ),
                ),

                // CATEGORY
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      labelStyle: const TextStyle(
                        color: Colors.blueAccent,
                        fontFamily: "ComicRelief",
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    menuMaxHeight: 300,
                    items: [
                      const DropdownMenuItem(
                        value: 'All',
                        child: Text('All Categories'),
                      ),
                      ...categories.map(
                        (category) => DropdownMenuItem(
                          value: category['name'],
                          child: Text(category['name']),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      selectedCategory = value ?? 'All';
                      filterPosts();
                    },
                  ),
                ),

                const SizedBox(height: 12),

                Expanded(
                  child: filteredPosts.isEmpty
                      ? const Center(
                          child: Text(
                            "Blog tidak ditemukan.",
                            style: TextStyle(
                              color: Colors.grey,
                              fontFamily: "ComicRelief",
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 4,
                          ),
                          itemCount: filteredPosts.length,
                          itemBuilder: (context, index) {
                            final itemPost = filteredPosts[index];

                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(18),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.15),
                                    blurRadius: 8,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DetailPostPage(post: itemPost),
                                    ),
                                  ).then((_) => getPosts());
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // JUDUL + EDIT DELETE
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              itemPost['Judul'] ??
                                                  'Tanpa Judul',
                                              style: const TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "ComicRelief",
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ),

                                          if (itemPost['id_user'] ==
                                              widget.userId)
                                            Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditPostPage(
                                                              post: itemPost,
                                                            ),
                                                      ),
                                                    ).then((_) => getPosts());
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit_outlined,
                                                    color: Colors.blueAccent,
                                                    size: 20,
                                                  ),
                                                ),
                                                const SizedBox(width: 8),
                                                IconButton(
                                                  padding: EdgeInsets.zero,
                                                  constraints:
                                                      const BoxConstraints(),
                                                  onPressed: () {
                                                    deletePost(itemPost['id']);
                                                  },
                                                  icon: const Icon(
                                                    Icons.delete_outline,
                                                    color: Colors.redAccent,
                                                    size: 20,
                                                  ),
                                                ),
                                              ],
                                            ),
                                        ],
                                      ),

                                      const SizedBox(height: 6),

                                      // CATEGORY + USER
                                      Row(
                                        children: [
                                          Icon(
                                            getCategoryIcon(
                                              itemPost['id_category'],
                                            ),
                                            size: 16,
                                            color: Colors.blueAccent,
                                          ),
                                          const SizedBox(width: 5),
                                          Text(
                                            itemPost['Kategori'] ??
                                                'Tanpa Kategori',
                                            style: const TextStyle(
                                              color: Colors.blueAccent,
                                              fontSize: 13,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                          const SizedBox(width: 8),
                                          Text(
                                            "• ${itemPost['username'] ?? 'Unknown User'}",
                                            style: const TextStyle(
                                              color: Colors.grey,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),

                                      const SizedBox(height: 10),

                                      // CONTENT
                                      Text(
                                        itemPost['content'] ?? '',
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          color: Colors.black54,
                                          fontSize: 14,
                                          height: 1.4,
                                        ),
                                      ),

                                      const SizedBox(height: 10),

                                      // DATE
                                      Text(
                                        itemPost['created_at']
                                            .toString()
                                            .substring(0, 10),
                                        style: const TextStyle(
                                          color: Colors.grey,
                                          fontSize: 12,
                                        ),
                                      ),

                                      const SizedBox(height: 6),

                                      // LIKE COMMENT SHARE
                                      Row(
                                        children: [
                                          TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                itemPost['liked'] =
                                                    !(itemPost['liked'] ??
                                                        false);

                                                if (itemPost['liked']) {
                                                  itemPost['likes'] =
                                                      (itemPost['likes'] ?? 0) +
                                                      1;
                                                } else {
                                                  itemPost['likes'] =
                                                      (itemPost['likes'] ?? 0) -
                                                      1;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              itemPost['liked'] == true
                                                  ? Icons.thumb_up
                                                  : Icons.thumb_up_alt_outlined,
                                              color: itemPost['liked'] == true
                                                  ? Colors.blueAccent
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                            label: Text(
                                              '${itemPost['likes'] ?? 0}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),

                                          TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                itemPost['comented'] =
                                                    !(itemPost['comented'] ??
                                                        false);

                                                if (itemPost['comented']) {
                                                  itemPost['coments'] =
                                                      (itemPost['coments'] ??
                                                          0) +
                                                      1;
                                                } else {
                                                  itemPost['coments'] =
                                                      (itemPost['coments'] ??
                                                          0) -
                                                      1;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              itemPost['comented'] == true
                                                  ? Icons.comment
                                                  : Icons.comment_outlined,
                                              color:
                                                  itemPost['comented'] == true
                                                  ? Colors.blueAccent
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                            label: Text(
                                              '${itemPost['coments'] ?? 0}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),

                                          TextButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                itemPost['shared'] =
                                                    !(itemPost['shared'] ??
                                                        false);

                                                if (itemPost['shared']) {
                                                  itemPost['shares'] =
                                                      (itemPost['shares'] ??
                                                          0) +
                                                      1;
                                                } else {
                                                  itemPost['shares'] =
                                                      (itemPost['shares'] ??
                                                          0) -
                                                      1;
                                                }
                                              });
                                            },
                                            icon: Icon(
                                              itemPost['shared'] == true
                                                  ? Icons.near_me
                                                  : Icons.near_me_outlined,
                                              color: itemPost['shared'] == true
                                                  ? Colors.blueAccent
                                                  : Colors.grey,
                                              size: 20,
                                            ),
                                            label: Text(
                                              '${itemPost['shares'] ?? 0}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }
}
