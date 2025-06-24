-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema projeto
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema projeto
-- -----------------------------------------------------


CREATE SCHEMA IF NOT EXISTS `projeto_easymanager` DEFAULT CHARACTER SET utf8 ;	
USE `projeto_easymanager` ;

-- -----------------------------------------------------
-- Table `projeto`.`Endereco`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Endereco` (
  `idEndereco` INT NOT NULL AUTO_INCREMENT,
  `cep` VARCHAR(8) NOT NULL,
  `logradouro` VARCHAR(45) NOT NULL,
  `numero` INT NULL,
  `complemento` VARCHAR(45) NULL,
  `cidade` VARCHAR(45) NOT NULL,
  `estado` VARCHAR(2) NOT NULL,
  `pais` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`idEndereco`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Usuario` (
  `idUsuario` INT NOT NULL AUTO_INCREMENT,
  `nomeCompleto` VARCHAR(100) NOT NULL,
  `cpf` VARCHAR(11) NOT NULL,
  `dtNascimento` DATE NOT NULL,
  `telefone` VARCHAR(15) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `senha` VARCHAR(10) NOT NULL,
  `tipoUsuario` ENUM("adm", "func") NOT NULL,
  `Endereco_idEndereco` INT NOT NULL,
  PRIMARY KEY (`idUsuario`),
  INDEX `fk_Usuario_Endereco1_idx` (`Endereco_idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_Usuario_Endereco1`
    FOREIGN KEY (`Endereco_idEndereco`)
    REFERENCES `projeto_easymanager`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Fornecedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Fornecedor` (
  `idFornecedor` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `telefone` VARCHAR(15) NOT NULL,
  `email` VARCHAR(45) NOT NULL,
  `Endereco_idEndereco` INT NOT NULL,
  PRIMARY KEY (`idFornecedor`),
  INDEX `fk_Fornecedor_Endereco1_idx` (`Endereco_idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_Fornecedor_Endereco1`
    FOREIGN KEY (`Endereco_idEndereco`)
    REFERENCES `projeto_easymanager`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Hospede`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Hospede` (
  `idHospede` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(45) NOT NULL,
  `sobrenome` VARCHAR(45) NOT NULL,
  `documento` VARCHAR(45) NOT NULL,
  `tipoDocumento` VARCHAR(45) NOT NULL,
  `dtNascimento` DATE NOT NULL,
  `telefone` VARCHAR(15) NOT NULL,
  `email` VARCHAR(45) NULL,
  `genero` VARCHAR(1) NOT NULL,
  `preferencia` VARCHAR(45) NULL,
  `Endereco_idEndereco` INT NOT NULL,
  PRIMARY KEY (`idHospede`),
  INDEX `fk_Hospede_Endereco1_idx` (`Endereco_idEndereco` ASC) VISIBLE,
  CONSTRAINT `fk_Hospede_Endereco1`
    FOREIGN KEY (`Endereco_idEndereco`)
    REFERENCES `projeto_easymanager`.`Endereco` (`idEndereco`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`EstoqueItem`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`EstoqueItem` (
  `idItem` INT NOT NULL AUTO_INCREMENT,
  `nomeItem` VARCHAR(45) NOT NULL,
  `descricao` VARCHAR(45) NOT NULL,
  `quantidade` INT NOT NULL,
  `preco` DECIMAL(10,2) NOT NULL,
  `dtValidade` DATE NULL,
  `Fornecedor_idFornecedor` INT NOT NULL,
  PRIMARY KEY (`idItem`),
  INDEX `fk_EstoqueItem_Fornecedor1_idx` (`Fornecedor_idFornecedor` ASC) VISIBLE,
  CONSTRAINT `fk_EstoqueItem_Fornecedor1`
    FOREIGN KEY (`Fornecedor_idFornecedor`)
    REFERENCES `projeto_easymanager`.`Fornecedor` (`idFornecedor`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Reserva` (
  `idReserva` INT NOT NULL AUTO_INCREMENT,
  `dtCheckin` DATE NOT NULL,
  `dtCheckout` DATE NOT NULL,
  `valorReserva` DECIMAL(10,2) NOT NULL,
  `canalReserva` VARCHAR(45) NOT NULL,
  `statusReserva` ENUM("confirmada", "cancelada", "pendente") NOT NULL,
  PRIMARY KEY (`idReserva`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`ServicoExtra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`ServicoExtra` (
  `idServicoExtra` INT NOT NULL AUTO_INCREMENT,
  `descricao` VARCHAR(45) NOT NULL,
  `valor` DECIMAL(10,2) NULL,
  PRIMARY KEY (`idServicoExtra`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Pagamento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Pagamento` (
  `idPagamento` INT NOT NULL AUTO_INCREMENT,
  `valorPago` DECIMAL(10,2) NOT NULL,
  `dtPagamento` DATE NOT NULL,
  `metodoPagamento` ENUM("credito", "debito", "dinheiro", "pix") NOT NULL,
  `Reserva_idReserva` INT NOT NULL,
  PRIMARY KEY (`idPagamento`),
  INDEX `fk_Pagamento_Reserva1_idx` (`Reserva_idReserva` ASC) VISIBLE,
  CONSTRAINT `fk_Pagamento_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `projeto_easymanager`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Quarto`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Quarto` (
  `idQuarto` INT NOT NULL AUTO_INCREMENT,
  `numeroQuarto` INT NOT NULL,
  `tipoQuarto` VARCHAR(45) NOT NULL,
  `precoDiaria` DECIMAL(10,2) NOT NULL,
  `capacidade` INT NOT NULL,
  `statusQuarto` ENUM("disponivel", "ocupado", "manutencao") NOT NULL,
  PRIMARY KEY (`idQuarto`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`ServicoExtra_has_Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`ServicoExtra_has_Reserva` (
  `ServicoExtra_idServicoExtra` INT NOT NULL,
  `Reserva_idReserva` INT NOT NULL,
  PRIMARY KEY (`ServicoExtra_idServicoExtra`, `Reserva_idReserva`),
  INDEX `fk_ServicoExtra_has_Reserva_Reserva1_idx` (`Reserva_idReserva` ASC) VISIBLE,
  INDEX `fk_ServicoExtra_has_Reserva_ServicoExtra1_idx` (`ServicoExtra_idServicoExtra` ASC) VISIBLE,
  CONSTRAINT `fk_ServicoExtra_has_Reserva_ServicoExtra1`
    FOREIGN KEY (`ServicoExtra_idServicoExtra`)
    REFERENCES `projeto_easymanager`.`ServicoExtra` (`idServicoExtra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_ServicoExtra_has_Reserva_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `projeto_easymanager`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Hospede_has_Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Hospede_has_Reserva` (
  `Hospede_idHospede` INT NOT NULL,
  `Reserva_idReserva` INT NOT NULL,
  PRIMARY KEY (`Hospede_idHospede`, `Reserva_idReserva`),
  INDEX `fk_Hospede_has_Reserva_Reserva1_idx` (`Reserva_idReserva` ASC) VISIBLE,
  INDEX `fk_Hospede_has_Reserva_Hospede1_idx` (`Hospede_idHospede` ASC) VISIBLE,
  CONSTRAINT `fk_Hospede_has_Reserva_Hospede1`
    FOREIGN KEY (`Hospede_idHospede`)
    REFERENCES `projeto_easymanager`.`Hospede` (`idHospede`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Hospede_has_Reserva_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `projeto_easymanager`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`EstoqueItem_has_ServicoExtra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`EstoqueItem_has_ServicoExtra` (
  `EstoqueItem_idItem` INT NOT NULL,
  `ServicoExtra_idServicoExtra` INT NOT NULL,
  PRIMARY KEY (`EstoqueItem_idItem`, `ServicoExtra_idServicoExtra`),
  INDEX `fk_EstoqueItem_has_ServicoExtra_ServicoExtra1_idx` (`ServicoExtra_idServicoExtra` ASC) VISIBLE,
  INDEX `fk_EstoqueItem_has_ServicoExtra_EstoqueItem1_idx` (`EstoqueItem_idItem` ASC) VISIBLE,
  CONSTRAINT `fk_EstoqueItem_has_ServicoExtra_EstoqueItem1`
    FOREIGN KEY (`EstoqueItem_idItem`)
    REFERENCES `projeto_easymanager`.`EstoqueItem` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_EstoqueItem_has_ServicoExtra_ServicoExtra1`
    FOREIGN KEY (`ServicoExtra_idServicoExtra`)
    REFERENCES `projeto_easymanager`.`ServicoExtra` (`idServicoExtra`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `projeto`.`Quarto_has_Reserva`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `projeto_easymanager`.`Quarto_has_Reserva` (
  `Quarto_idQuarto` INT NOT NULL,
  `Reserva_idReserva` INT NOT NULL,
  PRIMARY KEY (`Quarto_idQuarto`, `Reserva_idReserva`),
  INDEX `fk_Quarto_has_Reserva_Reserva1_idx` (`Reserva_idReserva` ASC) VISIBLE,
  INDEX `fk_Quarto_has_Reserva_Quarto1_idx` (`Quarto_idQuarto` ASC) VISIBLE,
  CONSTRAINT `fk_Quarto_has_Reserva_Quarto1`
    FOREIGN KEY (`Quarto_idQuarto`)
    REFERENCES `projeto_easymanager`.`Quarto` (`idQuarto`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Quarto_has_Reserva_Reserva1`
    FOREIGN KEY (`Reserva_idReserva`)
    REFERENCES `projeto_easymanager`.`Reserva` (`idReserva`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;



INSERT INTO Endereco (cep, logradouro, numero, complemento, cidade, estado, pais) VALUES
('01001000', 'Rua A', 100, 'Apto 1', 'São Paulo', 'SP', 'Brasil'),
('02002000', 'Rua B', 200, 'Casa', 'Rio de Janeiro', 'RJ', 'Brasil'),
('03003000', 'Rua C', 300, NULL, 'Belo Horizonte', 'MG', 'Brasil'),
('04004000', 'Rua D', 400, 'Bloco B', 'Curitiba', 'PR', 'Brasil'),
('05005000', 'Rua E', 500, NULL, 'Porto Alegre', 'RS', 'Brasil'),
('06006000', 'Rua F', 600, 'Sala 5', 'Florianópolis', 'SC', 'Brasil'),
('07007000', 'Rua G', 700, NULL, 'Salvador', 'BA', 'Brasil'),
('08008000', 'Rua H', 800, 'Fundos', 'Manaus', 'AM', 'Brasil'),
('09009000', 'Rua I', 900, NULL, 'Fortaleza', 'CE', 'Brasil'),
('10010000', 'Rua J', 1000, NULL, 'Recife', 'PE', 'Brasil');

INSERT INTO Usuario (nomeCompleto, cpf, dtNascimento, telefone, email, senha, tipoUsuario, Endereco_idEndereco) VALUES
('Ana Silva', '12345678900', '1990-01-01', '11999990000', 'ana@hotel.com', 'senha123', 'adm', 1),
('Carlos Lima', '22345678900', '1985-02-02', '21999990000', 'carlos@hotel.com', 'senha123', 'func', 2),
('Marina Souza', '32345678900', '1992-03-03', '31999990000', 'marina@hotel.com', 'senha123', 'func', 3);

INSERT INTO Fornecedor (nome, telefone, email, Endereco_idEndereco) VALUES
('Fornecedor A', '1123456789', 'fornecedorA@email.com', 4),
('Fornecedor B', '2123456789', 'fornecedorB@email.com', 5),
('Fornecedor C', '3123456789', 'fornecedorC@email.com', 6);

INSERT INTO Hospede (nome, sobrenome, documento, tipoDocumento, dtNascimento, telefone, email, genero, preferencia, Endereco_idEndereco) VALUES
('Pedro', 'Santos', 'ABC123', 'RG', '1990-01-01', '11988887777', 'pedro@email.com', 'M', 'andar alto', 7),
('Lucia', 'Moraes', 'DEF456', 'CPF', '1985-02-02', '21988887777', 'lucia@email.com', 'F', 'quarto silencioso', 8),
('Renato', 'Silva', 'GHI789', 'Passaporte', '1993-03-03', '31988887777', NULL, 'M', NULL, 9);

INSERT INTO EstoqueItem (nomeItem, descricao, quantidade, preco, dtValidade, Fornecedor_idFornecedor) VALUES
('Água Mineral', 'Garrafa 500ml', 100, 2.50, '2025-12-31', 1),
('Cerveja', 'Lata 350ml', 200, 5.00, '2025-12-31', 2),
('Shampoo', 'Frasco 250ml', 50, 10.00, NULL, 3),
('Sabonete', 'Sabonete neutro', 150, 3.00, NULL, 3),
('Toalha', 'Toalha de banho', 80, 25.00, NULL, 3),
('Lençol', 'Lençol de cama', 60, 40.00, NULL, 3),
('Vinho', 'Garrafa 750ml', 30, 60.00, '2026-05-30', 2),
('Refrigerante', 'Lata 350ml', 100, 4.50, '2025-12-31', 1),
('Papel Higiênico', 'Rolo', 300, 1.50, NULL, 3),
('Bolacha', 'Pacote 200g', 120, 3.50, '2025-10-10', 1);

INSERT INTO ServicoExtra (descricao, valor) VALUES
('Café da manhã', 30.00),
('Estacionamento', 50.00),
('Spa', 200.00),
('Lavanderia', 80.00),
('Passeio turístico', 150.00),
('Transfer aeroporto', 120.00),
('Massagem', 180.00),
('Aluguel de bicicleta', 40.00),
('Jantar romântico', 250.00),
('Pet friendly', 70.00);

INSERT INTO Quarto (numeroQuarto, tipoQuarto, precoDiaria, capacidade, statusQuarto) VALUES
(101, 'Standard', 120.00, 2, 'disponivel'),
(102, 'Luxo', 200.00, 2, 'disponivel'),
(103, 'Suíte', 350.00, 4, 'disponivel'),
(104, 'Standard', 120.00, 2, 'disponivel'),
(105, 'Luxo', 200.00, 2, 'disponivel'),
(106, 'Suíte', 350.00, 4, 'disponivel'),
(107, 'Standard', 120.00, 2, 'disponivel'),
(108, 'Luxo', 200.00, 2, 'disponivel'),
(109, 'Suíte', 350.00, 4, 'disponivel'),
(110, 'Standard', 120.00, 2, 'disponivel');



