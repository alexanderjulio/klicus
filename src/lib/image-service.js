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

    // Sharp processing: resizing and WebP conversion with advanced optimizations
    await sharp(fileBuffer)
      .rotate() // Auto-rotate based on EXIF orientation (essential for mobile uploads)
      .resize(1200, 800, {
        fit: 'inside',
        withoutEnlargement: true
      })
      .webp({ 
        quality: 80, 
        effort: 6,
        smartSubsample: true,
        lossless: false
      })
      .withMetadata(false) // Strip all EXIF data for privacy and size reduction
      .toFile(outputPath);

    return `/uploads/ads/${newFileName}`;
  } catch (error) {
    console.error('Error procesando imagen:', error);
    throw new Error('No se pudo procesar la imagen');
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
