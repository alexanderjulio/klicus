/**
 * KLICUS Image Service
 * Optimized image handling for ad banners and galleries using WebP tech.
 */

import sharp from 'sharp';
import path from 'path';
import fs from 'fs/promises';

// Local directory for ad image storage
const UPLOAD_DIR = path.join(process.cwd(), 'public/uploads/ads');

/**
 * Processes a raw buffer, converts to WebP, and saves locally.
 * @param {Buffer} fileBuffer - The image file buffer from form submission
 * @param {string} fileName - Original file name for reference
 * @returns {Promise<string>} - The public URL to access the processed image
 */
export async function processAdImage(fileBuffer, fileName) {
  try {
    // Ensure directory exists
    await fs.mkdir(UPLOAD_DIR, { recursive: true });

    // Generate unique optimized filename
    const newFileName = `${path.parse(fileName).name}-${Date.now()}.webp`;
    const outputPath = path.join(UPLOAD_DIR, newFileName);

    // Sharp processing: resizing and WebP conversion
    await sharp(fileBuffer)
      .resize(1200, 800, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .webp({ quality: 80 })
      .toFile(outputPath);

    return `/uploads/ads/${newFileName}`;
  } catch (error) {
    console.error('Error procesando imagen:', error);
    throw new Error('No se pudo procesar la imagen');
  }
}
