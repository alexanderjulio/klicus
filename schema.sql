/**
 * KLICUS DATABASE SCHEMA
 * System for high-performance localized advertising.
 * Compatible with MySQL 8.x.
 */

-- 1. Profiles: Core identity of Professionals and Businesses
CREATE TABLE IF NOT EXISTS profiles (
  id VARCHAR(255) PRIMARY KEY,      -- Unique identifier (UUID)
  full_name VARCHAR(255) NOT NULL,  -- Personal name of the owner
  business_name VARCHAR(255),       -- Public brand name
  avatar_url VARCHAR(255),          -- Cloud or local path to profile image
  banner_url TEXT,                  -- Profile background banner
  bio TEXT,                         -- Professional biography/description
  social_links JSON,                -- Dynamic storage for Facebook, Instagram, etc.
  role ENUM('admin', 'professional', 'business') DEFAULT 'professional',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Categories: Market segments (Tech, Health, etc.)
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL, -- URL-friendly identifier
  icon VARCHAR(50),                  -- Lucide icon name matching
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Advertisements: The core product (Pautas)
CREATE TABLE IF NOT EXISTS advertisements (
  id VARCHAR(255) PRIMARY KEY,
  owner_id VARCHAR(255) NOT NULL,
  category_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  image_urls JSON,                   -- Local WebP file paths (up to 5 images)
  priority_level ENUM('basic', 'pro', 'diamond') DEFAULT 'basic',
  status ENUM('pending', 'active', 'paused', 'expired') DEFAULT 'pending', -- Managed by Admin
  location VARCHAR(255),             -- Geographical description
  price_range VARCHAR(255),          -- Customer-facing price estimate
  clicks INT DEFAULT 0,              -- Performance metric
  impressions INT DEFAULT 0,         -- Visibility metric
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NULL,
  FOREIGN KEY (owner_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 4. Metrics: Track interaction trends over time
CREATE TABLE IF NOT EXISTS metrics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ad_id VARCHAR(255) NOT NULL,
  event_type ENUM('view', 'click', 'contact') NOT NULL,
  device_type VARCHAR(50),           -- Mobile, Desktop, PWA
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
);

-- 5. Billings: Financial ledger connected to Mercado Pago
CREATE TABLE IF NOT EXISTS billings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ad_id VARCHAR(255) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,    -- Amount in COP
  currency VARCHAR(3) DEFAULT 'COP',
  status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
  mp_preference_id VARCHAR(255),     -- Mercado Pago internal reference
  external_ref VARCHAR(255),         -- Our internal tracking ID
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
);
