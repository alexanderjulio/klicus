export const dynamic = 'force-dynamic';
import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';
import { PROFILE_PLANS } from '@/config/plans';

export async function POST(req) {
  if (process.env.BUILD_MODE) return new Response(JSON.stringify({ build: true }), { status: 200, headers: { 'Content-Type': 'application/json' } });
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
        await query('UPDATE profiles SET plan_type = ? WHERE id = ?', [PROFILE_PLANS.FREE, targetUserId]);
        return NextResponse.json({ success: true, message: `Plan Cambiado a ${PROFILE_PLANS.FREE}` });

      case 'set_plan_basico':
        await query('UPDATE profiles SET plan_type = ? WHERE id = ?', [PROFILE_PLANS.BASIC, targetUserId]);
        return NextResponse.json({ success: true, message: `Plan Cambiado a ${PROFILE_PLANS.BASIC}` });

      case 'set_plan_premium':
        await query('UPDATE profiles SET plan_type = ? WHERE id = ?', [PROFILE_PLANS.PREMIUM, targetUserId]);
        return NextResponse.json({ success: true, message: `Plan Cambiado a ${PROFILE_PLANS.PREMIUM}` });

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

