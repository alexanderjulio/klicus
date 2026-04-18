import { query } from '@/lib/db';
import { NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth';

export async function GET() {
  try {
    const session = await getServerSession(authOptions);
    if (!session || session.user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const roles = await query('SELECT * FROM roles ORDER BY name ASC');
    return NextResponse.json({ roles });
  } catch (error) {
    return NextResponse.json({ error: 'Error fetching roles' }, { status: 500 });
  }
}

export async function POST(req) {
  try {
    const session = await getServerSession(authOptions);
    if (!session || session.user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { id, name, color, description } = await req.json();

    if (!id || !name) {
      return NextResponse.json({ error: 'ID y Nombre son obligatorios' }, { status: 400 });
    }

    await query(
      'INSERT INTO roles (id, name, color, description) VALUES (?, ?, ?, ?) ON DUPLICATE KEY UPDATE name=VALUES(name), color=VALUES(color), description=VALUES(description)',
      [id.toLowerCase().replace(/\s+/g, '_'), name, color, description]
    );

    return NextResponse.json({ success: true, message: 'Rol actualizado/creado' });
  } catch (error) {
    return NextResponse.json({ error: 'Error al procesar el rol' }, { status: 500 });
  }
}

export async function DELETE(req) {
  try {
    const session = await getServerSession(authOptions);
    if (!session || session.user.role !== 'admin') {
      return NextResponse.json({ error: 'No autorizado' }, { status: 401 });
    }

    const { searchParams } = new URL(req.url);
    const id = searchParams.get('id');

    if (['admin', 'anunciante', 'cliente'].includes(id)) {
      return NextResponse.json({ error: 'No puedes eliminar roles del sistema core' }, { status: 403 });
    }

    await query('DELETE FROM roles WHERE id = ?', [id]);
    return NextResponse.json({ success: true });
  } catch (error) {
    return NextResponse.json({ error: 'Error al eliminar el rol' }, { status: 500 });
  }
}
