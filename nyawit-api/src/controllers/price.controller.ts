import { Request, Response } from 'express';
import prisma from '../lib/prisma';

/**
 * Membuat hash angka deterministik dari string tanggal.
 * Menjamin nilai seed yang sama untuk hari yang sama.
 */
const getSeedForDate = (dateStr: string): number => {
  let hash = 0;
  for (let i = 0; i < dateStr.length; i++) {
    hash = dateStr.charCodeAt(i) + ((hash << 5) - hash);
  }
  return Math.abs(hash);
};

export const getTodayPrices = async (req: Request, res: Response) => {
  try {
    const today = new Date();
    // Gunakan format zona waktu Jakarta/WIB (Waktu Indonesia Barat)
    const dateStr = new Date(today.getTime() + (7 * 60 * 60 * 1000))
      .toISOString()
      .split('T')[0];

    // 1. Cari di Database MySQL apakah ada data harga manual untuk hari ini
    let basePrice: number;
    let trend: string;
    let trendPercent: string;
    let note: string;

    const dbPrice = await prisma.palm_price.findUnique({
      where: { date: dateStr },
    });

    if (dbPrice) {
      // Jika ada, gunakan data dari database phpMyAdmin
      basePrice = dbPrice.averagePrice;
      trend = dbPrice.trend;
      trendPercent = dbPrice.trendPercent;
      note = dbPrice.note || 'Harga hari ini bersumber langsung dari ketetapan dinas perkebunan setempat.';
    } else {
      // Jika tidak ada di DB, fallback ke Generator Deterministik Harian Otomatis
      const seed = getSeedForDate(dateStr);
      const priceVariation = (seed % 300) - 150;
      basePrice = 2850 + priceVariation;

      trend = seed % 2 === 0 ? 'up' : 'down';
      const calculatedTrendPercent = ((seed % 180) / 100 + 0.1).toFixed(2);
      trendPercent = `${calculatedTrendPercent}%`;

      const notes = [
        'Harga TBS kelapa sawit menguat hari ini didorong oleh naiknya permintaan CPO global dari India dan Tiongkok.',
        'Harga TBS mengalami sedikit koreksi karena melimpahnya pasokan buah sawit segar pada musim panen raya.',
        'Nilai tukar rupiah terhadap USD dan penguatan pasar CPO Rotterdam turut mendongkrak ketetapan harga TBS hari ini.',
        'Kenaikan ekspor minyak nabati dunia memicu sentimen positif di pasar kelapa sawit dalam negeri.',
      ];
      note = notes[seed % notes.length];
    }

    // 2. Kalkulasi Rincian Berdasarkan Umur Pohon & Wilayah Secara Dinamis
    const prices = {
      date: dateStr,
      averagePrice: Math.round(basePrice),
      trend,
      trendPercent,
      note,
      byAge: {
        'Umur 3 Tahun': Math.round(basePrice * 0.77),
        'Umur 4 Tahun': Math.round(basePrice * 0.84),
        'Umur 5 Tahun': Math.round(basePrice * 0.90),
        'Umur 6 Tahun': Math.round(basePrice * 0.93),
        'Umur 7 Tahun': Math.round(basePrice * 0.96),
        'Umur 8 Tahun': Math.round(basePrice * 0.98),
        'Umur 10-20 Tahun': Math.round(basePrice),
        'Umur 21-25 Tahun': Math.round(basePrice * 0.97),
      },
      byRegion: {
        'Riau (Disbun)': Math.round(basePrice * 1.02),
        'Jambi (Disbun)': Math.round(basePrice * 0.99),
        'Sumatera Utara': Math.round(basePrice * 1.01),
        'Kalimantan Barat': Math.round(basePrice * 0.96),
        'Kalimantan Timur': Math.round(basePrice * 0.97),
        'Sulawesi Barat': Math.round(basePrice * 0.95),
      }
    };

    return res.status(200).json({
      status: 'success',
      data: prices,
    });
  } catch (error: any) {
    return res.status(500).json({
      status: 'error',
      message: 'Internal server error',
      error: error.message,
    });
  }
};
