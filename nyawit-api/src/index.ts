import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import path from 'path';
import authRoutes from './routes/auth.routes';
import detectionRoutes from './routes/detection.routes';

dotenv.config();

const app = express();
const PORT = Number(process.env.PORT) || 8000;

app.use(cors());
app.use(express.json({ limit: '50mb' }));
app.use(express.urlencoded({ limit: '50mb', extended: true }));
app.use('/uploads', express.static(path.join(__dirname, '../uploads')));

// Health check
app.get('/health', (req, res) => {
  res.json({
    status: 'ok',
    app: 'nyawit-api'
  });
});

// Routes
app.use('/api/auth', authRoutes);
app.use('/api/detections', detectionRoutes);

// Error handling middleware (catch-all for unhandled errors)
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
  console.error(err.stack);
  res.status(500).json({ message: 'Internal server error', error: err.message });
});

app.listen(PORT, '0.0.0.0', () => {
  console.log(`Nyawit API running on http://0.0.0.0:${PORT}`);
});
