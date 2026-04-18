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
 * Returns metadata for reference.
 */
export async function processAdImage(fileBuffer, fileName) {
  try {
    await fs.mkdir(UPLOAD_DIR, { recursive: true });

    const newFileName = `${path.parse(fileName).name}-${Date.now()}.webp`;
    const outputPath = path.join(UPLOAD_DIR, newFileName);

    const info = await sharp(fileBuffer)
      .rotate()
      .resize(1200, 800, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .webp({ quality: 80, effort: 6 })
      .toFile(outputPath);

    return {
      url: `/uploads/ads/${newFileName}`,
      width: info.width,
      height: info.height,
      size: info.size // in bytes
    };
  } catch (error) {
    console.error('Error procesando imagen de anuncio:', error);
    throw new Error('No se pudo procesar la imagen');
  }
}

const MARKETING_DIR = path.join(process.cwd(), 'public/uploads/marketing');

/**
 * Optimized processing for banner/promotional images.
 */
export async function processMarketingImage(fileBuffer, fileName) {
  try {
    await fs.mkdir(MARKETING_DIR, { recursive: true });

    const newFileName = `mkt-${path.parse(fileName).name}-${Date.now()}.webp`;
    const outputPath = path.join(MARKETING_DIR, newFileName);

    const info = await sharp(fileBuffer)
      .rotate()
      .resize(1200, 600, { // Banners are wider
        fit: 'cover',
        position: 'center'
      })
      .webp({ quality: 85, effort: 6 })
      .toFile(outputPath);

    return {
      url: `/uploads/marketing/${newFileName}`,
      width: info.width,
      height: info.height,
      size: info.size
    };
  } catch (error) {
    console.error('Error procesando imagen de marketing:', error);
    throw new Error('No se pudo procesar la imagen de marketing');
  }
}
// Local directory for QR code storage
const QR_DIR = path.join(process.cwd(), 'public/uploads/qr');

/**
 * Processes a QR image buffer, converts to WebP with high contrast, and saves locally.
 * @param {Buffer} fileBuffer - The image file buffer from form submission
 * @param {string} fileName - Original file name for reference
 * @returns {Promise<string>} - The public URL to access the QR image
 */
export async function processQRImage(fileBuffer, fileName) {
  try {
    // Ensure directory exists
    await fs.mkdir(QR_DIR, { recursive: true });

    // Generate unique optimized filename
    const newFileName = `qr-${path.parse(fileName).name}-${Date.now()}.webp`;
    const outputPath = path.join(QR_DIR, newFileName);

    // Sharp processing: resizing and WebP conversion for maximum clarity
    await sharp(fileBuffer)
      .rotate()
      .resize(600, 600, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .sharpen() // Add sharpening for easier reading by mobile devices
      .webp({ 
        quality: 100, 
        effort: 6,
        lossless: true // Use lossless for QR codes to avoid artifacting
      })
      .toFile(outputPath);

    return `/uploads/qr/${newFileName}`;
  } catch (error) {
    console.error('Error procesando QR:', error);
    throw new Error('No se pudo procesar la imagen QR');
  }
}
