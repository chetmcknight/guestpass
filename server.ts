import express from 'express';
import type { Request, Response } from 'express';
import QRCode from 'qrcode';
import path from 'path';
import { fileURLToPath } from 'url';

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());
app.use(express.static(path.join(__dirname, 'public')));

interface WifiRequest {
    ssid: string;
    password?: string;
    encryption?: 'WPA' | 'WEP' | 'nopass';
}

app.post('/api/generate', async (req: Request, res: Response) => {
    try {
        const { ssid, password, encryption = 'WPA' } = req.body as WifiRequest;

        if (!ssid) {
            res.status(400).json({ error: 'SSID is required' });
            return;
        }

        // Format: WIFI:T:WPA;S:mynetwork;P:mypass;;
        // Note: Special characters need escaping in some readers, but standard format is usually robust.
        // We will stick to the standard basic format.
        let wifiString = `WIFI:S:${ssid};`;

        if (password && encryption !== 'nopass') {
            wifiString += `T:${encryption};P:${password};;`;
        } else {
            wifiString += `T:nopass;;`;
        }

        // Generate QR Code to Data URL (Base64)
        const qrImage = await QRCode.toDataURL(wifiString, {
            width: 600,
            margin: 2,
            color: {
                dark: '#000000',
                light: '#00000000' // Transparent background
            }
        });

        res.json({ image: qrImage, ssid });
    } catch (error) {
        console.error('Error generating QR code:', error);
        res.status(500).json({ error: 'Failed to generate QR code' });
    }
});

app.listen(PORT, () => {
    console.log(`Server running at http://localhost:${PORT}`);
});
