-- CreateEnum
CREATE TYPE "Cargo" AS ENUM ('USUARIO_COMUM', 'RESOLUTOR', 'ADMINISTRADOR', 'SUPERVISOR');

-- CreateEnum
CREATE TYPE "UsuarioStatus" AS ENUM ('ATIVO', 'INATIVO', 'BLOQUEADO');

-- CreateEnum
CREATE TYPE "Disponibilidade" AS ENUM ('DISPONIVEL', 'EM_ATENDIMENTO', 'AUSENTE');

-- CreateEnum
CREATE TYPE "RegistroStatus" AS ENUM ('PENDENTE', 'APROVADO', 'RECUSADO');

-- CreateEnum
CREATE TYPE "TicketStatus" AS ENUM ('ABERTO', 'EM_ANDAMENTO', 'AGUARDANDO', 'FECHADO');

-- CreateEnum
CREATE TYPE "Prioridade" AS ENUM ('CRITICA', 'ALTA', 'MEDIA', 'BAIXA');

-- CreateEnum
CREATE TYPE "AtivosStatus" AS ENUM ('ATIVO', 'MANUTENCAO', 'INATIVO', 'DESCARTADO');

-- CreateEnum
CREATE TYPE "TipoNotificacao" AS ENUM ('NOVO_CADASTRO', 'CHAMADO_ATRIBUIDO', 'CHAMADO_RESPONDIDO', 'CHAMADO_RESOLVIDO', 'SLA_ALERTA', 'SLA_VENCIDO');

-- CreateTable
CREATE TABLE "setores" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "apagadoEm" TIMESTAMP(3),

    CONSTRAINT "setores_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cpfHash" TEXT NOT NULL,
    "cpfMasked" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "senhaHash" TEXT NOT NULL,
    "cargo" "Cargo" NOT NULL DEFAULT 'USUARIO_COMUM',
    "status" "UsuarioStatus" NOT NULL DEFAULT 'ATIVO',
    "disponibilidade" "Disponibilidade" NOT NULL DEFAULT 'DISPONIVEL',
    "setorId" TEXT NOT NULL,
    "nomePosicao" TEXT NOT NULL,
    "dataNascimento" DATE,
    "telefone" TEXT,
    "sala" TEXT,
    "iconeUrl" TEXT,
    "deveMudarSenha" BOOLEAN NOT NULL DEFAULT true,
    "tentativasLoginFalhadas" INTEGER NOT NULL DEFAULT 0,
    "travadoAte" TIMESTAMP(3),
    "ultimoLoginEm" TIMESTAMP(3),
    "preferenciasUi" JSONB NOT NULL DEFAULT '{}',
    "preferenciasNot" JSONB NOT NULL DEFAULT '{}',
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "deletadoEm" TIMESTAMP(3),

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "pedido_registro" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "cpfHash" TEXT NOT NULL,
    "cpfMasked" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "setorId" TEXT NOT NULL,
    "nomePosicao" TEXT NOT NULL,
    "dataNascimento" DATE NOT NULL,
    "status" "RegistroStatus" NOT NULL DEFAULT 'PENDENTE',
    "revisadoPorId" TEXT,
    "revisadoEm" TIMESTAMP(3),
    "usuarioCriadorId" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "pedido_registro_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "permissoes" (
    "id" TEXT NOT NULL,
    "chave" TEXT NOT NULL,
    "etiqueta" TEXT NOT NULL,
    "descricao" TEXT,

    CONSTRAINT "permissoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "cargo_permissao" (
    "cargo" "Cargo" NOT NULL,
    "permissaoId" TEXT NOT NULL,
    "concedido" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "cargo_permissao_pkey" PRIMARY KEY ("cargo","permissaoId")
);

-- CreateTable
CREATE TABLE "categorias" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "ativo" BOOLEAN NOT NULL DEFAULT true,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "deletadoEm" TIMESTAMP(3),

    CONSTRAINT "categorias_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "politica_sla" (
    "prioridade" "Prioridade" NOT NULL,
    "horasResposta" INTEGER NOT NULL,
    "horasResolucao" INTEGER NOT NULL,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "politica_sla_pkey" PRIMARY KEY ("prioridade")
);

