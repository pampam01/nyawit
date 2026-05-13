import { z } from 'zod';

export const createDetectionSchema = z.object({
  total: z.number().int().min(0),
  dominantLabel: z.string().nullable().optional(),
  counts: z.record(z.string(), z.number().int()),
  detections: z.array(z.any()).nullable().optional(),
  imagePath: z.string().nullable().optional(),
});
