import { Request, Response } from 'express';
import bcrypt from 'bcryptjs';
import prisma from '../lib/prisma';
import { registerSchema, loginSchema, updateProfileSchema } from '../validators/auth.validator';
import { signToken } from '../lib/jwt';
import { saveBase64Image } from '../utils/file';

export const register = async (req: Request, res: Response) => {
  try {
    const data = registerSchema.parse(req.body);

    const existingUser = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (existingUser) {
      return res.status(400).json({ message: 'Email already exists' });
    }

    const hashedPassword = await bcrypt.hash(data.password, 10);

    const user = await prisma.user.create({
      data: {
        name: data.name,
        email: data.email,
        password: hashedPassword,
      },
    });

    const token = signToken({ id: user.id });

    // Remove password from response
    const { password, ...userWithoutPassword } = user;

    return res.status(201).json({
      message: 'Register berhasil',
      user: userWithoutPassword,
      token,
    });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ message: 'Validation error', errors: error.errors });
    }
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const login = async (req: Request, res: Response) => {
  try {
    const data = loginSchema.parse(req.body);

    const user = await prisma.user.findUnique({
      where: { email: data.email },
    });

    if (!user) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const isPasswordValid = await bcrypt.compare(data.password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({ message: 'Invalid email or password' });
    }

    const token = signToken({ id: user.id });

    const { password, ...userWithoutPassword } = user;

    return res.status(200).json({
      message: 'Login berhasil',
      user: userWithoutPassword,
      token,
    });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ message: 'Validation error', errors: error.errors });
    }
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const getMe = async (req: Request, res: Response) => {
  try {
    const user = req.user;
    if (!user) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const { password, ...userWithoutPassword } = user;

    return res.status(200).json({
      user: userWithoutPassword,
    });
  } catch (error: any) {
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const updateProfile = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const data = updateProfileSchema.parse(req.body);

    const updateData: any = {};
    if (data.name !== undefined) updateData.name = data.name;
    if (data.nickname !== undefined) updateData.nickname = data.nickname;
    if (data.photoProfile !== undefined) {
      if (data.photoProfile && !data.photoProfile.startsWith('preset_') && !data.photoProfile.startsWith('/uploads')) {
        updateData.photoProfile = saveBase64Image(data.photoProfile, 'profile');
      } else {
        updateData.photoProfile = data.photoProfile;
      }
    }
    if (data.password !== undefined) {
      updateData.password = await bcrypt.hash(data.password, 10);
    }

    const updatedUser = await prisma.user.update({
      where: { id: userId },
      data: updateData,
    });

    const { password, ...userWithoutPassword } = updatedUser;

    return res.status(200).json({
      message: 'Profil berhasil diperbarui',
      user: userWithoutPassword,
    });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ message: 'Validation error', errors: error.errors });
    }
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};
