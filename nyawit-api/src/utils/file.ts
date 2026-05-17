import fs from 'fs';
import path from 'path';

/**
 * Mendekode string Base64 gambar dan menyimpannya sebagai berkas fisik di folder uploads.
 * @param base64Str String Base64 lengkap (dapat menyertakan skema data:image atau tidak)
 * @param subfolder Nama awalan opsional untuk nama file (misal: 'profile' atau 'detection')
 * @returns Path relatif gambar yang dapat disimpan ke MySQL (contoh: '/uploads/profile_1716301293_12345.jpg')
 */
export const saveBase64Image = (base64Str: string, subfolder: string = ''): string => {
  // 1. Jika ini sudah berupa path atau URL uploads, langsung kembalikan
  if (base64Str.startsWith('/uploads') || base64Str.startsWith('http')) {
    return base64Str;
  }

  // 2. Jika ini adalah preset avatar kita (contoh: 'preset_leaf'), biarkan tersimpan apa adanya
  if (base64Str.startsWith('preset_')) {
    return base64Str;
  }

  try {
    // 3. Ekstrak data base64 dan ekstensi file
    const matches = base64Str.match(/^data:([A-Za-z-+\/]+);base64,(.+)$/);
    let ext = 'jpg';
    let buffer: Buffer;

    if (matches && matches.length === 3) {
      const type = matches[1];
      ext = type.split('/')[1] || 'jpg';
      // Tangani ekstensi khusus
      if (ext === 'jpeg') ext = 'jpg';
      buffer = Buffer.from(matches[2], 'base64');
    } else {
      // Jika base64 mentah tanpa skema data:image
      buffer = Buffer.from(base64Str, 'base64');
    }

    // 4. Buat nama file unik
    const filename = `${subfolder ? subfolder + '_' : ''}${Date.now()}_${Math.round(Math.random() * 1e6)}.${ext}`;
    
    // 5. Tentukan folder uploads di root backend (nyawit-api/uploads)
    const uploadDir = path.join(__dirname, '../../uploads');

    // 6. Buat folder jika belum ada secara rekursif
    if (!fs.existsSync(uploadDir)) {
      fs.mkdirSync(uploadDir, { recursive: true });
    }

    const filepath = path.join(uploadDir, filename);
    
    // 7. Tulis file biner ke sistem berkas
    fs.writeFileSync(filepath, buffer);

    return `/uploads/${filename}`;
  } catch (error) {
    console.error('Error saving base64 image:', error);
    // Jika gagal decode, kembalikan string asli agar tidak merusak data
    return base64Str;
  }
};
