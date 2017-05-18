CREATE TABLE auditoria(
id_audit integer primary key,
nome_tabela varchar(20),
pk_tupla varchar(30),
op_tupla char(1) check (op_tupla in ('I','D','U')),
alt_tupla text,
reg_tupla text,
dt_alt_tupla timestamp
);

CREATE OR REPLACE FUNCTION fn_audit_departamento() RETURNS trigger AS $$
 DECLARE
  OPERACAO char(1);
  ALTERACAO text DEFAULT '';
  ORIGINAL text DEFAULT '';
  id integer;
 BEGIN
  SELECT COALESCE (MAX (id_audit),0)+1 INTO id FROM auditoria;
   IF TG_OP = 'INSERT' THEN OPERACAO = 'I';
    ELSIF TG_OP = 'DELETE' THEN OPERACAO = 'D';
    ELSIF TG_OP = 'UPDATE' THEN OPERACAO = 'U';
   END IF;

   IF TG_OP = 'INSERT' THEN
	IF NEW.coddepartamento IS NULL THEN
	    ORIGINAL := 'coddepartamento=' || ',';
	ELSE
	    ORIGINAL := 'coddepartamento=' || NEW.coddepartamento || ',';
	END IF;
	IF NEW.nomedepartamento IS NULL THEN
	    ORIGINAL := ORIGINAL || 'nomedepartamento=' || COALESCE(NEW.nomedepartamento,'NULL') || ',';
	ELSE
	    ORIGINAL := ORIGINAL || 'nomedepartamento=' || NEW.nomedepartamento || ',';
	END IF;
	IF NEW.datainicioger IS NULL THEN
	    ORIGINAL := ORIGINAL || 'datainicioger=' || 'NULL' || ',';
	ELSE
	    ORIGINAL := ORIGINAL || 'datainicioger=' || NEW.datainicioger || ',';
	END IF;
	IF NEW.codempregado IS NULL THEN
	    ORIGINAL := ORIGINAL || 'codempregado=' || 'NULL' || ',';
	ELSE
            ORIGINAL := ORIGINAL || 'codempregado=' || NEW.codempregado || ',';
        END IF;
        IF NEW.codcidade IS NULL THEN
	    ORIGINAL := ORIGINAL || 'codcidade=' || 'NULL' || ',';
	ELSE
	    ORIGINAL := ORIGINAL || 'codcidade=' || NEW.codcidade || ',';
	END IF;
	
	INSERT INTO auditoria VALUES (id,TG_RELNAME, NEW.coddepartamento, OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
	RETURN NEW;

   END IF;

   IF TG_OP = 'UPDATE' THEN
	IF (NEW.nomedepartamento IS NOT NULL AND OLD.nomedepartamento IS NOT NULL AND NEW.nomedepartamento != OLD.nomedepartamento) OR
	    NEW.nomedepartamento IS NOT NULL AND OLD.nomedepartamento IS NULL OR
	    NEW.nomedepartamento IS NULL AND OLD.nomedepartamento IS NOT NULL THEN
	    
		ALTERACAO := ALTERACAO || 'nomedepartamento=' || COALESCE(NEW.nomedepartamento,'') || ',';
		ORIGINAL  := ORIGINAL  || 'nomedepartamento=' || COALESCE(OLD.nomedepartamento,'') || ',';
	END IF;
	
	IF (NEW.datainicioger IS NOT NULL AND OLD.datainicioger IS NOT NULL AND NEW.datainicioger != OLD.datainicioger) OR
	    NEW.datainicioger IS NOT NULL AND OLD.datainicioger IS NULL OR
	    NEW.datainicioger IS NULL AND OLD.datainicioger IS NOT NULL THEN
		IF NEW.datainicioger IS NULL THEN
			ALTERACAO := ALTERACAO || 'datainicioger=' || 'NULL' || ',';
		ELSE
			ALTERACAO := ALTERACAO || 'datainicioger=' || NEW.datainicioger || ',';
		END IF;
		IF OLD.datainicioger IS NULL THEN
			ORIGINAL  := ORIGINAL  || 'datainicioger=' || 'NULL' || ',';
		ELSE
			ORIGINAL  := ORIGINAL  || 'datainicioger=' || OLD.datainicioger || ',';
		END IF;
	END IF;
	
	IF (NEW.codempregado IS NOT NULL AND OLD.codempregado IS NOT NULL AND NEW.codempregado != OLD.codempregado) OR
	    NEW.codempregado IS NOT NULL AND OLD.codempregado IS NULL OR
	    NEW.codempregado IS NULL AND OLD.codempregado IS NOT NULL THEN
		IF NEW.codempregado IS NULL THEN
			ALTERACAO := ALTERACAO || 'codempregado=' || ',';
		ELSE
			ALTERACAO := ALTERACAO || 'codempregado=' || NEW.codempregado || ',';
		END IF;
		IF OLD.codempregado IS NULL THEN
			ORIGINAL := ORIGINAL || 'codempregado=' || ',';
		ELSE
			ORIGINAL := ORIGINAL || 'codempregado=' || OLD.codempregado || ',';
		END IF;
	END IF;
	
	IF (NEW.codcidade IS NOT NULL AND OLD.codcidade IS NOT NULL AND NEW.codcidade != OLD.codcidade) OR
	    NEW.codcidade IS NOT NULL AND OLD.codcidade IS NULL OR
	    NEW.codcidade IS NULL AND OLD.codcidade IS NOT NULL THEN
		IF NEW.codcidade IS NULL THEN
			ALTERACAO := ALTERACAO || 'codcidade=' ||  ',';
		ELSE
			ALTERACAO := ALTERACAO || 'codcidade=' || NEW.codcidade || ',';
		END IF;
		IF OLD.codcidade IS NULL THEN
			ORIGINAL := ORIGINAL || 'codcidade=' || ',';
		ELSE
			ORIGINAL  := ORIGINAL  || 'codcidade=' || OLD.codcidade || ',';
		END IF;
	END IF;

	INSERT INTO auditoria VALUES (id,TG_RELNAME, OLD.coddepartamento, OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
	RETURN NEW;

   ELSIF TG_OP = 'DELETE' THEN
	
	ORIGINAL := ORIGINAL || 'coddepartamento=' || OLD.coddepartamento || ',';
	ORIGINAL := ORIGINAL || 'nomedepartamento=' || COALESCE(OLD.nomedepartamento,'NULL') || ',';

	IF OLD.datainicioger IS NULL THEN
		ORIGINAL := ORIGINAL || 'datainicioger=' || 'NULL' || ',';
	ELSE
		ORIGINAL := ORIGINAL || 'datainicioger=' || OLD.datainicioger || ',';
	END IF;

	IF OLD.codempregado IS NULL THEN
		ORIGINAL := ORIGINAL || 'codempregado=' || 'NULL' || ',';
	ELSE
		ORIGINAL := ORIGINAL || 'codempregado=' || OLD.codempregado || ',';
	END IF;
	
	ORIGINAL := ORIGINAL || 'codcidade=' || OLD.codcidade || ',';

	INSERT INTO auditoria VALUES (id,TG_RELNAME, OLD.coddepartamento, OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
	RETURN OLD;
   END IF;

   
 END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER audit_departamento BEFORE
UPDATE OR DELETE OR INSERT
 ON departamento FOR EACH ROW
 EXECUTE PROCEDURE fn_audit_departamento();

UPDATE departamento 
SET nomedepartamento = 'Doutorado Engerenharia de Computacao',codempregado=3,codcidade=2 
WHERE coddepartamento=1;

INSERT INTO departamento values (28,'Contas','26/11/2015',4,10);
