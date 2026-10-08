import {plainToInstance} from 'class-transformer'

import {
    IsEnum,
    IsInt,
    IsNotEmpty,
    IsString,
    Max,
    Min,
    MinLength,
    validateSync,
} from 'class-validator';

enum Environment {
    Development = 'development',
    Production = 'production',
    Test = 'test',
}

class EnvironmentVariables {
    @IsEnum(Environment)
    NODE_ENV: Environment = Environment.Development;

    @IsInt()
    @Min(1)
    @Max(65535)
    PORT: number = 3000;

    @IsString()
    @IsNotEmpty()
    CORS_ORIGIN: string = 'http://localhost:5173'

    @IsString()
    @IsNotEmpty()
    DATABASE_URL: string;

    @IsString()
    @IsNotEmpty()
    REDIS_HOST: string = 'localhost'

    @IsInt()
    @Min(1)
    @Max(65535)
    REDIS_PORT: number = 6379;

    @IsString()
    REDIS_PASSWORD: string = '';

    @IsString()
    @MinLength(32)
    JWT_ACCESS_SECRET: string;

    @IsString()
    @IsNotEmpty()
    JWT_ACCESS_EXPIRES_IN: string = '15m';
    
    @IsString()
    @MinLength(32)
    JWT_REFRESH_SECRET: string;

    @IsString()
    @IsNotEmpty()
    JWT_REFRESH_EXPIRES_IN: string = '7d';

    @IsInt()
    @Min(4)
    @Max(15)
    BCRYOT_ROUNDS: number = 10;

    @IsString()
    @MinLength(32)
    CPF_HASH_SECRET: string;

    @IsString()
    @IsNotEmpty()
    UPLOAD_DIR: string = './uploads';
}

export function validateEnv(config: Record<string, unknown>){
    const validated = plainToInstance(EnvironmentVariables, config, {
        enableImplicitConversion: true,
    });

    const errors = validateSync(validated, { skipMissingProperties: false});

    if (errors.length > 0) {
        const details = errors
            .map((e) => ` - ${e.property}: ${Object.values(e.constraints ?? {}).join(', ')}`)
            .join('\n');
        throw new Error(`Variáveis de ambiente inválidas: \n${details}`);
    }

    return config;
}