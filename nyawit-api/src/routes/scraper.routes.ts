import { Router } from 'express';
import { getHargaSawitLive } from '../controllers/scraper.controller';

const router = Router();

// Endpoint publik agar bisa dites langsung via Postman / Browser tanpa auth token
router.get('/', getHargaSawitLive);

export default router;
