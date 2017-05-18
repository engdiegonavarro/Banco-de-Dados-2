CREATE SCHEMA rev_p1;


ALTER SCHEMA rev_p1 OWNER TO postgres;

SET search_path = rev_p1, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

CREATE TABLE cidade (
    cod_cidade integer NOT NULL,
    nome_cidade character varying(100) NOT NULL,
    uf character(2) NOT NULL
);


ALTER TABLE rev_p1.cidade OWNER TO postgres;

CREATE SEQUENCE cidade_cod_cidade_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;


ALTER TABLE rev_p1.cidade_cod_cidade_seq OWNER TO postgres;

ALTER SEQUENCE cidade_cod_cidade_seq OWNED BY cidade.cod_cidade;


SELECT pg_catalog.setval('cidade_cod_cidade_seq', 4, true);

CREATE TABLE cliente (
    cod_cliente integer NOT NULL,
    nome_cliente character varying(70) NOT NULL,
    telefone character varying(20),
    cod_cidade integer NOT NULL
);

ALTER TABLE rev_p1.cliente OWNER TO postgres;

CREATE SEQUENCE cliente_cod_cliente_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE rev_p1.cliente_cod_cliente_seq OWNER TO postgres;

ALTER SEQUENCE cliente_cod_cliente_seq OWNED BY cliente.cod_cliente;

SELECT pg_catalog.setval('cliente_cod_cliente_seq', 4, true);

CREATE TABLE estado (
    uf character(2) NOT NULL,
    nome_estado character varying(50) NOT NULL,
    cod_regiao integer NOT NULL
);

ALTER TABLE rev_p1.estado OWNER TO postgres;

CREATE TABLE produto (
    cod_produto integer NOT NULL,
    descricao_produto character varying(100) NOT NULL,
    valor_venda numeric(12,2) NOT NULL,
    qtd_estoque numeric(15,4) DEFAULT 0 NOT NULL
);

ALTER TABLE rev_p1.produto OWNER TO postgres;

CREATE SEQUENCE produto_cod_produto_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE rev_p1.produto_cod_produto_seq OWNER TO postgres;

ALTER SEQUENCE produto_cod_produto_seq OWNED BY produto.cod_produto;

SELECT pg_catalog.setval('produto_cod_produto_seq', 6, true);

CREATE TABLE produtos_venda (
    cod_venda integer NOT NULL,
    cod_produto integer NOT NULL,
    qtd_vendida numeric(14,4) DEFAULT 1 NOT NULL,
    valor_uni_venda numeric(12,2) NOT NULL,
    baixa_estoque boolean DEFAULT false NOT NULL
);

ALTER TABLE rev_p1.produtos_venda OWNER TO postgres;

CREATE TABLE regiao (
    cod_regiao integer NOT NULL,
    nome_regiao character varying(30) NOT NULL
);

ALTER TABLE rev_p1.regiao OWNER TO postgres;

CREATE SEQUENCE regiao_cod_regiao_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE rev_p1.regiao_cod_regiao_seq OWNER TO postgres;

ALTER SEQUENCE regiao_cod_regiao_seq OWNED BY regiao.cod_regiao;

SELECT pg_catalog.setval('regiao_cod_regiao_seq', 5, true);

CREATE TABLE total_vendas_estado (
    uf character(2) NOT NULL,
    cod_produto integer NOT NULL,
    mes_referencia integer NOT NULL,
    ano_referencia integer NOT NULL,
    qtd_vendida numeric(20,4) NOT NULL,
    vlr_total_vendido numeric(20,2) NOT NULL
);

ALTER TABLE rev_p1.total_vendas_estado OWNER TO postgres;

CREATE TABLE total_vendas_regiao (
    cod_regiao integer NOT NULL,
    mes_referencia integer NOT NULL,
    ano_referencia integer NOT NULL,
    cod_produto integer NOT NULL,
    qtd_vendida numeric(20,4) NOT NULL,
    vlr_total_vendido numeric(20,2) NOT NULL
);

ALTER TABLE rev_p1.total_vendas_regiao OWNER TO postgres;

CREATE TABLE venda (
    cod_venda integer NOT NULL,
    data_venda date NOT NULL,
    cod_cliente integer NOT NULL
);

ALTER TABLE rev_p1.venda OWNER TO postgres;

CREATE SEQUENCE venda_cod_venda_seq
    START WITH 1
    INCREMENT BY 1
    NO MAXVALUE
    NO MINVALUE
    CACHE 1;

ALTER TABLE rev_p1.venda_cod_venda_seq OWNER TO postgres;

ALTER SEQUENCE venda_cod_venda_seq OWNED BY venda.cod_venda;

SELECT pg_catalog.setval('venda_cod_venda_seq', 1, false);

ALTER TABLE cidade ALTER COLUMN cod_cidade SET DEFAULT nextval('cidade_cod_cidade_seq'::regclass);

ALTER TABLE cliente ALTER COLUMN cod_cliente SET DEFAULT nextval('cliente_cod_cliente_seq'::regclass);

ALTER TABLE produto ALTER COLUMN cod_produto SET DEFAULT nextval('produto_cod_produto_seq'::regclass);

ALTER TABLE regiao ALTER COLUMN cod_regiao SET DEFAULT nextval('regiao_cod_regiao_seq'::regclass);

ALTER TABLE venda ALTER COLUMN cod_venda SET DEFAULT nextval('venda_cod_venda_seq'::regclass);

INSERT INTO cidade VALUES (1, 'CAMPO GRANDE', 'MS');
INSERT INTO cidade VALUES (2, 'DOURADOS', 'MS');
INSERT INTO cidade VALUES (3, 'GOIANIA', 'GO');
INSERT INTO cidade VALUES (4, 'CUIABÁ', 'MT');

