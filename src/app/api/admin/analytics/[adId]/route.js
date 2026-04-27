import { NextResponse } from 'next/server';

export const dynamic = 'force-dynamic';

export async function GET(req, { params }) {
  try {
    const { adId } = await params;
    return NextResponse.json({ success: true, message: 'Debug build pass', adId });
  } catch (error) {
    return NextResponse.json({ error: 'Fail' }, { status: 500 });
  }
}
