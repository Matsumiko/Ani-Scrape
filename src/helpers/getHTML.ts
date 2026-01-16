import errorinCuy from "./errorinCuy.js";
import sanitizeHtml from "sanitize-html";

export const userAgent =
  "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36";

export default async function getHTML(
  baseUrl: string,
  pathname: string,
  ref?: string,
  sanitize = false
): Promise<string> {
  const finalPath = pathname.startsWith("/") ? pathname.slice(1) : pathname;
  const url = new URL(finalPath, baseUrl.endsWith("/") ? baseUrl : `${baseUrl}/`);

  const headers: Record<string, string> = {
    "User-Agent": userAgent,
    "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,image/apng,*/*;q=0.8,application/signed-exchange;v=b3;q=0.7",
    "Accept-Language": "id-ID,id;q=0.9,en-US;q=0.8,en;q=0.7",
    "Accept-Encoding": "gzip, deflate, br", // Mendukung kompresi
    "Upgrade-Insecure-Requests": "1",
    "Cache-Control": "max-age=0",
    
    // Header Penyamaran Tingkat Lanjut (Sec-*)
    "Sec-Ch-Ua": '"Not_A Brand";v="8", "Chromium";v="120", "Google Chrome";v="120"',
    "Sec-Ch-Ua-Mobile": "?0",
    "Sec-Ch-Ua-Platform": '"Windows"',
    "Sec-Fetch-Dest": "document",
    "Sec-Fetch-Mode": "navigate",
    "Sec-Fetch-Site": "same-origin", // Pura-pura klik dari dalam situs
    "Sec-Fetch-User": "?1",
    "Connection": "keep-alive"
  };

  // Referer Logic
  headers["Referer"] = ref
    ? ref.startsWith("http")
      ? ref
      : new URL(ref, baseUrl).toString()
    : baseUrl;

  try {
    // Debug: Cek URL yang mau ditembak
    // console.log(`[DEBUG] Fetching: ${url.toString()}`);

    const response = await fetch(url, { headers, redirect: "follow" });

    // Cek apakah terjadi Redirect ke URL lain?
    if (response.url !== url.toString()) {
        console.log(`[REDIRECT DETECTED] ${url.toString()} -> ${response.url}`);
    }

    // Handle Error Status Khusus
    if (response.status === 403) {
      errorinCuy(
        403,
        `Akses Ditolak (403). Kemungkinan IP VPS kena blacklist Cloudflare atau User-Agent terdeteksi bot.`
      );
    }

    if (!response.ok) {
      // baca body-nya dikit barangkali ada pesan error dari servernya
      const errText = await response.text().catch(() => "No content");
      console.error(`[ERROR RESPONSE BODY]: ${errText.slice(0, 200)}...`); // Print 200 huruf pertama error
      
      errorinCuy(response.status, `Server Error: ${response.statusText} pada URL: ${response.url}`);
    }

    const html = await response.text();

    if (!html || !html.trim()) errorinCuy(404, "HTML kosong dari source");

    if (!sanitize) return html;

    return sanitizeHtml(html, {
      allowedTags: [
        "address","article","aside","footer","header","h1","h2","h3","h4","h5","h6",
        "main","nav","section","blockquote","div","dl","figcaption","figure","hr","li",
        "ol","p","pre","ul","a","abbr","b","br","code","data","em","i","mark","span",
        "strong","sub","sup","time","u","img","table","tbody","td","th","thead","tr"
      ],
      allowedAttributes: {
        a: ["href", "name", "target", "title"],
        img: ["src", "alt", "title"],
        "*": ["class", "id", "style"], // Kadang style perlu buat info hidden
      },
      allowedSchemes: ['http', 'https', 'data']
    });

  } catch (err: any) {
    // Tangkap error jaringan (DNS failed, Timeout, dll)
    errorinCuy(500, `Network Error: ${err.message}`);
    return ""; // Unreachable karena errorinCuy nge-throw
  }
}