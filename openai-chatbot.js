const http = require("http");

const port = Number(process.env.PORT || 8000);
const appApiKey = process.env.APP_API_KEY || "";
const openaiApiKey = process.env.OPENAI_API_KEY || "";
const openaiModel = process.env.OPENAI_MODEL || "gpt-4o-mini";
const baseInstructions =
  process.env.ASSISTANT_INSTRUCTIONS ||
  [
    "Sen RestoranApp icin calisan bir operasyon asistanisin.",
    "Kullanicilarla Turkce konus.",
    "Odak alanin: lisans, giris, menu, sepet, siparis, mutfak, kurye, stok, yazici, yonetim paneli ve entegrasyon ayarlari.",
    "Yaniti kisa ve uygulanabilir adimlarla ver.",
    "Restoran operasyonu disina cikan konularda nazikce sinir koy ve RestoranApp baglamina geri don.",
    "Bilmedigin konuda uydurma; net olmadiginda acikca belirt ve gerekli bilgiyi iste.",
  ].join(" ");

const json = (res, code, obj) => {
  res.writeHead(code, { "Content-Type": "application/json; charset=utf-8" });
  res.end(JSON.stringify(obj));
};

const readBody = (req) =>
  new Promise((resolve) => {
    let body = "";
    req.on("data", (c) => (body += c));
    req.on("end", () => resolve(body));
  });

const requestApiKey = (req) => {
  const auth = String(req.headers["authorization"] || "");
  const xApiKey = String(req.headers["x-api-key"] || "");
  if (xApiKey.trim()) return xApiKey.trim();
  if (auth.startsWith("Bearer ")) return auth.slice("Bearer ".length).trim();
  return "";
};

const hasValidAppKey = (req) => {
  if (!appApiKey.trim()) {
    return true;
  }
  return requestApiKey(req) === appApiKey.trim();
};

const openaiReply = async (message, source, effectiveOpenaiKey) => {
  const requestInput = [
    {
      role: "user",
      content: [
        {
          type: "input_text",
          text: `Kaynak: ${source || "bilinmiyor"}`,
        },
      ],
    },
    {
      role: "user",
      content: [
        {
          type: "input_text",
          text: message,
        },
      ],
    },
  ];

  const r = await fetch("https://api.openai.com/v1/responses", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
      Authorization: `Bearer ${effectiveOpenaiKey}`,
    },
    body: JSON.stringify({
      model: openaiModel,
      instructions: baseInstructions,
      input: requestInput,
    }),
  });

  const data = await r.json().catch(() => ({}));
  if (!r.ok) {
    const detail = data?.error?.message || `OpenAI hata kodu: ${r.status}`;
    throw new Error(detail);
  }

  const text = data?.output_text;
  if (typeof text === "string" && text.trim()) return text.trim();

  const first = data?.output?.[0]?.content?.[0]?.text;
  if (typeof first === "string" && first.trim()) return first.trim();

  return "Yanıt üretildi ama metin çözümlenemedi.";
};

const isHealth = (m, u) => m === "GET" && ["/", "/health", "/api/health"].includes(u);
const isChat = (m, u) => m === "POST" && ["/", "/chat", "/api/chat", "/chatbot", "/api/chatbot"].includes(u);

const server = http.createServer(async (req, res) => {
  const method = req.method || "GET";
  const url = req.url || "/";

  if (!hasValidAppKey(req)) {
    return json(res, 401, { error: "unauthorized" });
  }

  if (isHealth(method, url)) {
    return json(res, 200, {
      status: "ok",
      provider: "openai",
      model: openaiModel,
      keyMode: openaiApiKey.trim() ? "env" : "request-header",
    });
  }

  if (isChat(method, url)) {
    const effectiveOpenaiKey = openaiApiKey.trim() || requestApiKey(req);
    if (!effectiveOpenaiKey) {
      return json(res, 500, { error: "OPENAI_API_KEY veya istek API anahtari gerekli" });
    }

    const raw = await readBody(req);
    let message = "";
    let source = "restoran_app";
    try {
      const parsed = JSON.parse(raw || "{}");
      message = parsed.message || "";
      source = parsed.source || "restoran_app";
    } catch {
      return json(res, 400, { error: "Gecersiz JSON" });
    }

    if (!String(message).trim()) {
      return json(res, 400, { error: "message alani zorunlu" });
    }

    try {
      const reply = await openaiReply(
        String(message),
        String(source),
        effectiveOpenaiKey,
      );
      return json(res, 200, { reply });
    } catch (e) {
      return json(res, 502, { error: String(e.message || e) });
    }
  }

  return json(res, 404, { error: "not_found" });
});

server.listen(port, "0.0.0.0", () => {
  console.log(`OpenAI chatbot backend aktif: http://localhost:${port}`);
  console.log(`APP_API_KEY mode: ${appApiKey ? "strict" : "passthrough"}`);
  console.log(`OPENAI_API_KEY mode: ${openaiApiKey ? "env" : "request-header"}`);
  console.log(`OPENAI_MODEL: ${openaiModel}`);
});
