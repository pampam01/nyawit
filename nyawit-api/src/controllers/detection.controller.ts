import { Request, Response } from 'express';
import prisma from '../lib/prisma';
import { createDetectionSchema } from '../validators/detection.validator';
import { saveBase64Image } from '../utils/file';

export const createDetection = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const data = createDetectionSchema.parse(req.body);

    let savedImagePath = data.imagePath ?? null;
    if (savedImagePath && !savedImagePath.startsWith('/uploads')) {
      savedImagePath = saveBase64Image(savedImagePath, 'detection');
    }

    const detection = await prisma.detection.create({
      data: {
        userId,
        total: data.total,
        dominantLabel: data.dominantLabel,
        counts: data.counts,
        detections: data.detections ?? undefined,
        imagePath: savedImagePath,
      },
    });

    return res.status(201).json({
      message: 'Riwayat deteksi berhasil disimpan',
      detection,
    });
  } catch (error: any) {
    if (error.name === 'ZodError') {
      return res.status(400).json({ message: 'Validation error', errors: error.errors });
    }
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const getDetections = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const detections = await prisma.detection.findMany({
      where: { userId },
      orderBy: { createdAt: 'desc' },
    });

    return res.status(200).json({
      detections,
    });
  } catch (error: any) {
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const getDetectionById = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const { id } = req.params;
    const detectionId = parseInt(id);

    if (isNaN(detectionId)) {
      return res.status(400).json({ message: 'Invalid ID format' });
    }

    const detection = await prisma.detection.findUnique({
      where: { id: detectionId },
    });

    if (!detection) {
      return res.status(404).json({ message: 'Detection not found' });
    }

    if (detection.userId !== userId) {
      return res.status(404).json({ message: 'Detection not found' });
    }

    return res.status(200).json({
      detection,
    });
  } catch (error: any) {
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};

export const deleteDetection = async (req: Request, res: Response) => {
  try {
    const userId = req.user?.id;
    if (!userId) {
      return res.status(401).json({ message: 'Unauthorized' });
    }

    const { id } = req.params;
    const detectionId = parseInt(id);

    if (isNaN(detectionId)) {
      return res.status(400).json({ message: 'Invalid ID format' });
    }

    const detection = await prisma.detection.findUnique({
      where: { id: detectionId },
    });

    if (!detection) {
      return res.status(404).json({ message: 'Detection not found' });
    }

    if (detection.userId !== userId) {
      return res.status(404).json({ message: 'Detection not found' });
    }

    await prisma.detection.delete({
      where: { id: detectionId },
    });

    return res.status(200).json({
      message: 'Detection deleted successfully',
    });
  } catch (error: any) {
    return res.status(500).json({ message: 'Internal server error', error: error.message });
  }
};
