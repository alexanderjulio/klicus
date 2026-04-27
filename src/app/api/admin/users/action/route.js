export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    
    // Security check
    if (!session || session.user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { action, targetUserId, value } = await req.json();

    if (!action || !targetUserId) {
      return NextResponse.json({ error: 'Faltan datos obligatorios' }, { status: 400 });
    }

    // Safety: Admin cannot delete themselves
    if (action === 'delete' && targetUserId === session.user.id) {
      return NextResponse.json({ error: 'No puedes eliminar tu propia cuenta administrativa.' }, { status: 403 });
    }

    switch (action) {
      case 'update_role':
        if (!value) return NextResponse.json({ error: 'Nuevo rol no proporcional' }, { status: 400 });
        await query('UPDATE profiles SET role = ? WHERE id = ?', [value, targetUserId]);
        return NextResponse.json({ success: true, message: 'Rol de usuario actualizado' });

      case 'promote_admin':
        await query('UPDATE profiles SET role = "admin" WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Usuario promovido a Administrador' });

      case 'promote_anunciante':
        await query('UPDATE profiles SET role = "anunciante" WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Usuario convertido en Anunciante' });

      case 'set_plan_gratis':
        await query('UPDATE profiles SET plan_type = "Gratis" WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Plan Cambiado a Gratis' });

      case 'set_plan_basico':
        await query('UPDATE profiles SET plan_type = "Básico" WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Plan Cambiado a Básico' });

      case 'set_plan_premium':
        await query('UPDATE profiles SET plan_type = "Premium" WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Plan Cambiado a Premium' });

      case 'delete':
        await query('DELETE FROM profiles WHERE id = ?', [targetUserId]);
        return NextResponse.json({ success: true, message: 'Usuario y sus datos eliminados con éxito' });

      default:
        return NextResponse.json({ error: 'Acción no válida' }, { status: 400 });
    }

  } catch (error) {
    console.error('Admin user action error:', error);
    return NextResponse.json({ error: 'Error procesando la acción' }, { status: 500 });
  }
}

