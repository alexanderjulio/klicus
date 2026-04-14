import NextAuth from 'next-auth';
import CredentialsProvider from 'next-auth/providers/credentials';
import { query } from '@/lib/db';
import bcrypt from 'bcryptjs';

export const authOptions = {
  providers: [
    CredentialsProvider({
      name: 'Credentials',
      credentials: {
        email: { label: "Email", type: "text" },
        password: { label: "Password", type: "password" }
      },
      async authorize(credentials) {
        if (!credentials?.email || !credentials?.password) return null;

        const users = await query(
          'SELECT * FROM profiles WHERE id IN (SELECT id FROM profiles WHERE id = ?) OR full_name = ? LIMIT 1', 
          [credentials.email, credentials.email] // This is simplified, usually we'd have a separate 'users' table with email
        );

        // Note: For this demo, we'll assume the user ID or a custom field is the email
        // Real implementation would use a join or dedicated auth table
        const user = users[0];

        if (user && await bcrypt.compare(credentials.password, user.password_hash)) {
          return {
            id: user.id,
            name: user.full_name,
            email: credentials.email,
            role: user.role
          };
        }
        return null;
      }
    })
  ],
  callbacks: {
    async jwt({ token, user }) {
      if (user) {
        token.role = user.role;
        token.id = user.id;
      }
      return token;
    },
    async session({ session, token }) {
      if (token) {
        session.user.role = token.role;
        session.user.id = token.id;
      }
      return session;
    }
  },
  pages: {
    signIn: '/login',
  },
  session: {
    strategy: 'jwt'
  }
};

const handler = NextAuth(authOptions);

export { handler as GET, handler as POST };
