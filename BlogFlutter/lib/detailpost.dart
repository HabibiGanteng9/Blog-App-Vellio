import 'package:flutter/material.dart';

class DetailPostPage extends StatelessWidget {
  final Map post;

  const DetailPostPage({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F5FA),

      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    post['Judul'] ?? 'Tanpa Judul',
                    style: const TextStyle(
                      fontFamily: "ComicRelief",
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.category_outlined,
                        size: 17,
                        color: Colors.blueAccent,
                      ),
                      const SizedBox(width: 6),

                      Text(
                        post['Kategori'] ?? 'Tanpa Kategori',
                        style: const TextStyle(
                          fontFamily: "ComicRelief",
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.blueAccent,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.person_outline,
                        size: 17,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),

                      Text(
                        post['username'] ?? 'Unknown User',
                        style: const TextStyle(
                          fontFamily: "ComicRelief",
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(width: 10),

                      const Icon(
                        Icons.calendar_today_outlined,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),

                      Text(
                        post['created_at'].toString().substring(0, 10),
                        style: const TextStyle(
                          fontFamily: "ComicRelief",
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  const Divider(color: Colors.black12),

                  const SizedBox(height: 20),

                  Text(
                    post['content'] ?? 'Tidak ada isi.',
                    style: const TextStyle(
                      fontFamily: "ComicRelief",
                      fontSize: 16,
                      color: Colors.black87,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
