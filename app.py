# KR2: Khan
import os
import socket

import redis
from flask import Flask, request

app = Flask(__name__)

r = redis.Redis(
    host=os.getenv("REDIS_HOST", "localhost"),
    password=os.getenv("REDIS_PASSWORD") or None,
    decode_responses=True,
)
STUDENT = os.getenv("STUDENT", "unknown")


@app.get("/")
def index():
    hits = r.incr("hits")
    return f"KR2 | {STUDENT} | container {socket.gethostname()} | hits: {hits}\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


@app.get("/health")
def health():
    return "ok\n", 200, {"Content-Type": "text/plain; charset=utf-8"}


@app.get("/whoami")
def whoami():
    h = request.headers
    body = (
        f"scheme: {h.get('X-Forwarded-Proto', 'none')}\n"
        f"client: {h.get('X-Real-IP', 'none')}\n"
        f"host: {h.get('Host', 'none')}\n"
    )
    return body, 200, {"Content-Type": "text/plain; charset=utf-8"}


if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000)
