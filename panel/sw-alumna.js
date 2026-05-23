const CACHE = 'triskel-alumna-v1';
const SHELL = ['/panel/alumna.html', '/panel/logo-triskel.png', '/panel/icon-192.png', '/panel/icon-512.png'];

// Recursos externos que el SW nunca debe interceptar
const BYPASS = ['supabase.co', 'jsdelivr.net', 'googleapis.com', 'gstatic.com'];

self.addEventListener('install', e => {
  e.waitUntil(caches.open(CACHE).then(c => c.addAll(SHELL)));
  self.skipWaiting();
});

self.addEventListener('activate', e => {
  e.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(k => k !== CACHE).map(k => caches.delete(k)))
    )
  );
  // Sin clients.claim() — evita reclamar ventanas de la otra app
});

// ── PUSH NOTIFICATIONS ───────────────────────────────────────────────────────
self.addEventListener('push', e => {
  let data = {};
  try { data = e.data?.json() || {}; } catch(_) {}
  e.waitUntil(self.registration.showNotification(data.title || 'Triskel Academy', {
    body: data.body || '',
    icon: '/panel/icon-192.png',
    badge: '/panel/icon-192.png',
    data: data.data || {},
    vibrate: [200, 100, 200],
  }));
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
  const url = e.request.url;

  // Pasar directo al network: recursos externos (Supabase API, CDN, fuentes)
  if (BYPASS.some(host => url.includes(host))) return;

  const isHTML = url.endsWith('.html') || url.endsWith('/panel/') || url.endsWith('/panel');

  if (isHTML) {
    // Network-first para HTML: siempre sirve la versión más nueva
    e.respondWith(
      fetch(e.request).then(res => {
        if (res.ok) caches.open(CACHE).then(c => c.put(e.request, res.clone()));
        return res;
      }).catch(() => caches.match(e.request))
    );
    return;
  }

  // Cache-first para assets estáticos (iconos, imágenes)
  e.respondWith(
    caches.match(e.request).then(cached => {
      const network = fetch(e.request).then(res => {
        if (res.ok && e.request.method === 'GET') {
          caches.open(CACHE).then(c => c.put(e.request, res.clone()));
        }
        return res;
      }).catch(() => cached); // si falla la red, usar caché
      return cached || network;
    })
  );
});
