/*
  Warnings:

  - You are about to drop the column `quantidade` on the `Equipamento` table. All the data in the column will be lost.
  - A unique constraint covering the columns `[email]` on the table `Utilizador` will be added. If there are existing duplicate values, this will fail.
  - Added the required column `email` to the `Utilizador` table without a default value. This is not possible if the table is not empty.
  - Added the required column `nome` to the `Utilizador` table without a default value. This is not possible if the table is not empty.

*/
-- AlterTable
ALTER TABLE `Amortizacao` ADD COLUMN `taxaAnual` DECIMAL(5, 2) NULL;

-- AlterTable
ALTER TABLE `Equipamento` DROP COLUMN `quantidade`,
    ADD COLUMN `idLote` INTEGER NULL,
    ADD COLUMN `imagem` LONGBLOB NULL,
    MODIFY `modelo` VARCHAR(191) NULL,
    MODIFY `numeroSerie` VARCHAR(191) NULL,
    MODIFY `estado` ENUM('EM_USO', 'MANUTENCAO', 'OBSOLETO', 'AVARIADO', 'ABATIDO') NOT NULL DEFAULT 'EM_USO';

-- AlterTable
ALTER TABLE `Utilizador` ADD COLUMN `email` VARCHAR(191) NOT NULL,
    ADD COLUMN `nivelAcesso` ENUM('ADMIN', 'GESTOR', 'TECNICO', 'UTILIZADOR') NOT NULL DEFAULT 'UTILIZADOR',
    ADD COLUMN `nome` VARCHAR(191) NOT NULL;

