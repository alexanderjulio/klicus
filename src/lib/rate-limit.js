const store = new Map();

// Limpia entradas expiradas cada 10 minutos para evitar crecimiento ilimitado
setInterval(() => {
  const now = Date.now();
  for (const [key, record] of store.entries()) {
    if (now > record.resetAt) store.delete(key);
  }
}, 10 * 60 * 1000);

/**
 * Rate limiter en memoria — adecuado para procesos Node.js de instancia única (cPanel).
 * @param {string} key   - Clave única (ej: "login:127.0.0.1")
 * @param {number} limit - Máximo de intentos permitidos en la ventana
 * @param {number} windowMs - Duración de la ventana en milisegundos
 * @returns {{ allowed: boolean, remaining: number, retryAfter: number }}
 */
export function rateLimit({ key, limit, windowMs }) {
  const now = Date.now();
  const record = store.get(key);

  if (!record || now > record.resetAt) {
    store.set(key, { count: 1, resetAt: now + windowMs });
    return { allowed: true, remaining: limit - 1, retryAfter: 0 };
  }

  record.count++;

  const allowed = record.count <= limit;
  return {
    allowed,
    remaining: Math.max(0, limit - record.count),
    retryAfter: allowed ? 0 : Math.ceil((record.resetAt - now) / 1000),
  };
}

/**
 * Extrae la IP real del request, respetando proxies (cPanel/Nginx).
 * @param {Request} req
 * @returns {string}
 */
export function getClientIp(req) {
  return (
    req.headers.get('x-forwarded-for')?.split(',')[0].trim() ||
    req.headers.get('x-real-ip') ||
    'unknown'
  );
}