INSERT INTO cliente VALUES (1, 'HUGO B. BUCKER', '99998888', 1);
INSERT INTO cliente VALUES (2, 'ROBERT DE NIRO DA SILVA', '88889999', 1);
INSERT INTO cliente VALUES (3, 'JOHN TRAVOLTA PEREIRA', '88887777', 2);
INSERT INTO cliente VALUES (4, 'SHAKIRA REGINA OLIVEIRA', '98989898', 2);

INSERT INTO estado VALUES ('MS', 'MATO GROSSO DO SUL', 1);
INSERT INTO estado VALUES ('MT', 'MATO GROSSO', 1);
INSERT INTO estado VALUES ('GO', 'GOIÁS', 1);

INSERT INTO produto VALUES (1, 'COCA-COLA', 1.50, 200.0000);
INSERT INTO produto VALUES (2, 'GUARANÁ ANTARTICA', 1.50, 130.0000);
INSERT INTO produto VALUES (3, 'PEPSI COLA', 1.50, 100.0000);
INSERT INTO produto VALUES (4, 'CANINHA 51', 3.00, 200.0000);
INSERT INTO produto VALUES (5, 'KAISER', 3.50, 500.0000);
INSERT INTO produto VALUES (6, 'VODKA', 10.00, 30.0000);

INSERT INTO regiao VALUES (1, 'CENTRO OESTE');
INSERT INTO regiao VALUES (2, 'SUL');
INSERT INTO regiao VALUES (3, 'NORTE');
INSERT INTO regiao VALUES (5, 'SUDESTE');
INSERT INTO regiao VALUES (4, 'NORDESTE');

ALTER TABLE ONLY cidade
    ADD CONSTRAINT pk_cidade PRIMARY KEY (cod_cidade);

ALTER TABLE ONLY cliente
    ADD CONSTRAINT pk_cliente PRIMARY KEY (cod_cliente);

ALTER TABLE ONLY estado
    ADD CONSTRAINT pk_estado PRIMARY KEY (uf);

ALTER TABLE ONLY produto
    ADD CONSTRAINT pk_produto PRIMARY KEY (cod_produto);

ALTER TABLE ONLY produtos_venda
    ADD CONSTRAINT pk_produtos_venda PRIMARY KEY (cod_venda, cod_produto);

ALTER TABLE ONLY regiao
    ADD CONSTRAINT pk_regiao PRIMARY KEY (cod_regiao);

ALTER TABLE ONLY total_vendas_estado
    ADD CONSTRAINT pk_total_vendas_estado PRIMARY KEY (uf, cod_produto, mes_referencia, ano_referencia);

ALTER TABLE ONLY total_vendas_regiao
    ADD CONSTRAINT pk_total_vendas_regiao PRIMARY KEY (cod_regiao, mes_referencia, ano_referencia, cod_produto);

ALTER TABLE ONLY venda
    ADD CONSTRAINT pk_venda PRIMARY KEY (cod_venda);

ALTER TABLE ONLY cliente
    ADD CONSTRAINT cidade_cliente_fk FOREIGN KEY (cod_cidade) REFERENCES cidade(cod_cidade);

ALTER TABLE ONLY venda
    ADD CONSTRAINT cliente_venda_fk FOREIGN KEY (cod_cliente) REFERENCES cliente(cod_cliente);

ALTER TABLE ONLY cidade
    ADD CONSTRAINT estado_cidade_fk FOREIGN KEY (uf) REFERENCES estado(uf);

ALTER TABLE ONLY total_vendas_estado
    ADD CONSTRAINT estado_total_vendas_estado_fk FOREIGN KEY (uf) REFERENCES estado(uf);

ALTER TABLE ONLY produtos_venda
    ADD CONSTRAINT produto_produtos_venda_fk FOREIGN KEY (cod_produto) REFERENCES produto(cod_produto);

ALTER TABLE ONLY total_vendas_regiao
    ADD CONSTRAINT produto_total_vendas_regiao_fk FOREIGN KEY (cod_produto) REFERENCES produto(cod_produto);

ALTER TABLE ONLY estado
    ADD CONSTRAINT regiao_estado_fk FOREIGN KEY (cod_regiao) REFERENCES regiao(cod_regiao);

ALTER TABLE ONLY total_vendas_regiao
    ADD CONSTRAINT regiao_total_vendas_regiao_fk FOREIGN KEY (cod_regiao) REFERENCES regiao(cod_regiao);

ALTER TABLE ONLY produtos_venda
    ADD CONSTRAINT venda_produtos_venda_fk FOREIGN KEY (cod_venda) REFERENCES venda(cod_venda);


/*
EXERCÍCIOS

1) Faça uma procedure que inclua uma venda, receba como parâmetro o código do cliente e retorne o código da venda.
2) Faça uma procedure que inclua produtos de uma venda, receba como parâmetro o código da venda e o código do produto.
3) Faça uma procedure que finalize uma venda, receba como parâmetro o código da venda e faça a baixa do estoque dos 
   produtos vendidos e atualize o atributo baixa_estoque para true.
4) Faça uma procedure que cancele uma venda, receba como parâmetro o código da venda e caso o atributo baica_estoque for true, 
   deve ser somado ao estoque novamente a quantidade vendida antes de deletar os registros da venda.
5) Faça uma procedure que alimente a tabela total_vendas_regiao com as estatísticas de venda de produtos por região, passando 
   como parâmetro o mês e ano referentes as vendas, para calcular as estatísticas.
6) Faça uma procedure que alimente a tabela total_vendas_estado com as estatísticas de venda de produtos por estado, passando 
   como parâmetro o mês e ano referentes as vendas, para calcular as estatísticas.
*/
