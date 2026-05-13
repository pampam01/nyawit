import { Router } from 'express';
import {
  createDetection,
  getDetections,
  getDetectionById,
  deleteDetection,
} from '../controllers/detection.controller';
import { authMiddleware } from '../middleware/auth.middleware';

const router = Router();

router.use(authMiddleware);

router.post('/', createDetection);
router.get('/', getDetections);
router.get('/:id', getDetectionById);
router.delete('/:id', deleteDetection);

export default router;
