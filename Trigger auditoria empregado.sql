

CREATE OR REPLACE FUNCTION fn_audit_empregado() RETURNS trigger AS $$
	DECLARE
		OPERACAO char(1);
		ALTERACAO text DEFAULT '';
		ORIGINAL text DEFAULT '';
		id integer;

	BEGIN
		SELECT COALESCE (MAX (id_audit),0)+1 INTO id FROM auditoria;
		IF TG_OP = 'INSERT' THEN OPERACAO = 'I';
		ELSIF TG_OP = 'UPDATE' THEN OPERACAO = 'U';
		ELSIF TG_OP = 'DELETE' THEN OPERACAO = 'D';
		END IF;

		IF TG_OP = 'INSERT' THEN
			
			ALTERACAO := ALTERACAO || 'codempregado=' || NEW.codempregado || ',';
			ALTERACAO := ALTERACAO || 'nomeinic=' || COALESCE(NEW.nomeinic,'NULL') || ',';
			ALTERACAO := ALTERACAO || 'nomeint=' || COALESCE(NEW.nomeint,'NULL') || ',';
			ALTERACAO := ALTERACAO || 'nomefin=' || COALESCE(NEW.nomefin,'NULL') || ',';
			
			IF NEW.datanasc IS NULL THEN
				ALTERACAO := ALTERACAO || 'datanasc=' || 'NULL' || ',';
			ELSE
				ALTERACAO := ALTERACAO || 'datanasc=' || NEW.datanasc || ',';
			END IF;
			
			ALTERACAO := ALTERACAO || 'endereco=' || COALESCE(NEW.endereco,'NULL') || ',';
			ALTERACAO := ALTERACAO || 'sexo=' || COALESCE(NEW.sexo,'NULL') || ',';
			
			IF NEW.salario IS NULL THEN
				ALTERACAO := ALTERACAO || 'salario=' || 'NULL' || ',';
			ELSE
				ALTERACAO := ALTERACAO ||'salario-' || NEW.salario || ',';
			END IF;
			
			IF NEW.coddepartamento IS NULL THEN
				ALTERACAO := ALTERACAO || 'coddepartamento=' || ',';
			ELSE 
				ALTERACAO := ALTERACAO || 'coddepartamento=' || NEW.coddepartamento || ',';
			END IF;
			
			IF NEW.supcodempregado IS NULL THEN
				ALTERACAO := || ALTERACAO || 'supcodmpregado=' || ',';
			ELSE
				ALTERACAO := ALTERACAO || 'supcodempregado=' || NEW.supcodempregado || ',';
			END IF;

			INSERT INTO auditoria VALUES (id,TG_RELNAME, NEW.codempregado, OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
			RETURN NEW;
		

		ELSIF TG_OP = 'UPDATE' THEN
			IF (NEW.nomeinic IS NOT NULL AND OLD.nomeinic IS NOT NULL AND NEW.nomeinic != OLD.nomeinic ) OR
			    NEW.nomeinic IS NOT NULL AND OLD.nomeinic IS NULL OR
			    NEW.nomeinic IS NULL AND OLD.nomeinic IS NOT NULL THEN

				ALTERACAO := ALTERACAO || 'nomeinic=' || COALESCE(NEW.nomeinic,'NULL') || ',';
				ORIGINAL := ORIGINAL || 'nomeinci=' || COALESCE(OLD.nomeinic,'NULL') || ',';

			END IF;

			IF (NEW.nomeint IS NOT NULL AND OLD.nomeint IS NOT NULL AND NEW.nomeint != OLD.nomeint) OR
			    NEW.nomeint IS NOT NULL AND OLD.nomeint IS NULL OR
			    NEW.nomeint IS NULL AND OLD.nomeint IS NOT NULL THEN

				ALTERACAO := ALTERACAO || 'nomeint=' || COALESCE(NEW.nomeint,'NULL') || ',';
				ORIGINAL := ORIGINAL || 'nomeint=' || COALESCE(OLD.nomeint,'NULL') || ',';

			END IF;
			
			IF (NEW.nomefin IS NOT NULL AND OLD.nomefin IS NOT NULL AND NEW.nomefin != OLD.nomefin) OR
			    NEW.nomefin IS NOT NULL AND OLD.nomefin IS NULL OR
			    NEW.nomefin IS NULL AND OLD.nomefin IS NOT NULL THEN

				ALTERACAO := ALTERACAO || 'nomefin=' || COALESCE(NEW.nomefin,'NULL') || ',';
				ORIGINAL := ORIGINAL || 'nomefin=' || COALESCE(OLD.nomefin,'NULL') || ',';

			END IF;

			IF (NEW.datanasc IS NOT NULL AND OLD.datanasc IS NOT NULL AND NEW.datanasc != OLD.datanasc) OR
			    NEW.datanasc IS NOT NULL AND OLD.datanasc IS NULL OR
			    NEW.datanasc IS NULL AND OLD.datanasc IS NOT NULL THEN
				IF NEW.datanasc IS NULL THEN
					ALTERACAO := ALTERACAO || 'datanasc=' || ',';
				ELSE
					ALTERACAO := ALTERACAO || 'datanasc=' || NEW.datanasc || ',';
				END IF;
				IF OLD.datanasc IS NULL THEN
					ORIGINAL := ORIGINAL || 'datanasc=' || ',';
				ELSE
					ORIGINAL := ORIGINAL || 'datanasc=' || OLD.datanasc || ',';
				END IF;

			END IF;

			IF (NEW.endereco IS NOT NULL AND OLD.endereco IS NOT NULL AND NEW.endereco != OLD.endereco) OR
			    NEW.endereco IS NOT NULL AND OLD.endereco IS NULL OR
			    NEW.endereco IS NULL AND OLD.endereco IS NOT NULL THEN

				ALTERACAO := ALTERACAO || 'endereco=' || COALESCE(NEW.endereco,'NULL') || ',';
				ORIGINAL := ORIGINAL || 'endereco=' || COALESCE(OLD.endereco,'NULL') || ',';

			END IF;

			IF (NEW.sexo IS NOT NULL AND OLD.sexo IS NOT NULL AND NEW.sexo != OLD.sexo) OR
			    NEW.sexo IS NOT NULL AND OLD.sexo IS NULL OR
			    NEW.sexo IS NULL AND OLD.sexo IS NOT NULL THEN

				ALTERACAO := ALTERACAO || 'sexo=' || COALESCE(NEW.sexo,'NULL') || ',';
				ORIGINAL := ORIGINAL || 'sexo=' || COALESCE(OLD.sexo,'NULL') || ',';

			END IF;

			
			IF (NEW.salario IS NOT NULL AND OLD.salario IS NOT NULL AND NEW.salario != OLD.salario) OR
			    NEW.salario IS NOT NULL AND OLD.salario IS NULL OR
			    NEW.salario IS NULL AND OLD.salario IS NOT NULL THEN
				IF NEW.salario IS NULL THEN
					ALTERACAO := ALTERACAO || 'salario=' || ',';
				ELSE
					ALTERACAO := ALTERACAO || 'salario=' || NEW.salario || ',';
				END IF;
				IF OLD.salario IS NULL THEN
					ORIGINAL := ORIGINAL || 'salario=' || ',';
				ELSE
					ORIGINAL := ORIGINAL || 'salario=' || OLD.salario || ',';
				END IF;

			END IF;

			IF (NEW.coddepartamento IS NOT NULL AND OLD.coddepartamento IS NOT NULL AND NEW.coddepartamento != OLD.coddepartamento) OR
			    NEW.coddepartamento IS NOT NULL AND OLD.coddepartamento IS NULL OR
			    NEW.coddepartamento IS NULL AND OLD.coddepartamento IS NOT NULL THEN
				IF NEW.coddepartamento IS NULL THEN
					ALTERACAO := ALTERACAO || 'coddepartamento=' || ',';
				ELSE
					ALTERACAO := ALTERACAO || 'coddepartamento=' || NEW.coddepartamento || ',';
				END IF;
				IF OLD.coddepartamento IS NULL THEN
					ORIGINAL := ORIGINAL || 'coddepartamento=' || ',';
				ELSE
					ORIGINAL := ORIGINAL || 'coddepartamento=' || OLD.coddepartamento || ',';
				END IF;

			END IF;

			IF (NEW.supcodempregado IS NOT NULL AND OLD.supcodempregado IS NOT NULL AND NEW.supcodempregado != OLD.supcodempregado) OR
			    NEW.supcodempregado IS NOT NULL AND OLD.supcodempregado IS NULL OR
			    NEW.supcodempregado IS NULL AND OLD.supcodempregado IS NOT NULL THEN
				IF NEW.supcodempregado IS NULL THEN
					ALTERACAO := ALTERACAO || 'supcodempregado=' || ',';
				ELSE
					ALTERACAO := ALTERACAO || 'supcodempregado=' || NEW.supcodempregado || ',';
				END IF;
				IF OLD.supcodempregado IS NULL THEN
					ORIGINAL := ORIGINAL || 'supcodempregado=' || ',';
				ELSE
					ORIGINAL := ORIGINAL || 'supcodempregado=' || OLD.supcodempregado || ',';
				END IF;

			END IF;

			INSERT INTO auditoria VALUES (id,TG_RELNAME, OLD.codempregado,OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
			RETURN NEW;


		ELSIF TG_OP = 'DELETE' THEN

			ORIGINAL := ORIGINAL || 'codempregado=' || OLD.codempregado || ',';
			ORIGINAL := ORIGINAL || 'nomeinic=' || COALESCE(OLD.nomeinic,'NULL') || ',';
			ORIGINAL := ORIGINAL || 'nomeint=' || COALESCE(OLD.nomeint,'NULL') || ',';
			ORIGINAL := ORIGINAL || 'nomefin=' || COALESCE(OLD.nomefin,'NULL') || ',';
			
			IF OLD.datanasc IS NULL THEN
				ORIGINAL := ORIGINAL || 'datanasc=' || 'NULL' || ',';
			ELSE
				ORIGINAL := ORIGINAL || 'datanasc=' || OLD.datanasc || ',';
			END IF;
			
			ORIGINAL := ORIGINAL || 'endereco=' || COALESCE(OLD.endereco,'NULL') || ',';
			ORIGINAL := ORIGINAL || 'sexo=' || COALESCE(OLD.sexo,'NULL') || ',';

			IF OLD.salario IS NULL THEN
				ORIGINAL := ORIGINAL || 'salario=' || 'NULL' || ',';
			ELSE
				ORIGINAL := ORIGINAL || 'salario=' || OLD.salario || ',';
			END IF;

			IF OLD.coddepartamento IS NULL THEN
				ORIGINAL := ORIGINAL || 'coddepartamento=' || 'NULL' || ',';
			ELSE
				ORIGINAL := ORIGINAL || 'coddepartamento=' || OLD.coddepartamento || ',';
			END IF;

			IF OLD.supcodempregado IS NULL THEN
				ORIGINAL := ORIGINAL || 'supcodempregado=' || 'NULL' || ',';
			ELSE
				ORIGINAL := ORIGINAL || 'supcodempregado=' || OLD.supcodempregado || ',';
			END IF;

			INSERT INTO auditoria VALUES (id,TG_RELNAME, OLD.codempregado,OPERACAO,ALTERACAO,ORIGINAL,current_timestamp);
			RETURN OLD;

			
		END IF;
		
	END $$ LANGUAGE 'plpgsql';

CREATE TRIGGER audit_empregado BEFORE
UPDATE OR DELETE OR INSERT
ON empregado FOR EACH ROW
EXECUTE PROCEDURE fn_audit_empregado();









			