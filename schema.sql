/**
 * KLICUS DATABASE MASTER SCHEMA
 * System for high-performance localized advertising.
 * Version: 1.0 (PROD-READY)
 * Includes: Roles, Profiles (Admin preserved), Categories, Ads, Metrics, Billings, Settings.
 */

-- 1. Roles: Dynamic permission levels
CREATE TABLE IF NOT EXISTS roles (
  id VARCHAR(50) PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  color VARCHAR(50) DEFAULT 'gray',
  description TEXT,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO roles (id, name, color, description) VALUES 
('admin', 'Administrador', '#FFD700', 'Poder total sobre la plataforma'),
('anunciante', 'Anunciante', '#F59E0B', 'Usuarios profesionales con capacidad de publicar'),
('cliente', 'Cliente', '#94A3B8', 'Usuario estándar de la red')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 2. Profiles: Authentication & Identity
CREATE TABLE IF NOT EXISTS profiles (
  id VARCHAR(255) PRIMARY KEY,
  email VARCHAR(255) UNIQUE NOT NULL,
  full_name VARCHAR(255) NOT NULL,
  business_name VARCHAR(255),
  avatar_url VARCHAR(255),
  banner_url TEXT,
  bio TEXT,
  role VARCHAR(50) DEFAULT 'cliente',
  password_hash VARCHAR(255) NOT NULL,
  plan_type VARCHAR(50) DEFAULT 'Basic',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  FOREIGN KEY (role) REFERENCES roles(id)
);

-- Preserve Current Administrator (Alexander Julio)
INSERT INTO profiles (id, email, full_name, role, password_hash, plan_type) 
VALUES (
  '44bcac40-5c86-44d6-8cfd-44ae50574580', 
  'alexjuliosanchez@gmail.com', 
  'Alexander Julio', 
  'admin', 
  '$2b$12$6UUkYSMYSaycnWc/q18unOkLIvgGo1nA2pnaXmLdPGRhjn1IFfP66', 
  'Premium'
)
ON DUPLICATE KEY UPDATE email=VALUES(email);

-- 3. Categories: Marketplace segments
CREATE TABLE IF NOT EXISTS categories (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  slug VARCHAR(100) UNIQUE NOT NULL,
  icon VARCHAR(50), 
  active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO categories (id, name, slug, icon) VALUES 
(1, 'Tecnología', 'tecnologia', 'Smartphone'),
(2, 'Hogar', 'hogar', 'Home'),
(3, 'Servicios', 'servicios', 'Tool')
ON DUPLICATE KEY UPDATE name=VALUES(name);

-- 4. Advertisements: Core Products
CREATE TABLE IF NOT EXISTS advertisements (
  id VARCHAR(255) PRIMARY KEY,
  owner_id VARCHAR(255) NOT NULL,
  category_id INT NOT NULL,
  title VARCHAR(255) NOT NULL,
  description TEXT NOT NULL,
  image_urls JSON,                   -- Local WebP file paths
  priority_level ENUM('basic', 'pro', 'diamond') DEFAULT 'basic',
  status ENUM('pending', 'active', 'paused', 'expired', 'rejected') DEFAULT 'pending',
  rejection_reason TEXT,             -- Feedback for the advertiser
  location VARCHAR(255),
  price_range VARCHAR(255),
  clicks INT DEFAULT 0,
  impressions INT DEFAULT 0,
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  expires_at TIMESTAMP NULL,
  FOREIGN KEY (owner_id) REFERENCES profiles(id) ON DELETE CASCADE,
  FOREIGN KEY (category_id) REFERENCES categories(id)
);

-- 5. Metrics: Interaction trends
CREATE TABLE IF NOT EXISTS metrics (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ad_id VARCHAR(255) NOT NULL,
  event_type ENUM('view', 'click', 'contact') NOT NULL,
  device_type VARCHAR(50),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
);

-- 6. Billings: Mercado Pago ledger
CREATE TABLE IF NOT EXISTS billings (
  id INT AUTO_INCREMENT PRIMARY KEY,
  ad_id VARCHAR(255) NOT NULL,
  amount DECIMAL(10, 2) NOT NULL,
  currency VARCHAR(3) DEFAULT 'COP',
  status ENUM('pending', 'paid', 'failed', 'refunded') DEFAULT 'pending',
  mp_preference_id VARCHAR(255),
  external_ref VARCHAR(255),
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (ad_id) REFERENCES advertisements(id) ON DELETE CASCADE
);

-- 7. Settings: Global System Config
CREATE TABLE IF NOT EXISTS settings (
  setting_key VARCHAR(100) PRIMARY KEY,
  setting_value LONGTEXT,
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Default Settings (Example manual payments structure)
INSERT INTO settings (setting_key, setting_value) VALUES 
('manual_payments', '[]')
ON DUPLICATE KEY UPDATE setting_key=VALUES(setting_key);
