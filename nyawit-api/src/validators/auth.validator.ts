import { z } from 'zod';

export const registerSchema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email format'),
  password: z.string().min(6, 'Password must be at least 6 characters'),
});

export const loginSchema = z.object({
  email: z.string().email('Invalid email format'),
  password: z.string().min(1, 'Password is required'),
});

export const updateProfileSchema = z.object({
  name: z.string().min(1, 'Name is required').optional(),
  nickname: z.string().nullable().optional(),
  password: z.string().min(6, 'Password must be at least 6 characters').optional(),
  photoProfile: z.string().nullable().optional(),
});
