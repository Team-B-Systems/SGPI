-- CreateTable
CREATE TABLE `Tipo` (
    `idTipo` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    PRIMARY KEY (`idTipo`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Fabricante` (
    `idFabricante` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    PRIMARY KEY (`idFabricante`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Marca` (
    `idMarca` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    PRIMARY KEY (`idMarca`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Departamento` (
    `idDepartamento` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `sigla` VARCHAR(191) NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    PRIMARY KEY (`idDepartamento`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Seccao` (
    `idSeccao` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `sigla` VARCHAR(191) NOT NULL,
    `idDepartamento` INTEGER NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    INDEX `Seccao_idDepartamento_idx`(`idDepartamento`),
    PRIMARY KEY (`idSeccao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Responsavel` (
    `codResponsavel` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `idSeccao` INTEGER NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    PRIMARY KEY (`codResponsavel`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Utilizador` (
    `idUtilizador` INTEGER NOT NULL AUTO_INCREMENT,
    `username` VARCHAR(191) NOT NULL,
    `password` VARCHAR(191) NOT NULL,
    `idDepartamento` INTEGER NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Utilizador_username_key`(`username`),
    PRIMARY KEY (`idUtilizador`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Equipamento` (
    `idEquipamento` INTEGER NOT NULL AUTO_INCREMENT,
    `nome` VARCHAR(191) NOT NULL,
    `descricao` TEXT NULL,
    `modelo` VARCHAR(191) NOT NULL,
    `numeroSerie` VARCHAR(191) NOT NULL,
    `quantidade` INTEGER NOT NULL,
    `dataAquisicao` DATETIME(3) NOT NULL,
    `estado` ENUM('EM_USO', 'MANUTENCAO', 'OBSOLETO', 'AVARIADO') NOT NULL,
    `valorEstimado` DECIMAL(15, 2) NOT NULL,
    `idTipo` INTEGER NOT NULL,
    `idFabricante` INTEGER NOT NULL,
    `idMarca` INTEGER NOT NULL,
    `idSeccao` INTEGER NOT NULL,
    `idUtilizador` INTEGER NOT NULL,
    `idResponsavel` INTEGER NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    UNIQUE INDEX `Equipamento_numeroSerie_key`(`numeroSerie`),
    INDEX `Equipamento_idTipo_idx`(`idTipo`),
    INDEX `Equipamento_idSeccao_idx`(`idSeccao`),
    INDEX `Equipamento_dataAquisicao_idx`(`dataAquisicao`),
    PRIMARY KEY (`idEquipamento`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- CreateTable
CREATE TABLE `Amortizacao` (
    `idAmortizacao` INTEGER NOT NULL AUTO_INCREMENT,
    `metodo` VARCHAR(191) NOT NULL,
    `tempoUtilAnos` INTEGER NOT NULL,
    `valorInicial` DECIMAL(15, 2) NOT NULL,
    `valorResidual` DECIMAL(15, 2) NULL,
    `valorAmortizado` DECIMAL(15, 2) NULL,
    `dataCalculo` DATETIME(3) NOT NULL,
    `idEquipamento` INTEGER NOT NULL,
    `dataRegisto` DATETIME(3) NOT NULL DEFAULT CURRENT_TIMESTAMP(3),
    `dataActualizacao` DATETIME(3) NOT NULL,

    INDEX `Amortizacao_idEquipamento_idx`(`idEquipamento`),
    PRIMARY KEY (`idAmortizacao`)
) DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- AddForeignKey
ALTER TABLE `Seccao` ADD CONSTRAINT `Seccao_idDepartamento_fkey` FOREIGN KEY (`idDepartamento`) REFERENCES `Departamento`(`idDepartamento`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Responsavel` ADD CONSTRAINT `Responsavel_idSeccao_fkey` FOREIGN KEY (`idSeccao`) REFERENCES `Seccao`(`idSeccao`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Utilizador` ADD CONSTRAINT `Utilizador_idDepartamento_fkey` FOREIGN KEY (`idDepartamento`) REFERENCES `Departamento`(`idDepartamento`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idTipo_fkey` FOREIGN KEY (`idTipo`) REFERENCES `Tipo`(`idTipo`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idFabricante_fkey` FOREIGN KEY (`idFabricante`) REFERENCES `Fabricante`(`idFabricante`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idMarca_fkey` FOREIGN KEY (`idMarca`) REFERENCES `Marca`(`idMarca`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idSeccao_fkey` FOREIGN KEY (`idSeccao`) REFERENCES `Seccao`(`idSeccao`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idUtilizador_fkey` FOREIGN KEY (`idUtilizador`) REFERENCES `Utilizador`(`idUtilizador`) ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Equipamento` ADD CONSTRAINT `Equipamento_idResponsavel_fkey` FOREIGN KEY (`idResponsavel`) REFERENCES `Responsavel`(`codResponsavel`) ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE `Amortizacao` ADD CONSTRAINT `Amortizacao_idEquipamento_fkey` FOREIGN KEY (`idEquipamento`) REFERENCES `Equipamento`(`idEquipamento`) ON DELETE CASCADE ON UPDATE CASCADE;

CREATE OR REPLACE VIEW vw_AmortizacaoAcumulada AS
SELECT 
  e.idEquipamento,
  e.nome AS equipamento,
  e.valorEstimado AS valor_inicial,
  a.valorAmortizado AS valor_amortizado,
  (e.valorEstimado - a.valorAmortizado) AS valor_atual,
  a.metodo,
  a.tempoUtilAnos,
  a.dataCalculo
FROM Amortizacao a
JOIN Equipamento e ON e.idEquipamento = a.idEquipamento;

