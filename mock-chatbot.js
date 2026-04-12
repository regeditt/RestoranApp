const http = require("http");

const port = 8000;
const apiKey = process.env.CHATBOT_API_KEY || "restoran-test-key-123";

const ok = (res, obj) => {
  res.writeHead(200, { "Content-Type": "application/json" });
  res.end(JSON.stringify(obj));
};

const unauthorized = (res) => {
  res.writeHead(401, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "unauthorized" }));
};

const hasValidApiKey = (req) => {
  const auth = req.headers["authorization"] || "";
  const xApiKey = req.headers["x-api-key"] || "";
  if (typeof xApiKey === "string" && xApiKey.trim() === apiKey) {
    return true;
  }
  if (typeof auth === "string" && auth.trim() === `Bearer ${apiKey}`) {
    return true;
  }
  return false;
};

const server = http.createServer((req, res) => {
  const url = req.url || "/";

  if (req.method === "GET" && (url === "/" || url === "/health" || url === "/api/health")) {
    if (!hasValidApiKey(req)) {
      return unauthorized(res);
    }
    return ok(res, { status: "ok" });
  }

  if (req.method === "POST" && ["/", "/chat", "/api/chat", "/chatbot", "/api/chatbot"].includes(url)) {
    if (!hasValidApiKey(req)) {
      return unauthorized(res);
    }

    let body = "";
    req.on("data", (c) => {
      body += c;
    });
    req.on("end", () => {
      let msg = "";
      try {
        msg = JSON.parse(body || "{}").message || "";
      } catch {}
      return ok(res, { reply: `Yerel backend yaniti: ${msg}` });
    });
    return;
  }

  res.writeHead(404, { "Content-Type": "application/json" });
  res.end(JSON.stringify({ error: "not_found" }));
});

server.listen(port, "0.0.0.0", () => {
  console.log(`Chatbot backend aktif: http://localhost:${port}`);
  console.log(`API key: ${apiKey}`);
});
