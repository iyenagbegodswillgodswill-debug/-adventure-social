const CACHE_NAME = "adventure-preview-v29";
const APP_SHELL = [
  "./",
  "./index.html",
  "./admin.html",
  "./admin-manifest.webmanifest",
  "./assets/adventure-admin-icon.svg",
  "./account.html",
  "./messages.html",
  "./news.html",
  "./marketplace.html",
  "./discover.html",
  "./music.html",
  "./studio.html",
  "./photo-studio.html",
  "./art-house.html",
  "./notifications.html",
  "./support.html",
  "./policies.html",
  "./settings.html",
  "./adventure-theme.css",
  "./adventure-theme.js",
  "./manifest.webmanifest",
  "./assets/adventure-icon.svg"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then(cache => cache.addAll(APP_SHELL))
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys()
      .then(keys => Promise.all(
        keys.filter(key => key !== CACHE_NAME).map(key => caches.delete(key))
      ))
      .then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  if (event.request.method !== "GET") return;
  const url = new URL(event.request.url);
  if (url.origin !== self.location.origin) return;

  if (event.request.mode === "navigate") {
    event.respondWith(
      fetch(event.request).catch(async () => (await caches.match(event.request, { ignoreSearch: true })) || caches.match("./index.html"))
    );
    return;
  }

  event.respondWith(
    caches.match(event.request).then(cached => cached || fetch(event.request))
  );
});
