export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    let userRole = session?.user?.role?.toLowerCase();
    
    // Fallback if missing role in session
    if (!userRole && session?.user?.email) {
      const users = await query('SELECT role FROM profiles WHERE email = ? LIMIT 1', [session.user.email]);
      userRole = users[0]?.role?.toLowerCase();
    }

    if (userRole !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const settings = await query("SELECT * FROM settings WHERE setting_key = 'manual_payments'");
    let manualPayments = [];
    
    if (settings.length > 0) {
      manualPayments = JSON.parse(settings[0].setting_value || '[]');
    }

    return NextResponse.json({ manualPayments });
  } catch (error) {
    console.error('Admin Settings GET Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    let userRole = session?.user?.role?.toLowerCase();
    
    // Fallback if missing role in session
    if (!userRole && session?.user?.email) {
      const users = await query('SELECT role FROM profiles WHERE email = ? LIMIT 1', [session.user.email]);
      userRole = users[0]?.role?.toLowerCase();
    }

    if (userRole !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { manualPayments } = await req.json();

    if (!Array.isArray(manualPayments)) {
      return NextResponse.json({ error: 'Formato inválido: se espera un arreglo' }, { status: 400 });
    }

    await query(`
      INSERT INTO settings (setting_key, setting_value) 
      VALUES ('manual_payments', ?) 
      ON DUPLICATE KEY UPDATE setting_value = VALUES(setting_value)
    `, [JSON.stringify(manualPayments)]);

    return NextResponse.json({ success: true, message: 'Configuración guardada correctamente' });
  } catch (error) {
    console.error('Admin Settings POST Error:', error);
    return NextResponse.json({ error: 'Internal Server Error' }, { status: 500 });
  }
}

