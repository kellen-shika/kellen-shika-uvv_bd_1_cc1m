
CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximmo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'tabela com o cargo e salario minimo e maximo';

ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'chave primaria, codigo do cargo';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'o menor sal�rio';

ALTER TABLE cargos MODIFY COLUMN salario_maximmo DECIMAL(8, 2) COMMENT 'o maior s�lario';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao_ INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao_)
);

ALTER TABLE regioes COMMENT 'cotem a regiao';

ALTER TABLE regioes MODIFY COLUMN id_regiao_ INTEGER COMMENT 'chave pr�maria da tabela regi�es, cont�m codigo da regi�o';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'nome da regi�o';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE paises (
                _id_pais_ CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (_id_pais_)
);

ALTER TABLE paises COMMENT 'detalha qual o pa�s, qual � sua sigla e em que regiao est�';

ALTER TABLE paises MODIFY COLUMN _id_pais_ CHAR(2) COMMENT 'chave pr�maria da tabela pa�ses, sigla do pa�s';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do pais';

ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'chave estregereira da tabela regi�es do c�digo das regi�es';


CREATE UNIQUE INDEX paises_idx
 ON paises
 ( nome );

CREATE TABLE localizacoes (
                id_localizacao INT NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                CEP VARCHAR(12),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                PRIMARY KEY (id_localizacao)
);

ALTER TABLE localizacoes COMMENT 'tem os detalhes da localiza��o de escrit�rios e facilidades da empresa, n�o clientes.';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'caliza��o';

ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'o endere�o (rua, bairro e numero)';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'a ciddade';

ALTER TABLE localizacoes MODIFY COLUMN CEP VARCHAR(12) COMMENT 'o cep da localiza��o';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'a unidade federal da localiza��o';

ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR(2) COMMENT 'chave estrangeira para a tabela pa�ses, tem o c�digo do pa�s';


CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50),
                id_localizacao INT NOT NULL,
                id_gerente INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'tem o c�digo do departamento, seu nome, a localiza��o e quem o gerencia';

ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'epartamento';

ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do departamentento';

ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'a localiza�ao';

ALTER TABLE departamentos MODIFY COLUMN id_gerente INTEGER COMMENT 'empregado';


CREATE UNIQUE INDEX departamentos_idx
 ON departamentos
 ( nome );

CREATE TABLE empregados (
                id_empregado INT NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_carg0 VARCHAR(10) NOT NULL,
                salario DECIMAL(8,2),
                comissao DECIMAL(4,2),
                id_departamento INT NOT NULL,
                id_surpevisor INT NOT NULL,
                PRIMARY KEY (id_empregado)
);

ALTER TABLE empregados COMMENT 'tem o c�digo do empregado, nome, email, telefone, quando foi contratado, cargo, sal�rio, comiss�o, departamento, e o surpevisor';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'empregado';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'nome do empregado';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'email do empregado antes de @';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'n�mero de telefone, com o dodigo do pa�s e estado';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'quando o empregado iniciou no cargo atual';

ALTER TABLE empregados MODIFY COLUMN id_carg0 VARCHAR(10) COMMENT 'chave estrangeira da tabela cargos, idenetifica os cargos';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 's�lario do empragado';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT ' o departamento de vendas';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'chave estrangeira, cont�m c�digo do departamento';

ALTER TABLE empregados MODIFY COLUMN id_surpevisor INTEGER COMMENT 'o surpervisor direto do empregdo (auto-relacionamento)';


CREATE UNIQUE INDEX email
 ON empregados
 ( email );

CREATE TABLE historico_cargos (
                id_empregado INT NOT NULL,
                data_inical DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                d_departamento INT NOT NULL,
                PRIMARY KEY (id_empregado, data_inical)
);

ALTER TABLE historico_cargos COMMENT 'cont�m o c�digo do empregado, quando ele come�ou, quando teminou no cargo e em qual departamento';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'empregado';

ALTER TABLE historico_cargos MODIFY COLUMN data_inical DATE COMMENT 'chave prim�ria composta, cont�m quando iniciou o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'quando o empregado deixou o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'chave estrangeira para cargos, indentica o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN d_departamento INTEGER COMMENT 'nto';


ALTER TABLE empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_carg0)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE paises ADD CONSTRAINT paises_regioes_fk
FOREIGN KEY (id_regiao)
REFERENCES regioes (id_regiao_)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE localizacoes ADD CONSTRAINT localizacoes_paises_fk
FOREIGN KEY (id_pais)
REFERENCES paises (_id_pais_)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT departamentos_localizacoes_fk
FOREIGN KEY (id_localizacao)
REFERENCES localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (d_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;

ALTER TABLE empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_surpevisor)
REFERENCES empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION;
