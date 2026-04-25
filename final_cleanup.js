import { query } from './src/lib/db.js';
import fs from 'fs';
import path from 'path';

async function finalCleanup() {
  console.log('🧹 [CLEANUP] Iniciando gran limpieza de seguridad...');
  try {
    // 1. Purgar notificaciones de prueba
    console.log('🗑️ Eliminando alertas de prueba...');
    await query("DELETE FROM notifications WHERE title LIKE '%prueba%' OR message LIKE '%prueba%'");
    
    // 2. Purgar mensajes de prueba
    console.log('🗑️ Eliminando mensajes de chat de prueba...');
    await query("DELETE FROM chat_messages WHERE content LIKE '%prueba%'");

    // 3. Eliminar scripts de simulación y auditoría
    const scripts = [
      'audit_notifications_table.js',
      'fix_notifications_table.js',
      'harden_db.js',
      'database_backup.js',
      'simulate_notification.js',
      'scratch_setup_guests.js'
    ];

    for (const script of scripts) {
      const p = path.join(process.cwd(), script);
      if (fs.existsSync(p)) {
        fs.unlinkSync(p);
        console.log(`♻️ Archivo eliminado: ${script}`);
      }
    }

    console.log('✅ [CLEANUP] Gran limpieza completada. Sistema KLICUS impecable.');
    process.exit(0);
  } catch (err) {
    console.error('❌ Error en la limpieza:', err.message);
    process.exit(1);
  }
}

finalCleanup();
