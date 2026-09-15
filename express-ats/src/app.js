import express from "express";
import pool from "./db/index.js";
import cors from "cors";
import { z } from "zod";

const app = express();
const port = 4444;

app.use(express.json());

app.use(cors());


const postSchema = z.object({
  title : z.string().min(1, "Title is required,"),
  category : z.string().min(1, "Category is required"),
  content :z.string().min(1, "Content is required"),
  id_user: z.number()
});

app.get("/api/posts", async (req,res) => {
  const [posts] = await pool.query(`
    SELECT 
      p.id,
      p.id_user,
      p.id_category,
      p.title AS Judul,
      c.name AS Kategori,
      u.username,
      p.content,
      p.likes,
      p.coments,
      p.shares,
      p.created_at
    FROM posts p
    JOIN categories c ON p.id_category = c.id
    JOIN users u ON p.id_user = u.id
  `);

  res.status(200).json({
    message: "Berhasil Fetch posts",
    data: posts
  });
});

app.post("/api/posts", async (req, res) => {

  console.log(req.body);

  const result = postSchema.safeParse(req.body || {});

  if (!result.success) {
    return res.status(400).json({
      message: result.error.issues[0].message
    });
  }

  const { title, category, content, id_user } = result.data;

  const [categories] = await pool.query(
    'SELECT id FROM categories WHERE name = ?',
    [category]
  );

  if (categories.length === 0) {
    return res.status(400).json({
      message: "Category tidak ditemukan"
    });
  }

  const id_category = categories[0].id;

  await pool.query(
    'INSERT INTO posts(title, id_category, content, id_user) VALUES(?,?,?,?)',
    [title, id_category, content, id_user]
  );

  res.status(201).json({
    message: 'Blog berhasil di post!'
  });
});

app.put("/api/posts/:id", async (req, res) => {

  const result = postSchema.safeParse(req.body || {});

  if (!result.success) {
    return res.status(400).json({
      message: result.error.issues[0].message
    });
  }

  const { title, category, content, id_user } = result.data;
  const { id } = req.params;

  const [categories] = await pool.query(
    "SELECT id FROM categories WHERE name = ?",
    [category]
  );

  if (categories.length === 0) {
    return res.status(400).json({
      message: "Category tidak ditemukan"
    });
  }

  const id_category = categories[0].id;

  const [updateResult] = await pool.query(
  `UPDATE posts 
   SET title = ?, id_category = ?, content = ?
   WHERE id = ? AND id_user = ?`,
  [title, id_category, content, id, id_user]
);

if (updateResult.affectedRows === 0) {
  return res.status(403).json({
    message: "Kamu tidak bisa mengedit post milik user lain",
  });
}

res.status(200).json({
  message: "Post berhasil diperbarui",
});

});

app.delete("/api/posts/:id", async (req, res) => {
  const { id } = req.params;
  const { id_user } = req.body;

  try {
    const [result] = await pool.query(
      "DELETE FROM posts WHERE id = ? AND id_user = ?",
      [id, id_user]
    );

    if (result.affectedRows === 0) {
      return res.status(403).json({
        message: "Kamu tidak bisa menghapus post milik user lain",
      });
    }

    res.status(200).json({
      message: "Post berhasil dihapus",
    });
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Terjadi kesalahan server",
    });
  }
});

app.get("/api/categories", async (req,res) => {
  const [categories] = await pool.query(`
select * from categories
`);


   res.status(200).json({
    message: "Berhasil Fetch posts",
    data: categories
  });
})

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});

app.post("/api/login", async (req, res) => {
  const { email, password } = req.body;

  try {
    const [users] = await pool.query(
      "SELECT id, username, email FROM users WHERE email = ? AND password = ?",
      [email, password]
    );

    if (users.length === 0) {
      return res.status(401).json({
        message: "Email atau password salah",
      });
    }

    res.status(200).json({
      message: "Login berhasil",
      data: users[0],
    });
  } catch (error) {
    res.status(500).json({
      message: "Terjadi kesalahan server",
    });
  }
});

app.post("/api/register", async (req, res) => {
  const { username, email, password } = req.body;

  try {
    const [cekUser] = await pool.query(
      "SELECT id FROM users WHERE email = ? OR username = ?",
      [email, username]
    );

    if (cekUser.length > 0) {
      return res.status(400).json({
        message: "Username atau email sudah digunakan",
      });
    }

    const [result] = await pool.query(
      "INSERT INTO users (username, email, password) VALUES (?, ?, ?)",
      [username, email, password]
    );

    const [user] = await pool.query(
      "SELECT id, username, email FROM users WHERE id = ?",
      [result.insertId]
    );

    res.status(201).json({
      message: "Register berhasil",
      data: user[0],
    });
  } catch (error) {
    console.log(error);

    res.status(500).json({
      message: "Terjadi kesalahan server",
    });
  }
});

