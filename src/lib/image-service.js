/**
 * KLICUS Image Service
 * Optimized image handling using WebP + Firebase Storage in production.
 * Falls back to local disk when FIREBASE_STORAGE_BUCKET is not set (dev).
 */

import sharp from 'sharp';
import path from 'path';

// Limit libvips thread usage to avoid CloudLinux nproc limits
sharp.concurrency(1);
import fs from 'fs/promises';
import admin from './firebase-admin.js';

// ─── Firebase Storage helper ──────────────────────────────────────────────────

async function uploadToFirebase(buffer, storagePath, contentType = 'image/webp') {
  const bucket = admin.storage().bucket(process.env.FIREBASE_STORAGE_BUCKET);
  const file = bucket.file(storagePath);
  await file.save(buffer, { metadata: { contentType }, resumable: false });
  const encoded = encodeURIComponent(storagePath);
  return `https://firebasestorage.googleapis.com/v0/b/${process.env.FIREBASE_STORAGE_BUCKET}/o/${encoded}?alt=media`;
}

const useFirebase = () => !!process.env.FIREBASE_STORAGE_BUCKET;

// ─── Local disk helper ────────────────────────────────────────────────────────

const LOCAL_BASE = path.join(process.cwd(), 'public/uploads');

async function saveLocally(buffer, subDir, fileName) {
  const dir = path.join(LOCAL_BASE, subDir);
  await fs.mkdir(dir, { recursive: true });
  const outputPath = path.join(dir, fileName);
  await fs.writeFile(outputPath, buffer);
  return `/uploads/${subDir}/${fileName}`;
}

// ─── Public API ───────────────────────────────────────────────────────────────

/**
 * Process ad image and save to Firebase Storage (prod) or local disk (dev).
 */
export async function processAdImage(fileBuffer, fileName) {
  try {
    const newFileName = `${path.parse(fileName).name}-${Date.now()}.webp`;

    const buffer = await sharp(fileBuffer)
      .rotate()
      .resize(1200, 800, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality: 80, effort: 4 })
      .toBuffer();

    let url;
    if (useFirebase()) {
      try {
        url = await uploadToFirebase(buffer, `ads/${newFileName}`);
      } catch (fbErr) {
        console.error('Firebase upload failed, falling back to local:', fbErr.message);
        url = await saveLocally(buffer, 'ads', newFileName);
      }
    } else {
      url = await saveLocally(buffer, 'ads', newFileName);
    }

    return { url };
  } catch (error) {
    console.error('Error procesando imagen de anuncio:', error);
    throw new Error('No se pudo procesar la imagen');
  }
}

/**
 * Process interstitial (full-screen) image — preserves original aspect ratio.
 */
export async function processInterstitialImage(fileBuffer, fileName) {
  try {
    const newFileName = `interstitial-${path.parse(fileName).name}-${Date.now()}.webp`;

    const buffer = await sharp(fileBuffer)
      .rotate()
      .resize(1080, 1920, { fit: 'inside', withoutEnlargement: true })
      .webp({ quality: 85, effort: 4 })
      .toBuffer();

    let url;
    if (useFirebase()) {
      try {
        url = await uploadToFirebase(buffer, `marketing/${newFileName}`);
      } catch (fbErr) {
        console.error('Firebase upload failed, falling back to local:', fbErr.message);
        url = await saveLocally(buffer, 'marketing', newFileName);
      }
    } else {
      url = await saveLocally(buffer, 'marketing', newFileName);
    }

    return { url };
  } catch (error) {
    console.error('Error procesando imagen intersticial:', error);
    throw new Error('No se pudo procesar la imagen intersticial');
  }
}

/**
 * Process marketing/banner image.
 */
export async function processMarketingImage(fileBuffer, fileName) {
  try {
    const newFileName = `mkt-${path.parse(fileName).name}-${Date.now()}.webp`;

    const buffer = await sharp(fileBuffer)
      .rotate()
      .resize(1200, 600, { fit: 'cover', position: 'center' })
      .webp({ quality: 85, effort: 4 })
      .toBuffer();

    let url;
    if (useFirebase()) {
      try {
        url = await uploadToFirebase(buffer, `marketing/${newFileName}`);
      } catch (fbErr) {
        console.error('Firebase upload failed, falling back to local:', fbErr.message);
        url = await saveLocally(buffer, 'marketing', newFileName);
      }
    } else {
      url = await saveLocally(buffer, 'marketing', newFileName);
    }

    return { url };
  } catch (error) {
    console.error('Error procesando imagen de marketing:', error);
    throw new Error('No se pudo procesar la imagen de marketing');
  }
}

/**
 * Process QR image.
 */
export async function processQRImage(fileBuffer, fileName) {
  try {
    const newFileName = `qr-${path.parse(fileName).name}-${Date.now()}.webp`;

    const buffer = await sharp(fileBuffer)
      .rotate()
      .resize(600, 600, { fit: 'inside', withoutEnlargement: true })
      .sharpen()
      .webp({ quality: 100, effort: 4, lossless: true })
      .toBuffer();

    let url;
    if (useFirebase()) {
      try {
        url = await uploadToFirebase(buffer, `qr/${newFileName}`);
      } catch (fbErr) {
        console.error('Firebase upload failed, falling back to local:', fbErr.message);
        url = await saveLocally(buffer, 'qr', newFileName);
      }
    } else {
      url = await saveLocally(buffer, 'qr', newFileName);
    }

    return url;
  } catch (error) {
    console.error('Error procesando QR:', error);
    throw new Error('No se pudo procesar la imagen QR');
  }
}
