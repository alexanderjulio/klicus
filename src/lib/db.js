/**
 * KLICUS Database Connector
 * Utilities for establishing connection and querying the local MySQL database.
 */

import mysql from 'mysql2/promise';

let pool;

/**
 * Singleton function to initialize and return the MySQL connection pool.
 * @returns {Promise<mysql.Pool>}
 */
export async function getDbConnection() {
  if (!pool) {
    pool = mysql.createPool({
      host: process.env.MYSQL_HOST || 'localhost',
      user: process.env.MYSQL_USER || 'root',
      password: process.env.MYSQL_PASSWORD || '',
      database: process.env.MYSQL_DATABASE || 'klicus_db',
      waitForConnections: true,
      connectionLimit: 10,
      queueLimit: 0
    });
  }
  return pool;
}

/**
 * Standard query wrapper for running SQL commands.
 * @param {string} sql - SQL query string
 * @param {Array} params - Sanitized parameters for the query
 * @returns {Promise<any>}
 */
export async function query(sql, params) {
  const db = await getDbConnection();
  const [results] = await db.execute(sql, params);
  return results;
}
