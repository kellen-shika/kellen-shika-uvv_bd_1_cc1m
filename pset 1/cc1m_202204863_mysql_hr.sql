CREATE USER 'rayssa'@'localhost' IDENTIFIED BY 'root';
GRANT ALL ON *.* TO 'rayssa'@'localhost';

FLUSH PRIVILEGES;

CREATE DATABASE uvv;

CREATE TABLE cargos (
                id_cargo VARCHAR(10) NOT NULL,
                cargo VARCHAR(35) NOT NULL,
                salario_minimo DECIMAL(8,2),
                salario_maximmo DECIMAL(8,2),
                PRIMARY KEY (id_cargo)
);

ALTER TABLE cargos COMMENT 'tabela com o cargo e salario minimo e maximo';

ALTER TABLE cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'chave primaria, codigo do cargo';

ALTER TABLE cargos MODIFY COLUMN salario_minimo DECIMAL(8, 2) COMMENT 'o menor salario';

ALTER TABLE cargos MODIFY COLUMN salario_maximmo DECIMAL(8, 2) COMMENT 'o maior salario';


CREATE UNIQUE INDEX cargos_idx
 ON cargos
 ( cargo );

CREATE TABLE regioes (
                id_regiao_ INT NOT NULL,
                nome VARCHAR(25) NOT NULL,
                PRIMARY KEY (id_regiao_)
);

ALTER TABLE regioes COMMENT 'cotem a regiao';

ALTER TABLE regioes MODIFY COLUMN id_regiao_ INTEGER COMMENT 'chave primaria da tabela regioes, contem codigo da regiao';

ALTER TABLE regioes MODIFY COLUMN nome VARCHAR(25) COMMENT 'nome da regiao';


CREATE UNIQUE INDEX regioes_idx
 ON regioes
 ( nome );

CREATE TABLE paises (
                _id_pais_ CHAR(2) NOT NULL,
                nome VARCHAR(50) NOT NULL,
                id_regiao INT NOT NULL,
                PRIMARY KEY (_id_pais_)
);

ALTER TABLE paises COMMENT 'detalha qual o pais, regiao e a sigla';

ALTER TABLE paises MODIFY COLUMN _id_pais_ CHAR(2) COMMENT 'chave primaria da tabela paises, sigla do pais';

ALTER TABLE paises MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do pais';

ALTER TABLE paises MODIFY COLUMN id_regiao INTEGER COMMENT 'chave estregereira da tabela regioes do codigo das regioes';


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

ALTER TABLE localizacoes COMMENT 'tem os detalhes da localizacao de escritorios e facilidades da empresa, nao clientes.';

ALTER TABLE localizacoes MODIFY COLUMN id_localizacao INTEGER COMMENT 'localizacao';

ALTER TABLE localizacoes MODIFY COLUMN endereco VARCHAR(50) COMMENT 'o endereco (rua, bairro e numero)';

ALTER TABLE localizacoes MODIFY COLUMN cidade VARCHAR(50) COMMENT 'a ciddade';

ALTER TABLE localizacoes MODIFY COLUMN CEP VARCHAR(12) COMMENT 'o cep da localizacao';

ALTER TABLE localizacoes MODIFY COLUMN uf VARCHAR(25) COMMENT 'a unidade federal da localizacao';

ALTER TABLE localizacoes MODIFY COLUMN id_pais CHAR(2) COMMENT 'chave estrangeira para a tabela paises, tem o codigo do pais';


CREATE TABLE departamentos (
                id_departamento INT NOT NULL,
                nome VARCHAR(50),
                id_localizacao INT NOT NULL,
                id_gerente INT NOT NULL,
                PRIMARY KEY (id_departamento)
);

ALTER TABLE departamentos COMMENT 'tem o codigo do departamento, seu nome, a localizacao e quem o gerencia';

ALTER TABLE departamentos MODIFY COLUMN id_departamento INTEGER COMMENT 'departamento';

ALTER TABLE departamentos MODIFY COLUMN nome VARCHAR(50) COMMENT 'nome do departamentento';

ALTER TABLE departamentos MODIFY COLUMN id_localizacao INTEGER COMMENT 'a localizacao';

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

ALTER TABLE empregados COMMENT 'tem o codigo do empregado, nome, email, telefone, quando foi contratado, cargo, salario, comissao, departamento, e o surpevisor';

