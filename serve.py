import http.server
import socketserver

PORT = 8000

class LuaHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        # Menambahkan header agar file .lua dibaca sebagai teks, bukan download
        if self.path.endswith(".lua"):
            self.send_header("Content-Type", "text/plain")
            self.send_header("Cache-Control", "no-cache, no-store, must-revalidate")
        super().end_headers()

with socketserver.TCPServer(("", PORT), LuaHandler) as httpd:
    print(f"Server jalan di port {PORT} - Streaming Lua Aktif")
    httpd.serve_forever()