-- CreateTable
CREATE TABLE "tickets" (
    "id" TEXT NOT NULL,
    "numero" SERIAL NOT NULL,
    "titulo" TEXT NOT NULL,
    "descricao" TEXT NOT NULL,
    "status" "TicketStatus" NOT NULL DEFAULT 'ABERTO',
    "prioridade" "Prioridade" NOT NULL,
    "categoriaId" TEXT NOT NULL,
    "setorId" TEXT NOT NULL,
    "solicitanteId" TEXT NOT NULL,
    "atribuidoId" TEXT,
    "ativoId" TEXT,
    "telefone" TEXT,
    "sala" TEXT,
    "slaComecouEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "respostaPrevistaEm" TIMESTAMP(3) NOT NULL,
    "resolucaoPrevisaoEm" TIMESTAMP(3) NOT NULL,
    "primeiraRespostaEm" TIMESTAMP(3),
    "slaPausadoEm" TIMESTAMP(3),
    "slaPauseTotalSeg" INTEGER NOT NULL DEFAULT 0,
    "respostaQuebraEm" TIMESTAMP(3),
    "solucaoQuebraEm" TIMESTAMP(3),
    "solucionadoEm" TIMESTAMP(3),
    "fechadoEm" TIMESTAMP(3),
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "deletadoEm" TIMESTAMP(3),

    CONSTRAINT "tickets_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket_comentario" (
    "id" TEXT NOT NULL,
    "ticketId" TEXT NOT NULL,
    "autorId" TEXT NOT NULL,
    "corpo" TEXT NOT NULL,
    "interna" BOOLEAN NOT NULL DEFAULT false,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "deletadoEm" TIMESTAMP(3),

    CONSTRAINT "ticket_comentario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ticket_eventos" (
    "id" TEXT NOT NULL,
    "ticketId" TEXT NOT NULL,
    "autorId" TEXT,
    "tipo" TEXT NOT NULL,
    "doValor" TEXT,
    "paraValor" TEXT,
    "motivo" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ticket_eventos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ativos" (
    "id" TEXT NOT NULL,
    "nome" TEXT NOT NULL,
    "tipo" TEXT NOT NULL,
    "modeloMarca" TEXT,
    "numeroSerie" TEXT,
    "status" "AtivosStatus" NOT NULL DEFAULT 'ATIVO',
    "nomeResponsabilidade" TEXT,
    "departamento" TEXT,
    "adquiridoEm" DATE,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,
    "deletadoEm" TIMESTAMP(3),

    CONSTRAINT "ativos_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "notificacoes" (
    "id" TEXT NOT NULL,
    "usuarioId" TEXT NOT NULL,
    "tipo" "TipoNotificacao" NOT NULL,
    "titulo" TEXT NOT NULL,
    "menssagem" TEXT NOT NULL,
    "ticketId" TEXT,
    "data" JSONB,
    "lidoEm" TIMESTAMP(3),
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "notificacoes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audicao_log" (
    "id" TEXT NOT NULL,
    "usuarioId" TEXT,
    "evento" TEXT NOT NULL,
    "acao" TEXT NOT NULL,
    "entidade" TEXT,
    "entidadeId" TEXT,
    "metadata" JSONB,
    "enderecoIp" TEXT,
    "criadoEm" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audicao_log_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "configuracoes_sistema" (
    "chave" TEXT NOT NULL,
    "valor" JSONB NOT NULL,
    "atualizadoEm" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "configuracoes_sistema_pkey" PRIMARY KEY ("chave")
);

-- CreateIndex
CREATE UNIQUE INDEX "setores_nome_key" ON "setores"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "users_cpfHash_key" ON "users"("cpfHash");

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");

-- CreateIndex
CREATE INDEX "users_cargo_status_idx" ON "users"("cargo", "status");

-- CreateIndex
CREATE INDEX "users_disponibilidade_idx" ON "users"("disponibilidade");

-- CreateIndex
CREATE UNIQUE INDEX "pedido_registro_usuarioCriadorId_key" ON "pedido_registro"("usuarioCriadorId");

-- CreateIndex
CREATE INDEX "pedido_registro_status_idx" ON "pedido_registro"("status");

-- CreateIndex
CREATE INDEX "pedido_registro_cpfHash_idx" ON "pedido_registro"("cpfHash");

-- CreateIndex
CREATE UNIQUE INDEX "permissoes_chave_key" ON "permissoes"("chave");

-- CreateIndex
CREATE UNIQUE INDEX "categorias_nome_key" ON "categorias"("nome");

-- CreateIndex
CREATE UNIQUE INDEX "tickets_numero_key" ON "tickets"("numero");

-- CreateIndex
CREATE INDEX "tickets_status_prioridade_idx" ON "tickets"("status", "prioridade");

-- CreateIndex
CREATE INDEX "tickets_solicitanteId_idx" ON "tickets"("solicitanteId");

-- CreateIndex
CREATE INDEX "tickets_atribuidoId_status_idx" ON "tickets"("atribuidoId", "status");

-- CreateIndex
CREATE INDEX "tickets_resolucaoPrevisaoEm_idx" ON "tickets"("resolucaoPrevisaoEm");

-- CreateIndex
CREATE INDEX "ticket_comentario_ticketId_criadoEm_idx" ON "ticket_comentario"("ticketId", "criadoEm");

-- CreateIndex
CREATE INDEX "ticket_eventos_ticketId_criadoEm_idx" ON "ticket_eventos"("ticketId", "criadoEm");

-- CreateIndex
CREATE UNIQUE INDEX "ativos_numeroSerie_key" ON "ativos"("numeroSerie");

-- CreateIndex
CREATE INDEX "ativos_status_idx" ON "ativos"("status");

-- CreateIndex
CREATE INDEX "ativos_tipo_idx" ON "ativos"("tipo");

-- CreateIndex
CREATE INDEX "notificacoes_usuarioId_lidoEm_idx" ON "notificacoes"("usuarioId", "lidoEm");

-- CreateIndex
CREATE INDEX "audicao_log_criadoEm_idx" ON "audicao_log"("criadoEm");

-- CreateIndex
CREATE INDEX "audicao_log_usuarioId_idx" ON "audicao_log"("usuarioId");

-- CreateIndex
CREATE INDEX "audicao_log_acao_idx" ON "audicao_log"("acao");

-- AddForeignKey
ALTER TABLE "users" ADD CONSTRAINT "users_setorId_fkey" FOREIGN KEY ("setorId") REFERENCES "setores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedido_registro" ADD CONSTRAINT "pedido_registro_setorId_fkey" FOREIGN KEY ("setorId") REFERENCES "setores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedido_registro" ADD CONSTRAINT "pedido_registro_revisadoPorId_fkey" FOREIGN KEY ("revisadoPorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "pedido_registro" ADD CONSTRAINT "pedido_registro_usuarioCriadorId_fkey" FOREIGN KEY ("usuarioCriadorId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "cargo_permissao" ADD CONSTRAINT "cargo_permissao_permissaoId_fkey" FOREIGN KEY ("permissaoId") REFERENCES "permissoes"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_categoriaId_fkey" FOREIGN KEY ("categoriaId") REFERENCES "categorias"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_setorId_fkey" FOREIGN KEY ("setorId") REFERENCES "setores"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_solicitanteId_fkey" FOREIGN KEY ("solicitanteId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_atribuidoId_fkey" FOREIGN KEY ("atribuidoId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tickets" ADD CONSTRAINT "tickets_ativoId_fkey" FOREIGN KEY ("ativoId") REFERENCES "ativos"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_comentario" ADD CONSTRAINT "ticket_comentario_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "tickets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_comentario" ADD CONSTRAINT "ticket_comentario_autorId_fkey" FOREIGN KEY ("autorId") REFERENCES "users"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ticket_eventos" ADD CONSTRAINT "ticket_eventos_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "tickets"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificacoes" ADD CONSTRAINT "notificacoes_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "notificacoes" ADD CONSTRAINT "notificacoes_ticketId_fkey" FOREIGN KEY ("ticketId") REFERENCES "tickets"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audicao_log" ADD CONSTRAINT "audicao_log_usuarioId_fkey" FOREIGN KEY ("usuarioId") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;
