/**
 * KLICUS API Utilities
 * Standardization for multi-platform communication (Web & Flutter)
 */

import { NextResponse } from 'next/server';

/**
 * Universal API Response Formatter
 * @param {boolean} success - Operation status
 * @param {any} data - Payload to send
 * @param {string} error - Error message if applicable
 * @param {number} status - HTTP status code
 */
export function apiResponse({ success = true, data = null, error = null, status = 200 }) {
  return NextResponse.json(
    {
      success,
      data,
      error,
      timestamp: new Date().toISOString(),
      apiVersion: '1.0'
    },
    { status }
  );
}

/**
 * Common Error Responses
 */
export const ApiError = {
  unauthorized: (msg = 'No autorizado') => 
    apiResponse({ success: false, error: msg, status: 401 }),
    
  notFound: (msg = 'Recurso no encontrado') => 
    apiResponse({ success: false, error: msg, status: 404 }),
    
  badRequest: (msg = 'Petición inválida') => 
    apiResponse({ success: false, error: msg, status: 400 }),
    
  serverError: (msg = 'Error interno del servidor') => 
    apiResponse({ success: false, error: msg, status: 500 }),
};
