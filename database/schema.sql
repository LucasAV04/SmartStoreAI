-- SmartStore AI — Schema MVP (MySQL 8+)
-- Multiempresa via coluna EmpresaId em todas as tabelas de negócio.

CREATE DATABASE IF NOT EXISTS smartstoreai
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE smartstoreai;

-- =========================================================
-- 2. EMPRESAS
-- =========================================================
CREATE TABLE empresas (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    Nome            VARCHAR(150)    NOT NULL,
    Cnpj            VARCHAR(18)     NULL,
    Telefone        VARCHAR(20)     NULL,
    Email           VARCHAR(150)    NULL,
    Endereco        VARCHAR(255)    NULL,
    Ativa           TINYINT(1)      NOT NULL DEFAULT 1,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================================
-- 1. USUÁRIOS (Autenticação)
-- =========================================================
CREATE TABLE usuarios (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    Nome            VARCHAR(150)    NOT NULL,
    Email           VARCHAR(150)    NOT NULL,
    SenhaHash       VARCHAR(255)    NOT NULL,
    Role            VARCHAR(20)     NOT NULL DEFAULT 'Admin', -- Admin | User
    Ativo           TINYINT(1)      NOT NULL DEFAULT 1,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_usuarios_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id),
    CONSTRAINT uq_usuarios_email UNIQUE (Email)
) ENGINE=InnoDB;

CREATE TABLE senha_reset_tokens (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    UsuarioId       CHAR(36)        NOT NULL,
    Token           VARCHAR(255)    NOT NULL,
    ExpiraEm        DATETIME        NOT NULL,
    Usado           TINYINT(1)      NOT NULL DEFAULT 0,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reset_usuario FOREIGN KEY (UsuarioId) REFERENCES usuarios(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 5. CATEGORIAS
-- =========================================================
CREATE TABLE categorias (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    Nome            VARCHAR(100)    NOT NULL,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_categorias_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 6. FORNECEDORES
-- =========================================================
CREATE TABLE fornecedores (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    Nome            VARCHAR(150)    NOT NULL,
    Cnpj            VARCHAR(18)     NULL,
    Email           VARCHAR(150)    NULL,
    Telefone        VARCHAR(20)     NULL,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_fornecedores_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 10. CLIENTES
-- =========================================================
CREATE TABLE clientes (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    Nome            VARCHAR(150)    NOT NULL,
    Cpf             VARCHAR(14)     NULL,
    Telefone        VARCHAR(20)     NULL,
    Email           VARCHAR(150)    NULL,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_clientes_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 4. PRODUTOS
-- =========================================================
CREATE TABLE produtos (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    CategoriaId     CHAR(36)        NULL,
    Nome            VARCHAR(150)    NOT NULL,
    Codigo          VARCHAR(50)     NULL,
    CodigoBarras    VARCHAR(50)     NULL,
    Marca           VARCHAR(100)    NULL,
    Descricao       VARCHAR(500)    NULL,
    PrecoCompra     DECIMAL(10,2)   NOT NULL DEFAULT 0,
    PrecoVenda      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    EstoqueAtual    DECIMAL(10,2)   NOT NULL DEFAULT 0,
    EstoqueMinimo   DECIMAL(10,2)   NOT NULL DEFAULT 0,
    Unidade         VARCHAR(10)     NOT NULL DEFAULT 'UN',
    Ativo           TINYINT(1)      NOT NULL DEFAULT 1,
    CriadoEm        DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_produtos_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id),
    CONSTRAINT fk_produtos_categoria FOREIGN KEY (CategoriaId) REFERENCES categorias(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 7. ESTOQUE — MOVIMENTAÇÕES
-- =========================================================
CREATE TABLE movimentacoes_estoque (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    ProdutoId       CHAR(36)        NOT NULL,
    Tipo            VARCHAR(10)     NOT NULL, -- ENTRADA | SAIDA
    Quantidade      DECIMAL(10,2)   NOT NULL,
    Valor           DECIMAL(10,2)   NULL,      -- só entrada
    Motivo          VARCHAR(255)    NULL,      -- só saída
    Data            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_mov_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id),
    CONSTRAINT fk_mov_produto FOREIGN KEY (ProdutoId) REFERENCES produtos(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 8. COMPRAS
-- =========================================================
CREATE TABLE compras (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    FornecedorId    CHAR(36)        NOT NULL,
    Data            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ValorTotal      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    CONSTRAINT fk_compras_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id),
    CONSTRAINT fk_compras_fornecedor FOREIGN KEY (FornecedorId) REFERENCES fornecedores(Id)
) ENGINE=InnoDB;

CREATE TABLE compra_itens (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    CompraId        CHAR(36)        NOT NULL,
    ProdutoId       CHAR(36)        NOT NULL,
    Quantidade      DECIMAL(10,2)   NOT NULL,
    PrecoUnitario   DECIMAL(10,2)   NOT NULL,
    CONSTRAINT fk_compraitens_compra FOREIGN KEY (CompraId) REFERENCES compras(Id),
    CONSTRAINT fk_compraitens_produto FOREIGN KEY (ProdutoId) REFERENCES produtos(Id)
) ENGINE=InnoDB;

-- =========================================================
-- 9. VENDAS
-- =========================================================
CREATE TABLE vendas (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    EmpresaId       CHAR(36)        NOT NULL,
    ClienteId       CHAR(36)        NULL,
    Data            DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
    ValorTotal      DECIMAL(10,2)   NOT NULL DEFAULT 0,
    CONSTRAINT fk_vendas_empresa FOREIGN KEY (EmpresaId) REFERENCES empresas(Id),
    CONSTRAINT fk_vendas_cliente FOREIGN KEY (ClienteId) REFERENCES clientes(Id)
) ENGINE=InnoDB;

CREATE TABLE venda_itens (
    Id              CHAR(36)        NOT NULL PRIMARY KEY,
    VendaId         CHAR(36)        NOT NULL,
    ProdutoId       CHAR(36)        NOT NULL,
    Quantidade      DECIMAL(10,2)   NOT NULL,
    PrecoUnitario   DECIMAL(10,2)   NOT NULL,
    CONSTRAINT fk_vendaitens_venda FOREIGN KEY (VendaId) REFERENCES vendas(Id),
    CONSTRAINT fk_vendaitens_produto FOREIGN KEY (ProdutoId) REFERENCES produtos(Id)
) ENGINE=InnoDB;

-- Índices úteis para os relatórios do MVP
CREATE INDEX idx_produtos_empresa ON produtos(EmpresaId);
CREATE INDEX idx_vendas_empresa_data ON vendas(EmpresaId, Data);
CREATE INDEX idx_compras_empresa_data ON compras(EmpresaId, Data);
CREATE INDEX idx_mov_produto ON movimentacoes_estoque(ProdutoId);
