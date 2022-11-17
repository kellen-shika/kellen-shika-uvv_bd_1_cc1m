CREATE USER rayssa WITH
	SUPERUSER
	CREATEDB
	CREATEROLE
	INHERIT
	REPLICATION
	CONNECTION LIMIT -1;

CREATE DATABASE uvv
    WITH OWNER = rayssa
    ENCODING = 'UTF8'
    LC_COLLATE = 'pt_BR.UTF-8'
    LC_CTYPE = 'pt_BR.UTF-8'
    TABLESPACE = pg_default
	ALLOW_CONNECTIONS = TRUE;

CREATE SCHEMA hr
AUTHORIZATION rayssa;

SET SEARCH_PATH TO hr, "$user", public;

CREATE TABLE hr.cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo NUMERIC(8,2),
                salario_maximmo NUMERIC(8,2),
                CONSTRAINT id_cargo PRIMARY KEY (id_cargo)
);
COMMENT ON TABLE hr.cargos IS 'tabela com o cargo e salario minimo e maximo';
COMMENT ON COLUMN hr.cargos.id_cargo IS 'chave primaria, codigo do cargo';
COMMENT ON COLUMN hr.cargos.salario_minimo IS 'o menor salario';
COMMENT ON COLUMN hr.cargos.salario_maximmo IS 'o maior salario';


CREATE UNIQUE INDEX cargos_idx
 ON hr.cargos
 ( cargo );

CREATE TABLE hr.regioes (
                id_regiao_ INTEGER NOT NULL,
                nome VARCHAR(25) NOT NULL,
                CONSTRAINT id_regiao PRIMARY KEY (id_regiao_)
);
COMMENT ON TABLE hr.regioes IS 'cotem a regiao';
COMMENT ON COLUMN hr.regioes.id_regiao_ IS 'chave primaria da tabela regioes, contem codigo da regiao';
COMMENT ON COLUMN hr.regioes.nome IS 'nome da regiao';


CREATE UNIQUE INDEX regioes_idx
 ON hr.regioes
 ( nome );

CREATE TABLE hr.paises (
                _id_pais_ CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INTEGER NOT NULL,
                CONSTRAINT id_pais PRIMARY KEY (_id_pais_)
);
COMMENT ON TABLE hr.paises IS 'detalha qual o pais, qual e sua sigla e a regiao ';
COMMENT ON COLUMN hr.paises._id_pais_ IS 'chave primaria da tabela paises, sigla do pais';
COMMENT ON COLUMN hr.paises.nome IS 'nome do pais';
COMMENT ON COLUMN hr.paises.id_regiao IS 'chave estregereira da tabela regioes do codigo das regioes';


CREATE UNIQUE INDEX paises_idx
 ON hr.paises
 ( nome );

CREATE TABLE hr.localizacoes (
                id_localizacao INTEGER NOT NULL,
                endereco VARCHAR(50),
                cidade VARCHAR(50),
                CEP VARCHAR(12),
                uf VARCHAR(25),
                id_pais CHAR(2) NOT NULL,
                CONSTRAINT id_localizacao PRIMARY KEY (id_localizacao)
);
COMMENT ON TABLE hr.localizacoes IS 'tem os detalhes da localizacao de escritorios e facilidades da empresa, nao clientes.';
COMMENT ON COLUMN hr.localizacoes.id_localizacao IS 'chave primaria da tabela localizacoes, contem o codigo da localizacao';
COMMENT ON COLUMN hr.localizacoes.endereco IS 'o endereco (rua, bairro e numero)';
COMMENT ON COLUMN hr.localizacoes.cidade IS 'a ciddade';
COMMENT ON COLUMN hr.localizacoes.CEP IS 'o cep da localizacao';
COMMENT ON COLUMN hr.localizacoes.uf IS 'a unidade federal da localizacao';
COMMENT ON COLUMN hr.localizacoes.id_pais IS 'chave estrangeira para a tabela paises, tem o codigo do pais';


