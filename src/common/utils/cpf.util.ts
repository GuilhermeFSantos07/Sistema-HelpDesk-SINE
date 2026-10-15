import { createCipheriv, createDecipheriv, createHmac, randomBytes } from "crypto";

export function normalizeCpf (cpf: string): string {
    return (cpf ?? '').replace(/\D/g, '');
}

export function formataCpf(cpf: string): string {
    const d = normalizeCpf(cpf);
    return d.replace(/(\d{3})(\d{3})(\d{3})(\d{2})/, '$1.$2.$3-$4');
}

export function isValidCpf(cpf:string): boolean {
    const d = normalizeCpf(cpf);
    if (d.length !== 11) return false;
    if (/^(\d)\1{10}$/.test(d)) return false;

    const calcDigit = (base: string, factor: number): number => {
        let sum = 0;
        for (const ch of base) sum += Number(ch) * factor--;
        const rest = (sum * 10) % 11;
        return rest === 10 ? 0 : rest;
    };

    const d1 = calcDigit(d.slice(0,9), 10);
    const d2 = calcDigit(d.slice(0,10), 11);
    return d1 === Number(d[9]) && d2 === Number(d[10]);
}

export function hasCpfFormat(cpf: string): boolean {
    return normalizeCpf(cpf).length === 11;
}

export function hashCpf (cpf: string, secret: string): string {
    return createHmac('sha256', secret).update(normalizeCpf(cpf)).digest('hex');
}

export function maskCpf(cpf:string): string {
    const d = normalizeCpf(cpf);
    return `***.***.${d.slice(6,9)}-${d.slice(9,11)}`;
}

export function encryptCpf(cpf: string, keyHex: string): string {
    const key = Buffer.from(keyHex, 'hex');
    const iv = randomBytes(12);
    const cipher = createCipheriv('aes-256-gcm', key, iv);
    const encrypted = Buffer.concat([cipher.update(normalizeCpf(cpf), 'utf8'), cipher.final()]);
    const authTag = cipher.getAuthTag();
    return [iv, authTag, encrypted].map((b) => b.toString('base64')).join(':');
}

export function decryptCpf (payload: string, keyHex: string): string {
    const [ivB64, tagB64, dataB64] = payload.split(':');
    const decipher = createDecipheriv('aes-256-gcm', Buffer.from(keyHex, 'hex'), Buffer.from(ivB64, 'base64'));
    decipher.setAuthTag(Buffer.from(tagB64, 'base64'));
    const decrypted = Buffer.concat([decipher.update(Buffer.from(dataB64, 'base64')), decipher.final()]);
    return decrypted.toString('utf-8');
}