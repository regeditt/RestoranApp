# Online Siparis Kanali Entegrasyon Gecidi

Bu dokuman, `tool/online_siparis_entegrasyon_gecidi.dart` dosyasi ile gelen
Yemeksepeti / Getir / Trendyol webhook siparislerini tek formata ceviren
gecidi anlatir.

## Amac

- Farkli platformlardan gelen siparisleri tek JSON formata cevirmek.
- Bekleyen siparisleri tek yerden okumak.
- Uygulama tarafinda `kaynak` alani ile kanal bazli takip yapmak.

## Baslatma

PowerShell:

```powershell
$env:YEMEKSEPETI_WEBHOOK_SECRET="ys_secret"
$env:GETIR_WEBHOOK_SECRET="getir_secret"
$env:TRENDYOL_WEBHOOK_SECRET="trendyol_secret"
dart run tool/online_siparis_entegrasyon_gecidi.dart
```

Varsayilan adres:

- `http://127.0.0.1:8787`

Opsiyonel ortam degiskenleri:

- `INTEGRATION_GATEWAY_HOST` (varsayilan `127.0.0.1`)
- `INTEGRATION_GATEWAY_PORT` (varsayilan `8787`)
- `INTEGRATION_GATEWAY_DATA_DIR` (varsayilan `integration_gateway/data`)
- `ONLINE_WEBHOOK_SECRETS_JSON` (dinamik saglayici secret haritasi)

`ONLINE_WEBHOOK_SECRETS_JSON` ornegi:

```json
{
  "yemeksepeti": "ys_secret",
  "getir": "getir_secret",
  "trendyol": "trendyol_secret",
  "ubereats": "uber_secret"
}
```

Not: Geriye donuk uyum icin `YEMEKSEPETI_WEBHOOK_SECRET`,
`GETIR_WEBHOOK_SECRET`, `TRENDYOL_WEBHOOK_SECRET` degiskenleri halen
desteklenir.

## Endpointler

- `GET /health`
- `POST /webhook/yemeksepeti`
- `POST /webhook/getir`
- `POST /webhook/trendyol`
- `POST /webhook/{saglayiciKodu}` (dinamik saglayici)
- `GET /api/orders/pending`
- `POST /api/orders/ack`

## Imza Dogrulama

Her webhook isteginde imza zorunludur.

Desteklenen basliklar:

- Yemeksepeti: `x-signature`, `x-yemeksepeti-signature`
- Getir: `x-signature`, `x-getir-signature`
- Trendyol: `x-signature`, `x-trendyol-signature`
- Dinamik saglayici: `x-signature`, `x-<saglayiciKodu>-signature`

Algoritma:

- `HMAC-SHA256(secret, raw_body)`
- Imza hem `hex` hem `base64` olarak kabul edilir.

## Test Ornegi

```powershell
$body = '{"order":{"id":"abc-1001","totalPrice":245.5,"items":[{"name":"Burger","quantity":1,"unitPrice":245.5}]},"customer":{"name":"Ali","phone":"5550000000"},"delivery":{"address":"Ornek Mah. 1"}}'
$secret = "ys_secret"
$hmac = New-Object System.Security.Cryptography.HMACSHA256
$hmac.Key = [Text.Encoding]::UTF8.GetBytes($secret)
$bytes = [Text.Encoding]::UTF8.GetBytes($body)
$sigBytes = $hmac.ComputeHash($bytes)
$signature = -join ($sigBytes | ForEach-Object { $_.ToString("x2") })

Invoke-RestMethod `
  -Method Post `
  -Uri "http://127.0.0.1:8787/webhook/yemeksepeti" `
  -Headers @{ "x-signature" = $signature } `
  -ContentType "application/json" `
  -Body $body
```

## Bekleyen Siparisleri Okuma

```powershell
Invoke-RestMethod -Method Get -Uri "http://127.0.0.1:8787/api/orders/pending"
```

## Siparis Onaylama

```powershell
$ackBody = '{"ids":["yemeksepeti_abc-1001"]}'
Invoke-RestMethod `
  -Method Post `
  -Uri "http://127.0.0.1:8787/api/orders/ack" `
  -ContentType "application/json" `
  -Body $ackBody
```

## Veri Dosyalari

Varsayilan konum: `integration_gateway/data`

- `pending_orders.json`: Henuz uygulama tarafinda onaylanmamis siparisler.
- `order_events.jsonl`: Olay gunlugu (yeni siparis, onay vb).
