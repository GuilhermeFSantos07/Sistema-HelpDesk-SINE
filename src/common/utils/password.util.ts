import { randomInt } from "crypto";
import * as bcrypt from 'bcrypt';

export async function hashPassword(plain: string, rounds: number): Promise<string> {
    return bcrypt.hash(plain, rounds);
}

export async function comparePassword(plain: string, hash: string): Promise<boolean> {
    return bcrypt.compare(plain, hash);
}

const UPPER = 'ABCDEFGHJKLMNPQRSTUVWXYZ';
const LOWER = 'abcdefghijkmnopqrstuvwxyz';
const DIGITS = '23456789';

function pick (chars: string): string {
    return chars [randomInt(chars.length)];
}

export function generateInitialPassword(length = 12): string {
    const all = UPPER + LOWER + DIGITS;
    const chars = [pick(UPPER), pick(LOWER), pick(DIGITS)];
    while (chars.length < length) chars.push(pick(all));

    for (let i = chars.length - 1; i > 0; i--){
        const j = randomInt(i + 1);
        [chars[i], chars[j] = chars[j], chars[i]];
    }
    return chars.join('');
}

export function isPasswordStrongEnough(plain: string, minLength: number): boolean{
    return typeof plain === 'string' && plain.length >= minLength;
}