import { Request, Response } from 'express';
import axios from 'axios';

/**
 * Fungsi pembantu murni (Pure Helper Function) untuk mengambil data dari API SPKS
 * Anda bisa memakai fungsi ini di masa depan untuk ditanam ke sistem utama Anda!
 */
export const fetchHargaSawit = async () => {
  try {
    // Target langsung ke API resmi SPKS
    const apiUrl = "https://api.spks.or.id/api/public/tbs-prices/jambi";

    // Tembak API dengan menyamar sebagai browser asli menggunakan header dari hasil Inspect Element Anda
    const response = await axios.get(apiUrl, {
      headers: {
        "Accept": "application/json, text/plain, */*",
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/148.0.0.0 Safari/537.36",
        "Origin": "https://spks.or.id",
        "Referer": "https://spks.or.id/",
      },
    });

    const dataApi = response.data;

    // KARENA KITA SUDAH LIHAT ISI TAB "RESPONSE",
    // Mari kita parsing datanya secara premium dan rapi!
    const histories = dataApi?.data?.tbs_price_histories;
    if (histories && histories.length > 0) {
      // Ambil history indeks terakhir (yang paling baru ter-update)
      const latestHistory = histories[histories.length - 1];
      
      const rawAges = latestHistory.tbs_price_per_ages || [];
      const agesFormatted = rawAges.map((item: any) => ({
        usia_tanam: item.age,
        harga_per_kg: Math.round(parseFloat(item.price))
      }));

      // Cari harga rata-rata tertinggi (biasanya kelompok umur 10-20 tahun)
      const highestAgePrice = agesFormatted.find((a: any) => a.usia_tanam.includes('10-20'));
      const averagePrice = highestAgePrice 
        ? highestAgePrice.harga_per_kg 
        : Math.round(parseFloat(latestHistory.avg_sawit_price) || 0);

      return {
        provinsi: dataApi.data.province_name,
        slug: dataApi.data.slug,
        periode_mulai: latestHistory.start_period,
        periode_selesai: latestHistory.end_period,
        cpo_rata_rata: Math.round(parseFloat(latestHistory.avg_cpo_price) || 0),
        harga_rata_rata: averagePrice,
        harga_berdasarkan_umur: agesFormatted
      };
    }

    return null;
  } catch (error) {
    console.error("❌ Gagal mengambil data API SPKS:", error);
    return null;
  }
};

/**
 * Controller Rute Express (Express Route Handler)
 * Ini digunakan agar request dari Postman / Browser tidak gantung (hang)
 * dan mengembalikan respon JSON terformat dengan benar.
 */
export const getHargaSawitLive = async (req: Request, res: Response) => {
  try {
    const data = await fetchHargaSawit();
    
    if (!data) {
      return res.status(404).json({
        status: 'error',
        message: 'Gagal mengambil atau mem-parsing data dari API SPKS.'
      });
    }

    return res.status(200).json({
      status: 'success',
      source: "https://api.spks.or.id/api/public/tbs-prices/jambi",
      data: data
    });
  } catch (error: any) {
    return res.status(500).json({
      status: 'error',
      message: 'Internal server error saat mengambil harga live',
      error: error.message
    });
  }
};
