-- FUNCTION: public.usf_validate_league_team_or_player(text, integer)

-- DROP FUNCTION IF EXISTS public.usf_validate_league_team_or_player(text, integer);

CREATE OR REPLACE FUNCTION public.usf_validate_league_team_or_player(
	name text,
	league_id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
    count INTEGER;
	league_name ALIAS FOR league_id;
BEGIN
    -- Check if the name exists in t_league_player
    SELECT COUNT(1) 
    INTO count
    FROM t_league_player lp
    WHERE lp.user_name = name
    AND lp.league_id = league_name;

    IF count > 0 THEN 
        RETURN true;
    END IF;
    
    -- Check if the name exists in t_league_team
    SELECT COUNT(1) 
    INTO count
    FROM t_league_team lt
    WHERE lt.team_name = name
    AND lt.league_id = league_name;

    IF count > 0 THEN 
        RETURN true;
    END IF;

    -- If neither condition is true, return false
    RETURN false;
END;
$BODY$;

ALTER FUNCTION public.usf_validate_league_team_or_player(text, integer)
    OWNER TO postgres;