CREATE TABLE hr.departamentos (
                id_departamento INTEGER NOT NULL,
                nome VARCHAR(50),
                id_localizacao INTEGER NOT NULL,
                id_gerente INTEGER NOT NULL,
                CONSTRAINT id_departamento PRIMARY KEY (id_departamento)
);
COMMENT ON TABLE hr.departamentos IS 'tem o codigo do departamento, seu nome, a localizacao e quem o gerencia';
COMMENT ON COLUMN hr.departamentos.id_departamento IS 'chave primaria da tabela departamentos, contem o codigo do departamento';
COMMENT ON COLUMN hr.departamentos.nome IS 'nome do departamentento';
COMMENT ON COLUMN hr.departamentos.id_localizacao IS 'chave estrangeira para a tabela localizacoes, tem o codigo da localizacao';
COMMENT ON COLUMN hr.departamentos.id_gerente IS 'chave primaria da tabela empregados, com a identificacao do empregado';


CREATE UNIQUE INDEX departamentos_idx
 ON hr.departamentos
 ( nome );

CREATE TABLE hr.empregados (
                id_empregado INTEGER NOT NULL,
                nome VARCHAR(75) NOT NULL,
                email VARCHAR(35) NOT NULL,
                telefone VARCHAR(20),
                data_contratacao DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                salario NUMERIC(8,2),
                comissao NUMERIC(4,2),
                id_departamento INTEGER NULL,
                id_supervisor INTEGER NOT NULL,
                CONSTRAINT id_empregado PRIMARY KEY (id_empregado)
);
COMMENT ON TABLE hr.empregados IS 'tem o codigo do empregado, nome, email, telefone, quando foi contratado, cargo, salario, comissao, departamento, e o surpevisor';
COMMENT ON COLUMN hr.empregados.id_empregado IS 'chave primaria da tabela empregados, com a identificacao do empregado';
COMMENT ON COLUMN hr.empregados.nome IS 'nome do empregado';
COMMENT ON COLUMN hr.empregados.email IS 'email do empregado antes de @';
COMMENT ON COLUMN hr.empregados.telefone IS 'numero de telefone, com o dodigo do pais e estado';
COMMENT ON COLUMN hr.empregados.data_contratacao IS 'quando o empregado iniciou no cargo atual';
COMMENT ON COLUMN hr.empregados.id_cargo IS 'chave estrangeira da tabela cargos, idenetifica os cargos';
COMMENT ON COLUMN hr.empregados.salario IS 'salario do empragado';
COMMENT ON COLUMN hr.empregados.comissao IS 'quanto o empregado ganhou de comissao, apenas dsponivel para o departamento de vendas';
COMMENT ON COLUMN hr.empregados.id_departamento IS 'chave estrangeira, contem codigo do departamento';
COMMENT ON COLUMN hr.empregados.id_supervisor IS 'o surpervisor direto do empregdo (auto-relacionamento)';


CREATE UNIQUE INDEX email
 ON hr.empregados
 ( email );

CREATE TABLE hr.historico_cargos (
                id_empregado INTEGER NOT NULL,
                data_inical DATE NOT NULL,
                data_final DATE NOT NULL,
                id_cargo VARCHAR(10) NOT NULL,
                d_departamento INTEGER NOT NULL,
                CONSTRAINT data_inicial PRIMARY KEY (id_empregado, data_inical)
);
COMMENT ON TABLE hr.historico_cargos IS 'contem o codigo do empregado, quando ele comecou, quando teminou no cargo e em qual departamento';
COMMENT ON COLUMN hr.historico_cargos.id_empregado IS 'chave primaria da tabela empregados, com a identificaao do empregado';
COMMENT ON COLUMN hr.historico_cargos.data_inical IS 'chave primaria composta, contem quando iniciou o cargo';
COMMENT ON COLUMN hr.historico_cargos.data_final IS 'quando o empregado deixou o cargo';
COMMENT ON COLUMN hr.historico_cargos.id_cargo IS 'chave estrangeira para cargos, indentica o cargo';
COMMENT ON COLUMN hr.historico_cargos.d_departamento IS 'chave estrageira para departamentos, tem codigo do departamento';


