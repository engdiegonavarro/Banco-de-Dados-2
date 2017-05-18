--============= EXERCICIO 1 ===================

CREATE OR REPLACE FUNCTION valida_cpf(codempregado integer, nomeinic character,
					nomeint character, nomefin character, datanasc date,
					endereco character, sexo character, salario numeric,
					coddepartamento integer, supcodempregado integer, aux_cpf numeric) 

	RETURNS VOID AS $$
	
BEGIN
	IF ( aux_cpf = (SELECT cpf FROM empregado WHERE aux_cpf = cpf)) IS NOT NULL THEN
	
		RAISE EXCEPTION ' cpf ja cadastrado ';
	ELSE
		INSERT INTO EMPREGADO VALUES (codempregado,nomeinic,nomeint,nomefin,
						datanasc,endereco,sexo,salario,coddepartamento,
						supcodempregado, aux_cpf);
	END IF;	
	
END
$$ LANGUAGE 'plpgsql'

/*SELECT valida_cpf(16,'diego','c','navarro',
		 '1987-1-2','rua t','m',2198,1,1,1234); */



--============= EXERCICIO 2 ===================


CREATE OR REPLACE FUNCTION fn_block_supemp() RETURNS trigger AS $$

BEGIN
	IF TG_OP = 'INSERT' THEN
		IF NEW.codempregado = NEW.supcodempregado THEN
			RAISE EXCEPTION 'O empregado não pode ser supervisionado por ele mesmo';
		END IF; 
		RETURN NEW;
	END IF;

	IF TG_OP = 'UPDATE' THEN
		IF NEW.codempregado = OLD.supcodempregado OR
			OLD.codempregado = NEW.supcodempregado OR
			NEW.codempregado = NEW.supcodempregado THEN
			RAISE EXCEPTION 'O empregado não pode ser supervisionado por ele mesmo';
		END IF;
		RETURN NEW;
	END IF;
END

$$ LANGUAGE 'plpgsql'

CREATE TRIGGER block_supemp BEFORE
UPDATE OR INSERT
ON empregado FOR EACH ROW
EXECUTE PROCEDURE fn_block_supemp();


--============= EXERCICIO 3 ===================

CREATE OR REPLACE FUNCTION fn_red_salario() RETURNS trigger AS $$

BEGIN
	IF TG_OP = 'UPDATE' THEN

		IF NEW.salario < OLD.salario THEN
			RAISE EXCEPTION 'Salario não pode ser reduzido';
		END IF;
		RETURN NEW;
	END IF;
END;
$$ LANGUAGE 'plpgsql'

CREATE TRIGGER red_salario BEFORE
UPDATE
ON empregado FOR EACH ROW
EXECUTE PROCEDURE fn_red_salario();


--============= EXERCICIO 3 ===================

CREATE OR REPLACE FUNCTION fn_exc_func() RETURNS trigger AS $$

BEGIN

	DELETE FROM dependente where codempregado = OLD.codempregado;
	
	return OLD;
END;
$$ LANGUAGE 'plpgsql'

CREATE TRIGGER exc_func BEFORE
DELETE
ON empregado FOR EACH ROW
EXECUTE PROCEDURE fn_exc_func();