ALTER TABLE empregados MODIFY COLUMN id_empregado INTEGER COMMENT 'empregado';

ALTER TABLE empregados MODIFY COLUMN nome VARCHAR(75) COMMENT 'nome do empregado';

ALTER TABLE empregados MODIFY COLUMN email VARCHAR(35) COMMENT 'email do empregado antes de @';

ALTER TABLE empregados MODIFY COLUMN telefone VARCHAR(20) COMMENT 'numero de telefone, com o dodigo do pais e estado';

ALTER TABLE empregados MODIFY COLUMN data_contratacao DATE COMMENT 'quando o empregado iniciou no cargo atual';

ALTER TABLE empregados MODIFY COLUMN id_carg0 VARCHAR(10) COMMENT 'chave estrangeira da tabela cargos, idenetifica os cargos';

ALTER TABLE empregados MODIFY COLUMN salario DECIMAL(8, 2) COMMENT 'salario do empragado';

ALTER TABLE empregados MODIFY COLUMN comissao DECIMAL(4, 2) COMMENT ' o departamento de vendas';

ALTER TABLE empregados MODIFY COLUMN id_departamento INTEGER COMMENT 'chave estrangeira, contem codigo do departamento';

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

ALTER TABLE historico_cargos COMMENT 'contem o codigo do empregado, quando ele comecou, quando teminou no cargo e em qual departamento';

ALTER TABLE historico_cargos MODIFY COLUMN id_empregado INTEGER COMMENT 'empregado';

ALTER TABLE historico_cargos MODIFY COLUMN data_inical DATE COMMENT 'chave primaria composta, contem quando iniciou o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN data_final DATE COMMENT 'quando o empregado deixou o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN id_cargo VARCHAR(10) COMMENT 'chave estrangeira para cargos, indentica o cargo';

ALTER TABLE historico_cargos MODIFY COLUMN d_departamento INTEGER COMMENT 'nome do departamento';


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

INSERT INTO regioes (id_regiao_, nome) VALUES
( region_id|| ', ''' || IFNULL(region_name, 'null') )
;

INSERT INTO departamentos (id_departamento, nome, id_localizacao, id_gerente) VALUES
( department_id || ', ''' || 
department_name || ', ' ||
IFNULL(location_id, 'null')  || ''', ''' ||
IFNULL(manager_id, 'null') )
;

INSERT INTO localizacoes (id_localizacao, endereco, cidade, CEP,  uf, id_pais) VALUES
( location_id|| ', ''' || 
street_address|| ', ' ||
city || ''', ''' || postal_code || ''', ''' ||
state_province || ''', ''' || IFNULL(country_id, 'null') )
;

INSERT INTO cargos ( id_cargo, cargo, salario_minimo, salario_maximmo) VALUES
( job_id || ', ''' || IFNULL(job_title, 'null') || ' ,''' ||
 MIN(min_salary) || ''', ''' || 
 MAX(max_salary) )
;

INSERT INTO historico_cargos ( id_empregado, data_inical, data_final, id_cargo, d_departamento ) VALUES
(employee_id || ', ''' ||
DATE_FORMAT(start_date, '%Y-% M-%D') || ' ,''' ||
IFNULL(DATE_FORMAT(end_date, '%Y-% M-%D'), 'null') || ''', ''' || IFNULL(job_id, 'null') 
|| ''', ''' || IFNULL(department_id, 'null') )
;

INSERT INTO empregados (id_empregado, nome, email,
telefone, data_contratacao, id_cargo, salario,
comissao, id_supervisor, id_departamento) VALUES
( employee_id || ', ''' || IFNULL(first_name || ' ' ||
last_name, 'null') || ''', ''' || IFNULL(email, 'null') || ''', ''' ||
phone_number || ''', ''' ||
IFNULL(DATE_FORMAT(hire_date, '%Y-% M-%D'), 'null') || ', ''' ||
IFNULL(job_id, 'null') || ''', ' || salary || ', ' ||
IFNULL(commission_pct, 'null') || ', ' ||
IFNULL(manager_id, 'null') || ', ' ||
IFNULL(department_id, 'null') )
;

INSERT INTO paises ( _id_pais_, nome, id_regiao) VALUES
(country_id || ', ''' ||
IFNULL( country_name , 'null')|| ', ''' ||
IFNULL(region_id, 'null'))
;
