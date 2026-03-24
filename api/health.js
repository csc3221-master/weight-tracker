import mongoose, { mongo } from 'mongoose'
import { connectToDatabase } from './_lib/mongoose.js'

export default async function handler(req, res) {
  try {
    await connectToDatabase()
    const dbName = mongoose.connection.name;
    const host = mongoose.connection.host;
    res.status(200).json({
      ok: true,
      service: 'weight-tracker-api',
      db: 'connected',
      host: host,      
      dbName: dbName,
      timestamp: new Date().toISOString(),
    })
  } catch (error) {
    res.status(500).json({
      ok: false,
      service: 'weight-tracker-api',
      db: 'disconnected',
      error: error.message,
      timestamp: new Date().toISOString(),
    })
  }
}