const cors = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "GET, OPTIONS",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Content-Type": "application/json; charset=utf-8"
};
const feeds = [
  { name: "BBC News Africa", url: "https://feeds.bbci.co.uk/news/world/africa/rss.xml" },
  { name: "Africanews", url: "https://www.africanews.com/feed/rss" },
  { name: "Premium Times", url: "https://www.premiumtimesng.com/feed" },
  { name: "The Guardian Africa", url: "https://www.theguardian.com/world/africa/rss" },
  { name: "France 24 Africa", url: "https://www.france24.com/en/africa/rss" }
];
let cached: { at: number; items: unknown[] } | null = null;
function clean(value: string) {
  return value.replace(/<!\[CDATA\[([\s\S]*?)\]\]>/g, "$1").replace(/<[^>]*>/g, " ")
    .replace(/&nbsp;/gi, " ").replace(/&amp;/gi, "&").replace(/&quot;/gi, '"')
    .replace(/&#39;|&apos;/gi, "'").replace(/&lt;/gi, "<").replace(/&gt;/gi, ">")
    .replace(/&#(\d+);/g, (_, n) => String.fromCodePoint(Number(n))).replace(/\s+/g, " ").trim();
}
function tag(block: string, name: string) {
  const re = new RegExp("<" + name + "(?:\\s[^>]*)?>([\\s\\S]*?)<\\/" + name + ">", "i");
  return clean(block.match(re)?.[1] || "");
}
function imageOf(block: string) {
  const raw = block.match(/<(?:media:content|media:thumbnail|enclosure)[^>]+url=["']([^"']+)["']/i)?.[1];
  return raw && /^https:\/\//i.test(raw) ? raw : null;
}
async function loadFeed(feed: { name: string; url: string }) {
  try {
    const response = await fetch(feed.url, { headers: { "User-Agent": "AdventureNews/1.0" }, signal: AbortSignal.timeout(8000) });
    if (!response.ok) return [];
    const xml = await response.text();
    const blocks = [...xml.matchAll(/<(item|entry)(?:\s[^>]*)?>([\s\S]*?)<\/\1>/gi)];
    return blocks.slice(0, 25).map(match => {
      const block = match[2];
      const linkTag = block.match(/<link[^>]+href=["']([^"']+)["'][^>]*\/?\s*>/i)?.[1];
      const link = tag(block, "link") || linkTag || tag(block, "guid");
      const title = tag(block, "title");
      const summary = tag(block, "description") || tag(block, "summary") || tag(block, "content");
      const published = tag(block, "pubDate") || tag(block, "published") || tag(block, "updated");
      if (!title || !link || !/^https:\/\//i.test(link)) return null;
      let host = ""; try { host = new URL(link).hostname.replace(/^www\./, ""); } catch { return null; }
      return { id: link, title, summary: summary.slice(0, 700), publisher: feed.name, domain: host, url: link, image: imageOf(block), published: published || null };
    }).filter(Boolean);
  } catch { return []; }
}
Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: cors });
  if (req.method !== "GET") return new Response(JSON.stringify({ error: "Method not allowed" }), { status: 405, headers: cors });
  const now = Date.now();
  if (cached && now - cached.at < 300000) return new Response(JSON.stringify({ items: cached.items, cached: true }), { headers: { ...cors, "Cache-Control": "public, max-age=120, s-maxage=300" } });
  const batches = await Promise.all(feeds.map(loadFeed));
  const seen = new Set<string>();
  const items = batches.flat().filter((item: any) => { if (!item || seen.has(item.url)) return false; seen.add(item.url); return true; })
    .sort((a: any, b: any) => (Date.parse(b.published || "") || 0) - (Date.parse(a.published || "") || 0)).slice(0, 80);
  if (items.length) cached = { at: now, items };
  return new Response(JSON.stringify({ items, cached: false, updatedAt: new Date().toISOString() }), { headers: { ...cors, "Cache-Control": "public, max-age=120, s-maxage=300" } });
});