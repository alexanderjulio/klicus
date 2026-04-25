-- Structure for advertisements
CREATE TABLE `advertisements` (
  `id` char(36) NOT NULL,
  `owner_id` char(36) DEFAULT NULL,
  `category_id` bigint(20) DEFAULT NULL,
  `title` varchar(255) NOT NULL,
  `description` text DEFAULT NULL,
  `image_urls` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`image_urls`)),
  `priority_level` varchar(20) DEFAULT 'basic',
  `status` varchar(20) DEFAULT 'pending',
  `location` varchar(255) DEFAULT NULL,
  `price_range` varchar(100) DEFAULT NULL,
  `contact_info` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`contact_info`)),
  `expires_at` datetime DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `address` varchar(255) DEFAULT NULL,
  `phone` varchar(255) DEFAULT NULL,
  `cellphone` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  `website_url` varchar(255) DEFAULT NULL,
  `facebook_url` varchar(255) DEFAULT NULL,
  `instagram_url` varchar(255) DEFAULT NULL,
  `business_hours` varchar(255) DEFAULT NULL,
  `delivery_info` varchar(255) DEFAULT NULL,
  `is_offer` tinyint(1) DEFAULT 0,
  `rejection_reason` text DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `owner_id` (`owner_id`),
  KEY `category_id` (`category_id`),
  CONSTRAINT `advertisements_ibfk_1` FOREIGN KEY (`owner_id`) REFERENCES `profiles` (`id`) ON DELETE CASCADE,
  CONSTRAINT `advertisements_ibfk_2` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for advertisements
