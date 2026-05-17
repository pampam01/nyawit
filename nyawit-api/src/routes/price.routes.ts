import { Router } from 'express';
import { getTodayPrices } from '../controllers/price.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();

// Kita proteksi rutenya agar hanya pengguna terdaftar (memiliki JWT) yang bisa melihat
router.get('/today', authMiddleware, getTodayPrices);

export default router;
