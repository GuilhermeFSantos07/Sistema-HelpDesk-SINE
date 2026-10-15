import { Injectable, Logger, OnModuleDestroy } from "@nestjs/common";
import { ConfigService } from "@nestjs/config";
import Redis from 'ioredis';

@Injectable()
export class RedisService implements OnModuleDestroy{
    private readonly logger = new Logger(RedisService.name);
    readonly client: Redis;

    constructor(private readonly config: ConfigService) {
        this.client = new Redis ({
            host: this.config.get<string>('redis.host'),
            port: this.config.get<number>('redis.port'),
            password: this.config.get<string>('redis.password'),
            maxRetriesPerRequest: null,
        });
        this.client.on('ready', () => this.logger.log('Conectado ao Redis'));
        this.client.on('error', (err) => this.logger.error(`Erro no Redis: ${err.message}`));
    }

    duplicate(): Redis{
        return this.client.duplicate();
    }

    async set(key: string, value: string, ttlSeconds?: number): Promise<void> {
        if (ttlSeconds) {
            await this.client.set(key, value, 'EX', ttlSeconds);
        } else {
            await this.client.set(key, value);
        }
    }

    async get (key: string): Promise<string | null> {
        return this.client.get(key);
    }

    async del (key: string): Promise<void> {
        await this.client.del(key);
    }

    async exists(key: string): Promise<boolean> {
        return (await this.client.exists(key)) === 1;
    }

    async onModuleDestroy(): Promise<void> {
        await this.client.quit();
        this.logger.log('Conexão com o Redis encerrada');
    }
}