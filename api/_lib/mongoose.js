import mongoose from 'mongoose'

const MONGODB_URI = process.env.MONGODB_URI

if (!MONGODB_URI) {
  throw new Error('Missing MONGODB_URI environment variable')
}

// Reuse across hot reloads in dev / repeated function invocations
let cached = global._mongooseCached

if (!cached) {
  cached = global._mongooseCached = { conn: null, promise: null }
}

export async function connectToDatabase() {
  if (cached.conn) {
    return cached.conn
  }

  if (!cached.promise) {
    cached.promise = mongoose.connect(MONGODB_URI, {
      bufferCommands: false,
    })
  }

  cached.conn = await cached.promise
  console.log('Connected to MongoDB', process.env.MONGODB_URI);
  return cached.conn
}