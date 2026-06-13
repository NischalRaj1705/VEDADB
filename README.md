# VedaDB — A Vector Database Built From Scratch in C++

A fully working **Vector Database** with a liquid-glass web UI, built as a
B.Tech final-year project to understand how production vector databases like
Pinecone, Weaviate, and Chroma actually work under the hood.

Implements **HNSW**, **KD-Tree**, and **Brute Force** search side-by-side, plus
a **RAG (Retrieval-Augmented Generation)** pipeline powered by a local LLM via
Ollama.

---

## ✨ Features

| Feature | Description |
|---|---|
| **3 Search Algorithms** | HNSW (production-grade), KD-Tree, Brute Force — run all three and compare speed |
| **3 Distance Metrics** | Cosine similarity, Euclidean distance, Manhattan distance |
| **16D Demo Vectors** | 20 pre-loaded semantic vectors across 4 categories (CS, Math, Food, Sports) |
| **2D PCA Scatter Plot** | Live visualization of semantic space — watch clusters form |
| **Real Document Embedding** | Paste any text → Ollama embeds it with `nomic-embed-text` (768D) |
| **RAG Pipeline** | Ask questions about your documents → HNSW retrieves context → local LLM answers |
| **Full REST API** | CRUD endpoints: insert, delete, search, benchmark, hnsw-info |
| **Liquid Glass UI** | Animated landing page + functional dashboard, single static `index.html` |

---

## 🏗 How It Works

```
Your Text
    │
    ▼
Ollama (nomic-embed-text)          ← converts text to a 768-dimensional vector
    │
    ▼
HNSW Index (C++)                   ← indexes the vector in a multilayer graph
    │
    ▼
Semantic Search                    ← finds nearest neighbors in vector space
    │
    ▼
Ollama (llama3.2)                  ← reads retrieved chunks, generates an answer
    │
    ▼
Answer
```

**HNSW (Hierarchical Navigable Small World)** builds a multilayer graph where
each layer is progressively sparser — searches start at the top layer and
zoom in, achieving ~O(log N) complexity instead of O(N) for brute force.

---

## 📁 Project Structure

```
VedaDB/
├── main.cpp        ← C++ backend (HNSW, KD-Tree, BruteForce, REST API, RAG)
├── httplib.h       ← Single-header HTTP server library (cpp-httplib)
├── index.html      ← Frontend (landing page + functional dashboard)
└── README.md       ← This file
```

---

## 💻 Run Locally

You need **g++ (C++17)** installed. Optionally **Ollama** for the
Documents/RAG tabs (the Search tab works without it).

### 1. Clone the repo

```bash
git clone https://github.com/<your-username>/VedaDB.git
cd VedaDB
```

### 2. (Optional) Install Ollama for RAG

Download from **https://ollama.com**, then:

```bash
ollama pull nomic-embed-text
ollama pull llama3.2
ollama serve
```

### 3. Compile

**Windows (MSYS2 / g++):**
```powershell
g++ -std=c++17 -O2 main.cpp -o db.exe -lws2_32
```

**Linux / macOS:**
```bash
g++ -std=c++17 -O2 main.cpp -o db -lpthread
```

### 4. Run

```bash
./db        # Linux/macOS
./db.exe    # Windows
```

You should see:
```
=== VedaDB Engine ===
http://localhost:8080
20 demo vectors | 16 dims | HNSW+KD-Tree+BruteForce
```

### 5. Open the app

Go to **http://localhost:8080** in your browser. Scroll past the landing
page and click **"Launch the Engine"** to open the dashboard.

---

## ☁️ Deploy on Render (Free Tier)

Render builds and runs the app inside a Docker container, so a `Dockerfile`
is included in this repo.

### 1. Push to GitHub

```bash
git init
git add .
git commit -m "VedaDB - vector database from scratch"
git branch -M main
git remote add origin https://github.com/<your-username>/VedaDB.git
git push -u origin main
```

### 2. Create a new Web Service on Render

1. Go to **https://dashboard.render.com** → **New** → **Web Service**
2. Connect your GitHub repo
3. Render will auto-detect the `Dockerfile` (or you can use `render.yaml`,
   included in this repo, for Blueprint deploy)
4. Settings:
   - **Environment**: Docker
   - **Plan**: Free
   - **Port**: Render auto-detects via `PORT` env var (the server listens on
     `0.0.0.0:8080` — Render maps this automatically)
5. Click **Create Web Service**

### 3. Wait for the build

First build takes ~2–3 minutes (compiling C++). Once live, Render gives you
a URL like:

```
https://vedadb.onrender.com
```

### ⚠️ Note on RAG / Ollama

Render's free tier (512MB RAM) **cannot run Ollama** (models need 3GB+ RAM).
On Render, the **Search tab** (HNSW/KD-Tree/Brute Force, 16D demo vectors,
PCA scatter plot, benchmarks) works fully. The **Documents/Ask AI tabs** will
show "Ollama: OFFLINE" — this is expected on the hosted demo. Mention in your
resume/README that the RAG pipeline runs locally with Ollama.

---

## 🔌 REST API Reference

| Method | Endpoint | Description |
|---|---|---|
| `GET` | `/search?v=f1,f2,...&k=5&metric=cosine&algo=hnsw` | K-NN search |
| `POST` | `/insert` | Insert a demo vector |
| `DELETE` | `/delete/:id` | Delete by ID |
| `GET` | `/items` | List all demo vectors |
| `GET` | `/benchmark?v=...&k=5&metric=cosine` | Compare all 3 algorithms |
| `GET` | `/hnsw-info` | HNSW graph structure and layer stats |
| `GET` | `/stats` | Database statistics |
| `POST` | `/doc/insert` | Embed and store document (`{"title":"...","text":"..."}`) |
| `GET` | `/doc/list` | List all stored documents |
| `DELETE` | `/doc/delete/:id` | Delete document chunk |
| `POST` | `/doc/ask` | RAG: retrieve + generate (`{"question":"...","k":3}`) |
| `GET` | `/status` | Ollama status and model info |

---

## 🧠 Algorithm Notes

- **Brute Force** — O(N·d), exact, the baseline
- **KD-Tree** — O(log N) average, exact, axis-aligned partitioning. Degrades
  in high dimensions (curse of dimensionality)
- **HNSW** — O(log N), approximate, multilayer navigable small-world graph.
  Same core idea used by Pinecone, Weaviate, Chroma, and Milvus

---

## 👤 Author

Built by **Your Name** — B.Tech CSE, Final Year, College Name
as a learning project on vector databases, search algorithms, and RAG.

## 📄 License

MIT — use this however you want.
