export const runtime = 'nodejs';

import { NextResponse } from 'next/server';
import { rateLimit, getClientIp } from '@/lib/rate-limit';

const ALLOWED_ORIGINS = (process.env.ALLOWED_ORIGINS || 'http://localhost:3000')
  .split(',')
  .map(o => o.trim())
  .filter(Boolean);

const CORS_HEADERS = {
  'Access-Control-Allow-Methods': 'GET,DELETE,PATCH,POST,PUT,OPTIONS',
  'Access-Control-Allow-Headers':
    'X-CSRF-Token, X-Requested-With, Accept, Accept-Version, Content-Length, Content-MD5, Content-Type, Date, X-Api-Version, Authorization, X-Guest-ID, X-Guest-Name',
  'Access-Control-Max-Age': '86400',
};

// Rutas con rate limiting y sus límites
// key: path prefix, limit: intentos, windowMs: ventana en ms
const RATE_LIMIT_RULES = [
  { path: '/api/auth/login',      limit: 5,  windowMs: 15 * 60 * 1000 }, // 5 / 15 min
  { path: '/api/auth/register',   limit: 3,  windowMs: 60 * 60 * 1000 }, // 3 / hora
  { path: '/api/auth/callback',   limit: 10, windowMs: 10 * 60 * 1000 }, // 10 / 10 min (NextAuth web login)
];

export function middleware(request) {
  const { pathname } = request.nextUrl;
  const ip = getClientIp(request);

  // Rate limiting — solo en requests POST a rutas de autenticación
  if (request.method === 'POST') {
    for (const rule of RATE_LIMIT_RULES) {
      if (pathname.startsWith(rule.path)) {
        const { allowed, retryAfter } = rateLimit({
          key: `${rule.path}:${ip}`,
          limit: rule.limit,
          windowMs: rule.windowMs,
        });
        if (!allowed) {
          return NextResponse.json(
            { error: 'Demasiados intentos. Por favor espera antes de volver a intentarlo.' },
            { status: 429, headers: { 'Retry-After': String(retryAfter) } }
          );
        }
        break;
      }
    }
  }

  // CORS
  const origin = request.headers.get('origin');
  const originAllowed = origin && (ALLOWED_ORIGINS.includes(origin) || origin.startsWith('http://localhost:'));

  if (request.method === 'OPTIONS') {
    const preflight = new NextResponse(null, { status: 200 });
    if (originAllowed) {
      preflight.headers.set('Access-Control-Allow-Origin', origin);
      preflight.headers.set('Access-Control-Allow-Credentials', 'true');
      preflight.headers.set('Vary', 'Origin');
    }
    Object.entries(CORS_HEADERS).forEach(([k, v]) => preflight.headers.set(k, v));
    return preflight;
  }

  const response = NextResponse.next();

  if (originAllowed) {
    response.headers.set('Access-Control-Allow-Origin', origin);
    response.headers.set('Access-Control-Allow-Credentials', 'true');
    response.headers.set('Vary', 'Origin');
  }

  return response;
}

export const config = {
  matcher: '/api/:path*',
};
