var cacheName = 'polygrid-pwa';
var filesToCache = [
  './',
  './index.html',
  './polygrid-app-{{ POLYGRID_APP_HASH }}.js',
  './polygrid-app-{{ POLYGRID_APP_HASH }}_bg.wasm',
];

/* Start the service worker and cache all of the app's content */
self.addEventListener('install', function (e) {
  e.waitUntil(
    caches.open(cacheName).then(function (cache) {
      return cache.addAll(filesToCache);
    })
  );
});

/* Serve cached content when offline only */
self.addEventListener('fetch', function (e) {
  e.respondWith(
    fetch(e.request)
      .then((networkResponse) => {
        return caches.open(currentCache).then((cache) => {
          cache.put(e.request, networkResponse.clone());
          return networkResponse;
        })
      })
      .catch(() => {
        return caches.match(e.request);
      })
  );
});