ALTER TABLE hr.empregados ADD CONSTRAINT cargos_empregados_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT cargos_historico_cargos_fk
FOREIGN KEY (id_cargo)
REFERENCES hr.cargos (id_cargo)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.paises ADD CONSTRAINT paises_regioes_fk
FOREIGN KEY (id_regiao)
REFERENCES hr.regioes (id_regiao_)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.localizacoes ADD CONSTRAINT localizacoes_paises_fk
FOREIGN KEY (id_pais)
REFERENCES hr.paises (_id_pais_)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT departamentos_localizacoes_fk
FOREIGN KEY (id_localizacao)
REFERENCES hr.localizacoes (id_localizacao)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT departamentos_historico_cargos_fk
FOREIGN KEY (d_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT departamentos_empregados_fk
FOREIGN KEY (id_departamento)
REFERENCES hr.departamentos (id_departamento)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.historico_cargos ADD CONSTRAINT empregados_historico_cargos_fk
FOREIGN KEY (id_empregado)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.departamentos ADD CONSTRAINT empregados_departamentos_fk
FOREIGN KEY (id_gerente)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;

ALTER TABLE hr.empregados ADD CONSTRAINT empregados_empregados_fk
FOREIGN KEY (id_supervisor)
REFERENCES hr.empregados (id_empregado)
ON DELETE NO ACTION
ON UPDATE NO ACTION
NOT DEFERRABLE;



INSERT INTO hr.regioes (id_regiao_, nome) VALUES
(1,'Europe' );
INSERT INTO hr.regioes (id_regiao_, nome) VALUES 
(2, 'Americas');
INSERT INTO hr.regioes (id_regiao_, nome) VALUES 
(3, 'Asia');
INSERT INTO hr.regioes (id_regiao_, nome) VALUES 
(4, 'Middle East and Africa');

INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('AR', 'Argentina', 2);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('AU', 'Australia', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('BE', 'Belgium', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('BR', 'Brazil', 2);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('CA', 'Canada', 2);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('CH', 'Switzerland', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('CN', 'China', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('DE', 'Germany', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('DK', 'Denmark', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('EG', 'Egypt', 4);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('FR', 'France', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('IL', 'Israel', 4);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('IN', 'India', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('IT', 'Italy', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('JP', 'Japan', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('KW', 'Kuwait', 4);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('ML', 'Malaysia', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('MX', 'Mexico', 2);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('NG', 'Nigeria', 4);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('NL', 'Netherlands', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('SG', 'Singapore', 3);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('UK', 'United Kingdom', 1);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('US', 'United States of America', 2);
INSERT INTO hr.paises ( _id_pais_, nome, id_regiao) VALUES
('ZM', 'Zambia', 4);

INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1000, '1297 Via Cola di Rie','Roma', '00989','null','IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1100, '93091 Calle della Testa','Venice', '10934','null','IT');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1200, '2017 Shinjuku-ku','Tokyo', '1689','Tokyo Prefecture','JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1300, '9450 Kamiya-cho','Hiroshima', '6823','null','JP');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1400, '2014 Jabberwocky Rd','Southlake', '26192','Texas','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1500, '2011 Interiors Blvd','South San Francisco', '99236','California','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1600, '2007 Zagora St','South Brunswick', '50090','New Jersey','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1700, '2004 Charade Rd','Seattle', '98199','Washington','US');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1800, '147 Spadina Ave','Toronto', 'M5V 2L7','Ontario','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(1900, '6092 Boxwood St','Whitehorse', 'YSW 9T2','Yukon','CA');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2000, '40-5-12 Laogianggen','Beijing', '190518','null','CN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2100, '1298 Vileparle (E)','Bombay', '490231','Maharashtra','IN');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2200, '12-98 Victoria Street','Sydney', '2901','New South Wales','AU');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2300, '198 Clementi North','Singapore', '540198','null','SG');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2400, '8204 Arthur St','London', 'null', 'null','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2500, 'Magdalen Centre, The Oxford Science Park', 'OX9 9ZB','Oxford','Oxford','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2600, '9702 Chester Road','Stretford', '09629850293','Manchester','UK');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2700, 'Schwanthalerstr. 7031','Munich', '80925','Bavaria','DE');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2800, 'Rua Frei Caneca 1360 ','Sao Paulo', '01307-002','Sao Paulo','BR');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(2900, '20 Rue des Corps-Saints','Geneva', '1730','Geneve','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(3000, 'Murtenstrasse 921','Bern', '3095','BE','CH');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(3100, 'Pieter Breughelstraat 837','Utrecht', '3029SK','Utrecht','NL');
INSERT INTO hr.localizacoes (id_localizacao, endereco, cidade, CEP, uf, id_pais) VALUES 
(3200, 'Mariano Escobedo 9991', 'Mexico City', '11932','Distrito Federal,','MX');


INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('AD_PRES','President',20080,40000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('AD_VP','Administration Vice President',15000,30000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('AD_ASST','Administration Assistant',3000,6000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('FI_MGR','Finance Manager',8200,16000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('FI_ACCOUNT','Accountant',4200,9000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('AC_MGR','Accounting Manager',8200,16000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('AC_ACCOUNT','Public Accountant',4200,9000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('SA_MAN','Sales Manager',10000,20080);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('SA_REP','Sales Representative',6000,12008);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('PU_MAN','Purchasing Manager',8000,15000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('PU_CLERK','Purchasing Clerk',2500,5500);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('ST_MAN','Stock Manager',5500,8500);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('ST_CLERK','Stock Clerk',2008,5000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('SH_CLERK','Shipping Clerk',2500,5500);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('IT_PROG','Programmer',4000,10000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('MK_MAN','Marketing Manager',9000,15000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('MK_REP','Marketing Representative',4000,9000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('HR_REP','Human Resources Representative',4000,9000);
INSERT INTO hr.cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
('PR_REP','Public Relations Representative',4500,10500);

INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
 id_supervisor, id_departamento) VALUES 
(0, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, 100, null);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(90, 'Executive', 1700, 100);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(60, 'IT', 1400, 0);

INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
 id_supervisor, id_departamento) VALUES 
(100, 'Steven King', 'SKING', '515.123.4567', '2003-06-17', 'AD_PRES', 24000, null, null, 90);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(101, 'Neena Kochhar', 'NKOCHHAR', '515.123.4568', '2005-09-21', 'AD_VP', 17000, null, 100, 90);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(102, 'Lex De Haan', 'LDEHAAN', '515.123.4569', '2001-01-13', 'AD_VP', 17000, null, 100, 90);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(103, 'Alexander Hunold', 'AHUNOLD', '590.423.4567', '2006-01-03', 'IT_PROG', 9000, null, 102, 60);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(104, 'Bruce Ernst', 'BERNST', '590.423.4568', '2007-05-21', 'IT_PROG', 6000, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(105, 'David Austin', 'DAUSTIN', '590.423.4569', '2005-06-25', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(106, 'Valli Pataballa', 'VPATABAL', '590.423.4560', '2006-02-05', 'IT_PROG', 4800, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(107, 'Diana Lorentz', 'DLORENTZ', '590.423.5567', '2007-02-07', 'IT_PROG', 4200, null, 103, 60);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(108, 'Nancy Greenberg', 'NGREENBE', '515.124.4569', '2002-08-17', 'FI_MGR', 12008, null, 101, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(109, 'Daniel Faviet', 'DFAVIET', '515.124.4169', '2002-08-16', 'FI_ACCOUNT', 9000, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(110, 'John Chen', 'JCHEN', '515.124.4269', '2005-09-28', 'FI_ACCOUNT', 8200, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(111, 'Ismael Sciarra', 'ISCIARRA', '515.124.4369', '2005-09-30', 'FI_ACCOUNT', 7700, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(112, 'Jose Manuel Urman', 'JMURMAN', '515.124.4469', '2006-03-07', 'FI_ACCOUNT', 7800, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(113, 'Luis Popp', 'LPOPP', '515.124.4567', '2007-12-07', 'FI_ACCOUNT', 6900, null, 108, 100);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(114, 'Den Raphaely', 'DRAPHEAL', '515.127.4561', '2002-12-07', 'PU_MAN', 11000, null, 100, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(115, 'Alexander Khoo', 'AKHOO', '515.127.4562', '2003-05-18', 'PU_CLERK', 3100, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(116, 'Shelli Baida', 'SBAIDA', '515.127.4563', '2005-12-24', 'PU_CLERK', 2900, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(117, 'Sigal Tobias', 'STOBIAS', '515.127.4564', '2005-07-24', 'PU_CLERK', 2800, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(118, 'Guy Himuro', 'GHIMURO', '515.127.4565', '2006-11-15', 'PU_CLERK', 2600, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(119, 'Karen Colmenares', 'KCOLMENA', '515.127.4566', '2007-08-10', 'PU_CLERK', 2500, null, 114, 30);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(120, 'Matthew Weiss', 'MWEISS', '650.123.1234', '2004-07-18', 'ST_MAN', 8000, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(121, 'Adam Fripp', 'AFRIPP', '650.123.2234', '2005-04-10', 'ST_MAN', 8200, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(122, 'Payam Kaufling', 'PKAUFLIN', '650.123.3234', '2003-05-01', 'ST_MAN', 7900, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(123, 'Shanta Vollman', 'SVOLLMAN', '650.123.4234', '2005-10-10', 'ST_MAN', 6500, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(124, 'Kevin Mourgos', 'KMOURGOS', '650.123.5234', '2007-11-16', 'ST_MAN', 5800, null, 100, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(125, 'Julia Nayer', 'JNAYER', '650.124.1214', '2005-07-16', 'ST_CLERK', 3200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(126, 'Irene Mikkilineni', 'IMIKKILI', '650.124.1224', '2006-09-28', 'ST_CLERK', 2700, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(127, 'James Landry', 'JLANDRY', '650.124.1334', '2007-01-14', 'ST_CLERK', 2400, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(128, 'Steven Markle', 'SMARKLE', '650.124.1434', '2008-03-08', 'ST_CLERK', 2200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(129, 'Laura Bissot', 'LBISSOT', '650.124.5234', '2005-08-20', 'ST_CLERK', 3300, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(130, 'Mozhe Atkinson', 'MATKINSO', '650.124.6234', '2005-10-30', 'ST_CLERK', 2800, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(131, 'James Marlow', 'JAMRLOW', '650.124.7234', '2005-02-16', 'ST_CLERK', 2500, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(132, 'TJ Olson', 'TJOLSON', '650.124.8234', '2007-04-10', 'ST_CLERK', 2100, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(133, 'Jason Mallin', 'JMALLIN', '650.127.1934', '2004-06-14', 'ST_CLERK', 3300, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(134, 'Michael Rogers', 'MROGERS', '650.127.1834', '2006-08-26', 'ST_CLERK', 2900, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(135, 'Ki Gee', 'KGEE', '650.127.1734', '2007-12-12', 'ST_CLERK', 2400, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(136, 'Hazel Philtanker', 'HPHILTAN', '650.127.1634', '2008-02-06', 'ST_CLERK', 2200, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(137, 'Renske Ladwig', 'RLADWIG', '650.121.1234', '2003-07-14', 'ST_CLERK', 3600, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(138, 'Stephen Stiles', 'SSTILES', '650.121.2034', '2005-10-26', 'ST_CLERK', 3200, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(139, 'John Seo', 'JSEO', '650.121.2019', '2006-02-12', 'ST_CLERK', 2700, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(140, 'Joshua Patel', 'JPATEL', '650.121.1834', '2006-04-06', 'ST_CLERK', 2500, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(141, 'Trenna Rajs', 'TRAJS', '650.121.8009', '2003-10-17', 'ST_CLERK', 3500, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(142, 'Curtis Davies', 'CDAVIES', '650.121.2994', '2005-01-29', 'ST_CLERK', 3100, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(143, 'Randall Matos', 'RMATOS', '650.121.2874', '2006-03-15', 'ST_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(144, 'Peter Vargas', 'PVARGAS', '650.121.2004', '2006-07-09', 'ST_CLERK', 2500, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(145, 'John Russell', 'JRUSSEL', '011.44.1344.429268', '2004-10-01', 'SA_MAN', 14000, .4, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(146, 'Karen Partners', 'KPARTNER', '011.44.1344.467268', '2005-01-05', 'SA_MAN', 13500, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(147, 'Alberto Errazuriz', 'AERRAZUR', '011.44.1344.429278', '2005-03-10', 'SA_MAN', 12000, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(148, 'Gerald Cambrault', 'GCAMBRAU', '011.44.1344.619268', '2007-10-15', 'SA_MAN', 11000, .3, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(149, 'Eleni Zlotkey', 'EZLOTKEY', '011.44.1344.429018', '2008-01-29', 'SA_MAN', 10500, .2, 100, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(150, 'Peter Tucker', 'PTUCKER', '011.44.1344.129268', '2005-01-30', 'SA_REP', 10000, .3, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(151, 'David Bernstein', 'DBERNSTE', '011.44.1344.345268', '2005-03-24', 'SA_REP', 9500, .25, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(152, 'Peter Hall', 'PHALL', '011.44.1344.478968', '2005-08-20', 'SA_REP', 9000, .25, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(153, 'Christopher Olsen', 'COLSEN', '011.44.1344.498718', '2006-03-30', 'SA_REP', 8000, .2, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(154, 'Nanette Cambrault', 'NCAMBRAU', '011.44.1344.987668', '2006-12-09', 'SA_REP', 7500, .2, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(155, 'Oliver Tuvault', 'OTUVAULT', '011.44.1344.486508', '2007-11-23', 'SA_REP', 7000, .15, 145, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(156, 'Janette King', 'JKING', '011.44.1345.429268', '2004-01-30', 'SA_REP', 10000, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(157, 'Patrick Sully', 'PSULLY', '011.44.1345.929268', '2004-03-04', 'SA_REP', 9500, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(158, 'Allan McEwen', 'AMCEWEN', '011.44.1345.829268', '2004-08-01', 'SA_REP', 9000, .35, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(159, 'Lindsey Smith', 'LSMITH', '011.44.1345.729268', '2005-03-10', 'SA_REP', 8000, .3, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(160, 'Louise Doran', 'LDORAN', '011.44.1345.629268', '2005-12-15', 'SA_REP', 7500, .3, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(161, 'Sarath Sewall', 'SSEWALL', '011.44.1345.529268', '2006-11-03', 'SA_REP', 7000, .25, 146, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(162, 'Clara Vishney', 'CVISHNEY', '011.44.1346.129268', '2005-11-11', 'SA_REP', 10500, .25, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(163, 'Danielle Greene', 'DGREENE', '011.44.1346.229268', '2007-03-19', 'SA_REP', 9500, .15, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(164, 'Mattea Marvins', 'MMARVINS', '011.44.1346.329268', '2008-01-24', 'SA_REP', 7200, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(165, 'David Lee', 'DLEE', '011.44.1346.529268', '2008-02-23', 'SA_REP', 6800, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(166, 'Sundar Ande', 'SANDE', '011.44.1346.629268', '2008-03-24', 'SA_REP', 6400, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(167, 'Amit Banda', 'ABANDA', '011.44.1346.729268', '2008-04-21', 'SA_REP', 6200, .1, 147, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(168, 'Lisa Ozer', 'LOZER', '011.44.1343.929268', '2005-03-11', 'SA_REP', 11500, .25, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(169, 'Harrison Bloom', 'HBLOOM', '011.44.1343.829268', '2006-03-23', 'SA_REP', 10000, .2, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(170, 'Tayler Fox', 'TFOX', '011.44.1343.729268', '2006-01-24', 'SA_REP', 9600, .2, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(171, 'William Smith', 'WSMITH', '011.44.1343.629268', '2007-02-23', 'SA_REP', 7400, .15, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(172, 'Elizabeth Bates', 'EBATES', '011.44.1343.529268', '2007-03-24', 'SA_REP', 7300, .15, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(173, 'Sundita Kumar', 'SKUMAR', '011.44.1343.329268', '2008-04-21', 'SA_REP', 6100, .1, 148, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(174, 'Ellen Abel', 'EABEL', '011.44.1644.429267', '2004-05-11', 'SA_REP', 11000, .3, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(175, 'Alyssa Hutton', 'AHUTTON', '011.44.1644.429266', '2005-03-19', 'SA_REP', 8800, .25, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(176, 'Jonathon Taylor', 'JTAYLOR', '011.44.1644.429265', '2006-03-24', 'SA_REP', 8600, .2, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(177, 'Jack Livingston', 'JLIVINGS', '011.44.1644.429264', '2006-04-23', 'SA_REP', 8400, .2, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(178, 'Kimberely Grant', 'KGRANT', '011.44.1644.429263', '2007-05-24', 'SA_REP', 7000, .15, 149, null);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(179, 'Charles Johnson', 'CJOHNSON', '011.44.1644.429262', '2008-01-04', 'SA_REP', 6200, .1, 149, 80);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(180, 'Winston Taylor', 'WTAYLOR', '650.507.9876', '2006-01-24', 'SH_CLERK', 3200, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(181, 'Jean Fleaur', 'JFLEAUR', '650.507.9877', '2006-02-23', 'SH_CLERK', 3100, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(182, 'Martha Sullivan', 'MSULLIVA', '650.507.9878', '2007-06-21', 'SH_CLERK', 2500, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(183, 'Girard Geoni', 'GGEONI', '650.507.9879', '2008-02-03', 'SH_CLERK', 2800, null, 120, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(184, 'Nandita Sarchand', 'NSARCHAN', '650.509.1876', '2004-01-27', 'SH_CLERK', 4200, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(185, 'Alexis Bull', 'ABULL', '650.509.2876', '2005-02-20', 'SH_CLERK', 4100, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(186, 'Julia Dellinger', 'JDELLING', '650.509.3876', '2006-06-24', 'SH_CLERK', 3400, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(187, 'Anthony Cabrio', 'ACABRIO', '650.509.4876', '2007-02-07', 'SH_CLERK', 3000, null, 121, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(188, 'Kelly Chung', 'KCHUNG', '650.505.1876', '2005-06-14', 'SH_CLERK', 3800, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(189, 'Jennifer Dilly', 'JDILLY', '650.505.2876', '2005-08-13', 'SH_CLERK', 3600, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(190, 'Timothy Gates', 'TGATES', '650.505.3876', '2006-07-11', 'SH_CLERK', 2900, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(191, 'Randall Perkins', 'RPERKINS', '650.505.4876', '2007-12-19', 'SH_CLERK', 2500, null, 122, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(192, 'Sarah Bell', 'SBELL', '650.501.1876', '2004-02-04', 'SH_CLERK', 4000, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(193, 'Britney Everett', 'BEVERETT', '650.501.2876', '2005-03-03', 'SH_CLERK', 3900, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(194, 'Samuel McCain', 'SMCCAIN', '650.501.3876', '2006-07-01', 'SH_CLERK', 3200, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(195, 'Vance Jones', 'VJONES', '650.501.4876', '2007-03-17', 'SH_CLERK', 2800, null, 123, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(196, 'Alana Walsh', 'AWALSH', '650.507.9811', '2006-04-24', 'SH_CLERK', 3100, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(197, 'Kevin Feeney', 'KFEENEY', '650.507.9822', '2006-05-23', 'SH_CLERK', 3000, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (198, 'Donald OConnell', 'DOCONNEL', '650.507.9833', '2007-06-21', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (199, 'Douglas Grant', 'DGRANT', '650.507.9844', '2008-01-13', 'SH_CLERK', 2600, null, 124, 50);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (200, 'Jennifer Whalen', 'JWHALEN', '515.123.4444', '2003-09-17', 'AD_ASST', 4400, null, 101, 10);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (201, 'Michael Hartstein', 'MHARTSTE', '515.123.5555', '2004-02-17', 'MK_MAN', 13000, null, 100, 20);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (202, 'Pat Fay', 'PFAY', '603.123.6666', '2005-08-17', 'MK_REP', 6000, null, 201, 20);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (203, 'Susan Mavris', 'SMAVRIS', '515.123.7777', '2002-06-07', 'HR_REP', 6500, null, 101, 40);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (204, 'Hermann Baer', 'HBAER', '515.123.8888', '2002-06-07', 'PR_REP', 10000, null, 101, 70);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) 
VALUES (205, 'Shelley Higgins', 'SHIGGINS', '515.123.8080', '2002-06-07', 'AC_MGR', 12008, null, 101, 110);
INSERT INTO hr.empregados (id_empregado, nome, email, telefone, data_contratacao, id_cargo, salario, comissao,
id_supervisor, id_departamento) VALUES 
(206, 'William Gietz', 'WGIETZ', '515.123.8181', '2002-06-07', 'AC_ACCOUNT', 8300, null, 205, 110);



INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES
(10, 'Administration', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(20, 'Marketing', 1800, 201);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(30, 'Purchasing', 1700, 114);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(40, 'Human Resources', 2400, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(50, 'Shipping', 1500, 124, 0);

INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(70, 'Public Relations', 2700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(80, 'Sales', 2500, 149);

INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(100, 'Finance', 1700, 108);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(110, 'Accounting', 1700, 205);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(120, 'Treasury', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(130, 'Corporate Tax', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(140, 'Control And Credit', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(150, 'Shareholder Services', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(160, 'Benefits', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(170, 'Manufacturing', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(180, 'Construction', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(190, 'Contracting', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(200, 'Operations', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(210, 'IT Support', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(220, 'NOC', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(230, 'IT Helpdesk', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(240, 'Government Sales', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(250, 'Retail Sales', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(260, 'Recruiting', 1700, 0);
INSERT INTO hr.departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES 
(270, 'Payroll', 1700, 0);





INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(200, '1995-09-17', '2001-06-17', 'AD_ASST',90);													       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(101, '1997-09-21', '2001-10-27', 'AC_ACCOUNT',110);
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(102, '2001-01-13', '2006-07-24', 'IT_PROG',60);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(101, '2001-10-28', '2005-03-15', 'AC_MGR',110);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(200, '2002-07-01', '2006-12-31', 'AC_ACCOUNT',90);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(201, '2004-02-17', '2007-12-19', 'MK_REP',20);												
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(114, '2006-03-24', '2007-12-31', 'ST_CLERK',50);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(176, '2006-03-24', '2006-12-31', 'SA_REP',80);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(176, '2007-01-01', '2007-12-31', 'SA_MAN',80);														       
INSERT INTO hr.historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(122, '2007-01-01', '2007-12-31', 'ST_CLERK',50);

ALTER DATABASE uvv OWNER TO postgres;
ALTER SCHEMA hr OWNER TO postgres;
