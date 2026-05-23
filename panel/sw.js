const CACHE = 'triskel-v5';
const SHELL = ['/panel/', '/panel/index.html', '/panel/alumna.html', '/panel/logo-triskel.png', '/panel/icon-192.png', '/panel/icon-512.png'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
    // No clients.claim() — evita que el SW reclame ventanas de la otra app
  );
});

// ── PUSH NOTIFICATIONS ───────────────────────────────────────────────────────
self.addEventListener('push', e => {
  let data = {};
  try { data = e.data?.json() || {}; } catch(_) {}

  const title = data.title || 'Triskel Academy';
  const options = {
    body: data.body || '',
    icon: '/panel/icon-192.png',
    badge: '/panel/icon-192.png',
    data: data.data || {},
    vibrate: [200, 100, 200],
  };
  e.waitUntil(self.registration.showNotification(title, options));
});

self.addEventListener('notificationclick', e => {
  e.notification.close();
  const url = e.notification.data?.url || '/panel/';
  e.waitUntil(
    clients.matchAll({ type: 'window', includeUncontrolled: true }).then(list => {
      const existing = list.find(c => c.url === url || c.url.startsWith(url));
      if (existing) return existing.focus();
      return clients.openWindow(url);
    })
  );
});

self.addEventListener('fetch', e => {
  // Supabase API: network-only (datos siempre frescos)
  if (e.request.url.includes('supabase.co')) return;

  const isHTML = e.request.url.endsWith('.html') || e.request.url.endsWith('/panel/') || e.request.url.endsWith('/panel');

  if (isHTML) {
    // Network-first para HTML: siempre trae la versión más nueva
    e.respondWith(
      fetch(e.request).then(res => {
        if (res.ok) caches.open(CACHE).then(c => c.put(e.request, res.clone()));
        return res;
      }).catch(() => caches.match(e.request))
    );
    return;
  }

  e.respondWith(
    caches.match(e.request).then(cached => {
      const network = fetch(e.request).then(res => {
        if (res.ok && e.request.method === 'GET') {
          caches.open(CACHE).then(c => c.put(e.request, res.clone()));
        }
        return res;
      });
      return cached || network;
    })
  );
});
