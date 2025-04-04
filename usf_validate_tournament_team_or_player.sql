-- FUNCTION: public.usf_validate_tournament_team_or_player(text, integer)

-- DROP FUNCTION IF EXISTS public.usf_validate_tournament_team_or_player(text, integer);

CREATE OR REPLACE FUNCTION public.usf_validate_tournament_team_or_player(
	name text,
	tournament_id integer)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
DECLARE 
    count INTEGER;
	tournament_name ALIAS FOR tournament_id;
BEGIN
    -- Check if the name exists in t_league_player
    SELECT COUNT(1) 
    INTO count
    FROM t_league_player lp
	INNER JOIN t_tournament t
	ON lp.league_id = t.league_id
    WHERE lp.user_name = name
    AND t.tournament_id = tournament_name;

    IF count > 0 THEN 
        RETURN true;
    END IF;
    
    -- Check if the name exists in t_league_team
    SELECT COUNT(1) 
    INTO count
    FROM t_league_team lt
	INNER JOIN t_tournament t
	ON lt.league_id = t.league_id
    WHERE lt.team_name = name
    AND t.tournament_id = tournament_name;

    IF count > 0 THEN 
        RETURN true;
    END IF;

    -- If neither condition is true, return false
    RETURN false;
END;
$BODY$;

ALTER FUNCTION public.usf_validate_tournament_team_or_player(text, integer)
    OWNER TO postgres;