-- CreateTable
CREATE TABLE `EventoSistema` (
    `id` INTEGER NOT NULL AUTO_INCREMENT,
    `tipoEvento` ENUM('CREATE', 'UPDATE', 'DELETE', 'LOGIN', 'LOGOUT', 'OTHER') NOT NULL,
    `entidade` VARCHAR(191) NOT NULL,
    `entidadeId` INTEGER NULL,
    `descricao` VARCHAR(191) NULL,
    `detalhes` JSON NULL,
    `ipOrigem` VARCHAR(191) NULL,
    `utilizadorId` INTEGER NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    INDEX `EventoSistema_utilizadorId_idx`(`utilizadorId`),
    INDEX `EventoSistema_entidade_idx`(`entidade`),
    INDEX `EventoSistema_tipoEvento_idx`(`tipoEvento`),
    INDEX `EventoSistema_dataRegisto_idx`(`dataRegisto`),
    PRIMARY KEY (`id`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Lote` (
    `idLote` INTEGER NOT NULL AUTO_INCREMENT,
    `codigo` VARCHAR(191) NOT NULL,
    `nome` VARCHAR(191) NULL,
    `quantidade` INTEGER NOT NULL DEFAULT 1,
    `estado` ENUM('ATIVO', 'PARCIALMENTE_ABATIDO', 'TOTALMENTE_ABATIDO') NOT NULL DEFAULT 'ATIVO',
    `idTipo` INTEGER NULL,
    `idFabricante` INTEGER NULL,
    `idMarca` INTEGER NULL,
    `dataAquisicao` DATETIME(3) NULL,
    `valorEstimado` DECIMAL(15, 2) NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Lote_codigo_key`(`codigo`),
    INDEX `Lote_codigo_idx`(`codigo`),
    INDEX `Lote_estado_idx`(`estado`),
    PRIMARY KEY (`idLote`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Abate` (
    `idAbate` INTEGER NOT NULL AUTO_INCREMENT,
    `idEquipamento` INTEGER NULL,
    `idLote` INTEGER NULL,
    `motivo` ENUM('FIM_VIDA_UTIL', 'SINISTRO', 'FURTO_ROUBO', 'ACIDENTE', 'INOPERANCIA', 'OBSOLESCENCIA_TECNOLOGICA', 'OBSOLESCENCIA_AMBIENTAL', 'TRANSFERENCIA', 'OUTRO') NOT NULL,
    `descricao` TEXT NULL,
    `dataPedido` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `relatorioTecnico` LONGBLOB NULL,
    `membrosComissao` VARCHAR(191) NOT NULL,
    `decisao` ENUM('VENDA_HASTA_PUBLICA', 'TRANSFERENCIA_GRATUITA', 'DESMANTELAMENTO', 'RECUPERACAO', 'REJEITADO') NULL,
    `valorVenda` DECIMAL(15, 2) NULL,
    `status` ENUM('PENDENTE', 'EM_AVALIACAO', 'APROVADO', 'REJEITADO', 'FINALIZADO') NOT NULL DEFAULT 'PENDENTE',
    `dataDecisao` DATETIME(3) NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    INDEX `Abate_idEquipamento_idx`(`idEquipamento`),
    INDEX `Abate_idLote_idx`(`idLote`),
    INDEX `Abate_status_idx`(`status`),
    INDEX `Abate_dataPedido_idx`(`dataPedido`),
    PRIMARY KEY (`idAbate`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Movimentacao` (
    `idMovimentacao` INTEGER NOT NULL AUTO_INCREMENT,
    `idEquipamento` INTEGER NULL,
    `idLote` INTEGER NULL,
    `idSeccaoOrigem` INTEGER NULL,
    `idSeccaoDestino` INTEGER NOT NULL,
    `idUtilizador` INTEGER NULL,
    `motivo` ENUM('TRANSFERENCIA_INTERNA', 'MANUTENCAO', 'ALOCACAO_NOVA', 'OUTRO') NOT NULL,
    `descricao` TEXT NULL,
    `anexo` LONGBLOB NULL,
    `dataMovimentacao` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,
    `idResponsavel` INTEGER NULL,

    INDEX `Movimentacao_idEquipamento_idx`(`idEquipamento`),
    INDEX `Movimentacao_idLote_idx`(`idLote`),
    INDEX `Movimentacao_idSeccaoOrigem_idx`(`idSeccaoOrigem`),
    INDEX `Movimentacao_idSeccaoDestino_idx`(`idSeccaoDestino`),
    INDEX `Movimentacao_dataMovimentacao_idx`(`dataMovimentacao`),
    PRIMARY KEY (`idMovimentacao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Manutencao` (
    `idManutencao` INTEGER NOT NULL AUTO_INCREMENT,
    `idEquipamento` INTEGER NOT NULL,
    `idUtilizador` INTEGER NULL,
    `tipo` ENUM('PREVENTIVA', 'CORRETIVA', 'INSPECAO', 'OUTRA') NOT NULL,
    `estado` ENUM('PENDENTE', 'EM_EXECUCAO', 'CONCLUIDA', 'CANCELADA') NOT NULL DEFAULT 'PENDENTE',
    `descricao` TEXT NULL,
    `custoEstimado` DECIMAL(15, 2) NULL,
    `custoReal` DECIMAL(15, 2) NULL,
    `dataInicioPrevista` DATETIME(3) NULL,
    `dataInicioReal` DATETIME(3) NULL,
    `dataConclusao` DATETIME(3) NULL,
    `fornecedor` VARCHAR(191) NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    INDEX `Manutencao_idEquipamento_idx`(`idEquipamento`),
    INDEX `Manutencao_estado_idx`(`estado`),
    INDEX `Manutencao_dataInicioPrevista_idx`(`dataInicioPrevista`),
    PRIMARY KEY (`idManutencao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateIndex
CREATE INDEX `Equipamento_idLote_idx` ON `Equipamento`(`idLote`);

-- CreateIndex
CREATE INDEX `Equipamento_numeroSerie_idx` ON `Equipamento`(`numeroSerie`);

-- CreateIndex
CREATE UNIQUE INDEX `Utilizador_email_key` ON `Utilizador`(`email`);

-- AddForeignKey
ALTER TABLE `EventoSistema` ADD CONSTRAINT `EventoSistema_utilizadorId_fkey` FOREIGN KEY (`utilizadorId`) REFERENCES `Utilizador`(`idUtilizador`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lote` ADD CONSTRAINT `Lote_idTipo_fkey` FOREIGN KEY (`idTipo`) REFERENCES `Tipo`(`idTipo`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lote` ADD CONSTRAINT `Lote_idFabricante_fkey` FOREIGN KEY (`idFabricante`) REFERENCES `Fabricante`(`idFabricante`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Lote` ADD CONSTRAINT `Lote_idMarca_fkey` FOREIGN KEY (`idMarca`) REFERENCES `Marca`(`idMarca`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idLote_fkey` FOREIGN KEY (`idLote`) REFERENCES `Lote`(`idLote`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Abate` ADD CONSTRAINT `Abate_idEquipamento_fkey` FOREIGN KEY (`idEquipamento`) REFERENCES `Equipamento`(`idEquipamento`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Abate` ADD CONSTRAINT `Abate_idLote_fkey` FOREIGN KEY (`idLote`) REFERENCES `Lote`(`idLote`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idEquipamento_fkey` FOREIGN KEY (`idEquipamento`) REFERENCES `Equipamento`(`idEquipamento`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idLote_fkey` FOREIGN KEY (`idLote`) REFERENCES `Lote`(`idLote`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idSeccaoOrigem_fkey` FOREIGN KEY (`idSeccaoOrigem`) REFERENCES `Seccao`(`idSeccao`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idSeccaoDestino_fkey` FOREIGN KEY (`idSeccaoDestino`) REFERENCES `Seccao`(`idSeccao`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idUtilizador_fkey` FOREIGN KEY (`idUtilizador`) REFERENCES `Utilizador`(`idUtilizador`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Movimentacao` ADD CONSTRAINT `Movimentacao_idResponsavel_fkey` FOREIGN KEY (`idResponsavel`) REFERENCES `Responsavel`(`codResponsavel`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Manutencao` ADD CONSTRAINT `Manutencao_idEquipamento_fkey` FOREIGN KEY (`idEquipamento`) REFERENCES `Equipamento`(`idEquipamento`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Manutencao` ADD CONSTRAINT `Manutencao_idUtilizador_fkey` FOREIGN KEY (`idUtilizador`) REFERENCES `Utilizador`(`idUtilizador`) ON DELETE SET NULL ON UPDATE CASCADE;
