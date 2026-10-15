export default () => ({
    env: process.env.NODE_ENV ?? 'development',
    port: parseInt(process.env.PORT ?? '3000', 10),
    corsOrigin: process.env.CORS_ORIGIN ?? 'http://localhost:5173',

    database: {
        url: process.env.DATABASE_URL as string,
    },

    redis: {
        host: process.env.REDIS_HOST ?? 'localhost',
        port: parseInt(process.env.REDIS_PORT ?? '6379', 10),
        password: process.env.REDIS_PASSWORD || undefined,
    },

    jwt: {
        accessSecret: process.env.JWT_ACCESS_SECRET as string,
        accessExpiresIn: process.env.JWT_ACCESS_EXPIRES_IN ?? '15m',
        refreshSecret: process.env.JWT_REFRESH_SECRET as string,
        refreshExpiresIn: process.env.JWT_REFRESH_EXPIRES_IN ?? '7d'
    },

    security: {
        bcryptRounds: parseInt(process.env.BCRYPT_ROUNDS ?? '10', 10),
        cpfHashSecrect: process.env.CPF_HASH_SECRET as string,
    },

    upload: {
        dir: process.env.UPLOAD_DIR ?? './uploads',
    },
});