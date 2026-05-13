import jwt from 'jsonwebtoken';
import dotenv from 'dotenv';

dotenv.config();

const JWT_SECRET = process.env.JWT_SECRET || 'nyawit_super_secret_key';

export const signToken = (payload: object, expiresIn: jwt.SignOptions['expiresIn'] = '7d') => {
  return jwt.sign(payload, JWT_SECRET, { expiresIn } as jwt.SignOptions);
};

export const verifyToken = (token: string) => {
  return jwt.verify(token, JWT_SECRET);
};