INSERT INTO advertisements (id, owner_id, category_id, title, description, image_urls, priority_level, status, location, price_range, contact_info, expires_at, created_at, address, phone, cellphone, email, website_url, facebook_url, instagram_url, business_hours, delivery_info, is_offer, rejection_reason) VALUES
('09b30f00-769b-487c-8405-5beef0d45611', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Habitar Inmobiliaria + Arquitectura', 'Diseño Arquitectónico Urbano, Construcción, Avalúos, Legalización de predios, Arriendos y venta de inmuebles.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3153112744
📞 Teléfono: 3178531108
📘 Facebook: https://www.facebook.com/Inmobiliaria-Arquitectura-Habitar-1719808914952382/
🌐 Web: http://klicus.com/habitar.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_habitar.jpg?alt=media&token=4354cf0c-9383-4dc6-b34f-36727db0c012","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_habitar.jpg?alt=media&token=4354cf0c-9383-4dc6-b34f-36727db0c012","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_habitar.jpg?alt=media&token=4354cf0c-9383-4dc6-b34f-36727db0c012"]', 'diamond', 'active', 'CC City Gold Local 219 - Centro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3178531108', '3153112744', NULL, 'http://klicus.com/habitar.php', 'https://www.facebook.com/Inmobiliaria-Arquitectura-Habitar-1719808914952382/', NULL, NULL, NULL, 0, NULL),
('0c6f7761-c6a7-4016-af51-92fe6e13bcfa', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Asadero Donde Leo', 'Deleita tu paladar con la comida Santandereana

	Churrasco
	Robalo
	Pepitoria
	Sobrebarriga a la Brasa
	Carne Oreada
	Arroz con Pollo
	Colombinas de Pollo Apanadas
	Cabro Asado
	Mojarra Frita
	Picada Mixta
	Cazuela de Frijol
	Sancocho

Disfruta en familia de nuestra gastronomía todos los días, también alquilamos nuestras instalaciones para todo tipo de eventos sociales.

Tenemos venta de Postres y Aguacates.

El mejor sabor Santandereano en Ocaña

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3155073961
📞 Teléfono: 0375624892
📘 Facebook: https://www.facebook.com/Asadero-Donde-Leo-618331958232851/?ref=br_rs', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasaderodondeleo%2F1.jpg?alt=media&token=03b95f79-47cc-4ee2-bb31-723c5e830be1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasaderodondeleo%2F17.jpg?alt=media&token=bf2344fb-32c0-4f93-a984-2f9bece68ba4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasaderodondeleo%2F2.jpg?alt=media&token=3cc110ea-f77d-4373-b99a-ee5a8ca7853f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasaderodondeleo%2F3.jpg?alt=media&token=59ba78da-00f1-4895-8a6f-648abc8aafb9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasaderodondeleo%2F4.jpg?alt=media&token=989476ff-8fa4-41f4-b7ca-a6c790122eb9"]', 'diamond', 'active', 'Cra 7 No. 16a-38 Barrio Los Almendros', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375624892', '3155073961', NULL, NULL, 'https://www.facebook.com/Asadero-Donde-Leo-618331958232851/?ref=br_rs', NULL, NULL, NULL, 0, NULL),
('0eac42c3-0f5b-48ba-ae98-50766ee8b404', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Comercial Ballesteros', 'Créditos para su hogar en muebles y electrodomésticos

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3502913448', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fballesteros%2Flogo.jpeg?alt=media&token=52d2b1e7-29fd-48a5-9654-c3e3a77b6101","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fballesteros%2F1.jpeg?alt=media&token=01399a71-a952-4adf-a9e8-80fc399d2a65","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fballesteros%2F2.jpeg?alt=media&token=e63320bb-3971-4198-8639-a4d2588f2220","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fballesteros%2F3.jpeg?alt=media&token=727c468b-1eef-4593-ba4a-c44611d5d34d"]', 'diamond', 'active', 'Cra 48 # 4-41 Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, NULL, '3502913448', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('121239c3-dd92-46b0-94c7-73fcea4a43ba', '44bcac40-5c86-44d6-8cfd-44ae50574580', 3, 'Efectus Producciones', 'TARIMAS: Variedad de tamaños desde 2x2 mts hasta 12x12 mts. 
CARPAS Y ESTRUCTURAS: Lonas a 2 aguas en Truss de aluminio y estructura Leyers. 
ILUMINACION: Luces de ultima tecnología de diferentes marcas, entre ellas, Bigdipper, Beam, Avolites, M-PC. 
VIDEO: Pantalla LED de 3x2 mts, Video Beam y telones, circuito cerrado de TV a 4 cámaras. 
SISTEMA ELECTRICO: Contamos con una planta eléctrica de 75 Kva. 
SONIDO: Sistema Line Array, cabinas 3215 y G12, SoundKing a 3 vías, Sub 18x12 RCF, sistema activo en monitores y Yorkville, consolas Yamaha Ls9, allen y Head Qu32

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3163060703
📘 Facebook: https://www.facebook.com/Efectus-Producciones-389920697811115/
🌐 Web: http://klicus.com/efectus.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_efectus.jpg?alt=media&token=e4b294f4-cad5-40e3-851b-fd5040116f31","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fefectus%2F1.jpg?alt=media&token=ecb97590-5df4-4f88-9e6d-d31d23277591","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fefectus%2F2.jpg?alt=media&token=9a1a8f4c-3f58-4303-8a8d-c253cf9acbfa","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fefectus%2F3.jpg?alt=media&token=6d6617bd-2e3c-4623-ad0b-906205b73aca","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fefectus%2F4.jpg?alt=media&token=35178c06-aa72-4c5e-a1d5-98184c9c5e82"]', 'diamond', 'active', 'Carrera 11 Centro, Parqueadero la castellana', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3163060703', NULL, 'http://klicus.com/efectus.php', 'https://www.facebook.com/Efectus-Producciones-389920697811115/', NULL, NULL, NULL, 0, NULL),
('15295f77-0502-419c-a38c-f41decac86c0', '44bcac40-5c86-44d6-8cfd-44ae50574580', 10, 'Hotel Santa Clara', 'Con los más altos estándares en confort, higiene y privacidad. Recreando espacios con mobiliario moderno

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375613480
📘 Facebook: https://www.facebook.com/htlsantaclara/
🌐 Web: https://www.hotelsantaclara.com', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_hotelsantaclara.jpg?alt=media&token=162736b4-3a77-4522-aa04-35ce018247be","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelsantaclara%2F2.jpg?alt=media&token=7abc09b3-fe57-4a43-9355-689366bf45ea","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelsantaclara%2F22.jpg?alt=media&token=368ac451-6b88-410c-8da4-62e180a46c49","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelsantaclara%2F33.jpg?alt=media&token=92ef37bb-52c4-4d59-88ad-2e8b810e6bfd","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelsantaclara%2F4.jpg?alt=media&token=451daed1-05aa-4c7a-bf5f-72e54918f6cd"]', 'diamond', 'active', 'Calle 5 No. 48 - 75 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375613480', NULL, NULL, 'https://www.hotelsantaclara.com', 'https://www.facebook.com/htlsantaclara/', NULL, NULL, NULL, 0, NULL),
('182a91b2-3e18-4341-a002-b9d530a8caf9', '44bcac40-5c86-44d6-8cfd-44ae50574580', 5, 'Injabonosa', 'Industria jabonera de Norte de Santander, empresa Ocañera que te ofrece la mejor línea en productos para el aseo y limpieza y lo más importante son Biodegradables, estamos en armonía con el medio ambiente. 

Línea +Clean  

	Jabón Liquido para Ropa 
	Desinfectante para Piso 
	Blanqueador 
	Limpia Vidrio 
	Desengrasante 
	Lavalosa 

Línea Suave Totti  

	Suavizante de ropa 
	Jabón Liquido para Manos 
	Gel Antibacterial 

Encuéntranos en Tiendas y Supermercados

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3228736444
📞 Teléfono: 0375491503
🌐 Web: http://klicus.com/injabonosa.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2FInjabonosa%2Flogo.jpg?alt=media&token=0cda7990-1c1d-4b73-9c27-ca373993a4b1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2FInjabonosa%2F1.jpg?alt=media&token=c3e2137d-5a08-4921-8d35-497359b5f076","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2FInjabonosa%2F2.jpg?alt=media&token=51769a44-5a2c-4d9f-8508-ec8e7cb3777f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2FInjabonosa%2F3.jpg?alt=media&token=7fcec0a9-040a-45b3-b9eb-7e4e37852959","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2FInjabonosa%2F4.jpg?alt=media&token=8f83dea2-185b-4f7f-9df2-e01244192a4c"]', 'diamond', 'active', 'KDX 411-370 Piso 1 Av. Circunvalar', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375491503', '3228736444', NULL, 'http://klicus.com/injabonosa.php', NULL, NULL, NULL, NULL, 0, NULL),
('2219708f-52f8-4847-a4c8-d0caa90adc49', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Guardería Lobaton', 'Descansa tranquilo mientras tu mascota queda en las mejores manos.

Cuidamos muy bien tu mascota.

Servicio de guardería
Paseos caninos
Baño
Peluquería

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3173170120
📞 Teléfono: 3167813204
📘 Facebook: https://www.facebook.com/servimascotaslobaton/
📸 Instagram: https://www.instagram.com/lobaton_guarderia/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobaton%2Flogo.jpeg?alt=media&token=ece5c465-1dc2-49c3-886f-e27e551038b4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobaton%2F1.jpg?alt=media&token=fb31cf94-18d5-4c5e-b399-50c4195b43a0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobaton%2F2.jpg?alt=media&token=2c7ad709-23a8-4973-9b5f-70dfb134d5c2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobaton%2F3.jpeg?alt=media&token=a81853e3-9589-4908-a430-4ad4ba488e5b"]', 'diamond', 'active', 'Barrio Marabel', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3167813204', '3173170120', NULL, NULL, 'https://www.facebook.com/servimascotaslobaton/', NULL, NULL, NULL, 0, NULL),
('244e5b5f-b9fa-4bc3-97c4-e5453a4f06b8', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Supermercado Ocaña Sin Límites', 'En OCAÑA SIN LIMITES tenemos todo lo relacionado con frutas y verduras, pollo, charcutería, víveres, rancho, licores, entre otros.  

Contamos con el mejor servicio de atención al cliente; es un placer para nosotros atender a nuestros clientes en nuestro horario habitual. 

Los invitamos a vivir una experiencia de compra con su familia llevando todos los productos de su canasta familiar.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3176455023
📞 Teléfono: 3176455023
🌐 Web: http://klicus.com/superocanasinlimites.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsuperocanasinlimites%2Flogo1.jpg?alt=media&token=de74790d-c1e4-4c78-9323-d2cc2b656e0d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsuperocanasinlimites%2F5.jpg?alt=media&token=3ca369cd-351a-4a32-b81f-569fc00f1e2e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsuperocanasinlimites%2F6.jpg?alt=media&token=5fdf2687-7a32-46ef-b630-b141f0dd0cd2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsuperocanasinlimites%2F3.jpg?alt=media&token=ce13842b-4083-45f0-9b11-cee47834815a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsuperocanasinlimites%2F7.jpg?alt=media&token=0ab9acd5-35ea-416f-9f63-cdebf3d8e4a6"]', 'diamond', 'active', 'Calle 7 No. 40-14 Barrio La Gloria', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3176455023', '3176455023', NULL, 'http://klicus.com/superocanasinlimites.php', NULL, NULL, NULL, NULL, 0, NULL),
('2477ace7-5c02-4280-bdd0-c78fc66a9526', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Servicios Preexequiales La Eternidad', 'Aseguramos su tranquilidad y la de su familia hoy y para siempre. Con los planes Preexequiales más económicos del mercado.

Sedes: 

	Cúcuta Tel: 5726407
	Aguachica Tel: 5661186
	Valledupar Tel: 5885335
	San Alberto Cel: 3214020551
	Hacari Cel: 3214016749
	Conveción Cel: 3214019239
	Abrego Cel: 3214017971
	Durania Cel: 3214015475
	Salazar de las Palmas Cel: 3133148719
	Pamplona Cel: 3214012930
	Pailitas Cel: 3214019274
	Toledo Cel: 3214011654
	Cáchira Cel: 3214020565
	Sardinata Cel: 3214004082
	Fundación Cel: 3214024363
	Bosconia Cel: 3214021774
	Villa Caro Cel: 3214012985
	Ragonvalia Cel: 3214005326
	Aguaclara Cel: 3118546932.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3115383275
📞 Teléfono: 0375611631', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaeternidad%2Ffachada.jpg?alt=media&token=fa93f45b-dcf6-4750-b9c2-3b531ec9ec47","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaeternidad%2F1.jpg?alt=media&token=b27e6b8a-ec5f-4ca1-aedd-b16997c35182","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaeternidad%2F2.jpg?alt=media&token=51af4194-0cbc-4e4d-9292-96549558cb90","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaeternidad%2F3.jpg?alt=media&token=a0b1d120-13c5-4a13-a3d6-88f7cbaa9586","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaeternidad%2F4.jpg?alt=media&token=c2e661c0-879a-4cdb-94a3-6d1204c7a592"]', 'diamond', 'active', 'Calle 7 N 36-31 B. La Gloria', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375611631', '3115383275', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('27dc1ad0-edb0-4eee-929a-7937d4c61702', '44bcac40-5c86-44d6-8cfd-44ae50574580', 9, 'Urbanización Santa Mónica', 'Encuentras todo lo que necesitas, no solo compras tu lote sino también un estilo de vida. 

	Vías pavimentadas 
	Cancha Sintética 
	Capilla 
	Zonas Verdes, recreativas y comerciales 
	Lotes desde 100 m2 

Paga de contado y te entregan escrituras con plano sin costo alguno, financiación hasta por 60 meses. 

Pasos abajo de Coorponor

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3153757474
📞 Teléfono: 3214163547
📘 Facebook: https://www.facebook.com/Urbanizaci%C3%B3n-Santa-Monica-193908767945177/?ref=br_rs
🌐 Web: http://klicus.com/santamonica.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Furbsantamonica%2Flogo.jpg?alt=media&token=a570dbfb-0515-4760-b57f-b057a026891c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Furbsantamonica%2F1.jpg?alt=media&token=3f0ceb4f-8370-42fd-a1aa-16dc39c04c6e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Furbsantamonica%2F2.jpg?alt=media&token=590a456c-1f1b-4be5-bf61-19846826f39e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Furbsantamonica%2F3.jpg?alt=media&token=89fb3df4-2bfa-4769-a782-88150b4cf513","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Furbsantamonica%2F4.jpg?alt=media&token=28c8967f-61e5-48b7-8272-dde9e1a06bcb"]', 'diamond', 'active', 'Pasos abajo de Coorponor', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3214163547', '3153757474', NULL, 'http://klicus.com/santamonica.php', 'https://www.facebook.com/Urbanizaci%C3%B3n-Santa-Monica-193908767945177/?ref=br_rs', NULL, NULL, NULL, 0, NULL),
('29cdd8e5-ee19-4999-82c2-229ce2640308', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante Las Guaduas', 'Restaurante Campestre donde encontrarás platos a la carta, la especialidad de la casa es carne de Cerdo, variedad de presentaciones, Bandejas Mixtas, Chuletas, Costillitas y deliciosos Chicharrones.
 Un ambiente de exquisitos platos.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3142654490', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelasguaduas%2Flogo_guaduas.jpeg?alt=media&token=7ad35ec0-0cd3-48fa-8c91-c39306f5a112","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelasguaduas%2Fg1.jpeg?alt=media&token=24c67dd4-c574-40ab-8310-9206698205f5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelasguaduas%2Fg2.jpeg?alt=media&token=3b17aee9-923d-4a7c-93df-4bee8ec2fd64","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelasguaduas%2Fg3.jpeg?alt=media&token=4a4099d3-a122-4d70-bdf7-242d10d04fac"]', 'diamond', 'active', 'Kilómetro 14 vía a Abrego', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3142654490', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('3269b551-0afc-4e45-8676-e38d6fc71c4b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Distribuciones Ortiz', 'Distribuidores exclusivos Mayonesa Comapan, Coolechera, Jugos Fruttsi

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3108523456
📞 Teléfono: 3204553301
📘 Facebook: https://www.facebook.com/Distribuciones-ortiz-1600295840263624/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistribucionesortiz%2F17.jpeg?alt=media&token=fb553639-8908-423f-8379-5f5c4b0be1c1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistribucionesortiz%2F17.jpeg?alt=media&token=fb553639-8908-423f-8379-5f5c4b0be1c1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistribucionesortiz%2Fc1.jpg?alt=media&token=556149cb-812d-43d9-8033-070b6e90f021","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistribucionesortiz%2F10.png?alt=media&token=6a76cf7c-1282-4321-92bd-ac97f1a98135","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistribucionesortiz%2Fc2.jpeg?alt=media&token=61c6a01c-410d-48d8-9fcc-7bd1d532bd72"]', 'diamond', 'active', 'Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3204553301', '3108523456', NULL, NULL, 'https://www.facebook.com/Distribuciones-ortiz-1600295840263624/', NULL, NULL, NULL, 0, NULL),
('33003120-3dcf-4b6d-82c1-83d858efa8e9', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Disaman', 'Toda una amplia variedad en:
	 Dulces
	 Chocolates
	 Vinos
	 Licores de la más alta calidad
	 Desayunos Sorpresa
	 Cajas de Regalo
	 Detalles

 Ahora encontrarás víveres en general. Recibimos todas las tarjetas de crédito y débito

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375690440
📘 Facebook: https://www.facebook.com/disaman.distribuciones.18
🌐 Web: http://klicus.com/disaman.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2F2.jpg?alt=media&token=278169e6-40c4-47b8-844d-576634124d7f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdisaman%2F1.jpg?alt=media&token=fa161c67-e227-4a78-8529-0ce52a1aeb52","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdisaman%2F2.jpg?alt=media&token=a5c5c6a4-e60c-479c-8023-43fd158a8005","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdisaman%2F3.jpg?alt=media&token=2539cdcc-c2fb-4d67-b7e3-b00c57abc4ad","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdisaman%2F4.jpg?alt=media&token=4f2e14a7-0091-4cc5-a087-e340c7c8dc44"]', 'diamond', 'active', 'Cra. 11 # 11-48 Centro, pasos abajo de la Capilla de la Torcoroma', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375690440', NULL, NULL, 'http://klicus.com/disaman.php', 'https://www.facebook.com/disaman.distribuciones.18', NULL, NULL, NULL, 0, NULL),
('33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', '44bcac40-5c86-44d6-8cfd-44ae50574580', 13, 'As Deportes', 'Venta de Guayos marca Golty, Tony2, Camisetas, Medias, Pantalonetas, Balones de Fútbol, Micro, Básquet, Voleibol, Béisbol (marca Golty, Mikasa, Molten, Golary), Uniformes de ciclismo marca Adriani, Cascos para bicicleta y patinaje, Trofeos y Medallería.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3153112744
📞 Teléfono: 0375694281
📘 Facebook: https://www.facebook.com/profile.php?id=100012264370731
🌐 Web: http://klicus.com/deportes.html', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_asdeportes.jpg?alt=media&token=593ea51d-1f1f-4e21-98f7-5dcb3e3d3419","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasdeportes%2Fasima1.jpg?alt=media&token=2ba482f1-19aa-4f83-ba86-43514a423f58","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasdeportes%2Fasima2.jpeg?alt=media&token=c14eea88-4c42-4284-9ce5-acc3f85046df","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasdeportes%2Fasima3.jpeg?alt=media&token=fc0e3c57-c73f-4de6-8c1c-247b880cdac5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fasdeportes%2Fasima4.jpeg?alt=media&token=793a6baf-9739-4730-b45b-0eaa5af98094"]', 'diamond', 'active', 'Cra. 13a No. 7-67 Mercado publico', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375694281', '3153112744', NULL, 'http://klicus.com/deportes.html', 'https://www.facebook.com/profile.php?id=100012264370731', NULL, NULL, NULL, 0, NULL),
('357823a7-d962-4b66-9261-4134a1635374', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante y Asadero CHOWI', 'En nuestro Restaurante encontraras típicas comidas Chinas
 Arroz Cantonés
 Arroz Especial
 Cazuela de Marisco
 Plato Chino CHOWI
 Chop Suey
 Rice Cooking
 Pastas China
 Pollo Asado
 Pollo a la Broaster
 Lomo y Pechuga a la Plancha.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3166835439
📞 Teléfono: 0375695084
📘 Facebook: https://www.facebook.com/Restaurante-CHOWI-226522647877985/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantechowi%2Flogo_chowi.jpeg?alt=media&token=a6d4c8d2-29f2-4431-a171-fe9ddb93dc9f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantechowi%2Fw1.jpeg?alt=media&token=709c98c8-158c-4a26-a813-944662d6c9e8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantechowi%2Fw2.jpeg?alt=media&token=873114ab-f366-44b5-bcd9-93a029102db1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantechowi%2Fw3.jpeg?alt=media&token=748b586b-4d05-4914-b208-36b96074a158","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantechowi%2Fw5.jpg?alt=media&token=aa6868fb-f89e-4997-ac6a-5ae25f90336d"]', 'diamond', 'active', 'Calle 6 No 13A-68 Barrio Villa Luz', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375695084', '3166835439', NULL, NULL, 'https://www.facebook.com/Restaurante-CHOWI-226522647877985/', NULL, NULL, NULL, 0, NULL),
('37187578-8811-4644-882f-11763a1f123f', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Lobo Diaz Distribuciones', 'Empresa Ocañera que comercializa productos con altos estándares de calidad, responsabilidad y compromiso, cumpliendo con las exigencias de nuestros consumidores, apoyando al campesino de nuestra región. 

Encuentras: 
	Leche La Mejor 
	Bebidas Lácteas 
	Bebidas Refrescantes 
	Quesos 
	Kumis 

Calidad que puedes encontrar en Tiendas y Supermercados. 

Lobo Díaz Distribuciones apoya lo nuestro

--- 🌟 CONTACTO PREMIUM ---
🌐 Web: http://klicus.com/lobodiazdistribuciones.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobodiazdistribuciones%2Flogo.jpg?alt=media&token=7db28874-c1cd-4974-bdce-d30d36b3e6d0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobodiazdistribuciones%2F1.jpg?alt=media&token=acd08366-5d1c-45e3-8a6d-290fd2942380","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobodiazdistribuciones%2F2.jpg?alt=media&token=14555605-02a6-4fa5-9199-f6383cb91a5f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobodiazdistribuciones%2F3.jpg?alt=media&token=9659fb32-7216-4c74-8df0-3843ee110390","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flobodiazdistribuciones%2F4.jpg?alt=media&token=74917ab0-ae5c-4e1e-a794-87833336f01a"]', 'diamond', 'active', 'Ocaña', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, NULL, NULL, NULL, 'http://klicus.com/lobodiazdistribuciones.php', NULL, NULL, NULL, NULL, 0, NULL),
('37b0b6f5-cd0b-48b1-bbce-5c231961ffb3', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Centro Comercial Andalucia', 'El Centro Comercial Andalucía te ofrece gran variedad de productos y servicios donde encontrarás lo siguiente:

	Servicio de Peluquería y Belleza
	Técnicos en Celulares y Venta de Accesorios
	Asesoría Jurídica
	Asesoría Contable
	Pagos de Seguridad Social
	Créditos por Libranza
	Metro Redes e Instalación de Gas
	Venta por Catálogo Yanbal
	Servicio de Cerrajería
	Mantenimiento de Impresoras y Computadores
	Servicio Médico de Oftalmología
	Publicidad y Diseño Gráfico
	Librería y Accesorios Cristianos
	Sindicato de Docentes
	Compra y Venta de Lotes
	Accesorios Odontológicos
	Seguridad de Monitoreo y Alarmas
	Obras de Arte y Artesanías Representativas de la Ciudad.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3004227771
📞 Teléfono: 3004227771
📘 Facebook: https://www.facebook.com/centrocomercialandalucia/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fccandalucia%2Flogo.jpeg?alt=media&token=4c98d080-9d85-4b6b-9f4d-f5eef36ef906","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fccandalucia%2F2.jpeg?alt=media&token=00ad24b2-ab88-4619-b682-203069b8427c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fccandalucia%2F3.jpeg?alt=media&token=faf222ba-303e-4d98-85a2-3b131d9c6041","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fccandalucia%2F4.jpeg?alt=media&token=52d0c2e3-47fa-4aca-959e-be26329ea4b3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fccandalucia%2F5.jpeg?alt=media&token=82a2547a-6583-4849-9a28-2d52be829673"]', 'diamond', 'active', 'Calle 10 No. 14-01  Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3004227771', '3004227771', NULL, NULL, 'https://www.facebook.com/centrocomercialandalucia/', NULL, NULL, NULL, 0, NULL),
('38140a8f-10dd-4913-b6be-598f7b8df817', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Piñatería y Papelería Mundo Feliz', 'Ofrecemos venta de globos Sempertex 
Trabajos en Icopor 
Alquiler de Mantelería 
Accesorios para Eventos Sociales 
Fiestas Infantiles 
Peluches y Piñatería 

Visítanos 

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3167763722
📞 Teléfono: 3165785329
📘 Facebook: https://www.facebook.com/Pi%C3%B1ateria-mundo-feliz-Oca%C3%B1a-1172834696156535/?ref=br_rs
🌐 Web: http://klicus.com/mundofeliz.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpi%C3%B1ateriamundofeliz%2Flogo.jpg?alt=media&token=0912ee12-0d7f-41ca-b6e1-0dc3103c9732","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpi%C3%B1ateriamundofeliz%2F5.jpg?alt=media&token=00447e12-a0be-4a88-b6de-eb8f92e09b9a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpi%C3%B1ateriamundofeliz%2F2.jpg?alt=media&token=139d4972-ff48-4840-9034-00f533ad476e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpi%C3%B1ateriamundofeliz%2F3.jpg?alt=media&token=f9c162ed-9f49-4bab-85c0-5e312ef479c2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpi%C3%B1ateriamundofeliz%2F4.jpg?alt=media&token=4de189d4-a535-4e01-9d64-00e3ae4d4f1a"]', 'diamond', 'active', 'Calle 10 No. 11-25 
Al lado de Servientrega Ocaña', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3165785329', '3167763722', NULL, 'http://klicus.com/mundofeliz.php', 'https://www.facebook.com/Pi%C3%B1ateria-mundo-feliz-Oca%C3%B1a-1172834696156535/?ref=br_rs', NULL, NULL, NULL, 0, NULL),
('39a8b611-2970-4d31-be32-dfc8f8816cd9', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Al Día - Tramites Ante el Transito', 'Tramitador ante el Transito, ayudamos a tramitar su licencia de conducción en todas las categorías, matricular su vehículo, traspasos, pagar sus impuestos, venta de seguros SOAT y lo asesoramos para chatarrización.
 LO ASESORAMOS PARA POSTULAR SU VEHICULO PARA CHATARRIZACION... 
TAMBIEN LE COMPRAMOS SU VEHICULO DONDE SE ENCUENTRE.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3213016996
📞 Teléfono: 3042045512
📘 Facebook: https://www.facebook.com/Soluciones-Ante-el-Transito-Al-DIA-297947783696630/
🌐 Web: http://klicus.com/aldia.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_aldia.jpeg?alt=media&token=06db2347-a447-426f-af50-1c97c7656524","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Faldia%2F1.jpg?alt=media&token=f43eac06-ed70-4546-bc76-8bf9a51ab20a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Faldia%2F2.jpg?alt=media&token=76be3550-fc1b-4d91-83fc-479234d07f57"]', 'diamond', 'active', 'Terminal de transporte Locales 304-305', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3042045512', '3213016996', NULL, 'http://klicus.com/aldia.php', 'https://www.facebook.com/Soluciones-Ante-el-Transito-Al-DIA-297947783696630/', NULL, NULL, NULL, 0, NULL),
('3ad30066-4c92-4fe0-b1de-07b276f01bc6', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'PlastiOcaña', 'PlastiOcaña: Distribuimos al por mayor y al detal todo lo relacionado con:
	 Icopor
	 Desechables
	 Bolsas
	 Piñatería
	 Frutos Secos
	 Condimentos
	  Dulcería
 Productos de excelente calidad y al alcance de tu bolsillo. 
Ven y Visítanos...

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3106089759', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplastiocana%2Flogo_plastiocana.jpeg?alt=media&token=622c55f0-c014-4f31-8976-b01857e3938f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplastiocana%2Flogo_plastiocana.jpeg?alt=media&token=622c55f0-c014-4f31-8976-b01857e3938f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplastiocana%2Fp1.jpeg?alt=media&token=0d17563c-29a8-4596-ba0e-d8897aa7dcb8"]', 'diamond', 'active', 'Carrera 13# 7-80 Barrio los altillos al lado del almacén Francisco Giraldo.-- Sucursal: Conjunto Comercial Centro Mercado local B3 y B37', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3106089759', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('3c2cd861-98c2-4840-acb8-40be7277e09c', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante Plaza Gourmet', 'Ofrecemos variedad de platos a la carta, cócteles, cenas románticas, reuniones y todo tipo de eventos. Servicio de Cafetería, Menús ejecutivos, Carta Gourmet.
 Ideal para grupos.
 Ideal para niños.
 Se reciben todo tipo de tarjetas.
Haz tu reserva YA.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375691073
📘 Facebook: https://www.facebook.com/plazagourmeteventos/
🌐 Web: http://klicus.com/plaza.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_plaza.jpg?alt=media&token=678ccaf6-4c83-4c87-b920-c5ec0196efb4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplaza%2Fp1.jpg?alt=media&token=fdccc058-6e73-46e4-bcdb-376157ab306b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplaza%2Fp2.jpg?alt=media&token=eeae988a-328f-461b-aa98-450c91a67110","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplaza%2Fp3.jpg?alt=media&token=cff08294-d352-49fc-bd90-a858e9d2a0e6","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fplaza%2Fp4.jpg?alt=media&token=74c04383-562d-4f2f-b9de-06784e2058e8"]', 'diamond', 'active', 'Calle 11 #12-48 segundo piso BANCOLOMBIA Parque principal', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375691073', NULL, NULL, 'http://klicus.com/plaza.php', 'https://www.facebook.com/plazagourmeteventos/', NULL, NULL, NULL, 0, NULL),
('3c65b819-2921-4c76-bfb9-00850d944dd9', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Yamaha Abrego', 'Tenemos para ti motos YAMAHA en todas sus líneas, aprovecha las ofertas que mes a mes tenemos para ofrecerte.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183889241
📞 Teléfono: 0375642577
📘 Facebook: https://www.facebook.com/profile.php?id=100015345902580
🌐 Web: http://klicus.com/yamahaabrego.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fyamahaabrego%2Flogo.jpg?alt=media&token=89f07ea6-312c-48df-951e-6ec340d3e44b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fyamahaabrego%2F1.jpg?alt=media&token=78e22dbc-d389-4018-b774-17a9d977f3f0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fyamahaabrego%2F2.jpg?alt=media&token=4f3c467c-07c6-4eb1-b664-ff8b5fc7e3d4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fyamahaabrego%2F3.jpg?alt=media&token=05c4e74c-b600-45c5-a8dc-22fda4bfae8c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fyamahaabrego%2F4.jpg?alt=media&token=b2b77944-0549-4aa8-af02-297eb7cb0c64"]', 'diamond', 'active', 'Cra 7 No. 13-91 Abrego', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375642577', '3183889241', NULL, 'http://klicus.com/yamahaabrego.php', 'https://www.facebook.com/profile.php?id=100015345902580', NULL, NULL, NULL, 0, NULL),
('3e949f37-f3eb-4ecc-81bc-5678e3680d1c', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante La Cuesta', 'Contamos con nuevas instalaciones para que sigas disfrutando del delicioso menú con precios accesibles para todos nuestros clientes. 

	Churrasco 
	Pechuga Ranchera 
	Cazuela Mixta 
	Mojarra 
	Plato Mixto 
	Costilla de Cerdo 
	Lomo de Cerdo 

Atendemos eventos sociales, recibimos tarjetas de Crédito 

Servicio a Domicilio

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 75613855
📞 Teléfono: 0375613855
📘 Facebook: https://www.facebook.com/lacuestarestaurante/
📸 Instagram: https://www.instagram.com/explore/locations/160168231268675/restaurante-la-cuesta/
🌐 Web: http://klicus.com/restaurantelacuesta.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelacuesta%2Flogo.jpg?alt=media&token=9b792c49-97d7-4998-bcb3-4654ce9e4285","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelacuesta%2F1.jpg?alt=media&token=d4d789e7-0fb7-4f8f-ae3e-b0122563e62a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelacuesta%2F2.jpg?alt=media&token=cf26687c-5d15-4314-af2a-026aa99b671e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelacuesta%2F3.jpg?alt=media&token=b3a1bb08-b616-4142-a106-ea3bfcf1dc67","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelacuesta%2F4.jpg?alt=media&token=6c712fbb-5c53-4ade-b3d1-4c8f15b37c0e"]', 'diamond', 'active', 'Calle 7 No. 43-100', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375613855', '75613855', NULL, 'http://klicus.com/restaurantelacuesta.php', 'https://www.facebook.com/lacuestarestaurante/', NULL, NULL, NULL, 0, NULL),
('402ce3a6-4e73-4936-9236-6c6950fab871', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Tienda Jhonny Picón', 'Vístete siempre a la moda con prendas de las mejores marcas, somos distribuidores exclusivos de las marcas: 

	Chevignon 
	Americanino 
	Oxford 
	edc 
	Sprit 
	Color Siete 
	Lacoste 
	Tommy Hilfiger 

El estilo que buscas y la calidad que necesitas

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375625934
📘 Facebook: https://www.facebook.com/Tienda-Jhonny-Picon-495132374165769/ 
🌐 Web: http://klicus.com/jhonnypicon.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fjhonnypicon%2Flogo.jpg?alt=media&token=52aaa9cf-3600-4101-8b79-e4e9e8ef461f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fjhonnypicon%2F1.jpg?alt=media&token=7287bf51-1bb3-442a-a096-181ca069f47e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fjhonnypicon%2F2.jpg?alt=media&token=f94be635-39f3-4cdb-9586-a05867be6bd1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fjhonnypicon%2F3.jpg?alt=media&token=3581aa7e-10b2-482b-b318-ad25631d84c8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fjhonnypicon%2F4.jpg?alt=media&token=c760ccbd-482f-45ae-9e4d-93fe01afb0e9"]', 'diamond', 'active', 'CC Plazarella 2do Piso – Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375625934', NULL, NULL, 'http://klicus.com/jhonnypicon.php', 'https://www.facebook.com/Tienda-Jhonny-Picon-495132374165769/', NULL, NULL, NULL, 0, NULL),
('42845a83-dc98-4338-bdc8-57dd0ccc4daa', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Ferro Materiales', 'Todo en materiales para la construcción, herramientas, plomería, venta de bloques.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3193599638
🌐 Web: http://klicus.com/ferromateriales.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_ferromateriales.jpeg?alt=media&token=09e54ab9-29ae-4315-a251-5f401aef9c36","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferromateriales%2F1.jpeg?alt=media&token=98b9b916-84d7-4b66-828e-3682a083adff","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferromateriales%2F2.jpeg?alt=media&token=dc593454-0073-446b-8764-8d89fdf8ae61"]', 'diamond', 'active', 'Cra 49 N° 5-29 Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3193599638', NULL, 'http://klicus.com/ferromateriales.php', NULL, NULL, NULL, NULL, 0, NULL),
('43e762e4-c3f2-4e43-a068-4d7b67aeda93', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Amaya Rangel Asesores', 'Con una cobertura a la medida de sus exigencias presentes y necesidades futuras ofrecemos los siguientes productos:
	  -RESPONSABILIDAD CIVIL
	 -PROTECCIÓN PATRIMONIAL
	 -Seguro obligatorio de Accidentes de Tránsito SOAT
	 -Pólizas de manejo para funcionarios públicos y Privados
	 -SEGUROS DE DAÑOS
	 -Pólizas de ingeniería, montaje y construcción
	 -Pólizas de salud
	 -Exequias.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375695422
📘 Facebook: https://www.facebook.com/amayarangel12
🌐 Web: https://www.amayarangel.com.co', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Famayarangel%2Fam7.jpeg?alt=media&token=303ad3d2-9244-4560-b194-9dbe2a191691","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Famayarangel%2Fam1.jpg?alt=media&token=c3f99663-7549-4ece-afe1-8c81620c0356","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Famayarangel%2Fam2.jpg?alt=media&token=2cf91f48-ee5c-49fc-81f6-41ded2e91d5d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Famayarangel%2Fam7.jpeg?alt=media&token=303ad3d2-9244-4560-b194-9dbe2a191691","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Famayarangel%2Fam8.jpeg?alt=media&token=3ade501b-066b-42ad-83ae-bf318fb1ce7c"]', 'diamond', 'active', 'Calle 11 No. 12-06 Parque principal Diagonal a la Catedral', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375695422', NULL, NULL, 'https://www.amayarangel.com.co', 'https://www.facebook.com/amayarangel12', NULL, NULL, NULL, 0, NULL),
('44408219-37e9-4e33-abb8-0365adcee09b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Hotel el Libano', 'Ambiente familiar, confortables habitaciones con TV y aire acondicionado, excelente atención.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3208791739
🌐 Web: http://klicus.com/hotlibano.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_hotlibano.jpeg?alt=media&token=737f95ea-cfe4-4a1a-aa3c-d68fe0b09047","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotellibano%2F1.jpeg?alt=media&token=69dd2342-8a39-4777-836d-e1a5ddb29e15","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotellibano%2F2.jpeg?alt=media&token=171e7989-d1c1-4e51-90b3-76459a5000f8"]', 'diamond', 'active', 'Calle 7 N° 55-116 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3208791739', NULL, 'http://klicus.com/hotlibano.php', NULL, NULL, NULL, NULL, 0, NULL),
('461f65ca-35d0-474b-b163-b0505f8004b2', '44bcac40-5c86-44d6-8cfd-44ae50574580', 8, 'Contador público - Karem Josefa Trillos Arenas', 'Servicios

	Asesorías Contables
	Declaración Tributaria
	Información Exogena
	Certificado de ingresos
	Planilla de Seguridad Social
	Contratos
	Trabajos a Computador
	Impresiones

Descuentos

En el certificado de ingresos, Personas que deseen ingresar a la universidad tendrán descuentos del 25% en el mes de Octubre, Noviembre y Diciembre.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3232371099
📞 Teléfono: 3232371099
📘 Facebook: https://www.facebook.com/karemsita.trillosarenas
🌐 Web: http://www.klicus.com/karemtrillos.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkaremtrillos%2Flogo_karem.jpg?alt=media&token=e79b6f2b-2459-4b95-ac65-6f72812de8d6","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkaremtrillos%2Fc3.jpeg?alt=media&token=aea981cd-8650-476f-bef3-2806505591c4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkaremtrillos%2Fc4.jpeg?alt=media&token=385892a2-157d-40a5-ac89-5a311ccf1ff2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkaremtrillos%2Fc5.jpeg?alt=media&token=6250eaea-d83c-45a8-b62e-0c285689161c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkaremtrillos%2Fc6.jpeg?alt=media&token=fce8f2bf-d906-42ed-8510-cf5c46ed6de6"]', 'diamond', 'active', 'Cra 12 # 11-38 - Cooguasimales Local 01 Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3232371099', '3232371099', NULL, 'http://www.klicus.com/karemtrillos.php', 'https://www.facebook.com/karemsita.trillosarenas', NULL, NULL, NULL, 0, NULL),
('50152824-0675-4a99-8dcc-75f703f1a207', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Masajes Corporales a Domicilio', 'Servicio de masajes Corporales relajantes y reductores.
 Moldea tu cuerpo, reduce medidas, combate la flacidez y todo sin salir de tu casa.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168287030
📘 Facebook: https://www.facebook.com/doraliliana.ortizrueda
🌐 Web: http://klicus.com/masajescorporales.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_dora.jpeg?alt=media&token=ac5b1f48-44b2-4fbb-9bc6-9dcefe02d0c0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmasajesdora%2Flogo_dora.jpeg?alt=media&token=7d335f5c-3530-444b-9715-88510ace5ef7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmasajesdora%2Flogo_dora.jpeg?alt=media&token=7d335f5c-3530-444b-9715-88510ace5ef7"]', 'diamond', 'active', 'Calle 7 N° 40-73 Barrio La Gloria', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3168287030', NULL, 'http://klicus.com/masajescorporales.php', 'https://www.facebook.com/doraliliana.ortizrueda', NULL, NULL, NULL, 0, NULL),
('5276c5e0-1763-47d0-ab5c-b539310792e7', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Agrotrilladora La Octava', 'Todo lo relacionado con medicina veterinaria y granos en general: 
	Medicamentos veterinarios
	 - Maíz Blanco
	 - Maíz Amarillo
	 - Melaza
	 - Sal de Ganado
	 - Sal Mineralizada
	 - Purina de Pollo
	 - Purina de Cerdo
	 - Palmiste
	 - Bolsa para Ensilar

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3166244382
🌐 Web: http://klicus.com/agroctava.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_agrotrilladora.jpeg?alt=media&token=11d62270-68ca-4308-ad26-99b80ff305ea","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagrotrilladoralaoctava%2Ft1.jpeg?alt=media&token=9ce19adf-a258-4c58-9441-b0508fcf9cec","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagrotrilladoralaoctava%2Ft2.jpeg?alt=media&token=6181f7e8-76c9-4804-8d5e-65eadb916561","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagrotrilladoralaoctava%2Ft3.jpeg?alt=media&token=a0559f97-16fb-41c4-8b68-fc403f38ba52","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagrotrilladoralaoctava%2Ft4.jpeg?alt=media&token=ffb81fad-1eb1-4a0d-a479-27324e58b5af"]', 'diamond', 'active', 'Calle 8 - Mercado publico', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, NULL, '3166244382', NULL, 'http://klicus.com/agroctava.php', NULL, NULL, NULL, NULL, 0, NULL),
('5389159d-9a18-4de8-b3b0-990bff26479b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Ferretería Constru Bohorquez', 'Completo surtido en materiales para construcción.
 Cerrajería
 Pinturas
 Disolventes
 Herramientas
 Bloques
 Ladrillos y Material de Río

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183353997
📘 Facebook: https://www.facebook.com/fredy.bohorquezvillalba
🌐 Web: http://klicus.com/ferrebohorquez.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_ferrebohorquez.jpeg?alt=media&token=81fdb333-fbaa-4103-8e0f-d236ed039b68","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferreconstrubohorquez%2Fr1.jpeg?alt=media&token=9e8270f2-2e08-4289-a198-476643eb6e1b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferreconstrubohorquez%2Fr2.jpeg?alt=media&token=652e5dd1-f83b-4c91-8c6c-8d21dd0d43c9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferreconstrubohorquez%2Fr3.jpeg?alt=media&token=50788582-075b-42bf-b88e-68bf60b711a8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fferreconstrubohorquez%2Fr4.jpeg?alt=media&token=71ef7e73-cb97-495b-bd26-a17a94f139e7"]', 'diamond', 'active', 'Calle 7 N°55-173 Libano', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3183353997', NULL, 'http://klicus.com/ferrebohorquez.php', 'https://www.facebook.com/fredy.bohorquezvillalba', NULL, NULL, NULL, 0, NULL),
('569c4c11-e716-4640-9a76-7560609ff6d0', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Calzado Davanti', 'Línea de zapatos para mujeres en todo el país. Ventas al mayor y al por menor.

En Davanti encontrarás los mejores tips de moda, y las últimas noticias sobre nuestros productos.

En este espacio podrás enterarte de las promociones que tenemos para ti, así como interactuar con Davanti.

Conoce las novedades Davanti y las últimas tendencias en moda

Envíos a toda Colombia

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183904355
📞 Teléfono: 3183904355
📘 Facebook: https://www.facebook.com/Calzadodavanti/
📸 Instagram: https://www.instagram.com/calzadodavanti/
🌐 Web: http://klicus.com/davanti.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdavanti%2Flogo.png?alt=media&token=82478797-8a76-4080-b481-1656f99f2824","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdavanti%2F1.jpg?alt=media&token=0b89582a-5499-42be-ba2a-e41292dfd672","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdavanti%2F2.jpg?alt=media&token=c71f473c-1ae7-4922-a505-5a88836bacaf","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdavanti%2F3.jpg?alt=media&token=8538730a-e79f-428d-8557-648e2c8b9e18","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdavanti%2F4.jpg?alt=media&token=af192e58-de18-472b-a72a-53032a42831e"]', 'diamond', 'active', 'Calle 11 N 12-70 local 107 Edf. Azul', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3183904355', '3183904355', NULL, 'http://klicus.com/davanti.php', 'https://www.facebook.com/Calzadodavanti/', NULL, NULL, NULL, 0, NULL),
('5b0d0248-882c-4266-a43a-7077b1bb49ff', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Pizza Extreme', 'La mejor pizza con borde de queso gratis, la masa más crocante y la porción más generosa de la ciudad.
 Vení y visitános para que pruebes nuestras pizzas Panzerotti y Lasaña.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3223622052
📘 Facebook: https://www.facebook.com/pizzaextreme7/
📸 Instagram: https://www.instagram.com/explore/locations/1838364276477484/pizza-extreme/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpizzaextreme%2Flogo.jpeg?alt=media&token=c153e89e-e89d-435a-96d3-dfb4700af65c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpizzaextreme%2Fp1.jpeg?alt=media&token=682f93e2-745f-426f-b341-4268b28d194c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpizzaextreme%2Fp2.jpeg?alt=media&token=89fd284e-826f-4af9-9827-ecc881615e93","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpizzaextreme%2Fp3.jpeg?alt=media&token=bd81b84a-80bb-4ea7-9b54-c43cb507151e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpizzaextreme%2Fp4.jpeg?alt=media&token=7b8e5ceb-41e0-4237-a0d9-6af1267d93ae"]', 'diamond', 'active', 'Coliseo Cubierto, Local 5 y 6. Barrio La Primavera', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3223622052', NULL, NULL, 'https://www.facebook.com/pizzaextreme7/', NULL, NULL, NULL, 0, NULL),
('5c6a08d9-9198-4c81-8a23-1a095b3a7d6d', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Tortas Karina', 'Deliciosas Tortas caseras por encargo con la temática que elijas.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3204021828
📘 Facebook: https://www.facebook.com/anakarina.ruedaovallos
🌐 Web: http://klicus.com/tortaskarina.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_tortaskarina.jpg?alt=media&token=0f742009-db4f-48c2-9b22-04c350586233","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftortaskarina%2F1.jpg?alt=media&token=fafa6283-634d-4d3b-9c68-8db219b8e8fc","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftortaskarina%2F2.jpg?alt=media&token=a4d6af91-bfe2-4db7-8649-dbcd6ed9d307","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftortaskarina%2F3.jpg?alt=media&token=bc48a76d-8880-4f75-ab73-f182f3e451d4"]', 'diamond', 'active', 'Ocaña, Norte de Santander', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3204021828', NULL, 'http://klicus.com/tortaskarina.php', 'https://www.facebook.com/anakarina.ruedaovallos', NULL, NULL, NULL, 0, NULL),
('5c909e30-b0a4-4d5c-a478-e30568177823', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Distripollo Ciudadela', 'Distribuimos pollo procesado con altos niveles de calidad, trabajamos para que nuestros productos sobresalgan por su excelente condición (tamaño, frescura y excelente conservación) y cumplimiento en los tiempos de entrega.
 Distribuimos pollo procesado en Ocaña y la provincia. 
Somos distribuidores directos de: 
	Pimpollo
	 Campollo 
	Macpollo 
	Pesquera del Mar 
	 Papa Mydibel
 Todo lo relacionado con la pesquera del mar.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3178003262
📞 Teléfono: 0375613434
🌐 Web: http://klicus.com/distripollociudadela.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_distripollo.jpeg?alt=media&token=c19ccac8-a610-4da8-b46f-4e9f961d8551","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistripollociudadela%2Fd1.jpeg?alt=media&token=049e0130-36bc-41f8-b299-ca049340829d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistripollociudadela%2Fd2.jpeg?alt=media&token=45207054-e03a-4d33-a726-b3b1ddee4d44","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistripollociudadela%2Fd3.jpeg?alt=media&token=57b736aa-0e90-4fea-822f-6a6661c5ef7c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdistripollociudadela%2Fd4.jpeg?alt=media&token=cf83ba34-72f8-4991-a92b-5067a1e10def"]', 'diamond', 'active', 'CC Ciudadela Norte, Local 54-55', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375613434', '3178003262', NULL, 'http://klicus.com/distripollociudadela.php', NULL, NULL, NULL, NULL, 0, NULL),
('602c14e4-f61c-4a6d-92bb-f1489d963f94', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 1, 'Oferta especial', 'Activo la oferta especial - Prueba', '["/uploads/ads/Captura de pantalla 2026-01-17 141156-1776568134537.webp"]', 'diamond', 'active', 'Bucaramanga, Santander', '', NULL, '2036-04-15 01:16:35', '2026-04-17 19:49:16', 'Calle principal', '', '', '', '', '', '', 'zxcv', '', 0, NULL),
('604cccfb-7416-4a4a-83e4-2b442d96df62', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Droguería Santa Clara', 'Nuestro compromiso principal es la salud y el bienestar de nuestros clientes. 
Le ofrecemos suministro de medicamentos, productos de higiene personal, cuidados del bebe y cosméticos entre otros, despacho de formulas medicas.

--- 🌟 CONTACTO PREMIUM ---
🌐 Web: http://klicus.com/drogsantaclara.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_drogsantaclara.jpeg?alt=media&token=858fb72d-7c10-471a-8853-7d396885ab9c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdrogsantaclara%2F1.jpeg?alt=media&token=16fe6622-3d5e-4016-aa20-48fd5eaf559f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdrogsantaclara%2F2.jpeg?alt=media&token=22e7d986-b404-470c-8448-1d7b7870f7a1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdrogsantaclara%2F3.jpeg?alt=media&token=c64ec7c7-b91b-4da9-9cb7-d8403c572be2"]', 'diamond', 'active', 'Cra 49 calle 5 local 5 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, NULL, NULL, 'http://klicus.com/drogsantaclara.php', NULL, NULL, NULL, NULL, 0, NULL),
('64bca681-d448-4b77-a672-2b86d0887a17', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'MediLive', 'Dr. Olger Pino – Cardiologo. Prestamos los servicios de Consulta 

	Ecocardiograma 
	Electrocardiograma 
	Ecocardiograma de Estrés 
	Prueba de Esfuerzo 
	Holter Dinámico 24 Horas 
	Monitoreo de Presión Arterial 

Tenemos convenio con Crediservir 

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3504330415
📞 Teléfono: 0375696852
🌐 Web: http://klicus.com/medilive.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmedilive%2Flogo.jpg?alt=media&token=600111dc-e94d-459b-9acb-d35d82785a3e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmedilive%2F1.jpg?alt=media&token=696061ea-e5a9-4488-861c-4a97e2fc451a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmedilive%2F2.jpg?alt=media&token=f0d099bc-ffcf-44c1-a2e0-a8f1276668fc","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmedilive%2F3.jpg?alt=media&token=4f4c0bd6-4378-47dd-b350-688cbf8664a6","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmedilive%2F4.jpg?alt=media&token=096f0575-5071-4643-bf4c-4b8198ffcfa3"]', 'diamond', 'active', 'CC Santa María Local 305', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375696852', '3504330415', NULL, 'http://klicus.com/medilive.php', NULL, NULL, NULL, NULL, 0, NULL),
('673851f9-1c8f-4cfc-9a49-bd9d88eca348', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Galería Taller Prisma', 'Venta de Obras al Óleo y otras Técnicas.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3157801423
📘 Facebook: https://www.facebook.com/galeriataller.prisma
🌐 Web: http://klicus.com/galeriaprisma.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_prisma.jpeg?alt=media&token=ff0eed28-be03-410c-bd90-54af512f29ce","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgaleriaprisma%2Flogo_prisma.jpeg?alt=media&token=149b57f0-5008-4081-a2a2-36d498448566","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgaleriaprisma%2Flogo_prisma.jpeg?alt=media&token=149b57f0-5008-4081-a2a2-36d498448566"]', 'diamond', 'active', 'Calle 12ª 17-132 Barrio La Popa', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3157801423', NULL, 'http://klicus.com/galeriaprisma.php', 'https://www.facebook.com/galeriataller.prisma', NULL, NULL, NULL, 0, NULL),
('6931a2ac-7580-43d6-b966-c759dcf40c4b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Foto Arte', 'Estudios fotográficos con escenografía real, restauración de fotos antiguas, impresiones en gran formato, fotos tipo visa y documento, mug fotográfico.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3187950919
📞 Teléfono: 0375625306', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotoarte%2Flogo_fotoarte.jpg?alt=media&token=943b681c-0dee-43d2-ba61-556be0c1d418","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotoarte%2Flogo_fotoarte.jpg?alt=media&token=943b681c-0dee-43d2-ba61-556be0c1d418"]', 'diamond', 'active', 'Edificio Inacos local 202 frente a la cámara de comercio - Calle 12 No 12-64 centro.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375625306', '3187950919', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('69460bb0-c043-492d-9a56-c0b8ae6e9ee8', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Autoservicio El Campeón', 'Venta de víveres en general, frutas y verduras frescas, carnes frías y mucho más

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3102350991
📞 Teléfono: 0375612673
📘 Facebook: https://www.facebook.com/Autoservicio-El-Campe%C3%B3n-1101381693208759/
🌐 Web: http://klicus.com/autocampeon.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_campeon.jpeg?alt=media&token=54d07fd0-2b73-48ca-aba7-3e9d45aec5b4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcampeon%2F1.jpeg?alt=media&token=1d85dd2b-8fe2-4a00-9e30-a64d24a01c3c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcampeon%2F2.jpeg?alt=media&token=396d8f32-9fde-4412-8b61-6250cffc55c0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcampeon%2F3.jpeg?alt=media&token=ed7cf3ca-e664-4763-bde7-69cdd33a7949","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcampeon%2F4.jpeg?alt=media&token=38902b09-788f-459c-a29f-446b6cc2acfa"]', 'diamond', 'active', 'CC Ciudadela Norte Local 59', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375612673', '3102350991', NULL, 'http://klicus.com/autocampeon.php', 'https://www.facebook.com/Autoservicio-El-Campe%C3%B3n-1101381693208759/', NULL, NULL, NULL, 0, NULL),
('6b96f19e-3efe-435d-8588-1315f1a6df06', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Hogar Comultrasan', 'Encuentras las mejores marcas en Electrodomésticos, Muebles, Motos, Bicicletas y muchos productos más. 

Con facilidades de financiación hasta 36 meses por el convenio CENS en tu hogar.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375622485
🌐 Web: http://klicus.com/comultrasan.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcomultrasan%2Flogo.jpg?alt=media&token=36366b2b-6d1e-438f-9116-a48c2fbb1ff7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcomultrasan%2F1.jpg?alt=media&token=7f27418b-6814-4399-b9c8-7c7d1abe86f9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcomultrasan%2F2.jpg?alt=media&token=ef3d7778-8957-4a93-a635-d2fab9aa74d5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcomultrasan%2F3.jpg?alt=media&token=111404ac-2f42-4d14-8d9d-6d62ee84a4e3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcomultrasan%2F4.jpg?alt=media&token=f9850234-4408-4468-ac99-970a61ba6411"]', 'diamond', 'active', 'CC Plazarella y en el Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375622485', NULL, NULL, 'http://klicus.com/comultrasan.php', NULL, NULL, NULL, NULL, 0, NULL),
('6d135b24-51e0-41ab-aa62-26026eb98010', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Nazly Tatiana Alvarez', 'Consultorio Odontologico. Especialista en ortodoncia  y ortopedia maxilar. Manejo de corrección de mal posiciones dentales, corrección mal oclusiones en niños y adultos.
 Estética y funcionalidad para tu boca y puedas lucir la sonrisa deseada.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3013714334
📞 Teléfono: 0375691960
📘 Facebook: https://www.facebook.com/nazly.t.alvarez
📸 Instagram: https://www.instagram.com/tatianaalvarez_14/
🌐 Web: https://dratatianaalvarez.com/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_nazlytatiana.jpeg?alt=media&token=1131cd3c-587f-46b6-b4ae-bc9733425170","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fnazlytatiana%2F1.jpeg?alt=media&token=f9bed706-3300-45ec-b124-6e6a841a4c11","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fnazlytatiana%2F2.jpg?alt=media&token=312fa5a0-a4e0-4843-a94e-20183204d70a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fnazlytatiana%2F3.jpg?alt=media&token=7a082ab9-9eb4-4f54-8b05-b1f362cb9c8b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fnazlytatiana%2F4.png?alt=media&token=0265641b-fcd2-4843-b645-a20b2beb5eb0"]', 'diamond', 'active', 'Calle 11 No. 14-54, Centro, Consultorio 201', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375691960', '3013714334', NULL, 'https://dratatianaalvarez.com/', 'https://www.facebook.com/nazly.t.alvarez', NULL, NULL, NULL, 0, NULL),
('6d99b280-d405-426b-a3d0-83e2e6d8de16', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Panadería Santa Laura', 'Aquí encuentras el mejor pan de la cuidad. Servicio de cafetería. 
Te ofrecemos gran variedad en pan dulce, salados y rellenos.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3174890512
📘 Facebook: https://www.facebook.com/johannaandrea.guerrerosantos
🌐 Web: http://klicus.com/panaderiasanlaura.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_pansantalaura.jpeg?alt=media&token=998e4a69-951c-4a0e-88c5-b882e5b726d8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpanaderiasantalaura%2F1.jpeg?alt=media&token=8918a356-94e8-4d0f-b284-583cf0085afa","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpanaderiasantalaura%2F2.jpeg?alt=media&token=a85f0a9b-0777-4278-b424-805e59b53ce0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpanaderiasantalaura%2F3.jpeg?alt=media&token=ae243073-2b6e-4331-83af-df9ab523428c"]', 'diamond', 'active', 'Cra 49 N°03-05 Ciudadela Norte', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3174890512', NULL, 'http://klicus.com/panaderiasanlaura.php', 'https://www.facebook.com/johannaandrea.guerrerosantos', NULL, NULL, NULL, 0, NULL),
('72bb92b9-c68e-45e3-a671-6d6d1bfa4483', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Agroquímicos San Miguel', 'Venta de insumos agrícolas de excelente calidad. Amplia variedad de productos para la finca. 
Asistencia técnica

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3104095664
🌐 Web: http://klicus.com/agrosanmiguel.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_agrosanmiguel.jpeg?alt=media&token=1c0568e3-1e3c-4f04-af59-4e06f07acdc5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagroquimicossanmiguel%2F1.jpeg?alt=media&token=8cd7f446-dcca-493c-b87a-54c129e6cfbe","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagroquimicossanmiguel%2F2.jpeg?alt=media&token=4f95c26c-d26e-499d-8be3-56b5ed1000e7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fagroquimicossanmiguel%2F3.jpeg?alt=media&token=8282baac-c9a3-49b9-bd59-2af8d6dc9fcf"]', 'diamond', 'active', 'Calle 7 N° 55-173', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3104095664', NULL, 'http://klicus.com/agrosanmiguel.php', NULL, NULL, NULL, NULL, 0, NULL),
('73d72170-af2e-4c0b-a08e-510dc61f85b6', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Foto Centro Solo Color 1 y 2 ', 'Las fotos recuerdan lo que la mente olvida. Manejamos todo lo relacionado con:
	 Impresión fotográfica
	 Fotos para todo tipo de documento
	 Fotos postales
	 Montajes fotográficos
	 Estudios fotográficos
	 Restauración fotográfica.
 Puedes enviar tus fotos a través de las redes sociales. 
	Fotocopias
	 Laminación
	 Servicio de fax
 Tenemos mas de 45 años de experiencia brindando el mejor servicio para la comunidad.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3002166584
📞 Teléfono: 0375625303
🌐 Web: http://www.klicus.com/fotocentrosolocolor.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotocentro%2Flogo_fotocentro.jpg?alt=media&token=144e5c7f-00f8-46dd-994e-5a3b38a3c3a4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotocentro%2Ff1.jpeg?alt=media&token=c99495cc-3082-4612-970e-b3d2dbf23701","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotocentro%2Ff2.jpeg?alt=media&token=87a7d3d0-b6fe-49d2-ae4e-b5db54da522a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotocentro%2Ff3.jpeg?alt=media&token=2ea67c37-5a57-4108-bb4c-02b21e81ea13","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffotocentro%2Ff4.jpeg?alt=media&token=af89d712-79de-47be-b9db-f026c60cdac0"]', 'diamond', 'active', 'Calle 11# 11-76 Sede principal - Sucursal: Foto Centro 2 calle 11 # 11-46', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375625303', '3002166584', NULL, 'http://www.klicus.com/fotocentrosolocolor.php', NULL, NULL, NULL, NULL, 0, NULL),
('73e00f4d-a518-448d-95e4-aaf383fc25e9', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Te Vestimos', 'Alquiler de prendas de vestir para caballeros y niños para toda ocasión.
 Servicio de amenización musical para fiestas y eventos.
 Alquiler de Vehículos para toda Ocasión.
 Sombreros, Mancornas, Turistas, Corbatas. 
*Atendido por el popular Alvarito. 
Toda clase de eventos. 
Contamos con los siguientes servicios: 
	Fotógrafos
	 Camarógrafos
	 Peinadores

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3163343288
📞 Teléfono: Whatsapp 3163343288
📘 Facebook: https://www.facebook.com/profile.php?id=100009141482426
🌐 Web: http://klicus.com/tevestimos.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_tevestimos.jpeg?alt=media&token=ef053d37-ed53-4bed-9cf3-fe30e6d34eb4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftevestimos%2F2.jpeg?alt=media&token=619f9a0c-bf4e-4530-9307-147fd48a0a4c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftevestimos%2F3.jpeg?alt=media&token=cc0c42d4-d895-4b3d-ba12-28d66b0a3af1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftevestimos%2F4.jpeg?alt=media&token=38760212-a006-417f-90ce-df3021be5af2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftevestimos%2F5.jpeg?alt=media&token=3dcba281-6515-472a-9f66-496bae96f049"]', 'diamond', 'active', 'Calle 11 N° 16-13 Barrio San Agustín', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3163343288', NULL, 'http://klicus.com/tevestimos.php', 'https://www.facebook.com/profile.php?id=100009141482426', NULL, NULL, NULL, 0, NULL),
('740981e4-dff5-46bc-ba83-59448cd68228', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Optica Luz De Vida', 'Venta de monturas, lentes monofocales, bifocales, progresivas, transittions. 
Reparación de monturas, despacho de formulas. 
Venta de accesorios ópticos, monturas de media y alta gama.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3224008896
📞 Teléfono: 3224008896
🌐 Web: http://klicus.com/opticaluzdevida.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_opticaluzdevida.jpeg?alt=media&token=795e8fe4-9b5c-4168-86fa-2459425c2ec4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fopticaluzdevida%2F1.jpeg?alt=media&token=ba7da45b-d132-4960-8cd8-f53e1baea277","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fopticaluzdevida%2F2.jpeg?alt=media&token=d3bd46e0-fdc7-402c-ac6c-b9716bf15973"]', 'diamond', 'active', 'Centro Comercial Ciudadela Norte local 39', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3224008896', '3224008896', NULL, 'http://klicus.com/opticaluzdevida.php', NULL, NULL, NULL, NULL, 0, NULL),
('741b0d4a-dcb3-4469-a429-a7754765026e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 11, 'Shark Security Seguridad Electrónica', 'Somos una empresa de Ingeniería e innovación y desarrollo de productos y servicios orientados al mejoramiento tecnológico garantizando un adecuado control y monitoreo electrónico de bienes y actividades productivas. 
Seguimiento de rastreo satelital, vehícular y personal. 
Trabajamos con la mejor marca HIKVISION garantizando nuestro trabajo.
 Se realiza seguimiento 24/7

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3164994349
📞 Teléfono: Whatsapp 3044661014
📘 Facebook: https://www.facebook.com/Shark-Security-504878073016946/
📸 Instagram: https://www.instagram.com/securityshark/
🌐 Web: http://www.sharksecurity.com.co/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_shark.jpeg?alt=media&token=ee424977-5b98-49c4-ad80-e44087f98308","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsharksecurity%2Fs1.jpeg?alt=media&token=63d84bdf-4695-4d68-b6dd-f070ce76ee12","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsharksecurity%2Fs2.jpeg?alt=media&token=46d19153-abf4-495c-b17f-d9f0e7c074ac","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsharksecurity%2Fs3.jpeg?alt=media&token=9c0490c9-01f2-4642-b09e-0d105dc52a84","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsharksecurity%2Fs4.jpeg?alt=media&token=af098c4e-0c6e-4460-9d2d-84b13974e994"]', 'diamond', 'active', 'Calle 7 # 38-46 Barrio La Gloria', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3164994349', NULL, 'http://www.sharksecurity.com.co/', 'https://www.facebook.com/Shark-Security-504878073016946/', NULL, NULL, NULL, 0, NULL),
('77f0c23b-b11b-4f11-a212-126cae9056eb', '44bcac40-5c86-44d6-8cfd-44ae50574580', 8, 'Servicios Contables', 'Asesorías Contables Tributarias y Financieras. 
Tramitología del Rut.
 Créditos Bancarios.
 Planilla de seguridad Social.
 Revisoría Fiscal

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3012589125
📞 Teléfono: 0375637853
📘 Facebook: https://www.facebook.com/cecilia.jacomeprada
🌐 Web: http://klicus.com/servicioscontables.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_ceciliajacome.jpeg?alt=media&token=65d6cc68-e772-4c58-84f9-f95744fd38dd","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fservicioscontables%2F1.jpeg?alt=media&token=79d8c64a-9efa-40eb-afa8-d0271c9ec963","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fservicioscontables%2Flogo_ceciliajacome.jpeg?alt=media&token=827681ca-6e75-4c86-a10f-c009e1e5d37d"]', 'diamond', 'active', 'Calle 12 N°13-19 Local107', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375637853', '3012589125', NULL, 'http://klicus.com/servicioscontables.php', 'https://www.facebook.com/cecilia.jacomeprada', NULL, NULL, NULL, 0, NULL),
('7921871a-a02d-45ab-a7c3-3b8c0ce1da1c', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Odontokids', 'La salud oral es una parte integral de la salud general del niño. La odontopediatría es la especialidad de la odontología que trata el cuidado oral preventivo y terapéutico de niños y adolescentes.
 Detectamos oportunamente los problemas de salud oral.
 Tratamientos diseñados particularmente para niños.
 Educamos a los niños para el cuidado de sus dientes.
 Ayudamos a evitar la caries, enfermedades periodontales, permitiendo detección de posibles molestias.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3012700648
📞 Teléfono: 0375696237
📘 Facebook: https://www.facebook.com/laryquintero
🌐 Web: http://klicus.com/odontokids.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_odontokids.jpeg?alt=media&token=7d9952e2-a720-41eb-af24-b34d9d7456eb","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontokids%2Fodo1.jpg?alt=media&token=72d30b5f-f6fd-4724-84b7-bce9914bd948","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontokids%2Fodo2.jpg?alt=media&token=ff46712b-064c-43e6-8833-85b85fd339b3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontokids%2Fodo3.jpg?alt=media&token=b2ea0065-b7c0-4a36-b234-d6873203baf3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontokids%2Fodo4.jpg?alt=media&token=3b1fca74-a71a-4838-9935-4ffe4d2690aa"]', 'diamond', 'active', 'Edificio La Guaca Lc. 207 Centro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375696237', '3012700648', NULL, 'http://klicus.com/odontokids.php', 'https://www.facebook.com/laryquintero', NULL, NULL, NULL, 0, NULL),
('79e89e59-5ef3-43bd-b982-ad7415c24a4e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Charcutería El Deleite', 'Tenemos todo lo relacionado con Carnes Frías, Salsas, Pan para Perros - Hamburguesas.
 Distribuidores directos de productos GABY (Pastas - Salsas - Natas) en todas sus presentaciones.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168712828
📞 Teléfono: 0375690497', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcarnesfriaseldeleite%2Flogo.jpeg?alt=media&token=990e8f8c-6bfa-46ce-bae8-0282e2f05124","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcarnesfriaseldeleite%2Fc1.jpeg?alt=media&token=f95ef040-28d1-4b99-9c15-ad9810e0b923","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcarnesfriaseldeleite%2Fc10.jpeg?alt=media&token=93f498d0-be74-4d1d-a457-8fc4b0b9753b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcarnesfriaseldeleite%2Fc11.jpeg?alt=media&token=9152732a-7593-4779-acc7-82d1ff525590","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcarnesfriaseldeleite%2Fc2.jpeg?alt=media&token=9d308edc-1155-4897-a578-d35eaaebf70c"]', 'diamond', 'active', 'Cra 14 No. 8a-06 Local 4A Centromercado Ocaña y en la Cra 11 No. 11-37 Diagonal puerta falsa Capilla Torcoroma', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375690497', '3168712828', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('7bd6fc22-c4a1-4732-a0e3-27e77c3d9cc2', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Micromercado Koki', 'Todo lo relacionado con víveres en general. Encontrarás todo para tu canasta familiar, Aseo, Frutas y Verduras. 
También le ofrecemos a nuestra distinguida clientela el recaudo de todos los servicios Públicos como Agua, Luz, Parabólica, Gas.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3164942285
📞 Teléfono: 0375611593
🌐 Web: http://klicus.com/micromercadokoki.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmicromercadokoki%2Flogo.jpeg?alt=media&token=41a1f840-80d7-43f5-ad57-f373ef1f17e9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmicromercadokoki%2Fk1.jpeg?alt=media&token=a3515c4f-edc6-4075-a877-c57b2a5ce5d3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmicromercadokoki%2Fk2.jpeg?alt=media&token=c271e042-0a91-44e9-9d4d-06717aa6c7ab","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmicromercadokoki%2Fk3.jpeg?alt=media&token=c670288e-b1ff-4442-a66d-d7f52f8678eb","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmicromercadokoki%2Fk4.jpeg?alt=media&token=82463eca-7c7f-42a9-b119-88370326056f"]', 'diamond', 'active', 'Calle 5 # 49-07 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375611593', '3164942285', NULL, 'http://klicus.com/micromercadokoki.php', NULL, NULL, NULL, NULL, 0, NULL),
('7d964d01-2731-4ca8-9aec-116ec0db78ca', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Megadrogas Medicamentos Confiables', 'Despacho de medicamentos, toma de tensión, Fotocopias, Fax, Minutos

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3167479440
📞 Teléfono: 0375624991', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_megadrogas.jpeg?alt=media&token=b62e45b0-2314-453b-b45e-04922ff94b16","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_megadrogas.jpeg?alt=media&token=b62e45b0-2314-453b-b45e-04922ff94b16","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_megadrogas.jpeg?alt=media&token=b62e45b0-2314-453b-b45e-04922ff94b16"]', 'diamond', 'active', 'Calle 11 No. 25-40 Local 2 Barrio las llanadas', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375624991', '3167479440', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 6, 'Veterinaria el Recreo', 'Servicios veterinarios
Consulta
Grooming 
', '["/uploads/ads/Captura de pantalla 2026-04-15 105336-1776441833203.webp"]', 'diamond', 'active', 'Bucaramanga', '', NULL, '2036-04-15 01:17:45', '2026-04-17 16:03:57', 'Calle 197 27C - 21', '', '3135328897', 'prueba@prueba.com', 'elrecreovet.com', 'facebook.com/recreo', '@recreovet', 'L-V 8 a 6 pm', 'Domicilio Gratis', 0, NULL),
('83fe826c-d6dc-4c35-a0c0-fe91e62dd07a', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'La Cava', 'Tenemos para ti Útiles Escolares y de Oficina y los servicios de: 
	Fotocopias e impresiones en B/N y color
	 Laminación
	 Fax
	 Empaste anillado y cosido
	 Velobinder y pasta dura
	 Escaner
	 Impresión láser.
 Aplicamos normas APA e ICONTEC. 
Digitamos toda clase de trabajos. 
Descargamos tus antecedentes judiciales, Sisbén - Fosyga. 
Rotulamos y quemamos tus CD.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3164905202
📘 Facebook: https://www.facebook.com/cava.ocana', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacava%2Flogo_cava.jpeg?alt=media&token=48c96cc1-4bb4-46dc-b4af-6dcff10460e2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacava%2Flogo_cava.jpeg?alt=media&token=48c96cc1-4bb4-46dc-b4af-6dcff10460e2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacava%2Fc1.jpeg?alt=media&token=7c3d1206-7055-43dc-b032-c2ef26b1527e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacava%2Fc2.jpeg?alt=media&token=ae2eb94d-484c-4211-800d-031a75e32a94","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacava%2Fc3.jpeg?alt=media&token=080830b8-c105-483d-8870-92fd917e3fd2"]', 'diamond', 'active', 'Calle 12 N 10-03 Carretero', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3164905202', NULL, NULL, 'https://www.facebook.com/cava.ocana', NULL, NULL, NULL, 0, NULL),
('86bfcd1f-eb10-430f-9428-40a7e66b5848', '44bcac40-5c86-44d6-8cfd-44ae50574580', 8, 'Inocuo', 'Diseño e implementación Saneamiento básico.
 Cursos de Manipulación de alimentos.
 Asesoría en exigencias de INVIMA y Sec. De Salud.
 Implementación de B.P.M, POE, POES, PHS, HACCP.
 Montaje y Auditorías Internas del SG-SST

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3162282295
📘 Facebook: https://www.facebook.com/TAPIQU
🌐 Web: http://klicus.com/inocuo.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_inocuo.jpeg?alt=media&token=2c7748f6-e3f9-4f16-8704-381640f4c4ab","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Finocuo%2F1.jpeg?alt=media&token=8197ecf2-a9e8-4d07-8cac-e3957a33b856","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Finocuo%2F2.jpeg?alt=media&token=97adcfb4-f8c2-48e2-8e88-b2a05c78a877","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Finocuo%2F3.jpg?alt=media&token=4726d755-2c2f-432f-a0a2-bd3f78add6fd","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Finocuo%2F4.jpg?alt=media&token=0539bc39-e550-4703-aa44-f64c84de4df8"]', 'diamond', 'active', 'Ocaña, Norte de Santander', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3162282295', NULL, 'http://klicus.com/inocuo.php', 'https://www.facebook.com/TAPIQU', NULL, NULL, NULL, 0, NULL),
('8c227f5c-d2cc-40d7-8c99-cb077ae05fe0', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'El Reino Gourmet', 'Somos una empresa especialista en toda clase de tortas frías y ponque. También ofrecemos una gran variedad de Postres, Café, Malteadas y Jugos Naturales.
 Ven y visítanos para que deleites tu paladar.
 El Reino Gourmet, sabor y más inspiración.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3118185306
📞 Teléfono: 0375625252
📘 Facebook: https://www.facebook.com/andres.reino.94
📸 Instagram: https://www.instagram.com/elreinogourmet/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felreinogourmet%2Flogo_elreinogourmet.jpeg?alt=media&token=6f2f3d0a-2218-4ad1-8b90-be3149d02e40","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felreinogourmet%2F1.jpeg?alt=media&token=b8c6eaf0-9c23-4541-8f84-c0dd143c0e70","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felreinogourmet%2F2.jpg?alt=media&token=6f13c9c9-e541-4340-a6b3-af239d470ca1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felreinogourmet%2F3.jpg?alt=media&token=5275991e-6543-43e6-8d54-d767d12f8743","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felreinogourmet%2F4.jpg?alt=media&token=ddb584ed-87ad-4b98-801d-fe0fa37ffa66"]', 'diamond', 'active', 'CRA 12 # 7-51 cementerio central', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375625252', '3118185306', NULL, NULL, 'https://www.facebook.com/andres.reino.94', NULL, NULL, NULL, 0, NULL),
('8eb51b74-62f9-4f92-82db-734ca31d3bee', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Arepería La Ocañerita', 'La gastronomía de nuestra alegra el día a día de los Ocañeros, la arepa Ocañera tradición de nuestra tierra deleita los paladares de propios y extraños, la arepa evoluciona combinando ingredientes y sabores en la Ocañerita. 

El orgullo de una región manteniendo el sabor a hogar 

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3105697533
📞 Teléfono: 0375693265
📘 Facebook: https://www.facebook.com/areperialaocanerita/
📸 Instagram: https://www.instagram.com/areperialaocanerita/
🌐 Web: http://klicus.com/areperialaocanerita.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaoca%C3%B1eritaareperia%2Flogo.jpg?alt=media&token=988f5a06-ec71-46a3-87b0-074343061c6b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaoca%C3%B1eritaareperia%2F1.jpg?alt=media&token=de638f6d-99e7-4c39-b59f-8ac257d1f21a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaoca%C3%B1eritaareperia%2F2.jpg?alt=media&token=0f743e05-f0d8-46a8-a831-f9c117ad9260","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaoca%C3%B1eritaareperia%2F3.jpg?alt=media&token=2516c87b-4488-4402-acf3-5223ecf7bca8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flaoca%C3%B1eritaareperia%2F4.jpg?alt=media&token=f2460d95-42f0-4bf4-a9d4-c2c733985ee0"]', 'diamond', 'active', 'Calle 11 No. 14-14 Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375693265', '3105697533', NULL, 'http://klicus.com/areperialaocanerita.php', 'https://www.facebook.com/areperialaocanerita/', NULL, NULL, NULL, 0, NULL),
('8faa2361-63f2-4d59-9841-86022bb7f4be', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Papelería Skala', 'Papelería en general, Fotocopias, Empaste, Laminación, Recargas, Trabajos en Fomy, Country.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3163939252
📞 Teléfono: 3163939252
🌐 Web: http://www.klicus.com/papeleriaskala.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fskala%2Flogo.jpeg?alt=media&token=0a0c4e58-4871-432f-9336-26592e4de57a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fskala%2Fs1.jpeg?alt=media&token=47bb2ee2-5a28-438e-bedb-e8d50a4c2cd6","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fskala%2Fs2.jpg?alt=media&token=d9ce625f-9795-496c-8d61-47cf2b857705","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fskala%2Fs3.jpg?alt=media&token=30f90966-19f7-444f-b134-359aae0862e7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fskala%2Fs4.jpg?alt=media&token=a453a585-c6aa-4b57-b213-921eb57dc512"]', 'diamond', 'active', 'Calle 6 # 48-59 Pasos arriba Crediservir, frente al puente peatonal. Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3163939252', '3163939252', NULL, 'http://www.klicus.com/papeleriaskala.php', NULL, NULL, NULL, NULL, 0, NULL),
('8ff1ebb2-7d3f-4690-98b9-a0394e232f7b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Autoservicio El Emprendedor', 'Todo en productos para la canasta familiar.
 Frutas y verduras frescas de excelente calidad al por mayor y menor.
 Pollo.
 Carnes.
 Quesos.
 Excelentes precios.
 Pregunte por nuestros productos en oferta.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3167585144
🌐 Web: http://klicus.com/autelemprendedor.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_emprendedor.jpeg?alt=media&token=bd8d26ae-93d1-4826-bd24-30066812e2ca","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Femprendedor%2F3.jpeg?alt=media&token=34f3b85c-a02d-40f2-8345-8abc47966396","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Femprendedor%2F4.jpeg?alt=media&token=fd8420b0-3d97-4c8b-bea8-265607e308b0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Femprendedor%2F5.jpeg?alt=media&token=338755f1-5bf6-4195-97bf-174461f130e9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Femprendedor%2F6.jpeg?alt=media&token=3b784796-f661-47b0-8935-8b0322dd9bde"]', 'diamond', 'active', 'Cra 49 n°04 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3167585144', NULL, 'http://klicus.com/autelemprendedor.php', NULL, NULL, NULL, NULL, 0, NULL),
('90b94951-a2b3-49ff-b66b-df21c206b918', '44bcac40-5c86-44d6-8cfd-44ae50574580', 5, 'Academia y Sala de Belleza Gerau', 'Tenemos servicios de Peluquería, Cortes, Peinados, Maquillaje para toda ocasión.
 Contamos con gran variedad de productos y servicios. 
Dictamos clases en técnicos en Belleza Integral, manejas el aprendizaje por módulos, Manicure y Pedicure, Cortes en todas las tendencias, Barbería, Colorimetría.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3219695291
📞 Teléfono: 3162089162', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgerau%2Flogo.jpeg?alt=media&token=57c33aeb-34e6-44ca-bba2-733123b42e41","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgerau%2Fr2.jpeg?alt=media&token=cb32fccd-fd45-4f51-9754-004140246444","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgerau%2Fr11.jpeg?alt=media&token=72fdb6ed-a5e6-4aa2-9e44-0d9cb1e13ac5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgerau%2Fr12.jpeg?alt=media&token=02f5e613-0975-47c8-ba55-abf6ade4a6ac","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgerau%2Fr13.jpeg?alt=media&token=b334c5c5-6307-4e64-9c1f-411871cc0bb8"]', 'diamond', 'active', 'Ocaña, CC Ciudadela Norte - Abrego, Pasos arriba del parque la Cebolla - Convención, Frente al Chorrito calle del comercio.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3162089162', '3219695291', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('91ca1c4f-2414-460c-9b63-44e5f7038452', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Super Cascos Santa Clara', 'Accesorios para motocicletas, cascos, chalecos, impermeables.
 En super cascos encontraras cascos de tipo integral, cross y abiertos.
 Excelentes precios.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3162790927
🌐 Web: http://klicus.com/supercascos.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_supercascos.jpeg?alt=media&token=c66a1f71-adfc-4a34-85b9-b2793eb3fb07","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsupercascossantaclara%2F2.jpeg?alt=media&token=34bcd982-eefb-4951-bf5d-1a86cc7d96d4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsupercascossantaclara%2F3.jpeg?alt=media&token=60f8324f-6a98-4bf8-8900-cda6827be4b3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsupercascossantaclara%2F4.jpeg?alt=media&token=d73b0da9-4d55-4387-a918-6d429f45e8b4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsupercascossantaclara%2F5.jpeg?alt=media&token=b7cfa64a-4b87-4bb7-95b3-1bca18c914f5"]', 'diamond', 'active', 'Cra 49 N°04-31 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3162790927', NULL, 'http://klicus.com/supercascos.php', NULL, NULL, NULL, NULL, 0, NULL),
('96172909-7673-434f-b0b8-e98ee953363f', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Mundo Dulces', 'Todo lo relacionado con dulcería, licores y más. 
Somos distribuidores de Super, Italo, Colombina entre otros. 
Todo tipo de vinos y licores.
 ventas al por mayor y al detal.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168318897
🌐 Web: http://klicus.com/mundodulces.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_mundodulces.jpg?alt=media&token=7aed006e-1e5e-4a8e-b285-23e65c36794c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmundodulces%2Fm1.jpeg?alt=media&token=3d960af3-e006-404c-8fe5-acef1a0422c4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmundodulces%2Fm2.jpeg?alt=media&token=c32dded5-aefe-4cb4-9f21-2a8b9721fa40","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmundodulces%2Fm3.jpeg?alt=media&token=2385b3a2-077f-4d6c-932d-1530d90dc6e4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmundodulces%2Fm4.jpeg?alt=media&token=ff5bcddb-ca80-4df7-b57d-8a226ae24ac8"]', 'diamond', 'active', 'Mercado público', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3168318897', NULL, 'http://klicus.com/mundodulces.php', NULL, NULL, NULL, NULL, 0, NULL),
('964db835-425a-4e9a-a21a-ab7332f6494e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Tienda Naturista Fuente de Vida', 'La salud es el elixir de la vida, por eso le ofrecemos todo los relacionado con medicina natural alternativa. 
Comercializamos productos de bienestar vitaminas, suplementos dietarios, productos homeopáticos, productos dietéticos, fibras naturales entre otros.
 Ofrecemos precios competitivos para que el bienestar y la salud este al alcance de todos.

--- 🌟 CONTACTO PREMIUM ---
🌐 Web: http://klicus.com/tiendanaturfuentvida.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_fuentedevida.jpeg?alt=media&token=04eca101-18b9-497a-a4d6-95d04d428fe3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftiendafuentedevida%2F1.jpeg?alt=media&token=8bd3920b-7b40-401b-8761-d7c43ea227cc","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftiendafuentedevida%2F2.jpeg?alt=media&token=4969000d-9ae0-460f-b2d9-906abcd7600e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftiendafuentedevida%2F3.jpeg?alt=media&token=61fe541a-7845-4b6f-bdfb-74322242c02e"]', 'diamond', 'active', 'Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, NULL, NULL, 'http://klicus.com/tiendanaturfuentvida.php', NULL, NULL, NULL, NULL, 0, NULL),
('97457367-b245-4955-b084-e66131e70d32', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Mascoticas Mascolandia', 'Productos veterinarios, Mascotas, Peces, Peluquería canina, Guardería canina y muchos productos más para tus mascotas.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3165049760
📞 Teléfono: 0375623030
📘 Facebook: https://www.facebook.com/MASCOLANDIA
📸 Instagram: https://www.instagram.com/mascoticasocana/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_mascoticas.jpg?alt=media&token=29ea7b60-76ff-4174-8373-61da1ee8d29e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmascoticasmascolandia%2F8.jpeg?alt=media&token=934fd8d9-9602-4254-9568-0ced99531e7c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmascoticasmascolandia%2F9.jpeg?alt=media&token=3c7e0764-e566-4384-a00f-bfb979dbbd18","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmascoticasmascolandia%2F10.jpeg?alt=media&token=c8e55830-ee52-4eed-aaab-19a25c554cfe","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmascoticasmascolandia%2F11.jpeg?alt=media&token=0d0db58f-eaff-48b5-b268-990ec4129664"]', 'diamond', 'active', 'Calle 9 15-20 Barrio San Cayetano', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375623030', '3165049760', NULL, NULL, 'https://www.facebook.com/MASCOLANDIA', NULL, NULL, NULL, 0, NULL),
('981c4c2f-f87a-43a8-ac53-b5846cba6f66', '44bcac40-5c86-44d6-8cfd-44ae50574580', 5, 'Vanidad Estudio de Belleza', 'Se realizan uñas en acrílico, cepillados, colorimetría, peinados y maquillaje para toda ocasión. Spa.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3204624850
📞 Teléfono: Whatsapp 3005864320', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_vanidadstudio.jpeg?alt=media&token=cca05ade-ff8f-42a0-9d9d-4f13518de486","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fvanidadestudio%2F1.jpeg?alt=media&token=9b5bff7b-09e0-4850-867f-5a896dcd4d5b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fvanidadestudio%2F2.jpeg?alt=media&token=01ad7fb7-a7c5-4316-8919-3a7987ea93bb"]', 'diamond', 'active', 'CC Santa María local 212-213', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3204624850', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('990a5b7b-5883-46ae-bb4a-cd1674ee7d00', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Donde Karina Comidas Rápidas', 'DONDE KARINA COMIDAS RAPIDAS es un establecimiento que ofrece productos como salchipapas mixtas, perros calientes, hamburguesas, arepitas, entre otros. Donde nuestros clientes pueden degustar las comidas rápidas con productos de calidad. 

Además, también ofrecemos servicios decorativos para toda ocasión como son: 

	Fechas especiales 
	Cumpleaños 
	Amor y amistad 
	Toda aquella ocasión que usted como cliente desea que sea especial para su pareja, amigos o familia.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168273366
📞 Teléfono: 0375636264
📘 Facebook: https://www.facebook.com/dondekarina.comidasrapidas
📸 Instagram: https://www.instagram.com/dondekarina/
🌐 Web: http://klicus.com/dondekarina.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdondekarinacomidasrapidas%2Flogo.jpg?alt=media&token=231e00da-d44b-40db-8afa-30c17183f3e8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdondekarinacomidasrapidas%2F2.jpg?alt=media&token=a56d3042-a416-487c-ba2f-f12f93cdc0f2","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdondekarinacomidasrapidas%2F3.jpg?alt=media&token=cf38b494-d6a3-4349-a558-632903e2c229","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdondekarinacomidasrapidas%2F4.jpg?alt=media&token=edf1db78-1f3f-420c-82c7-eb3e6a02b02f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdondekarinacomidasrapidas%2F5.jpg?alt=media&token=5da83c69-6d8a-4c4b-8d96-f10de2ecbef4"]', 'diamond', 'active', 'Cra. 13 No. 3 - 13 Torcoroma, pasos abajo Parroquia Juan XXIII', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375636264', '3168273366', NULL, 'http://klicus.com/dondekarina.php', 'https://www.facebook.com/dondekarina.comidasrapidas', NULL, NULL, NULL, 0, NULL),
('99e1151b-b4a6-4fe4-bc67-12fff650c957', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Odontología y Ortodoncia', 'Tu sonrisa es nuestra pasión, por ello buscamos que cada uno de los procedimientos resalten tu estética dental. 
Manejo de diferentes tipos de ortodoncia y blanqueamientos dentales.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3108870937
🌐 Web: http://klicus.com/odontologia.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_odontologia.jpeg?alt=media&token=c68fb079-ae17-422a-9d93-9454a273f309","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontologiayortodoncia%2F1.jpeg?alt=media&token=c73ce1e9-74a6-4b04-bf23-18d2bec4526c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodontologiayortodoncia%2F2.jpeg?alt=media&token=6400dd3c-0695-4400-b35d-b093f776420b"]', 'diamond', 'active', 'Calle 4 N° 48-38 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3108870937', NULL, 'http://klicus.com/odontologia.php', NULL, NULL, NULL, NULL, 0, NULL),
('9ad97fa8-d027-48ff-af0a-3da4781c55b7', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Comidas Rápidas Tazmania', '-Arepas Rellenas
 -Papas Locas
 -Picadas
 -Perros 
-Hamburguesas
 -Chatas de Res
 -Desgranados
 -Frapes. 
Toda Una Tentación

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3133260725
📞 Teléfono: 0375619825', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftazmania%2Flogo.jpeg?alt=media&token=6a866dac-fb24-4dfc-b0e9-1f28964f5eb0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftazmania%2F1.jpeg?alt=media&token=7e0b26e3-25e1-41c1-9fe8-be4c0b388d2c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftazmania%2F19.jpeg?alt=media&token=0e50b339-16ca-47c1-803e-03f7b6167039","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftazmania%2F2.jpeg?alt=media&token=4e21600d-9726-4af9-a45c-b76d4c2459e9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ftazmania%2F11.jpeg?alt=media&token=9251c311-1c57-4fdf-8834-8d661d258454"]', 'diamond', 'active', 'Calle 4A # 48-04 Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375619825', '3133260725', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('a2ac70b9-a18e-4575-a353-1852df0132c6', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Dimonex Efecty', 'Servicios: 
		Corresponsal Bancolombia
		 Efecty
		 Coompencens
		 Giros nacionales
		 Pagos Servicios Públicos
		 Facturas
		  Recargas
		

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375697304', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdimonex%2Flogo.jpeg?alt=media&token=8c9c01c1-1130-4fbc-a210-6599f12fdded","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdimonex%2Flogo.jpeg?alt=media&token=8c9c01c1-1130-4fbc-a210-6599f12fdded","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdimonex%2Fd1.jpeg?alt=media&token=a7e5c3e4-d9a2-4a98-9d4f-7704ddc845c5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdimonex%2Fd2.jpeg?alt=media&token=458bb04e-1d09-4bf8-bc2f-abe7dbc0caa4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fdimonex%2Fd3.jpeg?alt=media&token=d7c581d1-f7d4-482a-932d-e81ccd13e3af"]', 'diamond', 'active', 'Calle 11 N 6-76 Barrio la luz polar diagonal a la cruz roja, pasos arriba San Francisco', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375697304', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('a2e651ce-a416-4722-a50f-b9ac58410b35', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Almacenes El Hueco', 'Te viste con las nuevas colecciones, accesorios y calzado, los precios te sorprenderán, tenemos un gran surtido para vestir a toda la familia.

--- 🌟 CONTACTO PREMIUM ---
📘 Facebook: https://www.facebook.com/Almac%C3%A9n-el-Hueco-347785718976491/?ref=br_rs
📸 Instagram: https://www.instagram.com/explore/locations/347785718976491/almacen-el-hueco/
🌐 Web: http://klicus.com/elhueco.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felhueco%2Flogo.jpg?alt=media&token=aff9a566-6983-4202-a0d4-a756e67a658c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felhueco%2F1.jpg?alt=media&token=6b5044dd-278b-4137-b72d-8360f7db69c9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felhueco%2F2.jpg?alt=media&token=676bd5eb-5cfa-453a-bd35-e79b9e323102","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felhueco%2F3.jpg?alt=media&token=4a1bece8-a15f-4706-b5f9-375b4c07a3cd","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Felhueco%2F4.jpg?alt=media&token=69625eae-5b37-4668-bec4-a1024bed6ea0"]', 'diamond', 'active', 'Cra 9 No. 12-39b Barrio El Carretero
Calle 11 No. 11-13 Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, NULL, NULL, NULL, 'http://klicus.com/elhueco.php', 'https://www.facebook.com/Almac%C3%A9n-el-Hueco-347785718976491/?ref=br_rs', NULL, NULL, NULL, 0, NULL),
('a93fac92-847d-4a77-a31f-74c113e3de39', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Serviservicios Ocaña Sas', 'Servicio de Monitoreo de alarmas. Vigilamos su Empresa, Local Comercia, Casa u Oficina. 
Nos especializamos en: 
	Aperturas
	 Cierres
	 Alarmas de robo
	 Sabotaje de líneas telefónicas.
 Su seguridad nuestra prioridad.
 Venta de Alarmas. 
Supervisión las 24 Horas. 
Algunos de nuestros Clientes: 
	Ladrillera Ocaña
	 Laino & Solano
	 Caficultores
	 Espo
	 Cámara de Comercio
	 Pisos y Enchapes

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3164114850
📞 Teléfono: 0375697977', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fserviservicios%2Flogo.jpg?alt=media&token=3c4a63dd-99f4-4876-b60c-b6c0f039d854","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fserviservicios%2Flogo.jpg?alt=media&token=3c4a63dd-99f4-4876-b60c-b6c0f039d854"]', 'diamond', 'active', 'Calle 10 # 14-17 Piso 3, Local 303 CC Andalucia', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375697977', '3164114850', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('aed54f12-298d-426f-8c6d-17fdb9208f82', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Droguería X', 'Venta de medicamentos Originales, servicio de inyectologia, productos naturales, personal ético e idóneo altamente capacitado para ofrecerle un mejor servicio.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3132311683
📞 Teléfono: 0375611952
📘 Facebook: https://www.facebook.com/DrogueriaX/
📸 Instagram: https://www.instagram.com/drogueria_x/
🌐 Web: http://klicus.com/drogueriax.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fx%2Fx6.jpeg?alt=media&token=5716cb7b-8051-4a9e-a52b-926eb4d22101","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fx%2Fx6.jpeg?alt=media&token=5716cb7b-8051-4a9e-a52b-926eb4d22101","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fx%2FX2.jpg?alt=media&token=034a12c5-939b-41aa-8da6-4a9459eb3c8d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fx%2FX3.jpg?alt=media&token=25a10354-d92f-4716-988a-8295f85c8f67","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fx%2FX4.jpg?alt=media&token=95b45ba5-70df-4c7f-b735-f7d50a5d9887"]', 'diamond', 'active', 'Ave, Francisco Fernandez de Contreras Entrada Hospital.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375611952', '3132311683', NULL, 'http://klicus.com/drogueriax.php', 'https://www.facebook.com/DrogueriaX/', NULL, NULL, NULL, 0, NULL),
('b0e37aa5-f53e-4245-853d-497ac170cb7f', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Frutinoa', 'FRUTINOA te ofrece Deliciosos Batidos Saludables, Ensaladas de Frutas, Regalos Deliciosos, Bouquets de Frutas para toda ocasión.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3156986858
📞 Teléfono: 3156986858
📘 Facebook: https://www.facebook.com/fruti.noa
📸 Instagram: https://www.instagram.com/frutinoa/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrutinoa%2Flogo.jpeg?alt=media&token=06975a88-26a3-4282-be31-e9e52ebd80a3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrutinoa%2Ff1.jpeg?alt=media&token=6f69d301-7048-40d0-bca3-5a57bbd892e8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrutinoa%2Ff2.jpeg?alt=media&token=5fccd554-48d0-4f8a-bb2a-568b0ff15a6c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrutinoa%2Ff3.jpeg?alt=media&token=1eb1c1eb-e0da-411d-91e0-2ac17c8d1510","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrutinoa%2Ff4.jpeg?alt=media&token=a4121650-09fd-4fc0-bda3-561cf14e24ec"]', 'diamond', 'active', 'Calle 12 N 11-18 calle de las notarias', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3156986858', '3156986858', NULL, NULL, 'https://www.facebook.com/fruti.noa', NULL, NULL, NULL, 0, NULL),
('b136eaed-df69-4d3d-8969-07adf992428e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Escudo de Acero', 'Venta de tubos en Acero, Tornillos, Accesorios en Acero 
	- Fabricación de equipos industriales para Panadería, Restaurantes, Comidas Rápidas

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3124170783
📞 Teléfono: 3142377498', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fescudodeacero%2Fe1.jpeg?alt=media&token=54b1fa99-ac30-4bfc-b1c6-16b9068369d8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fescudodeacero%2Fe1.jpeg?alt=media&token=54b1fa99-ac30-4bfc-b1c6-16b9068369d8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fescudodeacero%2Fe10.jpeg?alt=media&token=d5111338-d2b2-4d28-a00f-c53e39c69448","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fescudodeacero%2Fe11.jpeg?alt=media&token=01d26ee1-edf7-46f8-a189-109bb427161f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fescudodeacero%2Fe2.jpeg?alt=media&token=ff850d3c-6d4f-4e6c-83ca-d4dfe2fb7136"]', 'diamond', 'active', 'Av. el Dorado Calle 11 No. 30C-34 La Provenza', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3142377498', '3124170783', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('b30b2b52-4803-4ccc-bd51-49738e72234b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Grupo Empresarial Kmy', 'Llega a Ocaña con sus líneas de agua y refrescos para que los disfrutes al hacer deporte, en la casa, en el colegio o donde lo desees. 

	Agua Bruma 
	Jugos Kola Club

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3228736444
📞 Teléfono: 0375491503
🌐 Web: http://klicus.com/kmy.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkmy%2Flogo.jpg?alt=media&token=fdc225e7-8b8e-4e0a-99ca-0561d782db41","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkmy%2F1.jpg?alt=media&token=b22cc0ec-26b3-414f-bb57-a1cd6f162c13","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkmy%2F2.jpg?alt=media&token=fe6dc0cb-c2f8-401c-a6f8-a3f41aa5806f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkmy%2F3.jpg?alt=media&token=33118ed1-0684-4e54-b4a9-8febee3210ec","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fkmy%2F4.jpg?alt=media&token=9ba67c18-ec43-4bec-b334-8f707246ebf9"]', 'diamond', 'active', 'KDX 411-370 Piso 1 Av. Circunvalar', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375491503', '3228736444', NULL, 'http://klicus.com/kmy.php', NULL, NULL, NULL, NULL, 0, NULL),
('b7582a26-8c29-436e-ae3e-82cab0e53326', '44bcac40-5c86-44d6-8cfd-44ae50574580', 5, 'Salón de Belleza Ana', 'Quieres verte bella? Ven y visítanos, somos expertas en satisfacer tus necesidades. 
Te ofrecemos un servicio de excelente calidad en: 
	Cortes para niño
	 Peinados para niña
	 Mechas
	 Tintes
	 Peinados y maquillajes para toda ocasión.
	 Extensiones de cabello
	 Cepillados
	 Planchados
	 Keratina
	 Planchados permanentes
	 Pigmentación en cejas
	 Extensiones de pestañas
	 Uñas en gel y acrílicas
	 Corte de cabello para dama y caballero
	 Depilación en cera
	 Repolarización. 
Encontraras gran variedad de productos para el cabello.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3157520523
📞 Teléfono: 0375626313
📘 Facebook: https://www.facebook.com/profile.php?id=100009533623600', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsalonbellezaana%2Fa1.jpeg?alt=media&token=d602388d-1f2f-4b08-b570-286b942ae5a4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsalonbellezaana%2Fa2.jpeg?alt=media&token=9244443b-a48a-40dc-8761-90c04044b230","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsalonbellezaana%2Fa3.jpeg?alt=media&token=c4dfbc38-6a0d-46b8-881c-88781b08c661"]', 'diamond', 'active', 'Calle 8 No 11A - 25. Barrio Urbanización Marina.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375626313', '3157520523', NULL, NULL, 'https://www.facebook.com/profile.php?id=100009533623600', NULL, NULL, NULL, 0, NULL),
('bd33831e-f8d2-46ec-a3fb-5e98fe3c6aa3', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Aceros Inoxidables', 'Elaboramos fachadas en vidrio templado y acero
 Barandas
 Pasamanos
 Accesorios en Acero
 Servicio de Torno.
 Trabajo Garantizado

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3115296243', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Facerosinoxidables%2Flogo_acerosinoxidables.jpeg?alt=media&token=4aceeaf3-7e4c-48f9-8eaf-5b022c75ad3c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Facerosinoxidables%2Fa1.jpeg?alt=media&token=5f5509f5-29c6-4009-90b3-a763ff7e2db0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Facerosinoxidables%2Fa2.jpeg?alt=media&token=2e24ef55-1d16-45f7-ab1e-847ed9e5e995","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Facerosinoxidables%2Fa3.jpeg?alt=media&token=cc10dfd5-5499-4444-92fd-6d0825582839","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Facerosinoxidables%2Fa4.jpeg?alt=media&token=78bda18a-b7d6-4982-ab3f-dd26002e6435"]', 'diamond', 'active', 'Cra 25 # 13-02 Barrio El Retiro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3115296243', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('bfa32013-8fed-4522-a84c-3222d4911121', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Asadero Frespollo', 'El mejor pollo asado y a la broaster de la ciudad.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3214875465
🌐 Web: http://klicus.com/frespollo.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_frespollo.jpeg?alt=media&token=99d7e888-3491-4273-96db-1979c3c8f09f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrespollo%2F1.jpeg?alt=media&token=41552721-2a62-4e21-a7d9-5b864892395f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrespollo%2F2.jpeg?alt=media&token=f3087d65-a7fc-4758-a443-7b79e3883668","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrespollo%2F3.jpeg?alt=media&token=62234855-0486-4ec7-b882-7ad7c06b08ad","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffrespollo%2F4.jpeg?alt=media&token=dfd8ff91-3a52-4e81-b30e-ff200da03600"]', 'diamond', 'active', 'Cra 49 N°3-11 Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3214875465', NULL, 'http://klicus.com/frespollo.php', NULL, NULL, NULL, NULL, 0, NULL),
('c0425806-f337-4d18-be6a-55b2014e4bc5', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Magafi', 'Todo lo relacionado con madera melamina RH, Cocinas integrales, Closets, Puertas, Gabinetes para baños, Muebles para oficina, Escritorios.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3153331626
📞 Teléfono: 3173764676
📘 Facebook: https://www.facebook.com/leonardo.vilabecerra
📸 Instagram: https://www.instagram.com/leonardorafaelvila/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_magafi.jpg?alt=media&token=862aa537-3165-44e0-85a0-ad1a0e1092b7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_magafi.jpg?alt=media&token=862aa537-3165-44e0-85a0-ad1a0e1092b7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_magafi.jpg?alt=media&token=862aa537-3165-44e0-85a0-ad1a0e1092b7"]', 'diamond', 'active', 'Bodega #8, CC Ciudadela Norte', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3173764676', '3153331626', NULL, NULL, 'https://www.facebook.com/leonardo.vilabecerra', NULL, NULL, NULL, 0, NULL),
('c2096c5d-3c3c-4035-bbbd-84f16a97800e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'OdentPlus', 'Odontología general y estética.
 Ortodoncia. 
Rehabilitación oral. 
Periodoncia.
 Endodoncia. 
Blanqueamiento dental.
 Diseño de sonrisa.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3202274093
📞 Teléfono: 3008150392
📘 Facebook: https://www.facebook.com/Odentplus-OCA%C3%91A-237090756865154/?hc_ref=ARQWVqMa4CnieFS_u_ZDty4flABPOCos9rTezZiwxLyBzPXq3PUUvljSFbdOff20ET0&fref=nf
📸 Instagram: https://www.instagram.com/odentplus_ocana/
🌐 Web: http://klicus.com/odentplus.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_odentplus.jpeg?alt=media&token=288218bc-3acd-47d3-aaa6-70807b57ee54","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodentplus%2Fo1.jpeg?alt=media&token=d4ba6e13-654f-4d88-a620-9c0bf4da11c8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodentplus%2Fo2.jpeg?alt=media&token=b20f85b0-5d20-44c6-b416-b7267d9ca2df","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodentplus%2F03.jpeg?alt=media&token=6e644019-5025-440b-8814-08b3e4e87362","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fodentplus%2F04.jpeg?alt=media&token=6f639f1b-9770-4d08-b8e3-fd1a6a2b43ea"]', 'diamond', 'active', 'Calle 7 No. 41-66 Barrio La Gloria - Entrada las Lomas', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3008150392', '3202274093', NULL, 'http://klicus.com/odentplus.php', 'https://www.facebook.com/Odentplus-OCA%C3%91A-237090756865154/?hc_ref=ARQWVqMa4CnieFS_u_ZDty4flABPOCos9rTezZiwxLyBzPXq3PUUvljSFbdOff20ET0&fref=nf', NULL, NULL, NULL, 0, NULL),
('c8d3a0b7-62e5-466b-a1f4-c4637dbc9f62', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Flor Arte y Eventos', 'Arreglos florales para toda ocasión. Decoración de Fiestas y Eventos Sociales. Desayunos sorpresa. 
Si buscas innovación y gran variedad en decoración, estas en el lugar adecuado. 
Flor Arte, detalles que alegran el alma !!!

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3165356838
📞 Teléfono: 0375623154
📘 Facebook: https://www.facebook.com/FLOR-ARTE-1682728005284478/
📸 Instagram: https://www.instagram.com/explore/locations/1030445790/flor-arte/
🌐 Web: http://www.floristeriaflorarteyeventos.com.co/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fflorarte%2Flogo_florarte.jpeg?alt=media&token=1f230148-b685-410e-87ac-7433b5e83eb7","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fflorarte%2F1.jpeg?alt=media&token=809de19b-f1e8-4a88-8ea2-5aa0f71c7380","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fflorarte%2F2.jpg?alt=media&token=3a6ba1db-9edf-4f2d-aa20-81feab055aa1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fflorarte%2F3.jpg?alt=media&token=c3da8e24-1466-40fa-8935-7b167e5c60d8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fflorarte%2F4.jpg?alt=media&token=d2a70bc2-ebac-48d3-a70f-346f8bf75159"]', 'diamond', 'active', 'Calle 8A # 11A-04 Urbanización Marina ', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375623154', '3165356838', NULL, 'http://www.floristeriaflorarteyeventos.com.co/', 'https://www.facebook.com/FLOR-ARTE-1682728005284478/', NULL, NULL, NULL, 0, NULL),
('ce208db1-b782-4d24-b015-a1c9ada495a0', '44bcac40-5c86-44d6-8cfd-44ae50574580', 10, 'Hotel El Camino', 'Confortables habitaciones con un ambiente familiar. Servicios de: 
	Internet WiFi.
	 Lavandería

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3158696185
📞 Teléfono: 0375623637
🌐 Web: http://klicus.com/helcamino.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_hotelelcamino.jpeg?alt=media&token=f1372743-a0f5-433a-9987-6e4bbd90e263","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelelcamino%2Fh1.jpg?alt=media&token=0685ee2f-3365-4a7a-a961-d4da4703cc0e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelelcamino%2Fh2.jpg?alt=media&token=085e7136-8ecd-461c-aae8-63dab960a6b8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelelcamino%2Fh3.jpg?alt=media&token=43893444-8978-4dd6-99cc-4fc9b7335985","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelelcamino%2Fh4.jpg?alt=media&token=a6756426-0754-4469-98cc-3c8fdbd20100"]', 'diamond', 'active', 'Calle 11 Nº 13 - 59 Centro  Frente al CC City Gold', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375623637', '3158696185', NULL, 'http://klicus.com/helcamino.php', NULL, NULL, NULL, NULL, 0, NULL),
('cf92cff0-64d3-4902-979a-c3c2ea49a881', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante Los Recuerdos De Anasca', 'Ofrece a sus clientes los mejores platos de la ciudad. 

	Bandeja Mixta 
	Lomo de Cerdo 
	Pincho Mixto 
	Bagre Frito 
	Pechuga en Salsa de Champiñones 
	Bandeja Paisa 
	Costilla de Cerdo 
	Churrasco 
	Casuela de Mariscos 
	Comidas Rápidas 
	Jugos Naturales 
	Bebidas Heladas 

Piensa distinto, come distinto, un sitio para disfrutar con toda la familia. 

Contamos con Cancha Sintética

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 0375693586
📞 Teléfono: 0375626382
🌐 Web: http://klicus.com/anasca.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelosrecuerdosdeanasca%2Flogo1.jpg?alt=media&token=1fe31cec-3aad-42c5-b83a-a352f669f38e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelosrecuerdosdeanasca%2Flogo.jpg?alt=media&token=7c8a6b9e-c329-43bf-990d-ea4f33936214","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelosrecuerdosdeanasca%2F1.jpg?alt=media&token=5b107021-7806-43d9-932d-cebbda8136f8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelosrecuerdosdeanasca%2F2.jpg?alt=media&token=55248395-e078-434d-8228-f594bc4d19f1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frestaurantelosrecuerdosdeanasca%2F3.jpg?alt=media&token=c1e1b34f-ac7a-452b-938a-20b6bf59ed96"]', 'diamond', 'active', 'Entrada Barrio Cuesta Blanca', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375626382', '0375693586', NULL, 'http://klicus.com/anasca.php', NULL, NULL, NULL, NULL, 0, NULL),
('d4e0d75b-4768-4ffd-94ce-702431f61602', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Tecni Repuestos Gabo', 'Mantenemiento de motos y bicicletas, arreglo de rines de Moto.

Cambio de aceite para Motos.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3166278151
📞 Teléfono: 3166278151
📘 Facebook: https://www.facebook.com/gerardo.becerraovalles', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgabo%2F1.jpeg?alt=media&token=4c4e36e5-2a02-4e1c-91fe-e42371812e18","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgabo%2F1.jpeg?alt=media&token=4c4e36e5-2a02-4e1c-91fe-e42371812e18","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgabo%2F2.jpeg?alt=media&token=9fb9bd5b-ce37-4aad-8879-cbd401679c65","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgabo%2F3.jpeg?alt=media&token=9fe020d6-bf5c-4e4c-b8d6-ff6cad5e07ed"]', 'diamond', 'active', 'Calle 2 # 16-163 Barrio Juan XXIII', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3166278151', '3166278151', NULL, NULL, 'https://www.facebook.com/gerardo.becerraovalles', NULL, NULL, NULL, 0, NULL),
('d72c5341-bade-4259-8fdb-2c49bdbd23f4', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Greceramica', 'Si buscas remodelar tu casa en Greceramica lo encuentras todo, tenemos: 

	Enchape para pisos, paredes 
	Porcelanato 
	Sanitarios 
	Cocinas Integrales 
	Grifería 

Tenemos los mejores precios y las mejores marcas del mercado

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3156705020
📞 Teléfono: 0375611694
🌐 Web: http://klicus.com/greceramicas.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgreceramicas%2Flogo.jpg?alt=media&token=6ae4e487-6f97-475d-b8f0-229a5b526f9e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgreceramicas%2F1.jpg?alt=media&token=e7d47bfe-44c8-4ee2-8207-4c60b4bbc7ef","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgreceramicas%2F2.jpg?alt=media&token=6cd09a61-df8f-4c90-a655-606bc505f464","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgreceramicas%2F3.jpg?alt=media&token=70edddeb-4970-4013-92f4-af94e8507838","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fgreceramicas%2F4.jpg?alt=media&token=4e812391-4f70-453c-8c5a-d5fcd56405f6"]', 'diamond', 'active', 'Calle 7 No. 29-97 Diagonal al Hospital', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375611694', '3156705020', NULL, 'http://klicus.com/greceramicas.php', NULL, NULL, NULL, NULL, 0, NULL),
('d757d0cb-c6fd-4bfa-88ee-4b2d203dca2b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 8, 'Asesorías Escolares', 'ASESORIAS ESCOLARES, Primaria y secundaria, Todas las asignaturas.
Horario de lunes a viernes 2 a 5 pm. 
Se maneja horario de acuerdo a la necesidad del estudiante. 
Se realizan refuerzos y elaboración de trabajos en matemáticas, física, química por horas o por días

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168906811
📞 Teléfono: 3157160415', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_marielly.jpg?alt=media&token=0a9ab838-6ded-4208-8358-b3995f6993a3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_marielly.jpg?alt=media&token=0a9ab838-6ded-4208-8358-b3995f6993a3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_marielly.jpg?alt=media&token=0a9ab838-6ded-4208-8358-b3995f6993a3"]', 'diamond', 'active', 'Calle 6A # 16a-130  Barrio Santa Barbara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '3157160415', '3168906811', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('d7fe3026-62d0-46de-a11c-5305445e0034', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Autoservicio el Rebusque', 'Venta de víveres en general, productos de aseo para el hogar, aseo personal. 
Aquí encontrarás lo que necesitas para tu canasta familiar a los mejores precios. 
Disfruta de comodidad al mercar.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3173720102
📞 Teléfono: 0375611905
🌐 Web: http://www.klicus.com/autoservicioelrebusque.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fautorebusque%2Flogo_rebusque.jpeg?alt=media&token=b52fe07d-dd4e-4365-ae0b-961e84e21ca4","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fautorebusque%2Flogo.jpeg?alt=media&token=87ea7b7c-5e98-4dde-af17-15fc89ae3110","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fautorebusque%2Fr3.jpeg?alt=media&token=88130301-abe9-4fe8-8d3a-c8d1d80f9c1d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fautorebusque%2Fr4.jpeg?alt=media&token=7419f20e-b61b-4b47-8b8e-ec5d1033f4a0","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fautorebusque%2Fr5.jpeg?alt=media&token=b08d3275-dbae-4478-8072-3a370e4b1fcd"]', 'diamond', 'active', 'Calle 12 No. 25A-51 Barrio el Retiro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375611905', '3173720102', NULL, 'http://www.klicus.com/autoservicioelrebusque.php', NULL, NULL, NULL, NULL, 0, NULL),
('d9728b4e-7d18-4997-92ed-3676a4afcfe6', '44bcac40-5c86-44d6-8cfd-44ae50574580', 11, 'Compukit', 'Somos una empresa que nace en marzo de 2004 en la ciudad de Ocaña para brindar nuestros servicios tecnológicos a los clientes ubicados en el departamento.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3175003015
📞 Teléfono: 0375696846
📘 Facebook: https://www.facebook.com/profile.php?id=100013487235220
🌐 Web: https://www.compukit.com.co', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_compukit.jpg?alt=media&token=539ad444-c0c2-4c35-8a0e-4a1b55062e2c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcompukit%2F1.jpeg?alt=media&token=8d405f85-c8e3-49c8-b0fe-d0d48a690ebe","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcompukit%2F2.jpeg?alt=media&token=2a509e60-0dac-4518-94b3-75b2fd3f94be","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcompukit%2Fcomp1.jpg?alt=media&token=8f2bf625-0e46-4c10-a097-e1c0bbced45c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcompukit%2Fcomp2.jpeg?alt=media&token=5d87e14f-1e88-4eeb-b4ea-ab8d6b6e330f"]', 'diamond', 'active', 'Calle 11 No. 10-47, CC Cañaveral Local 20 Centro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375696846', '3175003015', NULL, 'https://www.compukit.com.co', 'https://www.facebook.com/profile.php?id=100013487235220', NULL, NULL, NULL, 0, NULL),
('d99a8ce8-d2e7-4fdd-9a1d-66519ef08c02', '44bcac40-5c86-44d6-8cfd-44ae50574580', 8, 'Centro Educativo Winny Pooh', 'Centro Educativo Winny Pooh ofrece una educación basada en valores con una excelente calidad humana de puertas abiertas a toda la población que lo requiera, desde Párvulos hasta Quinto de primaria.
 Matrículas abiertas desde inicio de año. 
Los esperamos, no se lo pierdan.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3185957675
📞 Teléfono: 0375611977', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fwinnypooh%2Flogo.jpeg?alt=media&token=3c8b6ad6-53c8-4fc6-81b4-0a024346b74f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fwinnypooh%2Flogo.jpeg?alt=media&token=3c8b6ad6-53c8-4fc6-81b4-0a024346b74f","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fwinnypooh%2F1.jpeg?alt=media&token=9ca52809-94de-4b40-a720-abbf24e2847c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fwinnypooh%2F2.jpeg?alt=media&token=f8d4cb56-e4b3-4790-bb30-843092300797","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fwinnypooh%2F3.jpeg?alt=media&token=a62b5fee-64d8-4b30-9040-2f61f47104ce"]', 'diamond', 'active', 'Calle 5a # 5-20 Barrio Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375611977', '3185957675', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('d9dd1ee8-6e9f-48b9-8a02-8383af245752', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Pacifika Ocaña', 'Conferencia campaña C11 31 de Julio Hotel Tarigua 3 pm, te esperamos.  

Si deseas hacer parte de nuestro equipo comunícate con nosotros.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3116916798
📘 Facebook: https://www.facebook.com/pacifika.ocana
🌐 Web: www.pcfk.com.co', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpcfk%2Fc10.jpg?alt=media&token=018ebf17-e03e-4f3a-8640-680c28c7389d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpcfk%2Fc10.jpg?alt=media&token=96972f97-3583-4061-a90d-41ab46886e2b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpcfk%2Fca10.jpg?alt=media&token=b483acb0-3dea-4f50-ad57-5a0dd97fff7a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpcfk%2F3.jpg?alt=media&token=2e9c63ae-36f9-48c6-9306-75cb1ea22256"]', 'diamond', 'active', 'Ocaña, Norte de Santander', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3116916798', NULL, NULL, 'https://www.facebook.com/pacifika.ocana', NULL, NULL, NULL, 0, NULL),
('ddcf3ec3-3fd1-484a-a376-488260d23a86', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Russoft LTDA', 'Russoft Ltda es una casa desarrolladora de Software que nace en Bucaramanga hace 30 años. Russoft ERP cuenta con más de 900 usuarios y más de 300 empresas en toda Colombia.

El producto insignia de la compañía consiste en un sistema de planificación y                    gestión de recursos empresariales ERP ZERUS

Es misión de Russoft Ltda desarrollar Software a la medida con el fin de satisfacer las necesidades en                    sistematización de información de los clientes con productos y servicios de calidad, fomentando el desarrollo                    y crecimiento de las empresas, mediante un equipo interdisciplinar de profesionales altamente competitivo.

Portafolio
	Facturación
	Compras
	Inventarios
	Caja registradora
	Cotizaciones y pedidos
	Cartera por cobrar
	Cuentas por pagar
	Contabilidad
	Procesos NIFF
	Producción
	Nomina

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3168340962
📞 Teléfono: 0376446748
🌐 Web: http://russoft-ltda.com/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frussoft%2FbanerZerus.jpg?alt=media&token=68c0d04b-6024-45ff-84d8-37e112dbe162","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frussoft%2FbanerZerus.jpg?alt=media&token=68c0d04b-6024-45ff-84d8-37e112dbe162","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frussoft%2FBanner_Factura_electronica_web.png?alt=media&token=c8cd6bad-82d2-4b16-af4f-0c9ad9c47e95","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frussoft%2FFacturacion_electronica.png?alt=media&token=969eed50-6e34-42ce-b7b0-08aedc66fbb8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frussoft%2Fprecios_venta_plus.png?alt=media&token=bfefe515-233f-4a5a-9494-f90106f6b543"]', 'diamond', 'active', 'Av. Los búcaros # 60 - 168 Bucaramanga - Santander', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0376446748', '3168340962', NULL, 'http://russoft-ltda.com/', NULL, NULL, NULL, NULL, 0, NULL),
('e0b1d5ea-f139-45ac-a0f5-43721e88e6a3', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Candelaria Café y Tienda de Regalos', 'Donde puedes encontrar el detalle perfecto para ti o para regalar. 
Además te ofrecemos el café Candelaria el mejor espacio para compartir con amigos y probar nuestras delicias

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183741411
📸 Instagram: https://www.instagram.com/candelariatiendaderegalos/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcandelariatiendaderegalos%2Flogo_candelaria.jpeg?alt=media&token=ad6e9efb-c3f8-440f-b2dd-6a40f0ef17d8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcandelariatiendaderegalos%2F1.jpeg?alt=media&token=f3afbbee-e385-4408-aa38-e428dcd74667","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcandelariatiendaderegalos%2F2.jpeg?alt=media&token=fb088c58-d7c7-4a8c-8dde-049cfb566f95","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcandelariatiendaderegalos%2F3.jpeg?alt=media&token=95157b20-6048-4e4d-9af6-982fc4ef8245","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcandelariatiendaderegalos%2F4.jpeg?alt=media&token=57dfaaa3-d06a-4b03-bfbf-d31bc1b316db"]', 'diamond', 'active', 'Calle 10 N 10-56  Al frente del hotel el príncipe', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3183741411', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('e11522cf-60bb-4f84-a4f6-d09fdd3026d6', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Calzado Norys', 'Calzado para Dama, Bisutería, Bolsos, Billeteras en cuero para Dama.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183936856
📘 Facebook: https://www.facebook.com/Calzado-Norys-888593797926592/
📸 Instagram: https://www.instagram.com/calzadonurys/', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_calzadonorys.jpg?alt=media&token=6aa0fe92-7b26-4d34-9934-38de0a1fd42c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_calzadonorys.jpg?alt=media&token=6aa0fe92-7b26-4d34-9934-38de0a1fd42c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_calzadonorys.jpg?alt=media&token=6aa0fe92-7b26-4d34-9934-38de0a1fd42c"]', 'diamond', 'active', 'Carrera 12 # 11-38 Centro, Al lado de Davivienda', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3183936856', NULL, NULL, 'https://www.facebook.com/Calzado-Norys-888593797926592/', NULL, NULL, NULL, 0, NULL),
('e1ad5041-9335-4584-969d-1e916266fb72', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Restaurante y Hospedaje el Zaguan de las Aguas', 'Confortables habitaciones con baño privado, TV e Internet.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3152010481
📞 Teléfono: 0375695623
🌐 Web: http://klicus.com/zaguan.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_zaguan.jpeg?alt=media&token=704ce0ed-e102-4b51-8c61-29ae98dbda8b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fzaguan%2Fz2.jpeg?alt=media&token=986aa32b-7bac-4dba-aed3-1feb9cee85c3","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fzaguan%2Fz3.jpeg?alt=media&token=d7d94eb7-0b3d-4130-8248-1b76dd4d937c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fzaguan%2Fz4.jpeg?alt=media&token=d3368660-7d4f-4603-bdb1-b62510f3f858","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fzaguan%2Fz5.jpeg?alt=media&token=7ac72f72-4716-40b2-81bd-ca7d4637c82f"]', 'diamond', 'active', 'Cra 11 N° 12-66 Centro', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375695623', '3152010481', NULL, 'http://klicus.com/zaguan.php', NULL, NULL, NULL, NULL, 0, NULL),
('e65e4ec5-62e9-4114-970d-12a1ef15c74e', '44bcac40-5c86-44d6-8cfd-44ae50574580', 10, 'Hotel Vicky', 'Confortables Habitaciones Con Baño, Tv, Aire Acondicionado.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375619797
📘 Facebook: https://www.facebook.com/profile.php?id=100012437927274
🌐 Web: http://klicus.com/hotvicky.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_hotvicky.jpeg?alt=media&token=1e419860-d640-46f4-ba43-052880e9322a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelvicky%2F2.jpeg?alt=media&token=ea3829e1-725f-4f6c-9aef-59a4e305d241","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelvicky%2F2.jpeg?alt=media&token=ea3829e1-725f-4f6c-9aef-59a4e305d241"]', 'diamond', 'active', 'Calle 7 N° 55-103 Barrio El Líbano', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375619797', NULL, NULL, 'http://klicus.com/hotvicky.php', 'https://www.facebook.com/profile.php?id=100012437927274', NULL, NULL, NULL, 0, NULL),
('ea74a6bf-9b04-4a67-88d2-c06f4545b9a8', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Empacadora La Trinidad', 'Distribuimos los mejores granos al por mayor y al detal de la ciudad
	 Sal La Trinidad
	 Café Mundial
 También empacamos toda clase de granos para depósitos y supermercados

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3152072798
📘 Facebook: https://www.facebook.com/trinidad.pacheco1', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_latrinidad.jpg?alt=media&token=87640f99-96b0-480e-b805-2743bee43349","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fepacadoralatrinidad%2F3.jpg?alt=media&token=ad105c5f-f001-43c0-ba30-494f895d640c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fepacadoralatrinidad%2Ft1.jpeg?alt=media&token=2d035074-4c29-4e77-939a-355d09aee859","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fepacadoralatrinidad%2Ft2.jpeg?alt=media&token=448ef78f-a229-4a0c-b238-b260c9945af6","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fepacadoralatrinidad%2Ft3.jpeg?alt=media&token=476df7df-7633-43dc-a227-e57d0d97a6b5"]', 'diamond', 'active', 'Centro comercial Centro Mercado, local --, Mercado publico', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3152072798', NULL, NULL, 'https://www.facebook.com/trinidad.pacheco1', NULL, NULL, NULL, 0, NULL),
('eb6e223b-5c75-4937-8f7e-d71ea4d263f5', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Crt Ocaña Ltda', 'Revisión Tecnico-Mecánica y de Emisiones Contaminantes para vehículos pesados, livianos y Motocicletas.

VENTA DE SOAT

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3214422098
📞 Teléfono: 0375622741
📘 Facebook: https://www.facebook.com/profile.php?id=100010533639905
🌐 Web: http://klicus.com/crtocana.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcrt%2Flogo.jpg?alt=media&token=6712e8b6-4eb3-47e3-a020-aa34a19d6d1e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcrt%2F1.JPG?alt=media&token=eb77ccef-7a4f-4720-90ba-5290931c764d","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcrt%2F2.JPG?alt=media&token=71d5ad52-4df0-40ef-be20-c0b685aaa58c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcrt%2F3.jpeg?alt=media&token=d724b570-5423-4bf5-97a4-5755e07af312","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fcrt%2F4.jpg?alt=media&token=89d84980-abad-4eff-adc5-4761e883bb22"]', 'diamond', 'active', 'Vía a la Universidad Francisco de Paula Santander', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375622741', '3214422098', NULL, 'http://klicus.com/crtocana.php', 'https://www.facebook.com/profile.php?id=100010533639905', NULL, NULL, NULL, 0, NULL),
('ec56d2a4-715c-40dc-8558-765ef228009c', '44bcac40-5c86-44d6-8cfd-44ae50574580', 3, 'La Calle Video Club', 'Los mejores estrenos en películas DVD-BLU_RAY-3D, dulces, caramelos y otros.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3184674864
📞 Teléfono: 0375692905
📘 Facebook: https://www.facebook.com/lacallevideoclub/
🌐 Web: http://klicus.com/lacalle.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Flogos%2Flogo_lacallevideo.jpg?alt=media&token=3daac920-e336-44d5-86cf-a7db87300f61","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacallevideoclub%2F1.jpg?alt=media&token=f02ba528-462e-4e83-bf1a-c76ff61d5061","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flacallevideoclub%2F2.jpg?alt=media&token=d544d22a-5072-43ec-806c-6ee6257b47a4"]', 'diamond', 'active', 'Calle 7 Barrio las llanadas', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375692905', '3184674864', NULL, 'http://klicus.com/lacalle.php', 'https://www.facebook.com/lacallevideoclub/', NULL, NULL, NULL, 0, NULL),
('eccedc76-8c87-434e-828c-c1f8c2755d38', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Almacén Unicentro', 'La imagen del buen vestir

Nuestras Marcas

	Kosta Azul
	Alberto VO5
	Mak Janna
	Naga
	Othello
	Flipper línea económica
	Calzado Trianni/Wander

Venta y alquiler de ajuares de Novia
	Primera Comunión
	Bautizo
	15 años
	Trajes de caballero
	Blazer

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375610269
🌐 Web: http://klicus.com/unicentro.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Falmacenunicentro%2Flogo.jpeg?alt=media&token=e133e1b9-02ac-47ae-8c9a-555c7b5e1bed","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Falmacenunicentro%2F2.jpeg?alt=media&token=d5487299-cb24-4d2f-9379-0580c9daa392","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Falmacenunicentro%2Fvo5logo.jpg?alt=media&token=8eb1b036-07d2-4db7-bb4d-92c4b1640a60","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Falmacenunicentro%2Fvo51.jpg?alt=media&token=639c9c80-0ebe-44d7-849c-741d4116684c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Falmacenunicentro%2Fvo52.jpg?alt=media&token=35ca052b-d7d9-4d2f-9fa3-13667ec76b50"]', 'diamond', 'active', 'Carrera 13 No. 9 - 44 Centro', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375610269', NULL, NULL, 'http://klicus.com/unicentro.php', NULL, NULL, NULL, NULL, 0, NULL),
('efeecd17-8ed1-4b6d-a08b-1becb7d0042b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Hotel Rancho Alegre', 'Hospedaje por días, semanas y meses.

Habitaciones con:

	Baño privado
	Closet
	TV
	Servicio de Internet
	Salón de actos
	Ambiente Campestre.

Parqueadero privado

Habitación a $17.000 con Parqueadero incluido

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3178461222
📞 Teléfono: 0375692014
🌐 Web: http://klicus.com/ranchoalegrehotel.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelranchoalegre%2Flogo.jpeg?alt=media&token=69f2ae80-62f0-41cc-9af5-b33589076ef1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelranchoalegre%2F1.jpeg?alt=media&token=ddb8f89c-e3e0-4b76-b2db-a70e6b3f36a5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelranchoalegre%2F2.jpeg?alt=media&token=f8361b29-725d-48ea-a24b-f05af5b67189","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelranchoalegre%2F3.jpeg?alt=media&token=c4fb0f7b-2f7b-4ce8-8378-36cedad2727a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fhotelranchoalegre%2F4.jpeg?alt=media&token=7d79154a-56e7-4edb-8bcb-245d093c9efb"]', 'diamond', 'active', 'Carrera 10 No. 15-56 Barrio Gustavo Alayon', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375692014', '3178461222', NULL, 'http://klicus.com/ranchoalegrehotel.php', NULL, NULL, NULL, NULL, 0, NULL),
('f168768b-1bc8-4925-aae5-b9772c290266', '44bcac40-5c86-44d6-8cfd-44ae50574580', 6, 'Almacén y Taller Friopatry', 'Reparación e instalación de aires acondicionados, neveras, lavadoras. 
Venta de repuesto para los mismos.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3157976261
📞 Teléfono: 0375626347', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffriopatry%2Flogo_friopatry.jpeg?alt=media&token=af35312a-3b13-4efc-9b4a-7c176b7be884","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Ffriopatry%2F1.jpg?alt=media&token=ee4d8c7f-4557-43e5-959d-a9c27698919d"]', 'diamond', 'active', 'Calle 11 No. 25A-20 Barrio las llanadas- Ocaña.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375626347', '3157976261', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('f1a92560-b3a4-4122-bb20-75094bec9c3a', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Punto Cuero ', 'Punto Cuero, un lugar exclusivo en Ocaña donde sus gustos son nuestra prioridad. 
Tenemos todo lo relacionado en artículos de Cuero
	 Correas
	 Zapatos
	 Bolsos
	 Billeteras
 y mucho más en las marcas Trianon, Riviera, Brahama entre otras marcas y accesorios. 
Punto Cuero es Calidad y Distinción al mejor precio. 
Visítanos para tener el gusto de atenderlos. 
Estamos ubicados en el corazón de Ocaña, calle del Dulce Nombre. 

TE ESPERAMOS.

--- 🌟 CONTACTO PREMIUM ---
🌐 Web: http://klicus.com/puntocuero.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpuntocuero%2Ftarjetapuntocuero.jpg?alt=media&token=01de6c83-4d60-47d5-9796-e74550f30671","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpuntocuero%2Fp3.jpeg?alt=media&token=cfbfcffa-0fa2-4a60-adaa-8473d63b413c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpuntocuero%2Fp3.jpeg?alt=media&token=cfbfcffa-0fa2-4a60-adaa-8473d63b413c","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpuntocuero%2Fp4.jpeg?alt=media&token=f20d6c72-05e9-4cc5-bb3e-e7e6ce4d5738","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fpuntocuero%2Fp5.jpeg?alt=media&token=102aba48-bf5c-4a53-9750-79ffac537891"]', 'diamond', 'active', 'CRA.13No.8-38 Calle del Dulce Nombre - Ocaña.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, NULL, NULL, 'http://klicus.com/puntocuero.php', NULL, NULL, NULL, NULL, 0, NULL),
('f6db7e14-f338-4570-8924-96188f0af796', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'La Merced Supermercado', 'El mas completo surtido en víveres, frutas y verduras para tu canasta familiar

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375613500
📘 Facebook: https://www.facebook.com/groups/813407752195495/
🌐 Web: https://www.lamercedsupermercado.com', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flamercedsupermercado%2Flogo.jpeg?alt=media&token=1edf26f0-6151-463e-98c8-00ca3c63d326","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flamercedsupermercado%2Fa10.jpeg?alt=media&token=d82c04c4-a707-4df3-b5a8-bffad03b4540","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flamercedsupermercado%2Fa1.jpeg?alt=media&token=30939d89-47fb-41ec-ab0a-b61003f2d003","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flamercedsupermercado%2Fa2.jpeg?alt=media&token=09177b76-df80-402d-83b7-5a181c9a39c9","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Flamercedsupermercado%2Fa3.jpeg?alt=media&token=abb3ee78-6336-49fc-a342-eaed50cccc53"]', 'diamond', 'active', 'Centro Comercial Ciudadela Norte Santa Clara', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375613500', NULL, NULL, 'https://www.lamercedsupermercado.com', 'https://www.facebook.com/groups/813407752195495/', NULL, NULL, NULL, 0, NULL),
('f7c2f590-edeb-4aea-a897-b096c2f12e6b', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Choco Sweet', 'Porque siempre hay un motivo para celebrar, en Ocaña La nueva Tienda de Regalos CHOCO Sweet abre sus puertas,  frente a la Torre Conquistador, donde encontrarás el detalle perfecto para esa persona que tanto quieres.  Peluches, tarjetas, pancartas, bolsas o cajas de regalos, chocomensajes, chocolates personalizados, fresas achocolatadas en varias presentaciones, desayunos sorpresa, onces sorpresa, cena romántica y más.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3004373410
📞 Teléfono: 3004373410
📘 Facebook: https://www.facebook.com/ocanachocolates/
📸 Instagram: https://instagram.com/choco.sweet1?utm_source=ig_profile_share&igshid=1eefmfc7x3ceg', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchocosweet%2Flogo.jpeg?alt=media&token=a8009488-4c41-49a1-8399-3f736ea0a1ec","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchocosweet%2F1.jpeg?alt=media&token=9854b7a7-1e1c-4387-808e-c736512f2874","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchocosweet%2F2.jpeg?alt=media&token=0916b091-23af-4540-9d81-6c6f1fc13cd5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchocosweet%2F3.jpeg?alt=media&token=7f68964b-00f7-4001-a1cd-493235969c3e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchocosweet%2F4.jpeg?alt=media&token=f407880f-cd71-4ed2-952c-3772926f8f61"]', 'diamond', 'active', 'Calle 10 # 14-90 al frente de la Torre el Conquistador', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3004373410', '3004373410', NULL, NULL, 'https://www.facebook.com/ocanachocolates/', NULL, NULL, NULL, 0, NULL),
('f8ad7ab9-68a8-4d2b-9335-354b9ac6754d', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Disaman Fortalece Tu Fe', 'Todo lo relacionado con Artículos Religiosos, Biblias, Libros, Novenas Enciclicas, Imágenes, Accesorios Decorativos, y muchas cosas para foltarecer tu Fe...
 Disaman fortalece tu Fe.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375690440', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmati%2Flogo.jpeg?alt=media&token=436d99f4-f3ab-4b98-92cb-0f5ea97db8f8","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmati%2Fm1.jpeg?alt=media&token=b547b025-1ef2-4ba3-ae06-e199ff546d9b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmati%2Fm2.jpeg?alt=media&token=592b3e4a-da00-4847-92e6-18f3e70db5ed","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmati%2Fm3.jpeg?alt=media&token=64777335-0112-4819-9745-9dc996da10cc"]', 'diamond', 'active', 'Cra 11 # 11-48 Pasos abajo Capilla Torcoroma', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375690440', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('f8c8de79-531c-498a-8193-dab6692979f3', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Almacén Everfit', 'Más de 50 años vistiendo al hombre de Ocaña y la región. 
En nuestra tienda, puedes encontrar gran variedad de artículos como:
	 Trajes
	 Pantalones
	 Camisas
	 Camisetas
	 Ropa interior
	 Corbatas
	 Corbatines
	 Tirantas
	 Billeteras
	 Correas
	 Llaveros y mucho más
 En las líneas de Kosta Azul, VO5, Patprimo, Punto Blanco, Trianon, Risare y Naga.
 Te esperamos con la mejor atención.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3003909647
📞 Teléfono: 0375610061', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Feverfit%2Flogo_everfit.jpg?alt=media&token=d7c73839-da31-4d43-b7f6-75b55741295a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Feverfit%2Fe1.jpeg?alt=media&token=10e2a3c2-f737-47ff-af87-f86b75ded7f1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Feverfit%2Fe2.jpeg?alt=media&token=267d08f3-e12c-4274-9b49-b264c42b1375","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Feverfit%2Fe3.jpeg?alt=media&token=00a81bb8-08b0-4a92-9984-8ea104d29945","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Feverfit%2Fe4.jpeg?alt=media&token=1796614e-d82a-490e-9327-5ef8b0b5c4fa"]', 'diamond', 'active', 'Calle 11 No 11-74 Diagonal Puerta Falsa de la Catedral.', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375610061', '3003909647', NULL, NULL, NULL, NULL, NULL, NULL, 0, NULL),
('f8f4a2b3-9f5a-42e9-a8c7-7afdc776af9f', '44bcac40-5c86-44d6-8cfd-44ae50574580', 4, 'Dra. Mildreth Carrascal', 'Tu médico de confianza con una consulta diferente, 27 años de trabajo conlleva a considerar al paciente como un todo teniendo en cuenta su parte física, emocional y espiritual. 

Atiendo pacientes de todas las edades, del área rural y urbana sin límite de tiempo. 

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3153779395
📞 Teléfono: 0375625551
📘 Facebook: https://www.facebook.com/mildreth.carrascaltorrado
🌐 Web: http://klicus.com/mildrethcarrascal.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmildrethcarrascal%2Flogo.jpg?alt=media&token=cbe3b7b2-cbc9-4637-b6ee-34c38c472b13","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmildrethcarrascal%2F1.jpg?alt=media&token=260f25f5-555d-4406-8dff-80c52fe6d44b","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmildrethcarrascal%2F2.jpg?alt=media&token=cb3073a1-0383-453c-ba24-341d2db5824e","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmildrethcarrascal%2F3.jpg?alt=media&token=339f2170-c5a4-4844-8834-c6ba3d63d6b1","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fmildrethcarrascal%2F4.jpg?alt=media&token=e6e326e5-be03-4c74-b160-45fdcd19b165"]', 'diamond', 'active', 'CC Ferrer Calle 11 No. 15-94 Local 102B', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '0375625551', '3153779395', NULL, 'http://klicus.com/mildrethcarrascal.php', 'https://www.facebook.com/mildreth.carrascaltorrado', NULL, NULL, NULL, 0, NULL),
('fbfa0891-eb92-44e0-ab07-bae385e033d2', '44bcac40-5c86-44d6-8cfd-44ae50574580', 12, 'Autoservicio El Surtidor', 'Satisfacemos las necesidades de su distinguida clientela a través de la prestación de un servicio de calidad y eficiente, donde su objeto es la venta de surtido compuesto especialmente por alimentos y bebidas.

--- 🌟 CONTACTO PREMIUM ---
📞 Teléfono: 0375624972
📘 Facebook: https://www.facebook.com/Autoservicio-El-surtidor-168569073853805/
🌐 Web: http://klicus.com/elsurtidor.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsurtidor%2Fs1.jpeg?alt=media&token=704d06a4-ed56-4a59-8f9a-4db1db5b5a77","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsurtidor%2Fs1.jpeg?alt=media&token=704d06a4-ed56-4a59-8f9a-4db1db5b5a77","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsurtidor%2FelSurtidor.png?alt=media&token=d333e82e-b884-4c69-b4af-94574a8b79d5","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsurtidor%2Fanuncio16.jpg?alt=media&token=fca6c0b9-3ae8-4e8d-ad20-d229e8a78c15","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fsurtidor%2Fanuncio18.jpg?alt=media&token=ba1c17fd-2d56-471a-b20d-0a60b1f719bf"]', 'diamond', 'active', 'Calle 9 No. 13-57 Mercado publico', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, '0375624972', NULL, NULL, 'http://klicus.com/elsurtidor.php', 'https://www.facebook.com/Autoservicio-El-surtidor-168569073853805/', NULL, NULL, NULL, 0, NULL),
('fdbeacb9-b66c-4b62-9f7e-1ee3a4e21b62', '44bcac40-5c86-44d6-8cfd-44ae50574580', 1, 'Red Negocios Ocaña', 'Somos una empresa dedicada a realizar el sueño de toda familia, tener casa propia.

Servicios

	Casas prefabricadas
	Venta de Casas
	Venta de lotes
	Tramites de Créditos
	Asesorías Jurídicas


--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3183662433
📞 Teléfono: 3186497039
📘 Facebook: https://www.facebook.com/Inmobiliaria-RED-Negocios-OCANA-325163977847518/
🌐 Web: http://www.klicus.com/rednegociosocana.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frednegociosocana%2Flogo.jpeg?alt=media&token=667e4ce0-339a-4ef1-982a-882592f8acdf","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frednegociosocana%2Flogo.jpeg?alt=media&token=667e4ce0-339a-4ef1-982a-882592f8acdf","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frednegociosocana%2F1.jpeg?alt=media&token=b17c60cc-cb58-4991-b9c4-fa95a60ea288","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frednegociosocana%2F2.jpeg?alt=media&token=44567efb-de62-4484-8ca4-3b85d5a71014","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Frednegociosocana%2F3.jpeg?alt=media&token=f9a91c89-f9f4-41bd-aef2-515baf56a023"]', 'diamond', 'active', 'Calle 10 Centro, abajo de Crediservir', NULL, NULL, NULL, '2026-04-17 04:30:19', NULL, '3186497039', '3183662433', NULL, 'http://www.klicus.com/rednegociosocana.php', 'https://www.facebook.com/Inmobiliaria-RED-Negocios-OCANA-325163977847518/', NULL, NULL, NULL, 0, NULL),
('fea41469-fe63-42dd-b8a8-5e96c2bc1946', '44bcac40-5c86-44d6-8cfd-44ae50574580', 2, 'Choriburger', 'Las mejores Hamburguesas de la ciudad y la región, ven y disfruta de nuestra gran variedad y del mejor sabor en: 
	Comidas rápidas.
	 Chorizos.
	 Perros calientes.
	  Picadas.

--- 🌟 CONTACTO PREMIUM ---
📲 WhatsApp: 3188158244
📘 Facebook: https://www.facebook.com/groups/853143804774822/
🌐 Web: http://klicus.com/choriburger.php', '["https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchroriburger%2Flogo.jpg?alt=media&token=9fbb6dc9-e7c5-4f12-9c73-2ffed583ba66","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchroriburger%2Fpicadas.jpg?alt=media&token=3f4c0bcd-892f-4d7c-ac88-e6d46d4a70bf","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchroriburger%2F1.jpg?alt=media&token=c76d3ccb-17a1-49d7-ac41-2fcc3f9b348a","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchroriburger%2F2.jpg?alt=media&token=c1202b0f-71b4-43f8-9eac-f15f770485fb","https://firebasestorage.googleapis.com/v0/b/klicus-4b8a7.appspot.com/o/images%2Fanuncios%2Fchroriburger%2F3.jpg?alt=media&token=69c0f690-caa3-4e12-a9c9-2b034219bd51"]', 'diamond', 'active', 'Calle 12A No. 17-123 San Agustin', NULL, NULL, NULL, '2026-04-17 04:30:18', NULL, NULL, '3188158244', NULL, 'http://klicus.com/choriburger.php', 'https://www.facebook.com/groups/853143804774822/', NULL, NULL, NULL, 0, NULL);


-- Structure for banners
CREATE TABLE `banners` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(255) NOT NULL,
  `subtitle` text DEFAULT NULL,
  `image_url` text NOT NULL,
  `cta_text` varchar(100) DEFAULT 'SABER MÁS',
  `cta_link` varchar(255) DEFAULT '/',
  `is_active` tinyint(1) DEFAULT 1,
  `position` int(11) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for banners
INSERT INTO banners (id, title, subtitle, image_url, cta_text, cta_link, is_active, position, created_at, updated_at) VALUES
(1, 'Impulsa tu negocio con KLICUS', 'Llega a miles de potenciales clientes con pautas Diamante.', 'https://images.unsplash.com/photo-1460925895917-afdab827c52f?auto=format&fit=crop&q=80&w=1200', 'PUBLICAR AHORA', '/publicar', 1, 0, '2026-04-18 20:33:25', '2026-04-18 20:33:25'),
(2, 'Encuentra lo mejor de tu ciudad', 'Salud, Gastronomía y Tecnología con calidad verificada.', 'https://images.unsplash.com/photo-1542744094-24638eff58bb?auto=format&fit=crop&q=80&w=1200', 'EXPLORAR', '/', 1, 0, '2026-04-18 20:33:25', '2026-04-18 20:33:25'),
(3, 'Publicidad efectiva y local', 'Únete a la comunidad de emprendedores que están creciendo.', 'https://images.unsplash.com/photo-1551434678-e076c223a692?auto=format&fit=crop&q=80&w=1200', 'COMENZAR', '/', 1, 0, '2026-04-18 20:33:25', '2026-04-18 20:33:25');


-- Structure for billings
CREATE TABLE `billings` (
  `id` char(36) NOT NULL,
  `user_id` char(36) DEFAULT NULL,
  `ad_id` char(36) DEFAULT NULL,
  `mp_preference_id` varchar(255) DEFAULT NULL,
  `mp_payment_id` varchar(255) DEFAULT NULL,
  `amount` decimal(12,2) DEFAULT NULL,
  `status` varchar(20) DEFAULT NULL,
  `plan_type` varchar(20) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  KEY `ad_id` (`ad_id`),
  CONSTRAINT `billings_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`id`) ON DELETE SET NULL,
  CONSTRAINT `billings_ibfk_2` FOREIGN KEY (`ad_id`) REFERENCES `advertisements` (`id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for billings
INSERT INTO billings (id, user_id, ad_id, mp_preference_id, mp_payment_id, amount, status, plan_type, created_at) VALUES
('0f33de17-1afe-4f74-a5fc-d784372fd5a1', 'c4713855-20f3-4f5b-a157-d960f1008c4c', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', NULL, NULL, '99000.00', 'paid', 'diamond', '2026-04-18 01:14:29'),
('23602ec5-0fa9-41d9-8e27-3daad7291612', 'c4713855-20f3-4f5b-a157-d960f1008c4c', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', NULL, NULL, '99000.00', 'paid', 'diamond', '2026-04-18 00:36:33'),
('24405342-a5b4-4349-9478-70b9b6d76535', 'c4713855-20f3-4f5b-a157-d960f1008c4c', '602c14e4-f61c-4a6d-92bb-f1489d963f94', NULL, NULL, '99000.00', 'paid', 'diamond', '2026-04-17 19:49:17'),
('69d8622c-af36-4b90-8608-3f1f91bcefee', 'c4713855-20f3-4f5b-a157-d960f1008c4c', NULL, NULL, NULL, '45000.00', 'pending', 'pro', '2026-04-17 19:24:30'),
('8e9bf01b-49cd-478a-a492-574014bc91d0', 'c4713855-20f3-4f5b-a157-d960f1008c4c', NULL, NULL, NULL, '45000.00', 'pending', 'pro', '2026-04-17 19:45:44'),
('9aacac0a-7dd1-4c3f-8b55-54e719c06f5f', 'c4713855-20f3-4f5b-a157-d960f1008c4c', NULL, NULL, NULL, '45000.00', 'pending', 'pro', '2026-04-17 19:27:53'),
('c8edda8e-fd87-4f96-a041-e9f84de48003', 'c4713855-20f3-4f5b-a157-d960f1008c4c', NULL, NULL, NULL, '45000.00', 'pending', 'pro', '2026-04-17 19:20:44'),
('fc884281-ba22-44c6-969b-d766798d9010', 'c4713855-20f3-4f5b-a157-d960f1008c4c', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', NULL, NULL, '99000.00', 'paid', 'diamond', '2026-04-18 00:39:37');


-- Structure for categories
CREATE TABLE `categories` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(100) NOT NULL,
  `slug` varchar(100) NOT NULL,
  `icon` varchar(50) DEFAULT NULL,
  `description` text DEFAULT NULL,
  `active` tinyint(1) DEFAULT 1,
  PRIMARY KEY (`id`),
  UNIQUE KEY `name` (`name`),
  UNIQUE KEY `slug` (`slug`)
) ENGINE=InnoDB AUTO_INCREMENT=14 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for categories
INSERT INTO categories (id, name, slug, icon, description, active) VALUES
(1, 'COMERCIO', 'comercio', 'Store', 'Categoría de comercio en KLICUS.', 1),
(2, 'RESTAURANTE-BAR', 'restaurante-bar', 'Utensils', 'Categoría de restaurante-bar en KLICUS.', 1),
(3, 'ENTRETENIMIENTO', 'entretenimiento', 'Gamepad2', 'Categoría de entretenimiento en KLICUS.', 1),
(4, 'SALUD', 'salud', 'HeartPulse', 'Categoría de salud en KLICUS.', 1),
(5, 'BELLEZA', 'belleza', 'Sparkles', 'Categoría de belleza en KLICUS.', 1),
(6, 'SERVICIO', 'servicio', 'Wrench', 'Categoría de servicio en KLICUS.', 1),
(7, 'TRANSPORTE', 'transporte', 'Truck', 'Categoría de transporte en KLICUS.', 1),
(8, 'PROFESIONAL', 'profesional', 'Briefcase', 'Categoría de profesional en KLICUS.', 1),
(9, 'CONSTRUCCION', 'construccion', 'HardHat', 'Categoría de construccion en KLICUS.', 1),
(10, 'TURISMO', 'turismo', 'Map', 'Categoría de turismo en KLICUS.', 1),
(11, 'TECNOLOGIA', 'tecnologia', 'Cpu', 'Categoría de tecnologia en KLICUS.', 1),
(12, 'SUPERMERCADOS', 'supermercados', 'ShoppingBasket', 'Categoría de supermercados en KLICUS.', 1),
(13, 'DEPORTE', 'deporte', 'Trophy', 'Categoría de deporte en KLICUS.', 1);


-- Structure for chat_conversations
CREATE TABLE `chat_conversations` (
  `id` char(36) NOT NULL,
  `ad_id` char(36) NOT NULL,
  `buyer_id` char(36) NOT NULL,
  `seller_id` char(36) NOT NULL,
  `last_message` text DEFAULT NULL,
  `last_message_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_chat` (`ad_id`,`buyer_id`,`seller_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for chat_conversations
INSERT INTO chat_conversations (id, ad_id, buyer_id, seller_id, last_message, last_message_at, updated_at) VALUES
('0b5b2228-8441-4e89-97b4-27ba8b78534f', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'gst_1776554524859', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'estas?.,,,', '2026-04-18 23:25:25', '2026-04-18 23:25:25'),
('0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', '602c14e4-f61c-4a6d-92bb-f1489d963f94', '77037021-69a2-46d0-b648-6ab51202059b', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'estas?', '2026-04-21 00:55:00', '2026-04-21 00:55:00'),
('2fb998c0-ed44-4241-bb58-1d2e4fe47fdd', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'gst_1776555581157', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'comprador 1', '2026-04-18 23:40:14', '2026-04-18 23:40:14'),
('3f531977-2754-4659-bb23-db9917ea0b95', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'gst_1776552863538', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-18 23:01:05', '2026-04-18 23:01:05'),
('48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776734585281', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola estas', '2026-04-21 01:30:47', '2026-04-21 01:30:47'),
('5a304f3e-0270-4c78-9305-efc6410342a0', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776552962457', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-18 23:00:50', '2026-04-18 23:00:50'),
('5d2d4b93-b3e1-479c-b329-928a3f1e8850', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776732450583', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-21 00:53:37', '2026-04-21 00:53:37'),
('6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'gst_1776552962457', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'alex', '2026-04-18 23:15:57', '2026-04-18 23:15:57'),
('b3ea65ae-67d1-4a8a-adde-273605b1edb3', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776735096494', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hey', '2026-04-21 01:53:57', '2026-04-21 01:53:57'),
('bc9d0995-e55a-417b-8632-5f654fc35d7e', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776555581157', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-18 23:39:57', '2026-04-18 23:39:57'),
('bd6fe2c0-b0ca-4f56-8ce9-1444a84a9f08', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776552863538', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-18 23:08:17', '2026-04-18 23:08:17'),
('c378024d-c11f-4bbf-a7a9-4eee65f13338', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776737031612', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'como esta', '2026-04-21 02:10:54', '2026-04-21 02:10:54'),
('cf289240-a5bd-459d-a721-359dd4b16647', '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '77037021-69a2-46d0-b648-6ab51202059b', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'hola', '2026-04-18 23:41:52', '2026-04-18 23:41:52'),
('f895eebb-62a8-4634-b210-e894cacd3caf', '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'gst_1776733817143', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'como estas', '2026-04-21 01:21:54', '2026-04-21 01:21:54');


-- Structure for chat_messages
CREATE TABLE `chat_messages` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `conversation_id` char(36) NOT NULL,
  `sender_id` char(36) NOT NULL,
  `message_type` enum('text','image') DEFAULT 'text',
  `content` text NOT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_conv` (`conversation_id`)
) ENGINE=InnoDB AUTO_INCREMENT=58 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for chat_messages
INSERT INTO chat_messages (id, conversation_id, sender_id, message_type, content, is_read, created_at) VALUES
(1, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', '77037021-69a2-46d0-b648-6ab51202059b', 'text', 'hola', 1, '2026-04-18 22:27:22'),
(2, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', '77037021-69a2-46d0-b648-6ab51202059b', 'text', 'queiro info', 1, '2026-04-18 22:27:50'),
(3, 'cf289240-a5bd-459d-a721-359dd4b16647', '77037021-69a2-46d0-b648-6ab51202059b', 'text', 'hola', 1, '2026-04-18 22:31:19'),
(4, '5a304f3e-0270-4c78-9305-efc6410342a0', 'gst_1776552962457', 'text', 'hola', 0, '2026-04-18 23:00:50'),
(5, '3f531977-2754-4659-bb23-db9917ea0b95', 'gst_1776552863538', 'text', 'hola', 0, '2026-04-18 23:01:05'),
(6, 'bd6fe2c0-b0ca-4f56-8ce9-1444a84a9f08', 'gst_1776552863538', 'text', 'hola', 0, '2026-04-18 23:08:17'),
(7, '6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', 'gst_1776552962457', 'text', 'menasje de prueba', 0, '2026-04-18 23:08:39'),
(8, '6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', 'gst_1776552962457', 'text', 'responde', 0, '2026-04-18 23:11:00'),
(9, 'cf289240-a5bd-459d-a721-359dd4b16647', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola', 0, '2026-04-18 23:14:06'),
(10, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'que informacion deseas', 0, '2026-04-18 23:14:22'),
(11, '6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', 'gst_1776552962457', 'text', 'hola', 0, '2026-04-18 23:14:35'),
(12, '6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', 'gst_1776552962457', 'text', 'soy yo', 0, '2026-04-18 23:14:42'),
(13, '6393d1e9-34fc-450d-a0ad-5cb5dc8b0e5f', 'gst_1776552962457', 'text', 'alex', 0, '2026-04-18 23:15:57'),
(14, '0b5b2228-8441-4e89-97b4-27ba8b78534f', 'gst_1776554524859', 'text', 'soy comprador', 0, '2026-04-18 23:25:04'),
(15, '0b5b2228-8441-4e89-97b4-27ba8b78534f', 'gst_1776554524859', 'text', 'estas?.,,,', 0, '2026-04-18 23:25:25'),
(16, 'cf289240-a5bd-459d-a721-359dd4b16647', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'aqui', 0, '2026-04-18 23:26:22'),
(17, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hey', 0, '2026-04-18 23:26:31'),
(18, 'bc9d0995-e55a-417b-8632-5f654fc35d7e', 'gst_1776555581157', 'text', 'hola', 0, '2026-04-18 23:39:57'),
(19, '2fb998c0-ed44-4241-bb58-1d2e4fe47fdd', 'gst_1776555581157', 'text', 'comprador 1', 0, '2026-04-18 23:40:14'),
(20, 'cf289240-a5bd-459d-a721-359dd4b16647', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola', 0, '2026-04-18 23:41:52'),
(21, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola', 0, '2026-04-18 23:41:59'),
(22, '5d2d4b93-b3e1-479c-b329-928a3f1e8850', 'gst_1776732450583', 'text', 'hola', 0, '2026-04-21 00:50:46'),
(23, '5d2d4b93-b3e1-479c-b329-928a3f1e8850', 'gst_1776732450583', 'text', 'hola', 0, '2026-04-21 00:53:37'),
(24, '0e8ca2bf-ff89-4f3b-80b0-9ffcad37e776', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'estas?', 0, '2026-04-21 00:55:00'),
(25, 'f895eebb-62a8-4634-b210-e894cacd3caf', 'gst_1776733817143', 'text', 'hola', 1, '2026-04-21 01:10:25'),
(26, 'f895eebb-62a8-4634-b210-e894cacd3caf', 'gst_1776733817143', 'text', 'estas es una prueba', 1, '2026-04-21 01:10:36'),
(27, 'f895eebb-62a8-4634-b210-e894cacd3caf', 'gst_1776733817143', 'text', 'seguimos con la prueba', 1, '2026-04-21 01:12:14'),
(28, 'f895eebb-62a8-4634-b210-e894cacd3caf', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola', 0, '2026-04-21 01:21:46'),
(29, 'f895eebb-62a8-4634-b210-e894cacd3caf', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'como estas', 0, '2026-04-21 01:21:54'),
(30, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'gst_1776734585281', 'text', 'hola', 1, '2026-04-21 01:23:22'),
(31, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'gst_1776734585281', 'text', 'necesito inf', 1, '2026-04-21 01:23:30'),
(32, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'claro', 1, '2026-04-21 01:23:56'),
(33, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'que necesitas', 1, '2026-04-21 01:24:07'),
(34, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'gst_1776734585281', 'text', 'relcion de precios', 1, '2026-04-21 01:24:28'),
(35, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'gst_1776734585281', 'text', 'estas', 1, '2026-04-21 01:24:37'),
(36, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'sic lado', 1, '2026-04-21 01:24:42'),
(37, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'dime', 1, '2026-04-21 01:24:45'),
(38, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'gst_1776734585281', 'text', 'que bueno', 1, '2026-04-21 01:24:56'),
(39, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'bien', 1, '2026-04-21 01:25:15'),
(40, '48e0e82c-8c6d-4fa6-80c9-ad67a5ac6858', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola estas', 1, '2026-04-21 01:30:47'),
(41, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'gst_1776735096494', 'text', 'hola', 1, '2026-04-21 01:31:41'),
(42, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola', 1, '2026-04-21 01:31:54'),
(43, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'bienvenido', 1, '2026-04-21 01:32:02'),
(44, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'gst_1776735096494', 'text', 'gracias', 1, '2026-04-21 01:32:08'),
(45, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'gst_1776735096494', 'text', 'hola', 1, '2026-04-21 01:49:26'),
(46, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'claro dime', 1, '2026-04-21 01:49:43'),
(47, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'gst_1776735096494', 'text', 'hey', 1, '2026-04-21 01:53:57'),
(48, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', '🔔 ¡HOLA! Esta es una prueba de notificación automática de KLICUS.', 1, '2026-04-21 01:55:37'),
(49, 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', '🔔 ¡HOLA! Esta es una prueba de notificación automática de KLICUS.', 1, '2026-04-21 01:56:39'),
(50, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'gst_1776737031612', 'text', 'hola', 1, '2026-04-21 02:04:36'),
(51, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'gst_1776737031612', 'text', 'como esan', 1, '2026-04-21 02:04:44'),
(52, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'hola, bienvenida', 1, '2026-04-21 02:05:39'),
(53, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'sigues', 1, '2026-04-21 02:10:11'),
(54, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'text', 'coo estas', 1, '2026-04-21 02:10:19'),
(55, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'gst_1776737031612', 'text', 'hola bien', 1, '2026-04-21 02:10:24'),
(56, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'gst_1776737031612', 'text', 'u du', 1, '2026-04-21 02:10:52'),
(57, 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 'gst_1776737031612', 'text', 'como esta', 1, '2026-04-21 02:10:54');


-- Structure for guest_identities
CREATE TABLE `guest_identities` (
  `id` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for guest_identities
INSERT INTO guest_identities (id, name, created_at) VALUES
('gst_1776735096494', 'Nata', '2026-04-21 01:31:37'),
('gst_1776737031612', 'Karina', '2026-04-21 02:04:25');


-- Structure for metrics
CREATE TABLE `metrics` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ad_id` varchar(255) NOT NULL,
  `event_type` enum('view','click','contact','install','session') NOT NULL,
  `device_type` enum('mobile','desktop','pwa','mobile-app') DEFAULT 'desktop',
  `ip_hash` varchar(64) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_ad_event_date` (`ad_id`,`event_type`,`created_at`)
) ENGINE=InnoDB AUTO_INCREMENT=645 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for metrics
INSERT INTO metrics (id, ad_id, event_type, device_type, ip_hash, created_at) VALUES
(1, 'FB_99', 'view', 'desktop', '13c95cbab9266ba77a476ae55452dadda9d1e71841d7bd3fb44e3967d58f9f59', '2026-04-16 20:16:02'),
(2, 'FB_1', 'view', 'desktop', '8a4d416740cd1af8261a4479afb8a386b6b667dbeefbeb051398f4c208c2270f', '2026-04-16 20:17:35'),
(3, '21782978-87b0-4c5a-95e4-ad046d44309d', 'view', 'desktop', 'ef4c5a8ac6551e1db4e32f0e7261931ecb11625b4e8fde85963daae426b9c2d2', '2026-04-16 20:21:35'),
(4, '21782978-87b0-4c5a-95e4-ad046d44309d', 'view', 'desktop', 'ef4c5a8ac6551e1db4e32f0e7261931ecb11625b4e8fde85963daae426b9c2d2', '2026-04-16 20:21:35'),
(5, '0281993f-c02b-4f23-9343-d6638145de80', 'view', 'desktop', '2dfea1e5c0c6e90c1a8d2502cbf004e1d25e4d55dee0fc71cd041a15d62f0f44', '2026-04-16 20:21:35'),
(6, 'FB_99', 'view', 'desktop', '13c95cbab9266ba77a476ae55452dadda9d1e71841d7bd3fb44e3967d58f9f59', '2026-04-16 22:01:40'),
(7, 'ADS10', 'view', 'desktop', 'e1c13b03b2bdc485c2cdcbb65579d7697f23cd9a4ef17f6ac91ceca0a71223fb', '2026-04-16 22:36:48'),
(8, 'ADS4', 'view', 'desktop', '0b86e9d26c60460e2469209823b926c23b5f55bf7a7b666ec7683d54001096e7', '2026-04-16 23:18:55'),
(9, 'ADS11', 'view', 'desktop', 'cb37d8816557b394450dfe8577fab838116ba46ed4d8b701489c395ba6f293f0', '2026-04-17 00:15:18'),
(10, 'ADS10', 'view', 'desktop', 'e1c13b03b2bdc485c2cdcbb65579d7697f23cd9a4ef17f6ac91ceca0a71223fb', '2026-04-17 00:15:29'),
(11, 'ADS1', 'view', 'desktop', '2dbca5d89d1283f6b856e265c38b34fbc7fb20bdd7fbcc6c18902745dd269c62', '2026-04-17 00:15:44'),
(12, 'ADS12', 'view', 'desktop', '94039e9596643e4f23ccdd4b97c322959227462fc44a62deaf66ea7ccadf7248', '2026-04-17 00:15:51'),
(13, 'ADS50', 'view', 'desktop', '121d33780950724ad0d2766f916424ebbf4aa95aaf02ee627b420ed12cdbc482', '2026-04-17 02:17:01'),
(14, 'ADS18', 'view', 'desktop', '6e10bb29906d2d77faf502d6d909109d018a2022a2ad328e5ccdc38bb2cbdb88', '2026-04-17 02:17:12'),
(15, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'view', 'desktop', '3fa64ad276bbc6f392c764dc6b78ecb136a1f447033e21ee9f93d5bcecd396b7', '2026-04-17 04:31:51'),
(16, '244e5b5f-b9fa-4bc3-97c4-e5453a4f06b8', 'view', 'desktop', 'ddb044ca30b115e1ccd11031f61ef4c0c759c11e489e2463d1c496c4034089b3', '2026-04-17 15:07:18'),
(17, '69460bb0-c043-492d-9a56-c0b8ae6e9ee8', 'view', 'desktop', 'de9079d862b66ebf7ef21ec1757e6632aa6dd415d4c59c4b78be109697dd3611', '2026-04-17 15:16:18'),
(18, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'view', 'desktop', 'c8dc43e04049f96051637dc8bb179e86e2786eddab0d18073de081f5ecefecb7', '2026-04-17 15:20:23'),
(19, 'f8f4a2b3-9f5a-42e9-a8c7-7afdc776af9f', 'view', 'desktop', '867f4d53dc150bf587d7e87c52e4e9bc4828eb3e9ac916064101ff9ddf952baa', '2026-04-17 15:21:21'),
(20, '0eac42c3-0f5b-48ba-ae98-50766ee8b404', 'view', 'desktop', 'b4897c276409ba03fe864c67edd342f41ce566123e841c14b08148d04102bed1', '2026-04-17 15:23:37'),
(21, '121239c3-dd92-46b0-94c7-73fcea4a43ba', 'view', 'desktop', '424546b729fe05fee77d82ab8d42df5a29493dc70acfdc050025396b1185455a', '2026-04-17 15:23:42'),
(22, '461f65ca-35d0-474b-b163-b0505f8004b2', 'view', 'desktop', 'f76a96335e15dc597260446afe1813c23dafce24d04fc1667a89e45b5e13eaa7', '2026-04-17 15:23:57'),
(23, 'd9728b4e-7d18-4997-92ed-3676a4afcfe6', 'view', 'desktop', '8cb799072e791d3bc84f6661a4cd560ce1b994636dc0ea99988630b52f972f3a', '2026-04-17 15:24:19'),
(24, 'e65e4ec5-62e9-4114-970d-12a1ef15c74e', 'view', 'desktop', 'fee89e88306c9b23eb22c50a8f836b2bd0be526c9e221cf74f2a601648847dfb', '2026-04-17 15:24:33'),
(25, '604cccfb-7416-4a4a-83e4-2b442d96df62', 'view', 'desktop', 'afeb0c9852189598ddc9a3d88dc76bd2d0f07678d30b1e993cb3655298145b61', '2026-04-17 15:27:16'),
(26, '09b30f00-769b-487c-8405-5beef0d45611', 'view', 'desktop', '2b0d7dbe19c285874de80da70b7e1c965a2e4afb44ed42ad9e8606e16961b6ec', '2026-04-17 15:27:23'),
(27, 'd9728b4e-7d18-4997-92ed-3676a4afcfe6', 'click', 'desktop', 'e595c228f73f73dc2cdd2d8a0185c476a8d28196b1e32cc068c8e8f762f62b5a', '2026-04-17 22:25:31'),
(28, 'd9728b4e-7d18-4997-92ed-3676a4afcfe6', 'view', 'desktop', '8cb799072e791d3bc84f6661a4cd560ce1b994636dc0ea99988630b52f972f3a', '2026-04-17 22:25:52'),
(29, 'd9728b4e-7d18-4997-92ed-3676a4afcfe6', 'contact', 'desktop', 'e7d8b348c36466289afa198c8acb297038572633d5f1e160824243d22e002a3e', '2026-04-17 22:26:03'),
(30, '0eac42c3-0f5b-48ba-ae98-50766ee8b404', 'click', 'desktop', 'd11db86d9cbe65ac736448b865ea8e1051bae188612ebd0b759d0950082f365a', '2026-04-17 22:28:05'),
(31, '0eac42c3-0f5b-48ba-ae98-50766ee8b404', 'view', 'desktop', 'b4897c276409ba03fe864c67edd342f41ce566123e841c14b08148d04102bed1', '2026-04-17 22:28:08'),
(32, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'click', 'desktop', 'b2ae86c7bd52dedd7a0b59c63260b38c8de7ac445c794f342f2b494c68f43080', '2026-04-17 22:40:56'),
(33, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'view', 'desktop', 'c8dc43e04049f96051637dc8bb179e86e2786eddab0d18073de081f5ecefecb7', '2026-04-17 22:40:59'),
(34, '121239c3-dd92-46b0-94c7-73fcea4a43ba', 'click', 'desktop', '66e8c5bf2f2751e1064c91e8879eea6378ef72782c5d0ac5c3b0759a410bf07e', '2026-04-17 22:46:03'),
(35, '121239c3-dd92-46b0-94c7-73fcea4a43ba', 'view', 'desktop', '424546b729fe05fee77d82ab8d42df5a29493dc70acfdc050025396b1185455a', '2026-04-17 22:46:05'),
(36, '0eac42c3-0f5b-48ba-ae98-50766ee8b404', 'click', 'desktop', 'd11db86d9cbe65ac736448b865ea8e1051bae188612ebd0b759d0950082f365a', '2026-04-17 22:57:10'),
(37, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'click', 'desktop', 'b73a6a579e85883e84b15e2500b9771a2fb48ff780002964a35a191bc6fce8dd', '2026-04-17 22:57:21'),
(38, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'view', 'desktop', '3fa64ad276bbc6f392c764dc6b78ecb136a1f447033e21ee9f93d5bcecd396b7', '2026-04-17 22:57:23'),
(39, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'contact', 'desktop', '6fa1a06c509e58825093ba67344bbc26a8f592afddc365d63725b5edf653df6f', '2026-04-17 22:57:23'),
(40, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'click', 'desktop', 'b73a6a579e85883e84b15e2500b9771a2fb48ff780002964a35a191bc6fce8dd', '2026-04-17 23:05:57'),
(41, '33f45d3c-a5e3-4f81-8c3b-1b77ab395cf3', 'contact', 'desktop', '6fa1a06c509e58825093ba67344bbc26a8f592afddc365d63725b5edf653df6f', '2026-04-17 23:06:06'),
(42, '6b1e9494-7d21-4845-9802-f9b79d089184', 'click', 'desktop', 'cf6165ba00b9081cd21fb9856946ff633a1ce7a9fdcdd48b14f46214d85c922e', '2026-04-17 23:42:41'),
(43, '6b1e9494-7d21-4845-9802-f9b79d089184', 'view', 'desktop', 'd826eb1263951f111a03b0762b6d29f2a9749f864c60a7e529d7ea3b802d4903', '2026-04-17 23:42:44'),
(44, '6b1e9494-7d21-4845-9802-f9b79d089184', 'contact', 'desktop', '2a932a566b0c59e0664b4372415cb5e7f83c95f8527bf3e92331afff80f2b99c', '2026-04-17 23:42:48'),
(45, '6b1e9494-7d21-4845-9802-f9b79d089184', 'contact', 'desktop', '2a932a566b0c59e0664b4372415cb5e7f83c95f8527bf3e92331afff80f2b99c', '2026-04-17 23:44:09'),
(46, '09b30f00-769b-487c-8405-5beef0d45611', 'click', 'desktop', '6f2f1fd8cf1b0262dbc0db4b14031479221b5e2b4496411e170127b1a83994e3', '2026-04-18 00:32:10'),
(47, '09b30f00-769b-487c-8405-5beef0d45611', 'view', 'desktop', '2b0d7dbe19c285874de80da70b7e1c965a2e4afb44ed42ad9e8606e16961b6ec', '2026-04-18 00:32:13'),
(48, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-18 00:48:04'),
(49, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-18 01:18:24'),
(50, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'be4bfe2fdd06250861d3d067edd7763dbbb998f08d5208529d71640ba8580e8b', '2026-04-18 18:18:52'),
(51, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7fedd4ad2339a17dbf47bf40d21f04b66f3337245313a43eb6a000690e0500c1', '2026-04-18 18:18:52'),
(52, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9ab8b313193e0eb8e46ec07f7c3da3d01e364f6fe2bfa0131e258b55faf172c1', '2026-04-18 18:18:52'),
(53, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd3d1427c8a747fc4e4cbb2ca87dbcb9cf37107d70aad5e9c409f895a04fc7660', '2026-04-18 18:18:52'),
(54, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a4e67ced240614427aef1a3971e25a17675798dc3152678e22c547e01e5e67d0', '2026-04-18 18:18:52'),
(55, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9ad26c6907760e5b3f1baa336110eb7ccbec12ad056cb703c00f732c02c65747', '2026-04-18 18:18:52'),
(56, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9e688253835cedba8040ac937393ed56fa1f3927a118a834e50725423f5929e8', '2026-04-18 18:18:52'),
(57, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8f218e66a90c6f8cb6dff878958dd567d0628274c05b7fd4e72ccf7043c7ee9b', '2026-04-18 18:18:52'),
(58, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a6f1466f59463f7112a9137f1205f3cf38dc10dd012c47b512970064b4bf8705', '2026-04-18 18:18:52'),
(59, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '442647af9fbaac0b07d33b5130a6bcff890fbd35fa3e5e3151a4856478ab8eaf', '2026-04-18 18:18:52'),
(60, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4f8aa71ca551f8ef551336a04c1e45cd29c600f8d076a01c79e9054d13c9f2ed', '2026-04-18 18:18:52'),
(61, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3643832ff580217749308526efcb1f69ddec046c44bf02df1e795336e3b762e8', '2026-04-18 18:18:52'),
(62, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'de1c502ac32d7315ffe43d9c4a339230368be3db1c739a9e374bd459c978c3f6', '2026-04-18 18:18:52'),
(63, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5601a540d39112aab35fd9a3dfd12331571fbfc00d8fc1c0d0828935a1452ada', '2026-04-18 18:18:52'),
(64, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ad416f4363bae9478bcd046596f0d4d3bc6437210e76d524ae596c5668a38039', '2026-04-18 18:18:52'),
(65, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7aacf00d4e4f95eedad1cd6a35ea59d57960e2172d1af731cce3d4b35c7957a6', '2026-04-18 18:18:52'),
(66, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'afa29dc542cb7f6086ddfb14524fb6e360378aa103fc23f55c773d3ee5e9d856', '2026-04-18 18:18:52'),
(67, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '97c28b97112530366ba2a83884a9869f5c805f475cb7f73fed997dc7a086cd2c', '2026-04-18 18:18:52'),
(68, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3e788e1814fe20c83ebc0a61d34fcfc75d73565e1dbd9c903eb6ca64f8b0268c', '2026-04-18 18:18:52'),
(69, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '51bade73ec1c40da4d68fe764f87db8fb7db6ca2a2518f1435d4240d794e7a1a', '2026-04-18 18:18:52'),
(70, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8add4b872177594dfb5a8615a7cbfaecc0f818c285d6f0d928ed00d6fe78dc10', '2026-04-18 18:18:52'),
(71, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'efa11998dc72c0177fc3e54bf681720da09c83319760eb195888750f4306619c', '2026-04-18 18:18:52'),
(72, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9f8e04bf88a66a591ffa6c8291b6667e430b29bb2f8145a234f29754ac3c2503', '2026-04-18 18:18:52'),
(73, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a1fc80a8ccff4b0c668e793d07cab7dbfcde484777da246735fa94119a91da9d', '2026-04-18 18:18:52'),
(74, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fc71c545747e7d331d1478e414e57dc02743f935d44f05a731e4e5d32ff69a42', '2026-04-18 18:18:52'),
(75, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ab04c43738d085edffae27ce23ce675313a905aafc6b93286b73bbd6c111efa5', '2026-04-18 18:18:52'),
(76, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '75aa1982e7f12c59b6af7cffc5786632f4fc0511aeb6578d3c82c2049ef7fe57', '2026-04-18 18:18:52'),
(77, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ff9c14d2df8658385083d1516e18eb1847db34a31186a22a801619a364e813e9', '2026-04-18 18:18:52'),
(78, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '634b06d532faa83ddfb623dfadc10a3e204188fcff1a7dd3afb1e76ad02363fe', '2026-04-18 18:18:52'),
(79, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bf3cdd67c20bf4508f8571b198fb15149f330bdc23e8079503a11c82b5987ec9', '2026-04-18 18:18:52'),
(80, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '503374a6e75dfcff62373f6d318471b94098816e75f737bf871d64e4ed6bb34c', '2026-04-18 18:18:52'),
(81, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f1a1b831a704c65ad8533ae4b67c795a0d4db29dbc91f64552d353c5d1be52d5', '2026-04-18 18:18:52'),
(82, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b39d2405496d6e5c619ff05809b70384f6c09014359856c262bd1f9a61447132', '2026-04-18 18:18:52'),
(83, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd6c50891880fd3c4b4a27b6085db8fd126daea905de947ef7f49c1e698f6acc4', '2026-04-18 18:18:52'),
(84, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0c6b2966685e6810074fec4b63f9e2925480ad2bf1e373c9bfb717a63e8de34a', '2026-04-18 18:18:52'),
(85, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '15fa5bd9554000223eba1e83e1d8c6b517c3a6ae4732716ab7ab563142a786a8', '2026-04-18 18:18:52'),
(86, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '879be7b10d68bb174dbe8ceb063401f82469c2c77a2f57ae20f6282bd050986f', '2026-04-18 18:18:52'),
(87, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9ca899f15ed19db586a9621e6cc4f1e31ee2e722502f0912aefe5484f1178a33', '2026-04-18 18:18:52'),
(88, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '39223c350c38c667161d9905df20e5682252f0499613d1e73b3745abf3bd401b', '2026-04-18 18:18:52'),
(89, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f0567762cda3ed3b1df90395b57d301dfd640c04721d869d6dc396d4e4d9c7a6', '2026-04-18 18:18:52'),
(90, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b5e8ef56b8e4809a974d6432e45f19b0114187489cd56d6ff68aaf091862f646', '2026-04-18 18:18:52'),
(91, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a8d117aced120fdff0cc2c664e010c3cf8e602989c448ec45c131a779e82312a', '2026-04-18 18:18:52'),
(92, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c8a5b325cf56eefe593c5d5e600dc21f4efaad121f5da8976446801a7c91e16a', '2026-04-18 18:18:52'),
(93, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4c046ad45327f64632d7bea0167967e2daee49ed80d497b3fdba467587a672f1', '2026-04-18 18:18:52'),
(94, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '08085accc8877e6dd56b43b9829aaccdf73331501f534b23aefc900a22333848', '2026-04-18 18:18:52'),
(95, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '64a9b9bcd5e86846e3a995388e446702ab73311a801bfd26396daefab1d99400', '2026-04-18 18:18:52'),
(96, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5a9a9da26fb39624db29f2d5460730f8a9e0c83c82b6ca96d81a84e86159c197', '2026-04-18 18:18:52'),
(97, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a2f6f7cdb9f695a31e0bca45e800efa26f6474fee8f9cbc408e0e4d6f884f083', '2026-04-18 18:18:52'),
(98, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '29658ea0ade3860ccd74d75fea802d4d8c8efa024c4d290f3681ca524993c8cc', '2026-04-18 18:18:52'),
(99, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '022b23b99b74e3ff7fcf3fa5a9405f8d2875737bfe885205e41c591baa66fbca', '2026-04-17 18:18:52'),
(100, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd27a81fd28017e3080799e9d2fb6a60e8361305aaef8004716f9dca3ee5f2201', '2026-04-17 18:18:52'),
(101, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '535708281897d2f3506155354a8eebe80e92cff6727641d93402b9c7a2138b4b', '2026-04-17 18:18:52'),
(102, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e8c6419e0f629ce76508741457f2ff3327a5383966b0b8e99b837bec6c2b842b', '2026-04-17 18:18:52'),
(103, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1258c7e733cb91aa4f8c6450f6260cd5eae44ceba35c11a3d36c5d96c81c51d7', '2026-04-17 18:18:52'),
(104, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '340852c8aa4fb2e086bda4f62698b2645ae228d4057f2ba587940fe3d111f12d', '2026-04-17 18:18:52'),
(105, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fe8907cc511a135b7f0395b5d6ed08cd0f3657401b82d92d006bff7b45a7eaa0', '2026-04-17 18:18:52'),
(106, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2de821124fd62fc0c545060b35322f6dc3d046f5a679dc876fb034a15faca499', '2026-04-17 18:18:52'),
(107, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ac1733e0b585361e051ff5a3903e8214903c5803186d6b0597731839290d57fb', '2026-04-17 18:18:52'),
(108, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'accc19dcb74de8d522f5a6be9e353c42674f72457e6ccee708d9b94bbad01005', '2026-04-17 18:18:52'),
(109, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '654b213de4b89a23e92fe30f09138d09ff7407a701b7fe2646b58386874408cd', '2026-04-17 18:18:52'),
(110, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '162c646e920d68e81ea0dcdb6293bd4308ad5498e0a77db0a053ddeff2ba1d8c', '2026-04-17 18:18:52'),
(111, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '924a9537d9fb8735411bd298928aacffe93c8b52d715e3a574f633e4051f2630', '2026-04-17 18:18:52'),
(112, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0c9d2b5c3878cafa228e3486acfc2de56b27e469326bbe63df1a1e950006b793', '2026-04-17 18:18:52'),
(113, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '82097a323c1116dafc46cc1f36365e2879858494380259ab6ddff2a965c1d4de', '2026-04-17 18:18:52'),
(114, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6c1f30c122225a0be584daf7192a7efc0686f8c7ab9a0d83a5e80826bbb27a4d', '2026-04-17 18:18:52'),
(115, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ba992baa07416d5bce136538feb73affd60f06a6ef9585b9dbec3b305c480a66', '2026-04-17 18:18:52'),
(116, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '459e732bdc9ea83bea5a23975715115c2cd8912ab0381039228ee772129e6748', '2026-04-17 18:18:52'),
(117, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '765c62a228b8a437e387a80f99ac8ed69f226a33048b6430207280d61fee6aa0', '2026-04-17 18:18:52'),
(118, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd312677a01c21e688705772f2e0cbc5cb5d086527d3b43ec54d136035dbe4b00', '2026-04-17 18:18:52'),
(119, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c685737a8131496efa8b7b6b1db548ed5af7b333f964ca095e46197deea7db16', '2026-04-17 18:18:52'),
(120, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0a68768f5fcf8296e3d1fb6c5fb2910bbba14b8f026f60d2f16c1bc2972bbbd1', '2026-04-17 18:18:52'),
(121, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '18641e99921c6f8a66a43007a32a2b31973e8eb83ca251d190681a8445feb72e', '2026-04-17 18:18:52'),
(122, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c75f7080af4ba40b0652fb4ff7b3387e751851394f492419b55eff9ea8305d54', '2026-04-17 18:18:52'),
(123, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dfef90caa44bc767d074e31f9191997e3cb62dbe613c770b70b32c63db1c13dd', '2026-04-17 18:18:52'),
(124, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd86e6d21c8857839e5d8c9c301c59ead787666d3a5315cdc9fbd0248ab8c7997', '2026-04-17 18:18:52'),
(125, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'ffcc0f8532c9f33aafc72916753ea0e21a1eda0d0ff34151666d6e914c1045c4', '2026-04-17 18:18:52'),
(126, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '2cf9520529ed24509c406703a4b9a9d1dbcb41693b0f5a7734b2d5779aa0609f', '2026-04-17 18:18:52'),
(127, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '814a35f3cca7f29be5e340904f920ae7243f3c3fcaa4797845acb86dd632cdfb', '2026-04-16 18:18:52'),
(128, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0e2d0682c3686fc9fa579841f82222b60cdda873e26717ac2ef6f5fe66060873', '2026-04-16 18:18:52'),
(129, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1eae63e0d9cc0abd3fef62002c613b1edff9994687a698dc5b200939169bf651', '2026-04-16 18:18:52'),
(130, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6947bbfc39f0f5d5d9f1916644f901fc01d53afb3930e3191422d16684cd85e6', '2026-04-16 18:18:52'),
(131, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd9893716a5892db235c3ba6b28e6fe051919457beac51114a857113c1f5bf048', '2026-04-16 18:18:52'),
(132, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e1d20f0e7b635a3d66338d4723c95a48b26b272fd1cc0d2c729b517178fa656a', '2026-04-16 18:18:52'),
(133, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '18c988fb4f669fe7973f868e935f97275cb06e601ba81a7b654356acdc1ef3eb', '2026-04-16 18:18:52'),
(134, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '20497fef6e4297b93d456f43a52959de466d98bc239f3f4afd16f8d76a59875c', '2026-04-16 18:18:52'),
(135, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd9df716bc2d429881a4c80d47f14594e7643e26a1515ffcc60ae3aa6d0bd3c6d', '2026-04-16 18:18:52'),
(136, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7d7b5d243b869251ea69d984645c7e01dd02e39cfaa9cab44489524e98ee4438', '2026-04-16 18:18:52'),
(137, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'deeef50f2e03ce208e3aaf7ca251aace26d539260bdc2f0f14325fa78c8a40f9', '2026-04-16 18:18:52'),
(138, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '13c4d9ac39c3d3ac04ed1e071eff32227ab7a92c4d936be712430b2a1200ea02', '2026-04-16 18:18:52'),
(139, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '59ee4fd76703d0cead728db3948dc9ce21149b635842e5e82ebf3f2a11085578', '2026-04-16 18:18:52'),
(140, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b80f73c3ff744f2397ae4e1689a77b96a2dd8629e33276610f78f9b619bc53cc', '2026-04-16 18:18:52'),
(141, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '48bad829b57af57a106778fddaa2f163b6e4365790cd11b2b9f9e54ded51a746', '2026-04-16 18:18:52'),
(142, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '01e3cac127296564c5669b375a0da5b90991d39cbba738cf99403debeebab69a', '2026-04-16 18:18:52'),
(143, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b1c4e72d8889c523f5771387deb1b304618933b98048ece9dfa725fd13b8a548', '2026-04-16 18:18:52'),
(144, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd1e13815fac1036e16b8a1786fc24e771fe344baaf5f25e4227bb632e5f0f95f', '2026-04-16 18:18:52'),
(145, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '27aa9d6b27656f1825242dcb8176446f29e9f05324fc212fa21d427330dc2d1a', '2026-04-16 18:18:52'),
(146, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f4efaac56698d094722f0c0cf1b9aa2e12687fddc7a1e1f280240a5cb231fe08', '2026-04-16 18:18:52'),
(147, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e996c8b6a8f1835fa3b99ccd4226844008a2fb366c8a51f795ee2ab60359e9a0', '2026-04-16 18:18:52'),
(148, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '841297dce4d04dc248d97f66b3b657563fde2c7b4c84a17277398b770322dea9', '2026-04-16 18:18:52'),
(149, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'abe21d591b0f4e7a9e0d96e0ef28a6d65012fd81babe7d1798c5b638bdf1a38a', '2026-04-16 18:18:52'),
(150, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e458af574cee1d274ce7d0e6dff09d5baf888764c9cab5fc1fe457c1daff46ea', '2026-04-16 18:18:52'),
(151, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4706c62f95368fb4753521c92dafb1136a00dab968fe034a7cb62f73e8112330', '2026-04-16 18:18:52'),
(152, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '17c19c6e6edd92e5b9029663f7a042b23b0cd4fe0ddf6c10f72ae4f52fc07e0e', '2026-04-16 18:18:52'),
(153, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '93732a03668ff4287d7690b78c21fba89fd4a76aa1eb10b790ffdcfe2c6334d2', '2026-04-16 18:18:52'),
(154, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd69cdc65d3e8ff504ae0e3daf55f30eaafb5d3a767097524946b7b0e018727bf', '2026-04-16 18:18:52'),
(155, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c17d6000fc212ad8390db5ef024d2b63c4a835d419a79e484e6f6f4267cdab2e', '2026-04-16 18:18:52'),
(156, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9bb684d58ef3579a971ce99960760b936a44e38bd1b0f2f7f60ccc603b6de69c', '2026-04-16 18:18:52'),
(157, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f3698d97048cdcea6d02c1b9316f7c72764d9ff00a5b763731e94fe529fe4c31', '2026-04-16 18:18:52'),
(158, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4e9744b555eeaefd70b24f64990d72d967bc09449d1bc3466c40387256ed9729', '2026-04-16 18:18:52'),
(159, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1ef6cc2035ea01e3b9cee3f2cb4d4e2cb2bf2fd7c1ef4053480767a1a01668ed', '2026-04-16 18:18:52'),
(160, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '44125795373d51d72597e584697632d0fcec06c31ee33d25b6d97c51d8cfbcbc', '2026-04-16 18:18:52'),
(161, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6ee667d7e1a08d6c71d23b53a9e7d086804ac15c680473550252ca7da47bfba5', '2026-04-16 18:18:52'),
(162, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '29d4a411a03cec1eea590070422eefc5e09dd29dded6894798a4d21e3c6ba19e', '2026-04-16 18:18:52'),
(163, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '01dcab78ad142f71f9d6a7cf22d723a77f499b143f71a724218774f937dea9cc', '2026-04-16 18:18:52'),
(164, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '81aa564a70ba1f5f2dd9114553d88a2ec95ce9e2ad441631e4577d90b81728bd', '2026-04-16 18:18:52'),
(165, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7b3dd814e6ddabab4ca41a50ef03a2da4f480eacc962aa69aad60242ae67003b', '2026-04-16 18:18:52'),
(166, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '034b2d74a09bf04d886f05f427cb71bf72633370ef91b9ecc23acd81ca2efe5c', '2026-04-16 18:18:52'),
(167, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fcfc375c9cc0add69f22b4f0e2cd856557e995618592482ceb31db279234a237', '2026-04-16 18:18:52'),
(168, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '198c992f9c11889eaed3184fc479a2a669df42a0d0b715c136011305dfe141b3', '2026-04-16 18:18:52'),
(169, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd33568452a742fc332b05c4af509168c9391ec25f0c6f3a49e36316fde1e2e65', '2026-04-16 18:18:52'),
(170, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bcd9f23504a32d4b3efe64f2f23d4698e008599be403ceb94fac412f023259dd', '2026-04-16 18:18:52'),
(171, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'aa7cb6130bb9f3d904f6f475bdc3ad40585a17695c98f8e988df015a7b7c1e3c', '2026-04-16 18:18:52'),
(172, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1d16db4af596b094285971ee16ea03bd7ff9508006ac03946b0a06fa62810ca5', '2026-04-16 18:18:52'),
(173, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '089969aca3207e9b406cd45e42fa23c9c14780b69cd98060970ef131709fe980', '2026-04-16 18:18:52'),
(174, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5f7459e1dcd6d13993e75ae178cb86263fc76bed382c0fdd6b121f641f0def0d', '2026-04-16 18:18:52'),
(175, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '57adfc3e368c999f32c05bb4a409b9e0f3660f9386e230a3f05e580b32d8c9e0', '2026-04-16 18:18:52'),
(176, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dd3593850f7b36ababa110409b29f2cf3343374fdc36ae66baa74b61e4b908aa', '2026-04-16 18:18:52'),
(177, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '19dcf7916519e67d857a50ee2262872b8cb10cadaa662739fb14968c62c4d52d', '2026-04-16 18:18:52'),
(178, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ab89dabe36ba05d77b23fc45ae36917c94422230314efdaf28b8fe9ef5fef2d2', '2026-04-16 18:18:52'),
(179, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4ede5c6c1ccafd4e634dba230489122535dd214314b4284114e3b9e0b741162b', '2026-04-16 18:18:52'),
(180, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3053977db97b1ff8d215ac566a236310e5d1b7852e4e42db82187adbfd9ba99a', '2026-04-16 18:18:52'),
(181, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '711ec244706df10416299094d303004824f4ff233507fbf5df450ea161843a22', '2026-04-16 18:18:52'),
(182, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a03b026a1a022539ef2bc43a95711631f7819fef72ca2fbe0c7692f0c4ee8b4e', '2026-04-16 18:18:52'),
(183, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c9ad0b191f0e9757a33c9ff45cdedeefcf222d73494039863c68cb1570ea6d50', '2026-04-16 18:18:52'),
(184, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '2b090515f2a2f5f39a08d9ba41458d08c795e4df50329468f5fef6c6983c46e5', '2026-04-16 18:18:52'),
(185, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '2e0975fe110077f6532fdde290c8788c83e159292598deacea3358a3789679ff', '2026-04-16 18:18:52'),
(186, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '9a2ca651b6d98ee67491b1462408ddf6ced5ce830573040fb03c1672104bbb4f', '2026-04-16 18:18:52'),
(187, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '481f341adef22c260c549226c5f9a96eee586b2c72648d32134b8f1f10c9d215', '2026-04-16 18:18:52'),
(188, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cadd00eda34dc7f74f25b71ea7e92ed82d44bf87a297fb91818f1fafc3cf02fa', '2026-04-15 18:18:52'),
(189, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dedb1f840a6d7ff6585fa051e8098d70f7a177b717495564a90f83a9ee2631cc', '2026-04-15 18:18:52'),
(190, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '94e78554d1cc523e29242811e05bf43c37563e5001e40c0c7853a157cc324cce', '2026-04-15 18:18:52'),
(191, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a6ab0877e4af4c773bde3209d3f64518dc7a9ebeddb9b4f8a49a8446befae2a6', '2026-04-15 18:18:52'),
(192, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd1efc6ecdc8fe1eecbd9873eac38df76311439bf00ee5affe1078047ed8bacca', '2026-04-15 18:18:52'),
(193, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c5b3500634e5f45d48621616ce683c02375f15b61e958510b8027ce84c302439', '2026-04-15 18:18:52'),
(194, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a95cb4c3b0607874bd0e75e7b015d73ee34aa53b7c5790d4f146573c4ba51826', '2026-04-15 18:18:52'),
(195, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '55b94e4e5af7f5985c754fe12ff3b9677a353e97b2e78b20a8894e6603aae0f4', '2026-04-15 18:18:52'),
(196, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'de39dcecc1a259aa261386261a149df2ac50cf2d82b13e513a44dd7d58646e0d', '2026-04-15 18:18:52'),
(197, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '41d2502bce7c4867d05210f78b8dc569d4e23321247abef8374e50f2aa195c8c', '2026-04-15 18:18:52'),
(198, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f24cd3c0f37e08a5957c013567c5f40a385ad16f6bf68d16962889498433bb32', '2026-04-15 18:18:52'),
(199, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '105cd453e1a70c503a17b9751c4bc66edefd5163d18e5f1c91102f75c369567b', '2026-04-15 18:18:52'),
(200, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '970bd73570d62b0f995d485517c31a5346b270a173ed1e0f147d22261bebca52', '2026-04-15 18:18:52'),
(201, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '244a98970bf22e24c489b18628fd9d408df86b49ab97727ea2e2fbf2853d18ea', '2026-04-15 18:18:52'),
(202, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7829662697509a9ee6138f1449ae94b3f56c98364a5f5f6111740f8e5a836c99', '2026-04-15 18:18:52'),
(203, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '911b6fb40b9fddf2fcbeb4861b276e7b19a78dde44b65513feb3b71f84456e0d', '2026-04-15 18:18:52'),
(204, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8d34d470d47a287eefd855644cb3d94d91eb1ed1928780810f3f61821117624c', '2026-04-15 18:18:52'),
(205, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3b7a7efe4134714b309997a1f8e517fba3b984158165a4de145fc5a670dae8b0', '2026-04-15 18:18:52'),
(206, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '360ae65c1b76490c1f32f8336e18833906b4fd942389ad99c8d24c3b792e4477', '2026-04-15 18:18:52'),
(207, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '184b30b586656ac3ccfc41ae1e689325507c009f75b4761e91e07de647ade397', '2026-04-15 18:18:52'),
(208, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6219ef2d2e86b39de3e6aacfd7e01aeb5a7376feabb99e3975a5c3f2225d09e3', '2026-04-15 18:18:52'),
(209, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6867d57238e164d03d03e6cd784ca5b1afc5147519c29dc54eca5fb7aba8154e', '2026-04-15 18:18:52'),
(210, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '11a221b26653b21e4660097b6adf218a3138c3fb66e91a53f1da71bf9f262c63', '2026-04-15 18:18:52'),
(211, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6a94d1acba85d3b4fc8619ebe0046129ca546327a42f0f8b30624c6f9387cf4f', '2026-04-15 18:18:52'),
(212, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7f8455a9a9d3cdf4845ba283a911a9e8fb005b53c2860f09bdf04aa14cef6057', '2026-04-15 18:18:52'),
(213, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'af90af4d4807fff092506c5f8ae94e641b5d62f8074145f1b77a9de07f67f341', '2026-04-15 18:18:52'),
(214, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3c1c13984fbd0768f80cf394b64f065e4b166c38daf55cb840f33087c8c67355', '2026-04-15 18:18:52'),
(215, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5279d113307475c1aec08fc689160a918bb87f5fc8590eb21718d8b5e7ecc449', '2026-04-15 18:18:52'),
(216, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9abaecf53f6aba83a8994ecb09c79465a1c954c665c0ec93b43b73b25b889e56', '2026-04-15 18:18:52'),
(217, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '62fee454e9cb11f97b48243be4f6c34013d5afa7e9af8ba9f1780cc558f1aa71', '2026-04-15 18:18:52'),
(218, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1ddcaf1434321fcd5f7a9faf4335844f5422422e5837dbc4e3e02e82c15e97c5', '2026-04-14 18:18:52'),
(219, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8aa6b0247272b4f63c68bccb9f086b97815af303f8275c2adf0b72f1e120bcec', '2026-04-14 18:18:52'),
(220, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7eaac574ac3c29d9d95e0812e0f29b0f8474f737564693b12a9d6d8a231d9f60', '2026-04-14 18:18:52'),
(221, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dfddf681b1c91b3e772aeb3b1b864601b23a5457a498862f61f45034c9d0c736', '2026-04-14 18:18:52'),
(222, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '90694bd854cbab5d82094fd5bb7e5cb202f19c256e0a3ab56479cc897871c9fc', '2026-04-14 18:18:52'),
(223, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '816ac993f51540d0ee42347c4c793e6093276d5a30c3a55276fac9d33b78e9a1', '2026-04-14 18:18:52'),
(224, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '76d0b066bfed41515ba033df6568472d36b9600676ce9fc733f1e936a9754a61', '2026-04-14 18:18:52'),
(225, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8992c86a2ffc6228125efd6c0180680b11fc8c14a4f15c0197ab0bdee4a70641', '2026-04-14 18:18:52'),
(226, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5d1c06c2dfe7e12d7d40a69cb718d9db8714eb4889ec9d37d0193cce2d056852', '2026-04-14 18:18:52'),
(227, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '64d3e4868d2ae72d07bf326a371f706fdc89815484d776fb22339f5d74f81dfd', '2026-04-14 18:18:52'),
(228, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e192d4d0b2e92154bb1dbab15d0d94e08886696b678088dc546792664599976a', '2026-04-14 18:18:52'),
(229, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a8cc7b1ed79cb99baf0c451da5aa8dac7050c820553c67bd8371f00158426841', '2026-04-14 18:18:52'),
(230, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ade2ea9f27c1d9c175a22e4ed5d818ab074ea15f364794cfdb5e9ceb47098b03', '2026-04-14 18:18:52'),
(231, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e928ae52a1290229cf887a515652f504455f368f2ab82d9b038dda545d5889ca', '2026-04-14 18:18:52'),
(232, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cb832bb207239437055d3dd926eed6b8bc0a09a2e62c290c9b8a5f04e79f8427', '2026-04-14 18:18:52'),
(233, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '422e1f7495832a5aa2aee200479a9a3f4e0d7ec4fc0cd1cf503d29093f557572', '2026-04-14 18:18:52'),
(234, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4435aa356fce483e3ff7e66808255eb42e2f7894a072add9ffcde0045992c2d8', '2026-04-14 18:18:52'),
(235, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1508fdb9be534bd7c8f31703e048de36e77697a61d8965ab48d24d7d61b76bbe', '2026-04-14 18:18:52'),
(236, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '31c52511f402e3210b4cdc323d78352f745949d6fbb88b42704a66c65b4139c0', '2026-04-14 18:18:52'),
(237, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2f3c35109dcf47cdd51ba0b9a7226d5a40d754004aa9c7945b7d14d0db2f4970', '2026-04-14 18:18:52'),
(238, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1acb475ccef866063b1f29373b4aeb3af410df86d2b5fa0626effe7092c3ea5e', '2026-04-14 18:18:52'),
(239, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'df8b3b575b49787844d62d395fc29a28af09025a0b4c600fedaa2001a236eb5c', '2026-04-14 18:18:52'),
(240, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '72f7ad575b06344930294e8b6164705a8ecb1d082ca56bd3ec38ffb04516e4df', '2026-04-14 18:18:52'),
(241, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1296679e68b3e38b2a4c8290fe1350ba946e6a2ba9c6812b996345b4ceb09437', '2026-04-14 18:18:52'),
(242, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '746668df28cec10c53a52730ebea800fd2b87016042ac4cb84aefc80dad07439', '2026-04-14 18:18:52'),
(243, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0e9fc8131babdfc5d4f685df4c8bef34e77d8d76d3e1504da2d44be3d6146c3a', '2026-04-14 18:18:52'),
(244, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1b348e434f53535458204fa225f5187d2c2a91ecbb0f37d1c989c0bbb8fec371', '2026-04-14 18:18:52'),
(245, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd84b1ddb9f9aabbed4ae9636f69cf3f8283bed55705d3c9989595df2d2185c54', '2026-04-14 18:18:52'),
(246, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'f06639360cff46b8db14b3535ef07276448fa09a7174a5a6233d1ee170cf8caa', '2026-04-14 18:18:52'),
(247, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'bfb94358bdf5bba7298a8b825406de64ee9e99be27acdf3923ebf2ec8ec76f96', '2026-04-14 18:18:52'),
(248, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bc62b8ddcb7c2cf0d6612d268ae38d871661a912b18cd51a9bf17f8e1a758fff', '2026-04-13 18:18:52'),
(249, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '788a8908c789e774425cff8c0264a443fe66e9569c98f46f5731ea1e478e748e', '2026-04-13 18:18:52'),
(250, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c15aac7cf4fbd6b87a426e76b4bd6a9836ff23632d99d740f53c61caed18f2b5', '2026-04-13 18:18:52'),
(251, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e3bae5f9d91d87db2ebca80a9c2692e413efc905ba00cc02300faf568059e8b4', '2026-04-13 18:18:52'),
(252, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '85c7171425290d637039e3efb5fbdbac1874ed6fc3bf703da5bf4740ccf7befb', '2026-04-13 18:18:52'),
(253, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ae0b0ccf8d8adae76a4d11000d6b244f58c7ab8de6ea46c4f84a24572cc7b96f', '2026-04-13 18:18:52'),
(254, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f51300d2d9a46ed678f647ef32872eb102c7480b6c1818db6b22191ab2d5a34c', '2026-04-13 18:18:52'),
(255, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '51b381ceadbde180128ddd07e579387c0afa29e15302028cb154091f505b3e0c', '2026-04-13 18:18:52'),
(256, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '82dd803ff51ac0251b47bd653a519bfd62444e077de442ab77e1c5a0bce1aca8', '2026-04-13 18:18:52'),
(257, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6313ed448dcdb01872b5fdc52da490213d684c28f5a7ab374a99583450f38f4d', '2026-04-13 18:18:52'),
(258, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dbe9256c9dcc14214cf45e088748cc43792265d6eff72132e76d57bace657c96', '2026-04-13 18:18:52'),
(259, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dfc5aa6682e0967c68fac452a46391926cfbcc2caa22c15c9f627b7af92080a6', '2026-04-13 18:18:52'),
(260, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ce4b476f4592538cbfe5471a44b22fd91376e126833c824499161b4d93c87605', '2026-04-13 18:18:52'),
(261, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ab6ec15f87a88fb880ab9a983d40b7ef7c4122ab63e7245c5fc2596a83838cb2', '2026-04-13 18:18:52'),
(262, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8c5dd88972ee7687fd90c2ab5ba3dccfd92f64ad0b5dbff08b1d9788826e0ead', '2026-04-13 18:18:52'),
(263, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b2671555c16fb20a320f43d37170e1ff22b089a81fff14ddd396858f78b58942', '2026-04-13 18:18:52'),
(264, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b8128bf37b7876342c0f92b06d642bcab87fef4844cf07dbc8ba9ee5d6b92045', '2026-04-13 18:18:52'),
(265, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '64116d84d0983ca820bfc3ab72402c4f4a3f97a5a17bf6598323af1b812cff43', '2026-04-13 18:18:52'),
(266, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f627c51232d6e34c884e117c0045fdbfb1d7d26156c5c9b6e7691e00beae0e73', '2026-04-13 18:18:52'),
(267, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ce91b8c9b00ace12f22f25c0c081f879f0139cfb7947b23a944c33ebe327616a', '2026-04-13 18:18:52'),
(268, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '628621b132a8884512aaa7ef60f15de63a95931a49bff22a75909d80a30d0967', '2026-04-13 18:18:52'),
(269, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '108419fc14d96bd7dc429aae97c13dd1b72c65a990e63aa17cca003f1d3fa4f6', '2026-04-13 18:18:52'),
(270, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '30c28dee209f1156f203aeb4c873a8461195c43aff92704da6b5e25aeb171b2c', '2026-04-13 18:18:52'),
(271, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '69a75019d269331fa591b3cf1b561fb8f28dcfa62b2258df3a8f1cb17bd184a0', '2026-04-13 18:18:52'),
(272, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '93c5e5035b9250a6bb8fa7d0319f1d6c58f0d7f5cbb9954d665f04e03670688c', '2026-04-13 18:18:52'),
(273, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5b375d5d2e1477f1e45fd772d0bca7f0a6adbbc0029c84199560657694833504', '2026-04-13 18:18:52'),
(274, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '895ec5fedf2bd8575acf4088115e30f32e59ab69a5880ef20f920ad91fff984e', '2026-04-13 18:18:52'),
(275, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '15b5eb9635ac56ff988b7d207e5c5dc3d01e85ea0aebcd31b0c3fd880ead9d0d', '2026-04-13 18:18:52'),
(276, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4a2673002d60e75fcd1e3ca3ad52df0ca36bf6a11e30222812fbebc697ebe6a1', '2026-04-13 18:18:52'),
(277, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '87dd18c292ba7f2cd71788d94d14d9ea821454d12da57822e82c7acb48ebb0c9', '2026-04-13 18:18:52'),
(278, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7916b69d13e5a46b8a11bf1f41ac0c764379f96fbd891144cc6cf5dd89bb961c', '2026-04-13 18:18:52'),
(279, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0d5269c38d350a327ecfb7284947286fe03e8da939e2c96974442327e894d4b9', '2026-04-13 18:18:52'),
(280, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6615f9a039f06e72ea5b551ae730e4e3b4a4f14b7f78b6a16dbdf86db965c9e9', '2026-04-13 18:18:52'),
(281, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ba55171afa7de00e6bcb259bb50b22c686b0565e438cee250a3970852b68d7ee', '2026-04-13 18:18:52'),
(282, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dfab044268abbcf53717a21281928b974908734a8ac641cc0ad82ca004fcab29', '2026-04-13 18:18:52'),
(283, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f8e2ae31871475a5220e71f18ae6ea3d96913d5d9b4f0c59fc2bd51d2a8382f4', '2026-04-13 18:18:52'),
(284, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b352fe650b1ddfa66dc2b0c5f45faf87a97d9346494b6569fedbd7ee4b50a3ed', '2026-04-13 18:18:52'),
(285, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '31bebd0e5de98f36563488b3084d9251f31fe6f5a0c1f99b22534b9d184e93e3', '2026-04-13 18:18:52'),
(286, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9c449e43832dcba93e5e6265af4dec80f2b2a5b5acfd21784e98ec87bc93951f', '2026-04-13 18:18:52'),
(287, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5f51ed9a586cd25498594ef46dc8d9b259b53255e298350dbd91a9773ae36f03', '2026-04-13 18:18:52'),
(288, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '22dc8d06908ba37eb496f66c369d5e928518e5bfa74868dd943dca006c55016a', '2026-04-13 18:18:52'),
(289, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8573b33605c0fb6eeb8c0b6de0339d5ef592fb86dc53d4775e4726b7c66ea8a9', '2026-04-13 18:18:52'),
(290, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c8bd1cd7e3dca2a7e0f6be3d590690dd9d3aefe6b8ca3d9c945e49d4d0197fd1', '2026-04-13 18:18:52'),
(291, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1af6f1e230a895dfeaf6c191e06e46648d089da277dea613218e9b703c15c864', '2026-04-13 18:18:52'),
(292, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4664a78bafe6830237f1dd8e3443883fe1dd4f58028c50c46ffef28888b7b849', '2026-04-13 18:18:52'),
(293, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5b59482336250cb2b7a3cfc1883929e4b4cf39a5ff4b06afba9158ed74fbf48a', '2026-04-13 18:18:52'),
(294, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1b951ff90e3cc0e408560a716058ef2529f09e2c3a2eaf17d98bd0f83d0a6505', '2026-04-13 18:18:52'),
(295, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '082edde4755034140a823c04758ea93d89b995c2b2f433029f53f6f532ea0ea6', '2026-04-13 18:18:52'),
(296, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a677b9829230cef811be210d5e60aa81a7fe07fdc5c6e5d5f63ae960c7c7712a', '2026-04-13 18:18:52'),
(297, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9faacd1c4388b5ce870320a98812846edb7a31826627834f65b9524beb617f33', '2026-04-13 18:18:52'),
(298, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c1d378990a319245aa2b5510831e301af1d8d72c06684e259e5452be68b69c86', '2026-04-13 18:18:52'),
(299, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '41be5c052d1aba8eb2f5ff99450432da753798da7c2d38c1cdce9c5540f2694c', '2026-04-13 18:18:52'),
(300, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7ddbbadc60a1c7b4f62f2b6b74e273c518b21d5c5590555ebc9774b832c0c078', '2026-04-13 18:18:52'),
(301, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8fae31a83d94957dba6957a434b1eee02f7606492ad54dbfa9b77f9601e0f1ee', '2026-04-13 18:18:52'),
(302, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ee94bfce6d9e277326a99bf92f8a6022e864ea70314820ebf4f946da6b971e99', '2026-04-13 18:18:52'),
(303, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '15b5a81e31ff81500709c157bef2a626806136d86737fe9a3dfa65534ddfcce2', '2026-04-13 18:18:52'),
(304, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4b74bb641e89458ebed21f416765d24db5d0d4a3df5eb1463529f49e00d17d4a', '2026-04-13 18:18:52'),
(305, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4b6f96ccafe9ae403decdfa01fac1804f7a6a30c9f674cdebbdbc3b1c5d4775f', '2026-04-13 18:18:52'),
(306, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '05952a82f55e15394f8f85c04dc9002cabd50dbe0841267a3c29057594bbdffe', '2026-04-13 18:18:52'),
(307, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '61824abf37a85d7fe07c720c497c8f180b25adf2482f0baa6f801cdb0789f5b7', '2026-04-13 18:18:52'),
(308, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '9f8bd8b42d16f219031a324774e9ab42396d7d436190fab05e73aba0f6e2a339', '2026-04-13 18:18:52'),
(309, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'ac712fc96881714178a9696e9b206fad73eedf5d408d481c635e6cea6799f52a', '2026-04-13 18:18:52'),
(310, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c2c95ad9a1bda13099f604b28ab40bb1bb36e161694624cc3e860d8ddcc04812', '2026-04-12 18:18:52'),
(311, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd8826fb0d8e3391c3a3a55e982412327fb091b93c53f740258e386f49a7d0ce5', '2026-04-12 18:18:52'),
(312, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6e1fda59136ccb9ac84b73caebf3df7d05237065e38e2daeb1bb5464fcbf8704', '2026-04-12 18:18:52'),
(313, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1608507e016a2ec3e8a5e9e93fc59a56a7f3eb56739abfe0e13a57fe6ef47ce2', '2026-04-12 18:18:52'),
(314, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'da479f75662e68dcad80e71bc3f2bcfb19b5d48ff3e96d4de8b320aef09658ff', '2026-04-12 18:18:52'),
(315, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dc64b23507fd36bf53853a01ef5c1f8eff40fb251a665e7088e13a79832d7f32', '2026-04-12 18:18:52'),
(316, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ec72e176cfafef46ddfdf26b140a4a9e9851e12d76bbdfc6e784e7e0ccca3347', '2026-04-12 18:18:52'),
(317, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f4c323eda22d9ff4a225fd5b7f99123739ffd6935ae938aa8a631203b581548c', '2026-04-12 18:18:52'),
(318, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3ff820dc2dad94191e3f5c7deeb8a3afb9f29c57e8710520d1fe7dbfb6b71877', '2026-04-12 18:18:52'),
(319, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7165bc806d1e7afb597c1bc8bc62d4097009c67e435072f06ee9329744ee7b05', '2026-04-12 18:18:52'),
(320, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7e8a84aa2ed6e635ccf659ed049704e6f9703020245346736c53320a24630ba5', '2026-04-12 18:18:52'),
(321, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b1858f86117c8c1de107821d7e878f300d15a6ecf066322ab66e862c69ad2c7d', '2026-04-12 18:18:52'),
(322, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '57da42be66dd432380efc9f9bbbf7d937cd1ed201d456f2a04ff52e96d18e8aa', '2026-04-12 18:18:52'),
(323, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ffce900b1b7ca4cc9f4cf8b44bb836670dff7b9d54f4170c706d48e37937f38e', '2026-04-12 18:18:52'),
(324, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1a8baaa06e0a5fa1d5e8971f96b66dc3d15a8e474c7884f5ec5b47656400791e', '2026-04-12 18:18:52'),
(325, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'f239e59fb49cc2c08eca38275a2172e67890516af2268c36fcc30d4df6f5344a', '2026-04-12 18:18:52'),
(326, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b65e02d75438e3d0107db35d9631daa92a3d8848cff8ff39ecf9a97bbdc5cd07', '2026-04-11 18:18:52'),
(327, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2ecc29a98bfd658c4917b472b24dd8ff24a2f72df9b53ba04961b80a5514abc0', '2026-04-11 18:18:52'),
(328, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '34c7599453a2e34e04a719a8471bbd29b1d60a628808c898ad0c113c56c05633', '2026-04-11 18:18:52'),
(329, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9f7bfe209591349f6d2297e139f2f796358569f8f6ca3d16cd5175b5c4119e5e', '2026-04-11 18:18:52'),
(330, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '259d11a3768e0b5923f1408067109a4e2449e479fe7abc2c17e394915dae3d2c', '2026-04-11 18:18:52'),
(331, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '17704950c59c805f50563fbbd94673c76635b7440e16ee06add6af3e5d8746a5', '2026-04-11 18:18:52'),
(332, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0874e538350df34449ff012ae9de36ea109c08d83b486114c171c00e16160cc6', '2026-04-11 18:18:52'),
(333, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '942c30be0e7c176efcdabc8fc8862955b24370443cfde1b3413a197a2d954c9b', '2026-04-11 18:18:52'),
(334, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '799b5c223d065a7fbcb845ab148d1481ce24bdb67e6cd3b6f9ee7777c64f8a20', '2026-04-11 18:18:52'),
(335, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2d38cfd63478eca4be23985a08fca6bf7aa5f122881416993936742d6dfb1491', '2026-04-11 18:18:52'),
(336, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '49f920bd3d013692084fa4ac4fcf4e8774c485bc10845d7a50f6d7ed8bd750a5', '2026-04-11 18:18:52'),
(337, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '893cf33127740ad756e0812955e23a50de298a924964d864af42b7499a5f70cd', '2026-04-11 18:18:52'),
(338, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a0a0305bff6623e3edfda85a0955ccb9c76c940d65d7adae0dba5d0900dd72e4', '2026-04-11 18:18:52'),
(339, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8307c14351d88c6c103a593cd17e4e33a6ee9dd68f1e402e622c5ee6ffad2fb5', '2026-04-11 18:18:52'),
(340, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '59b27e0c529b0e10285f634fd45413cba6d47d8813c15786847be8af27e4607c', '2026-04-11 18:18:52'),
(341, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'baaf0f1232cfa583e8bfe04a82ef433d8e6876b83c299941acf295dc172fca69', '2026-04-11 18:18:52'),
(342, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '731333c34d9c9c87fef886ae6ef11f6204cba1f711696f65e1afc382feaebacd', '2026-04-11 18:18:52'),
(343, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1481133dfbbf8687e809f13e86704b7e99454b372cd1b5f0ac3dfbc2bc43b211', '2026-04-11 18:18:52'),
(344, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7e94fe1579260ea08b3b3f0209d0466ac7ecfad0d3e37319814539c2d79331f8', '2026-04-11 18:18:52'),
(345, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1a10f3e6b5a9f0b193ea9cd1a8a8d2f2443624288d36e869eb5f965291b15d78', '2026-04-11 18:18:52'),
(346, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd339f65eb6252bbfb23ac17a888d3e75d0a66d46d6e404926e1d5eab344d4db1', '2026-04-11 18:18:52'),
(347, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b8bc096fa3db4a8a967a745d857b62bf4b44ece8f33a2f5ef79088315146ffbd', '2026-04-11 18:18:52'),
(348, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2a9c97fc71a16a8ec344990bf0088b8919f721b7c8df88d76f1e65aa3d27f6f4', '2026-04-11 18:18:52'),
(349, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4c3a9b86ef5be88bb659dfd176376a227a5c31bdf4af6f18a7c1b86fb3fc7133', '2026-04-11 18:18:52'),
(350, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '63c5cf354e1f3817007c3849eba0d43204cef8067e2086f0786e05975a308196', '2026-04-11 18:18:52'),
(351, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e66ea3ae54b8cb2c6ba36c1df688fbad6cfc90d9bcdbed67fd1d1e42a997a02d', '2026-04-11 18:18:52'),
(352, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0a3ef3a20c05ff83087f830a1eb8182cc5e0977b0278768c879cf6e375fa3616', '2026-04-11 18:18:52'),
(353, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '733ea997572de75928c1b3d4d12a44d0d8c1c92220d7767ab4501ef4f92d4c85', '2026-04-11 18:18:52'),
(354, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a5276f8de4d2510f80fdef57c0d45eb3623ce754a5bae0e3c2dfb1c32e85fcff', '2026-04-11 18:18:52'),
(355, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8edd54147cc4bac44b4e172ae2bd303ff6b19687bc12859841ed5818bc522f9d', '2026-04-11 18:18:52'),
(356, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b026c7f77e699bf43318b6f4bfff41d9738ee331c688ef03d1581af28ea7ecb9', '2026-04-11 18:18:52'),
(357, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd152da71cbf48429b0064cd3773bbf611f436b5172188e002f3291b4c98d0285', '2026-04-11 18:18:52'),
(358, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '278344d28ad8622d9294436d9c670b065ea75a4df8230df847d2714a0907afb7', '2026-04-11 18:18:52'),
(359, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cfffb86b24eeba876a026a7b88a10545d0dc4a1e24aa5f53cc513d29f8a81d35', '2026-04-11 18:18:52'),
(360, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '983844bf41f3a34faffe9dce49c5106516416e5d21d9c3de1345df9d9f0570dd', '2026-04-11 18:18:52'),
(361, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '51b706d6cfe90e3a84b0119a697b3b9a6d50ec49d8e213135a4073342538e1f5', '2026-04-11 18:18:52'),
(362, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '50761e8371f912bd8bb945b8a492fd48d93632e61c24a2814747cee94d7f66a1', '2026-04-11 18:18:52'),
(363, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '428f53e279d4298b6d4c83191d2cd77d4e637f53cb68688cd3ec14d5ba0d4ad9', '2026-04-11 18:18:52'),
(364, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '436c096e73681a28da48efb1d34e64489c2f980b9da06843035ddef89d8f379e', '2026-04-11 18:18:52'),
(365, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c5fbb2412358b387ab04a970a9a34a1e8cb8d48793113e057e5cd14c22207b3a', '2026-04-11 18:18:52'),
(366, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4c5c022f33541d315ef1c85f35856a979b1d2df0567d86bf8412ee6d46fa5812', '2026-04-11 18:18:52'),
(367, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'd4f16b035f733fe501dfe8ec3d6a2b1169781330edd4cf791c4e06a205795152', '2026-04-11 18:18:52'),
(368, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '7103ee8b968a1a7bb70beaa090ec2c3b96bba9e3d105e6f60da2abbdd41339e1', '2026-04-11 18:18:52'),
(369, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '07a866d182b93cfe253b397fee49f9f048c62fcd7216772fde55e923d9ef91d9', '2026-04-10 18:18:52'),
(370, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1e2d6d3672b7405a6238f84b07378dcde4b0af0b9357273f969b2a2fcc49a8d4', '2026-04-10 18:18:52'),
(371, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5042146e51634c40344624d44fff97e666683b78010a782cbe14ae397456879b', '2026-04-10 18:18:52'),
(372, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1765d31cec5e72ecb34ec23c999af0e1d24e163e1df62c67e24a25460bfe6cf3', '2026-04-10 18:18:52'),
(373, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '51bc345bec6d6314d4330eb36bab5fc08dfea12c2b100bdb835cb3d1eae97990', '2026-04-10 18:18:52'),
(374, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '146ad7504813f6b2fefc4247678ccb0c206004579e5dc95f911ea80f00739e19', '2026-04-10 18:18:52'),
(375, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f939cf4f36121115074b9a43bc17df02a235078d5a6175b30b2f99cf4f7218f1', '2026-04-10 18:18:52'),
(376, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '36af5a44079e3573c748ea9144789a8d6b87cb5dfb156928e7f245ccb3ddf0b2', '2026-04-10 18:18:52'),
(377, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bd523410e6cfa0b1f6abaea1ac9b6a483c980babb8cc47749188f2893a451950', '2026-04-10 18:18:52'),
(378, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '44fc08788798b685140073483995cc67fd07707933f367b8ee33dcf05f7b6e5d', '2026-04-10 18:18:52'),
(379, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '968f445bd7f32cd48cedc0b31edebd56d9387e9022e332760f6e2cad877475c5', '2026-04-10 18:18:52'),
(380, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6e476b173f056ea2bbaf35627c4273d9fd4237c639b23210ffcd96085275c3a7', '2026-04-10 18:18:52'),
(381, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c2f51eaf5a14b6b5ebaf252f982a32dbd248f8ddcc787a646245c738175961a6', '2026-04-10 18:18:52'),
(382, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b297fced3843c7c69dc54221c6434ca0696b5075628bd1df17a2ef7bb0b8e648', '2026-04-10 18:18:52'),
(383, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5d40a6dea2a3f0d5f6132650c72911a93216aa42032590585c0617b0626dd7f8', '2026-04-10 18:18:52'),
(384, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1b1120ab9b5e97e44e20e1f23ea279f167c8332384b981a7861f03e88cd0774f', '2026-04-10 18:18:52'),
(385, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd867d828f4b14f829e81861f954dd68fe4a36d39de0cc4d5699d8181211b4e5a', '2026-04-10 18:18:52'),
(386, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6e33b72ff8ed09de49d24278dda6c08b0803558f3ec9e7505345f4c7f521d7ab', '2026-04-10 18:18:52'),
(387, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '789903b1a1501cf79acebbecb5301e53fe01288f150757845677c9c823d4d39f', '2026-04-10 18:18:52'),
(388, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ae687adb94d513591f522c9981004f2552fa3fe9c70d5c08704804d2eb69b257', '2026-04-10 18:18:52'),
(389, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '09738a27d1df0da2c1dd10384ba4f850169efe0bf28513fa684dd8f757b9f07e', '2026-04-10 18:18:52'),
(390, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6da06c0acd069d436aff4341ad31957b9febf137a0c95342e82ee114ba0d5dbb', '2026-04-10 18:18:52'),
(391, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a7d091f9135d328fc528fe4ebde5229bdc1a39652fec19507cc7d82b0247d95c', '2026-04-10 18:18:52'),
(392, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '99d280e3a03b6b014b2610daf856bde28ca87bbea80c40fe77d04402799dae8a', '2026-04-10 18:18:52'),
(393, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4dfae62b965e7efd49a4be0de88fd32eccb23f74126eb3bcfe8ccd063bca0ca3', '2026-04-10 18:18:52'),
(394, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bb35f35041d5b5b2ea3db6a1f14fbd42a86f402529cbed1c7571a3e0ff7261f5', '2026-04-10 18:18:52'),
(395, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f16c1a2cb27684ca16811eda7c85652ce1a7e9a11fe964a4e09ffd1ff3b3e4ac', '2026-04-10 18:18:52'),
(396, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '39bf20780b0119f941274235056a6cae04d21f0c313bee4c024dcf80c5039601', '2026-04-10 18:18:52'),
(397, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '99f24277330c42fbdfa18fa0d1023986e1d8b53dd46c909964b74935b732efdf', '2026-04-10 18:18:52'),
(398, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a228fd84e7994a0dff590de4512956081fe59e532cd34f21490227f0d5ddd907', '2026-04-10 18:18:52'),
(399, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '66a97c46e4b6c83487e9733ed184c995c2058c1896128ff0788dc0c6c8bf81ac', '2026-04-10 18:18:52'),
(400, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd3bacf1e6559b71b8ad6198ba151f427dd8c46da354b6b35efb5962e7c421538', '2026-04-10 18:18:52'),
(401, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fc5e0c25a0ab359074a46efed72238620f35039468c1a7a38473645a3701203d', '2026-04-10 18:18:52'),
(402, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'b709f3a7bdd0194b94c852abdac73749ffea70757636303f6f0ae8a2ef6fc070', '2026-04-10 18:18:52'),
(403, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '5f0db5b4f137158750fc187498d57428e9ad22e5692b6b7d8c7fdfec36476773', '2026-04-10 18:18:52'),
(404, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b7479d57d693b0244cce9723a6699d121522e96d8ad102ecb59d834aeb640231', '2026-04-09 18:18:52'),
(405, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '434d364390142a00e00d118d07f9656cb05cb0d93a6eecaa4db4798c0e45bc39', '2026-04-09 18:18:52'),
(406, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e563a5e2ab5ec7fbaaacbad44d3e43510e29bebc7c1ebefa927592eacdeec7a9', '2026-04-09 18:18:52'),
(407, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a98d10491618c9e845d951882fa4e4e0f79c4d70e580ca18858a8a7215701fab', '2026-04-09 18:18:52'),
(408, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ded2b8665247f3238f38e14de099c86b5f2c0be07ff796bf97cb1e7147d98fe4', '2026-04-09 18:18:52'),
(409, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1ec2c28a625ce242c76a7d098a603868c27706b145957a1dc95fd080d7a9ef4e', '2026-04-09 18:18:52'),
(410, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ffcf637cb9b08bf862f64c92e63f868cc48a9298012d1a63eb7cc629d9adedc7', '2026-04-09 18:18:52'),
(411, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8fac70335aa064abe0b50e40c53b9d2244c9dcea56b6bea32e9072d864b8b3a8', '2026-04-09 18:18:52'),
(412, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '24e88eec9adb960541799b370e5b0f563ebd9b2c9ce246ac439ee731c4b11140', '2026-04-09 18:18:52'),
(413, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cfd1c7902dc18de5fbcbefd731c42bde51627b693fe88be04125869fc5962598', '2026-04-09 18:18:52'),
(414, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3e8b121b3aa3056b94b0b4cd09deb9708ea9e996a9e550f82c28af59421cc920', '2026-04-09 18:18:52'),
(415, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e40c600f30f2c13d58a7c82836c06844feb2a4e7d52e8527cf2b12f84a9821ec', '2026-04-09 18:18:52'),
(416, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '01711821263eac11fa75479ffcc996f7264e65305fb791e769cb50fa86019744', '2026-04-09 18:18:52'),
(417, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '039c4f4a4cc7d5715507e6820f2d0f7091cf38d240c7361ea54d219b95b3c6a5', '2026-04-09 18:18:52'),
(418, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f771761685ab6da38654f1109728002894f47d877f603fa68bdd098a5ab6e774', '2026-04-09 18:18:52'),
(419, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'baf9498f21f378be6ddcafff93447905b0772a14c2bf2cb37bef5afc325cac42', '2026-04-09 18:18:52'),
(420, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '896d54304d538fb1367b5e9dcc89a261da256a24bc6882906f73986be58ca991', '2026-04-09 18:18:52'),
(421, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1b2b5a05f02361839555ba1c173b4875a90ea9f4ca4c56949e2f5fb0815ea571', '2026-04-09 18:18:52'),
(422, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3bfc86d577893513b6d58f29faabf1b3217cd5d767a29acb48e40703b436b360', '2026-04-09 18:18:52'),
(423, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3acf5e293d70e7c3519ba82b898db9cc99039a81913dfc9260059a361044d759', '2026-04-09 18:18:52'),
(424, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd9652f0fa672c3d4bc40f50c90f1569d2a8c570bf483ae4a0506bcd235dd6de6', '2026-04-09 18:18:52'),
(425, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'af0ae3bcf563bee6b40f81d5edc65f477ed1fa91df4d69c2fe4798796c073811', '2026-04-09 18:18:52'),
(426, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '46144e91fd5358571d0e9208760f756c2821c702530a0d3a2a6bd39c62b79c8b', '2026-04-09 18:18:52'),
(427, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7b3c6c7e28a2aab9a00ce8b03ef6b5c174b0b3adf18cdd4e04866be25557bf67', '2026-04-09 18:18:52'),
(428, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '79acf78f209130edf0f0b42054ee7fd49952bdb5289897dc533534fda8942559', '2026-04-09 18:18:52'),
(429, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'beaa774041cf31f284817456dbdf7cb23cfe2587c558c5e6f9501c2909026969', '2026-04-09 18:18:52'),
(430, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '7135533ab0f43342d09b2c7afbaedfd76ebe9b8255675c5a57dde8668902054b', '2026-04-09 18:18:52'),
(431, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a4837fadb8077e871135a441c2e91cdbbb47416bf5d04ab1ab1578fa2f568203', '2026-04-08 18:18:52'),
(432, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6709299fa89ff7efc2053b4f10a12423eba4d46f14acda18aeb344782c7549e3', '2026-04-08 18:18:52'),
(433, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '02d61e5bb036899cf2976efeed3a09adb1c5194d3ed72d70e1928e7c99446ede', '2026-04-08 18:18:52'),
(434, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7aae023431b53d3a05c6b7baa1163f990ba55b1b50979f16ab4ee644253d7a9d', '2026-04-08 18:18:52'),
(435, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '20c23c98ea5fe650f55c5caf077e9e88d014d6624ecc638f1b32bb2fc17aeb9d', '2026-04-08 18:18:52'),
(436, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a48819bdb422d69fdff4608b8f91b48bc8651e6015a77ff6f83550bdd4e77568', '2026-04-08 18:18:52'),
(437, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '770cceb2e97909850e29fc7ebc3b0a678b82711ba01af08902fcf35d21af5210', '2026-04-08 18:18:52'),
(438, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '86247abca657207bb6145602eb658f1fca5f30454ba26cd79442261209e3e02f', '2026-04-08 18:18:52'),
(439, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2d77e5e2ee3bd0cb5eb3ab0fa3ff4d06a7afe6c35b49017b3ffbb2097f97253e', '2026-04-08 18:18:52'),
(440, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '27c72bef47fec07eb652e7d36448ce15499776b4e36f8d9908bc1ff4e20637f5', '2026-04-08 18:18:52'),
(441, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a42d40a548b52363064a4bd20c4a0838c8943ebacd726586ce2e1ea93b00c202', '2026-04-08 18:18:52'),
(442, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8525c3bb70ca9e56762d4a24bb4c8761180865575a3e1edcb880bf43a9fc6127', '2026-04-08 18:18:52'),
(443, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bbce937101f07dda1759394bb9b8212b081074107883ba8d0255fa754935a93c', '2026-04-08 18:18:52'),
(444, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '00bd7d3c21f169c3b196b092108543bea47f159f1efd3c47ef35affb4be4f614', '2026-04-08 18:18:52'),
(445, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c3ec2e76a62936ee61fafc1fb5cc6fdd87ff657e169a38069b385ad27e672fcc', '2026-04-08 18:18:52'),
(446, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c5f2e11fa5014384fe78d0f47a280f98efc8256ebfb4c2e67bebed41b07d37c9', '2026-04-08 18:18:52'),
(447, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7d510322f1db1004526878b7a6fb9f8c564e152af0ff64a79fa97617fc32ead0', '2026-04-08 18:18:52'),
(448, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '705766e891892637484b1a67455d4ba90f3fd168a9b8f4f3b510e2cb3c6fde11', '2026-04-08 18:18:52'),
(449, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '71b369d5035bc53f07037acc33661cb8f5ee53bbd16e586c6adf043935d59b00', '2026-04-08 18:18:52'),
(450, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'da782859c2d46899930cbfd032817803c846249bb6235cdf835039a11c689082', '2026-04-08 18:18:52'),
(451, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5f5a919bb1f0325b8aafe7693dce6640c9478a67411f67f23d684d7b8b2092c3', '2026-04-08 18:18:52'),
(452, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '428be5afbc7eb12d88a2ec2c33a96806241de46687cbb9d5c53961b0b2900759', '2026-04-08 18:18:52'),
(453, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '907e74c31a6f605dce30e77436c5b8fc80bd06a3aef6f67f5fa94b091c34b324', '2026-04-08 18:18:52'),
(454, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '682df2993832b3b7fe9aa6f668df8907532d7114535c930d58c820ccddd3deb1', '2026-04-08 18:18:52'),
(455, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f566b74795d66683177471eae1038f17363a592e44d0546a71b096b900eab131', '2026-04-08 18:18:52'),
(456, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9659ff86ebeb04a0cafd223a336ddc73f31d4a95bdac2a7a02975dc6602c75b6', '2026-04-08 18:18:52'),
(457, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6a20d9b695f7fe0b667b6141f070aa3a34e1ad22f1341f54bf57d7c1ae8728ff', '2026-04-08 18:18:52'),
(458, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3613eb8b3828ee161fbb8508ce03457e28e9cf6ab1538953c424fe74fdde41e3', '2026-04-08 18:18:52'),
(459, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '086549b7605e8ba23cb695cdaf69d2056c4c4c91455a9d9d86a9ca4389e9ecdf', '2026-04-08 18:18:52'),
(460, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0b8b3182e7c6b4e98e65ff2a47d731b43845ce5820cf25e2177f16355a1f3e23', '2026-04-08 18:18:52'),
(461, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a3c191ed0064bf420219fff3eefb5cb1245b6fa509c93010209aaa03d0539f63', '2026-04-08 18:18:52'),
(462, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c483c952a8f91dbc0e86e5c5559d8e31aa984c0c2be52e3886b1522b98858e02', '2026-04-08 18:18:52'),
(463, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '354252255f6837eb35543ce7fd480d21a9e813cf9f99928b2c9fc44e1d2f8a8d', '2026-04-08 18:18:52'),
(464, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'efa0f1b761fbafd5580a161b3d492d75a02f5443aa3ebc6b835e2bb69e932711', '2026-04-08 18:18:52'),
(465, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'daec93e4b37112595d0e4affe9aedac0f060f9c2700ccfe553b895ea244992de', '2026-04-08 18:18:52'),
(466, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fb76decaf56db53d29af3b7c802e5aad0ea16f386acbe5d214350b51a6b84f04', '2026-04-08 18:18:52'),
(467, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ebc54975b030064fe7349b6cf8a70ddca634f5da7e01391d65a32a08d6cf0417', '2026-04-08 18:18:52'),
(468, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c7e1ec5cc54e7811ca53001db372eb2145698670657e683d10d18c97250788ef', '2026-04-08 18:18:52'),
(469, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '47a488679b85d089beb4bec87d0e37c3c35af0354ad83870e5835f7ebe54e81e', '2026-04-08 18:18:52'),
(470, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '556efa06680ce64cf599ab350d5def19e25406fbe873aeac686c98956feee9e2', '2026-04-08 18:18:52'),
(471, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '29e840fc9ee52f92b3a83342a6a3b98ba44380fefa698f4e1a13df2c6578ce21', '2026-04-08 18:18:52'),
(472, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b195ef3688d7f2d6643e0dee071e264d549e2cbc86580e6dd932c2cb9759463e', '2026-04-08 18:18:52'),
(473, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '3e063ae6560d8ca54e8c2c4486c5d002d5c495637b4a54ab24226cfda8ede3c8', '2026-04-08 18:18:52'),
(474, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '66ae31e2092802d9a820e3f8aa89638dd8265587163105bc7cfccd3e92aa3ccf', '2026-04-08 18:18:52'),
(475, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '09b6c9af2a849a81640d9855b7eb8daa6bc62511383bb8d6de92a37550d1e7a3', '2026-04-08 18:18:52'),
(476, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f9788e4de33a605810c6ca2c4ba28ba0dad4e6f9cceb3a5572d65f57e3a316de', '2026-04-08 18:18:52'),
(477, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'f514eb78a5c6f2f79b03aefdba36226385e8401b270beb3923c10b53fa8a08e5', '2026-04-08 18:18:52'),
(478, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8f408967076abcbbb23dab5de9f64327b7eb1ec9fb3a04ed4d0aec03ceedacea', '2026-04-08 18:18:52'),
(479, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '84242090fda32dd007c922fbb68fd8c3b535a4b4c13e84fea4b26bcd9a93ba54', '2026-04-08 18:18:52'),
(480, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2a8aebef1d11b1821d8abeb6e253554a0e3a54495c9b1879688162f50b55e6db', '2026-04-08 18:18:52'),
(481, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9f755c4ad8eddae1cc83a99be99951c9b058d873ef6357a5296fefd3f6cfcd3e', '2026-04-08 18:18:52'),
(482, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b7e641b33e08ac6b5ba5a16b083eff5784ab416087e47265acf27a85e65cc96e', '2026-04-08 18:18:52'),
(483, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '94c16c169692827a8c8f697a2b5e81a33d4ef0f7f826e8172588786bfa66d456', '2026-04-08 18:18:52'),
(484, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '2c4d84a3d8f029593848b6fef68e97cfcc3764b1043d0c19e9c4b9680fb9ad4d', '2026-04-08 18:18:52'),
(485, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c9e1f40a33fea7f485fda0cddbce18fc0f67da1747d9f165d5d660d449712b35', '2026-04-07 18:18:52'),
(486, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '70fa4b42fad6ede8732a1bc25c2f0aa7697b42cf3e9cfe9bc1dca8dd79e77f10', '2026-04-07 18:18:52'),
(487, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '61ded131d654938f1d30eafa40bed7c52c01ca3f0867ae0ac2df9eb02a72564f', '2026-04-07 18:18:52'),
(488, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd013b23f7492f1aade0f9f614827a57042df59610d5f1efe408bcaf4f595a4e9', '2026-04-07 18:18:52'),
(489, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '21ef33d17a2a113f1332d9b99846c94001b8c569b85c3561d94716e50bfd7078', '2026-04-07 18:18:52'),
(490, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0ee71babf049e4c764381679d3497bc7687d24a00088171884a74e0521d8be9c', '2026-04-07 18:18:52'),
(491, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '7741a4c29331a10e10efedfb377b00223339620f98b8feb277bd1a323ed76885', '2026-04-07 18:18:52'),
(492, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6529c836cafdce603aa7fceb86c8e5d981a2d15caf6fd78bebdf8bca57bfd790', '2026-04-07 18:18:52'),
(493, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1e6963bdcb621577e0ed4a1095c4c40568d46055e102bf670a2afed4d6dcc0c3', '2026-04-07 18:18:52'),
(494, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '86d746780737fd265f7ed692a0805908671d7181a760e0142b7d8fb0439f3ebd', '2026-04-07 18:18:52'),
(495, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0d8b9eaee692af4035af42b93bc574f53f21f76b3e9a21bbe7ab925d7af8a925', '2026-04-07 18:18:52'),
(496, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c4786cdf0f7667aa1e7333a160383e3e4ca794c0e114d453cc89e115a04ce20a', '2026-04-07 18:18:52'),
(497, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '727855e68d6caece34583237b9dc0d05a9012be850f0aed590d97590a17dd998', '2026-04-07 18:18:52'),
(498, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e1b3b33fceb38df23845357e40bf3d5ff90e0e16988bf9b1e7d6ac9020d48b53', '2026-04-07 18:18:52'),
(499, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '760a2376545d4797d4995c6a520d41f5405dfd1196d7075d10efc0c652065d70', '2026-04-07 18:18:52'),
(500, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd609802d29ff98cc3c0990ffe3af0c5237ed2080e5f5bf6383bafcd2092e3ad2', '2026-04-07 18:18:52'),
(501, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '330f1863832f9389041baf119d37b1e3513553705c4c008a1ffbd33cc2a76b6b', '2026-04-07 18:18:52'),
(502, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '78bf875d019e180eeecec84c0dbf18f1cef05ad54afd6c258846aee08d8d1961', '2026-04-07 18:18:52'),
(503, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b51ac0688c0cb9d5f6da098a2f7d8501eeda9e925f0f6a7002601676c1794c07', '2026-04-07 18:18:52'),
(504, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '21ef590d8a958437199b41d4c9045e36fa10fa9014e6da33fc71aaa04205c35e', '2026-04-07 18:18:52'),
(505, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ce8522b5260327ef696cf01d0321fe1c82090458efc675746058e645968cf1b2', '2026-04-07 18:18:52'),
(506, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '329e84a2d5f579e0dd27cf6c4e374613ac98b72c8c7c6aee7a58a5bdabd8a976', '2026-04-07 18:18:52'),
(507, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cf7934626aa13ed6a43d5605aa899533d14e643b7477e9ce631449208d4a4c53', '2026-04-07 18:18:52'),
(508, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '33839777546274491eabdbe26a659e462ce21f5c20cd411bd02a960ede5dc799', '2026-04-07 18:18:52'),
(509, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dd75cc495d354767518b53134d6194756f1a93a9087e392f0542130d4f6de44d', '2026-04-07 18:18:52'),
(510, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '853fa3bc0e85b78dda68a77164d3512abca97a6732c18d947491dab09ddf600b', '2026-04-07 18:18:52'),
(511, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '327c86cf5d6841cffec2f590aeeabe11c9e16b5c550ce4ab67a3583d8d488f2b', '2026-04-07 18:18:52'),
(512, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4b47687e87ace12faf03cdd55469e2c6678b86d0a7e134b1c39447d69bca78b5', '2026-04-07 18:18:52'),
(513, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', '2c09d3e3fd87a03638a6d2cd5554f855ecc7552b11e1fb6da9e46c6e104250c2', '2026-04-07 18:18:52'),
(514, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '52c151b996d0bcfbf9c1f5549a953fcbe825785ac91117f80c89b8d7df0d8e5e', '2026-04-06 18:18:52'),
(515, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e8227ffb8b96a3e77a14c44c5c514761dcee8a078ea662ded29c370e175a3e0d', '2026-04-06 18:18:52'),
(516, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '54012f626d7b51ab2f4751cab0b0c598e703f5ac8f0d8ea9efc83e8e9b5e18d9', '2026-04-06 18:18:52'),
(517, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '520b5d1d98d7b7ff6f9064e63ebcfd9980c36f623334146ecf94140014312184', '2026-04-06 18:18:52'),
(518, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1215c44f396c8e8dfa452c204a101b8f782a6cb64703603996052ec95aa8e56b', '2026-04-06 18:18:52'),
(519, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '52ebd12c491217e5abed8814fe2aa471fb475948db57df6450c30f7395d0978b', '2026-04-06 18:18:52'),
(520, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '40819a5592056336464eb559afc9549cba42ccaf25052bdda784aedf1f9fc3a6', '2026-04-06 18:18:52'),
(521, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '090703c5f8c5693c5a2069c4affe32fa150d58e4eb5b646e37ffdad8055c9767', '2026-04-06 18:18:52'),
(522, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4b86bb84932658bd690644dac405f2d90d5669de893ac166720191fd29d8d06f', '2026-04-06 18:18:52'),
(523, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b4977181de332daf25d1b598b2ebe119279afe2c825ec56d6019de26fb40b6b3', '2026-04-06 18:18:52'),
(524, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5dfcda6ce0ced37e52d5c9c711fa824ee98c87dca0e28f000c42fefd27af558f', '2026-04-06 18:18:52'),
(525, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b37458932626a31887639be97873d6ff71f9c6f4f22a609242e7c996de7f2ccf', '2026-04-06 18:18:52'),
(526, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e44c142682bf247268fabf777afbc4d6085d084b4331121150de33769b07edf7', '2026-04-06 18:18:52'),
(527, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a5d77d7f3e7a1ff75d33c4a746592bed13b8f3c35c2371984bd49d37c8bb0fa1', '2026-04-06 18:18:52'),
(528, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'b7f5a264affd82f24d11bd4c824f5fa69a52a484a11d47dc608efd0f8638c70e', '2026-04-06 18:18:52'),
(529, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '81da38d4b1bcca80beaa36b05b40d1016812fa71e1c707092c599bb71a3319e1', '2026-04-06 18:18:52'),
(530, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1ffdf6e72671c7b309c4f92e49a853780020880cbd75c73baa208d983c219deb', '2026-04-06 18:18:52'),
(531, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a728c965cb4024d4c72b9f99dcd993a54354dc16872706a7ac5dca2da99ce392', '2026-04-06 18:18:52'),
(532, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8a9188fd36b8bb531e0f9947c46881fc2cd5a8ce707b25be1da16c13ce1a23b9', '2026-04-06 18:18:52'),
(533, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cb9d3812bb50a10a99b310dd3f7a84b46b4accd5c6109534b44643cd310b2133', '2026-04-06 18:18:52'),
(534, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'db46f6c6a2424e37b5b1ffaddbab7312a77fcf18e5ee487b4c619ba41fec0c9e', '2026-04-06 18:18:52'),
(535, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6ac048f1986941dde2f8ecd9a70bf766323ea08e6840cd22f0c074bd61d07aa9', '2026-04-06 18:18:52'),
(536, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'dcfad08b0d7800e748286fd470a75ce30c36f0c03c98bcace7d20989cb8a535a', '2026-04-06 18:18:52'),
(537, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'c0da44ba218eb3fc3914b65f22eb006cfc13358dc6f44a8869dd861c88933043', '2026-04-06 18:18:52'),
(538, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8446e79af25fd55f163ac4f738f61e8e8f931125330bb7715e0c7acc1df88cb5', '2026-04-06 18:18:52'),
(539, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bc8a9069d49234d5d04a4e85d19dafa06a3facb415776a4f5f48a5f716bc7fff', '2026-04-06 18:18:52'),
(540, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '594ac91be1efb7bee1aba829357e3cc08b5b794c757f87c6b1aceca78fec5812', '2026-04-06 18:18:52'),
(541, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0f51dc6bdc0efaea735f19f38c6e170ce4f9e9a76ab9bfcd40c1300c7cf14ed7', '2026-04-06 18:18:52'),
(542, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'e5017228792f04d5bba624edcf7b0129224d1d920eb5d8cf27025ffac6bee099', '2026-04-06 18:18:52'),
(543, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1283db17b55d957a0978fb30ee2d153c80aed04169b9a71d784c33447292185e', '2026-04-06 18:18:52'),
(544, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'd39b430c710ff63e0fd1bbaa47df504b1cfe2da338ade38ae28ee8d16750f1ce', '2026-04-06 18:18:52'),
(545, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ea9990119d209e52fb67601e561e1fcb9faa2fe5bae9f983082f50a07303011b', '2026-04-06 18:18:52'),
(546, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'abecab92953e9b48daeb4b2280595946ac34be21aaf9c9cc205e2898b30a558f', '2026-04-06 18:18:52'),
(547, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ec35c3af9e7c9fadf1d502d506ed50cfa5cb63aded4f3f8ad9beb828b2a4e2ad', '2026-04-06 18:18:52'),
(548, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0c3a0c52d07a3bced638136fd0a2d9c423f85260a33fdca3adc544717239b15c', '2026-04-06 18:18:52'),
(549, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'a9016b4963e058401c63fa4a363975f1fe0f9e99a66e2444b6143ae2cba0ada4', '2026-04-06 18:18:52'),
(550, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '38dc38f5b69d0b081c752ca3ca73d1634458aee2bcb54d6b35ca3f8a3724e110', '2026-04-06 18:18:52'),
(551, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9476c2b668f71475d3e631ec0c4152bc16c1e13685d7dd8b63cdb9c6139d0985', '2026-04-06 18:18:52'),
(552, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'bb806d8cec6cf1c940800d90441020f976e866196ff2fac01a49ad36039f7a4a', '2026-04-06 18:18:52'),
(553, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4aa753d0cbeaa92d5c0f4bec3dd97e2abdd7c5c6632e5544cdca6dbe2f2b021a', '2026-04-06 18:18:52'),
(554, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '84341ebda6151e68a937c3cb0c10356a79819f67b9862f752084c2bda3ef32c2', '2026-04-06 18:18:52'),
(555, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '58fc8ee0a0eb6ed93a54bd40615733dd3c9eba787c26cd5d25c5509a56ff659d', '2026-04-06 18:18:52'),
(556, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'fabb0c26c2994e7c6d9501ea84062923d7f14d5411924749673c2cbcd1cf522d', '2026-04-06 18:18:52'),
(557, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'fb1ca125339d09f7ca2460274838098df90ae901f0a2e3af838bea9d3271e88e', '2026-04-06 18:18:52'),
(558, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '706aa0fed84caec0e7c95c51c19a5ce7571f494b018d3f139718a52ddebb8bdb', '2026-04-05 18:18:52'),
(559, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '556476f641e9e08bad495501115f15d3b6415bab87dbadf123ab9d3219170e1e', '2026-04-05 18:18:52'),
(560, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0ef7cb1f811fd317b03df958581bb7f16b94f6df148582f13ec818e04cca0f36', '2026-04-05 18:18:52'),
(561, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '842ef16815dd8485678c5317df2f0f861f13c425769c75fbecab24f519f1ac87', '2026-04-05 18:18:52'),
(562, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '97f7175ade99b3b634eb92345d5a378c8e820d578847dfe4fb2b1271cec1c44f', '2026-04-05 18:18:52'),
(563, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '934ffac187bb0bca978f2296c874c334d0f5cbb9d7fb37af4f9ba3464702087e', '2026-04-05 18:18:52'),
(564, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cce89458b815d291bb27e2720e8a08aabd1ee8f5da86be9c32ca95e84fc19f70', '2026-04-05 18:18:52'),
(565, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '2cc0555643723260c3d320ea1ea2618bb8dc8cca05b0b7aef8293ffbddece5d1', '2026-04-05 18:18:52'),
(566, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '4e7d5c91f5713e5af710d56826f4c6ea519c29063e2f9485d48e2c2f1afc0225', '2026-04-05 18:18:52'),
(567, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ef872ee9b2e2eebbff10729a51a2665b80932caf78f3b50114180f81241aa717', '2026-04-05 18:18:52'),
(568, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '723f5247b48302314fba1f28eba1637d5bdd90fc61ce23cbfe09acd2bee657a3', '2026-04-05 18:18:52'),
(569, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '371dc9bac1902f7d9093689ba3c9a470e2e7018d15a7f0d295d4b9a9ee81fc6a', '2026-04-05 18:18:52'),
(570, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8d0dcf789eb6b4101df2537c52d4d1b301e4ea5c927251a59d3625680acd1bc5', '2026-04-05 18:18:52'),
(571, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ba83d777aee9e1c816bff26226e20ef7f4098143800de0418d77079b29fba65d', '2026-04-05 18:18:52'),
(572, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '55ddac752588ff7f84fdf042456f82f099506796a2e934a646fc8f503f017f8f', '2026-04-05 18:18:52'),
(573, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '48684acb7b4d183fd8d501ca6d9620f19a08d22e246f9d3188ef6368a68f39a4', '2026-04-05 18:18:52'),
(574, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0ddecdab59e0eb69c5ded3ce82fb6daffbe72921bb2f93f3f958ec8c71b009da', '2026-04-05 18:18:52'),
(575, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '45fd791313d8ece34dae7e304e16de059d6e9d8656427b12870f2fb84ac1c42e', '2026-04-05 18:18:52'),
(576, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '0a155d6ee30cf9b34250cc8f8b40e8f134f25b49f3b83af6375a081834798557', '2026-04-05 18:18:52'),
(577, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cb1f27bf43fb4289e5f10503a11795ef4c258a7f92a5300763ac32f0bbe996b4', '2026-04-05 18:18:52'),
(578, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'ef46b130806f80f22e57144a4061397352c0e1ac59987485588f2c4c5fc01f5c', '2026-04-05 18:18:52'),
(579, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6ed1f3d0a92a1d83c5fdbbd85690d721dab02ccfa8ed6ac67286658a8a1c9f50', '2026-04-05 18:18:52'),
(580, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8dee8d5cdeb9b62014843721ea67f19025be226e8f36fa6457ec69c5e8c36f54', '2026-04-05 18:18:52'),
(581, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '45c5a0e3d407e5f7b691b70aa65d037621c299a5932833939f1451853bdac412', '2026-04-05 18:18:52'),
(582, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '1f5612b05aa2c92067a519442055beaaf38d791fd7e0915848aff85e6b22e84c', '2026-04-05 18:18:52'),
(583, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '5ab8fa1d42cdc68e5ec1fa1a746137b6944d331e0c2ccc7abca35b9380532d06', '2026-04-05 18:18:52'),
(584, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', 'cf7c6b1e68a87c5057d0231a8d33ffa81f8970615b38bc01b1250fe582f3eac1', '2026-04-05 18:18:52'),
(585, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '44983cd92796f36e323c7d0f8a0711b94defc63038bff0bb70b4361b6a70ad57', '2026-04-05 18:18:52'),
(586, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '9c9d1faf84ceaade0d6a65c77c08b57e6bd4ea177c2190af1b736a3ed5c52191', '2026-04-05 18:18:52'),
(587, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8298d62509366e8b9abf89ddb17509ffd1c91d9183ca3fd3572533421f6d50e3', '2026-04-05 18:18:52'),
(588, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '6ac815ba6b3b520e802d75d505dbe40398439e129eff79ff915aecb3e6efefba', '2026-04-05 18:18:52'),
(589, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '824ae217ad8173141fcfcdc7874a44a0383b409090e40ce9c8c04a80968593df', '2026-04-05 18:18:52'),
(590, '09b30f00-769b-487c-8405-5beef0d45611', 'view', '', '8ffe17771cbe8b90fd4ce8bf22e49c564494c87d4e5d7589085cd4d4ce962c7d', '2026-04-05 18:18:52'),
(591, '09b30f00-769b-487c-8405-5beef0d45611', 'contact', '', 'f67d1c4f14d4829b1e1c86973cb8e34f7b2d795387ccb166194896a4ca859076', '2026-04-05 18:18:52'),
(592, 'fbfa0891-eb92-44e0-ab07-bae385e033d2', 'view', 'desktop', '1bec4bd771f685bac9cf2eb26f1f9c5ae7bbb8cb667221b17e77fb6d8e10aab3', '2026-04-18 14:19:21'),
(593, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-18 16:41:18'),
(594, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'view', 'desktop', 'c8dc43e04049f96051637dc8bb179e86e2786eddab0d18073de081f5ecefecb7', '2026-04-18 16:42:04'),
(595, '244e5b5f-b9fa-4bc3-97c4-e5453a4f06b8', 'view', 'desktop', 'ddb044ca30b115e1ccd11031f61ef4c0c759c11e489e2463d1c496c4034089b3', '2026-04-18 16:42:56'),
(596, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'view', 'desktop', 'c8dc43e04049f96051637dc8bb179e86e2786eddab0d18073de081f5ecefecb7', '2026-04-18 20:20:55'),
(597, '0eac42c3-0f5b-48ba-ae98-50766ee8b404', 'view', 'desktop', 'b4897c276409ba03fe864c67edd342f41ce566123e841c14b08148d04102bed1', '2026-04-18 20:26:30'),
(598, '244e5b5f-b9fa-4bc3-97c4-e5453a4f06b8', 'view', 'desktop', 'ddb044ca30b115e1ccd11031f61ef4c0c759c11e489e2463d1c496c4034089b3', '2026-04-18 20:26:36'),
(599, '3e949f37-f3eb-4ecc-81bc-5678e3680d1c', 'view', 'desktop', '0a58696a27531e657f23c452f26d98fbe287f4c0e313bac4356cc6fb9f20bbc6', '2026-04-18 20:27:00'),
(600, '27dc1ad0-edb0-4eee-929a-7937d4c61702', 'view', 'desktop', 'f5b28dff0a0999a383319582fc44a87a1419ddaee8e17e7bd6261d49a438a436', '2026-04-18 20:28:55'),
(601, '8eb51b74-62f9-4f92-82db-734ca31d3bee', 'view', 'desktop', 'd217524bd792e5ada26edb951b742d1d8165f3b8f1d11523757ed12135ac2f6a', '2026-04-18 20:56:13'),
(602, '569c4c11-e716-4640-9a76-7560609ff6d0', 'view', 'desktop', '8dfe5d208bfff74a3bde73ad76a4de2c87929acd8dec034d6a72407c043cdb8a', '2026-04-18 20:56:38'),
(603, 'e1ad5041-9335-4584-969d-1e916266fb72', 'view', 'desktop', '44aef15b5b9bfb29dc50053f22f2356a9e361a34c0ca3eae6f521931c0315749', '2026-04-18 21:01:19'),
(604, '2219708f-52f8-4847-a4c8-d0caa90adc49', 'view', 'desktop', 'f0ad88890d588a34f6d259bb035cc3221099c27d9179a44541c102e18ca2d9b5', '2026-04-18 21:06:08'),
(605, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-18 21:17:23'),
(606, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-18 21:17:33'),
(607, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-18 22:18:53'),
(608, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-18 22:31:14'),
(609, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-18 23:00:38'),
(610, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-18 23:00:46'),
(611, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:01:01'),
(612, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:07:49'),
(613, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-18 23:08:11'),
(614, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:08:33'),
(615, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:10:55'),
(616, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:13:52'),
(617, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:15:46'),
(618, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:24:53'),
(619, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-18 23:28:45'),
(620, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-18 23:39:31'),
(621, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-18 23:39:52'),
(622, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', '', 'desktop', 'bc8137553b8ffe6238e5869e43ddad75273994af873b326276dd37fd38d37490', '2026-04-18 23:40:04'),
(623, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'mobile-app', '6d046c40ca0951d326eab3b3068d8c21568faac86c76e491bc404116255c65af', '2026-04-19 01:28:52'),
(624, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'contact', 'mobile-app', 'a81f7cc8362d28fd42a6bbea64bbe210646abc5ea099d0f60ee0831c6bbcac02', '2026-04-19 01:29:05'),
(625, '0c6f7761-c6a7-4016-af51-92fe6e13bcfa', 'view', 'mobile-app', '4b950920432f9f3dc36352ca0c3985c4d25836985f169a7197a49557a55896dd', '2026-04-19 01:29:22'),
(626, '2219708f-52f8-4847-a4c8-d0caa90adc49', 'contact', 'mobile-app', 'c157634e6f82e642f4c2ba6fe1109d95122d2504f82147e727507e8149ac736e', '2026-04-19 01:32:52'),
(627, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-19 02:49:31'),
(628, '3e949f37-f3eb-4ecc-81bc-5678e3680d1c', 'view', 'desktop', '0a58696a27531e657f23c452f26d98fbe287f4c0e313bac4356cc6fb9f20bbc6', '2026-04-19 03:16:28'),
(629, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-19 03:30:43'),
(630, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'contact', 'desktop', '814349c05859ea37271d737eb023f6c2b004e5c626b972a59b1abd01911e823b', '2026-04-19 03:35:21'),
(631, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'contact', 'desktop', '814349c05859ea37271d737eb023f6c2b004e5c626b972a59b1abd01911e823b', '2026-04-19 03:37:00'),
(632, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-21 00:47:24'),
(633, '7fa30acb-aa4a-452d-8a60-6113ae20a4d7', 'view', 'desktop', 'f8d060c1f883be1e852c34cdf5d70fc6dc728bd7b335b731bb25853f8123e5fa', '2026-04-21 00:47:43'),
(634, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 00:50:36'),
(635, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:10:17'),
(636, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:11:02'),
(637, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:12:01'),
(638, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:23:05'),
(639, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:31:37'),
(640, '602c14e4-f61c-4a6d-92bb-f1489d963f94', 'view', 'desktop', 'beaa4fbc1e49304c8367d6afd218db9c9afcf44e27675f85f71de24f16614958', '2026-04-21 01:49:18'),
(641, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:49:21'),
(642, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 01:55:40'),
(643, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 02:04:26'),
(644, '602c14e4-f61c-4a6d-92bb-f1489d963f94', '', 'desktop', '7196a8b0bb0332b0089024ef1bbe387754fd7052ec5521364d58f322bce371e8', '2026-04-21 02:10:47');


-- Structure for notifications
CREATE TABLE `notifications` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `type` enum('info','success','warning','error') DEFAULT 'info',
  `related_id` varchar(255) DEFAULT NULL,
  `is_read` tinyint(1) DEFAULT 0,
  `link` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `idx_user_read` (`user_id`,`is_read`)
) ENGINE=InnoDB AUTO_INCREMENT=26 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for notifications
INSERT INTO notifications (id, user_id, title, message, type, related_id, is_read, link, created_at) VALUES
(1, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "zzxcv" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-17 21:46:51'),
(2, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "qwer" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-17 21:46:55'),
(3, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:46:58'),
(4, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:47:01'),
(5, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:51:50'),
(6, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:51:54'),
(7, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:51:56'),
(8, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "qwer" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:51:59'),
(9, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "asdf" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:52:05'),
(10, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "Prueba 1" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:52:16'),
(11, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "Veterinaria el Recreo" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-17 21:52:23'),
(12, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '⚠️ Pauta Pausada', 'Tu anuncio "Veterinaria el Recreo" ha sido pausado. Revisa tus correos para más detalles.', 'warning', NULL, 1, '/dashboard/pautas', '2026-04-17 21:52:27'),
(13, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "Oferta especial" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-18 01:02:34'),
(14, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '❌ Pauta Rechazada', 'Tu anuncio "Veterinaria el Recreo" requiere correcciones: No cumple con las politicas de la plataforma, revisa el enunciado', 'error', NULL, 1, '/dashboard/pautas', '2026-04-18 01:10:04'),
(15, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "Oferta especial" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-18 01:16:35'),
(16, 'c4713855-20f3-4f5b-a157-d960f1008c4c', '🌟 ¡Pauta Aprobada!', 'Tu anuncio "Veterinaria el Recreo" ha pasado la revisión y ya es visible en KLICUS.', 'success', NULL, 1, '/dashboard/pautas', '2026-04-18 01:17:45'),
(17, 'gst_1776735096494', 'Nuevo mensaje de prueba', '🔔 Tienes una nueva oportunidad de negocio.', '', 'b3ea65ae-67d1-4a8a-adde-273605b1edb3', 0, NULL, '2026-04-21 01:56:39'),
(18, 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'Nuevo mensaje de Karina', 'hola', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 1, NULL, '2026-04-21 02:04:36'),
(19, 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'Nuevo mensaje de Karina', 'como esan', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 1, NULL, '2026-04-21 02:04:44'),
(20, 'gst_1776737031612', 'Nuevo mensaje de Alex Prueba', 'hola, bienvenida', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:05:39'),
(21, 'gst_1776737031612', 'Nuevo mensaje de Alex Prueba', 'sigues', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:10:11'),
(22, 'gst_1776737031612', 'Nuevo mensaje de Alex Prueba', 'coo estas', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:10:19'),
(23, 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'Nuevo mensaje de Karina', 'hola bien', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:10:24'),
(24, 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'Nuevo mensaje de Karina', 'u du', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:10:52'),
(25, 'c4713855-20f3-4f5b-a157-d960f1008c4c', 'Nuevo mensaje de Karina', 'como esta', '', 'c378024d-c11f-4bbf-a7a9-4eee65f13338', 0, NULL, '2026-04-21 02:10:54');


-- Structure for plan_configs
CREATE TABLE `plan_configs` (
  `plan_name` varchar(50) NOT NULL,
  `max_images` int(11) DEFAULT 2,
  `duration_days` int(11) DEFAULT 30,
  `is_featured` tinyint(1) DEFAULT 0,
  `badge_color` varchar(50) DEFAULT 'gray',
  PRIMARY KEY (`plan_name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for plan_configs
INSERT INTO plan_configs (plan_name, max_images, duration_days, is_featured, badge_color) VALUES
('Básico', 3, 365, 1, 'blue'),
('Gratis', 1, 365, 0, 'gray'),
('Premium', 5, 365, 1, 'amber');


-- Structure for profiles
CREATE TABLE `profiles` (
  `id` char(36) NOT NULL,
  `email` varchar(255) DEFAULT NULL,
  `full_name` varchar(255) DEFAULT NULL,
  `business_name` varchar(255) DEFAULT NULL,
  `phone` varchar(20) DEFAULT NULL,
  `avatar_url` text DEFAULT NULL,
  `role` varchar(20) DEFAULT 'client',
  `password_hash` varchar(255) DEFAULT NULL,
  `website` varchar(255) DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `bio` text DEFAULT NULL,
  `banner_url` text DEFAULT NULL,
  `social_links` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL CHECK (json_valid(`social_links`)),
  `plan_type` varchar(50) DEFAULT 'Gratis',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for profiles
INSERT INTO profiles (id, email, full_name, business_name, phone, avatar_url, role, password_hash, website, created_at, updated_at, bio, banner_url, social_links, plan_type) VALUES
('44bcac40-5c86-44d6-8cfd-44ae50574580', 'alexjuliosanchez@gmail.com', 'Alexander Julio', NULL, NULL, NULL, 'admin', '$2b$12$6UUkYSMYSaycnWc/q18unOkLIvgGo1nA2pnaXmLdPGRhjn1IFfP66', NULL, '2026-04-17 03:00:03', '2026-04-17 04:29:57', NULL, NULL, NULL, 'Premium'),
('77037021-69a2-46d0-b648-6ab51202059b', 'prueba@prueba.com', 'prueba', NULL, NULL, NULL, 'cliente', '$2b$12$qYaujjvoNys.UtpWtasI1uFvMKaqiatDEU6yvue1FcvhaaEu0vVO6', NULL, '2026-04-18 22:13:47', '2026-04-18 22:13:47', NULL, NULL, NULL, 'Gratis'),
('c4713855-20f3-4f5b-a157-d960f1008c4c', 'alex@prueba.com', 'Alex Prueba', '', NULL, NULL, 'anunciante', '$2b$12$bIiB3SXSOE5/0yY1ES968OswV2WU/yL.Zt3IiQL8emYILrI7Uo6Xq', NULL, '2026-04-17 15:41:03', '2026-04-18 00:53:03', NULL, NULL, NULL, 'Gratis');


-- Structure for roles
CREATE TABLE `roles` (
  `id` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `color` varchar(50) DEFAULT 'gray',
  `description` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for roles
INSERT INTO roles (id, name, color, description, created_at) VALUES
('admin', 'Administrador', '#FFD700', 'Poder total sobre la plataforma', '2026-04-17 04:17:00'),
('anunciante', 'Anunciante', '#F59E0B', 'Usuarios profesionales con capacidad de publicar', '2026-04-17 04:17:00'),
('cliente', 'Cliente', '#94A3B8', 'Usuario estándar de la red', '2026-04-17 04:17:00');


-- Structure for settings
CREATE TABLE `settings` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `setting_key` varchar(100) NOT NULL,
  `setting_value` text DEFAULT NULL,
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `setting_key` (`setting_key`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;


-- Data for settings
INSERT INTO settings (id, setting_key, setting_value, updated_at) VALUES
(1, 'manual_payments', '[{"id":"main-1","name":"Bancolombia / Nequi","type":"Ahorros","number":"313 532 8897","owner":"Alexander Julio","qr_enabled":false,"qr_image":"/assets/qr-pago-klicus.png","whatsapp_number":"573135328897","whatsapp_message":"¡Hola! He realizado el pago de mi pauta comercial. Adjunto el comprobante."}]', '2026-04-17 22:04:08');


-- Structure for user_fcm_tokens
CREATE TABLE `user_fcm_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `token` text NOT NULL,
  `device_type` varchar(50) DEFAULT NULL,
  `last_used` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_token` (`token`(255)),
  KEY `idx_user` (`user_id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;


-- Data for user_fcm_tokens
INSERT INTO user_fcm_tokens (id, user_id, token, device_type, last_used) VALUES
(1, '44bcac40-5c86-44d6-8cfd-44ae50574580', 'mock_fcm_token_for_testing_1t104', 'web_mock', '2026-04-18 21:42:53');


-- Structure for user_tokens
CREATE TABLE `user_tokens` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` varchar(255) NOT NULL,
  `token` text NOT NULL,
  `device_type` enum('android','ios','web') DEFAULT 'android',
  `last_seen` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `user_tokens_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `profiles` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

