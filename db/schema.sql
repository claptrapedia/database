--
-- PostgreSQL database dump
--

-- Dumped from database version 17.2 (Debian 17.2-1.pgdg120+1)
-- Dumped by pg_dump version 17.2 (Debian 17.2-1.pgdg120+1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: catalogue; Type: SCHEMA; Schema: -; Owner: -
--

CREATE SCHEMA catalogue;


--
-- Name: enemy_kind; Type: DOMAIN; Schema: catalogue; Owner: -
--

CREATE DOMAIN catalogue.enemy_kind AS text
	CONSTRAINT enemy_kind_check CHECK ((VALUE = ANY (ARRAY['named'::text, 'boss'::text, 'mob'::text])));


--
-- Name: DOMAIN enemy_kind; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON DOMAIN catalogue.enemy_kind IS 'named for a unique enemy that is not a boss. boss for a boss. mob for a repeating archetype.';


--
-- Name: non_empty; Type: DOMAIN; Schema: catalogue; Owner: -
--

CREATE DOMAIN catalogue.non_empty AS text
	CONSTRAINT non_empty_check CHECK ((char_length(btrim(VALUE)) > 0));


--
-- Name: DOMAIN non_empty; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON DOMAIN catalogue.non_empty IS 'Text that contains something other than whitespace. Null is still allowed where the column is optional.';


--
-- Name: slug; Type: DOMAIN; Schema: catalogue; Owner: -
--

CREATE DOMAIN catalogue.slug AS text
	CONSTRAINT slug_check CHECK ((VALUE ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$'::text));


--
-- Name: DOMAIN slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON DOMAIN catalogue.slug IS 'Lowercase kebab-case key or URL segment, such as bone-head. No spaces, underscores or capitals.';


--
-- Name: summary; Type: DOMAIN; Schema: catalogue; Owner: -
--

CREATE DOMAIN catalogue.summary AS catalogue.non_empty
	CONSTRAINT summary_check CHECK (((VALUE)::text !~ '[\n\r]'::text));


--
-- Name: DOMAIN summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON DOMAIN catalogue.summary IS 'One line of non-empty text. Line breaks are rejected.';


SET default_table_access_method = heap;

--
-- Name: dlcs; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.dlcs (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: TABLE dlcs; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.dlcs IS 'A downloadable pack that introduced content for one game. Not a location where something drops.';


--
-- Name: COLUMN dlcs.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.dlcs.id IS 'Stable key within the game, for example zombie-island.';


--
-- Name: COLUMN dlcs.game_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.dlcs.game_id IS 'The game this DLC belongs to.';


--
-- Name: COLUMN dlcs.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.dlcs.slug IS 'Public URL segment, unique within the game.';


--
-- Name: COLUMN dlcs."position"; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.dlcs."position" IS 'Display order within the game. Each game has its own 1, 2, 3.';


--
-- Name: enemies; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.enemies (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    dlc_id catalogue.slug,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    kind catalogue.enemy_kind NOT NULL,
    family catalogue.slug,
    rank catalogue.slug,
    summary catalogue.summary,
    description catalogue.non_empty
);


--
-- Name: TABLE enemies; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.enemies IS 'A named enemy or a repeating mob. Skag and Badass Skag are separate rows.';


--
-- Name: COLUMN enemies.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.id IS 'Stable key within the game, for example bone-head.';


--
-- Name: COLUMN enemies.game_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.game_id IS 'The game this enemy belongs to.';


--
-- Name: COLUMN enemies.dlc_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.dlc_id IS 'DLC that introduced the enemy. Null for the base game. Not the DLC of a place where it appears.';


--
-- Name: COLUMN enemies.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.slug IS 'Public URL segment, unique within the game.';


--
-- Name: COLUMN enemies.kind; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.kind IS 'named for a unique enemy that is not a boss, such as Bone Head. boss for a boss, such as Sledge. mob for a repeating archetype such as Skag.';


--
-- Name: COLUMN enemies.family; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.family IS 'Species or archetype, such as skag, bandit or rakk. Shared by every tier of that species.';


--
-- Name: COLUMN enemies.rank; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.rank IS 'Tier within the family, such as whelp, elder or badass. Null when the enemy is not a tier. Not the display order.';


--
-- Name: COLUMN enemies.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.summary IS 'One-line catalogue summary. No line breaks.';


--
-- Name: COLUMN enemies.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.description IS 'Longer catalogue prose. No length limit.';


--
-- Name: games; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.games (
    id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: TABLE games; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.games IS 'A Borderlands title, such as Borderlands 1. Distinct from a release and from a DLC.';


--
-- Name: COLUMN games.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.games.id IS 'Stable key, for example bl1. Not the public URL.';


--
-- Name: COLUMN games.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.games.slug IS 'Public URL segment. Editable without changing id.';


--
-- Name: COLUMN games."position"; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.games."position" IS 'Display order across the whole catalogue. Unique.';


--
-- Name: releases; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.releases (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    summary catalogue.summary,
    "position" integer NOT NULL
);


--
-- Name: TABLE releases; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.releases IS 'An edition of one game, such as the original, GOTY or GOTY Enhanced. Not a patch and not a DLC.';


--
-- Name: COLUMN releases.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.releases.id IS 'Stable key within the game, for example goty-enhanced.';


--
-- Name: COLUMN releases.game_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.releases.game_id IS 'The game this release belongs to.';


--
-- Name: COLUMN releases.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.releases.slug IS 'Public URL segment, unique within the game.';


--
-- Name: COLUMN releases.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.releases.summary IS 'One-line catalogue summary. No line breaks.';


--
-- Name: COLUMN releases."position"; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.releases."position" IS 'Display order within the game. Each game has its own 1, 2, 3.';


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: dlcs dlcs_game_id_position_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.dlcs
    ADD CONSTRAINT dlcs_game_id_position_key UNIQUE (game_id, "position");


--
-- Name: dlcs dlcs_game_id_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.dlcs
    ADD CONSTRAINT dlcs_game_id_slug_key UNIQUE (game_id, slug);


--
-- Name: dlcs dlcs_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.dlcs
    ADD CONSTRAINT dlcs_pkey PRIMARY KEY (id, game_id);


--
-- Name: enemies enemies_game_id_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.enemies
    ADD CONSTRAINT enemies_game_id_slug_key UNIQUE (game_id, slug);


--
-- Name: enemies enemies_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.enemies
    ADD CONSTRAINT enemies_pkey PRIMARY KEY (id, game_id);


--
-- Name: games games_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.games
    ADD CONSTRAINT games_pkey PRIMARY KEY (id);


--
-- Name: games games_position_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.games
    ADD CONSTRAINT games_position_key UNIQUE ("position");


--
-- Name: games games_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.games
    ADD CONSTRAINT games_slug_key UNIQUE (slug);


--
-- Name: releases releases_game_id_position_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.releases
    ADD CONSTRAINT releases_game_id_position_key UNIQUE (game_id, "position");


--
-- Name: releases releases_game_id_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.releases
    ADD CONSTRAINT releases_game_id_slug_key UNIQUE (game_id, slug);


--
-- Name: releases releases_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.releases
    ADD CONSTRAINT releases_pkey PRIMARY KEY (id, game_id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: enemies_game_family_idx; Type: INDEX; Schema: catalogue; Owner: -
--

CREATE INDEX enemies_game_family_idx ON catalogue.enemies USING btree (game_id, family);


--
-- Name: enemies_game_kind_idx; Type: INDEX; Schema: catalogue; Owner: -
--

CREATE INDEX enemies_game_kind_idx ON catalogue.enemies USING btree (game_id, kind);


--
-- Name: dlcs dlcs_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.dlcs
    ADD CONSTRAINT dlcs_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- Name: enemies enemies_dlc_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.enemies
    ADD CONSTRAINT enemies_dlc_fkey FOREIGN KEY (dlc_id, game_id) REFERENCES catalogue.dlcs(id, game_id);


--
-- Name: enemies enemies_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.enemies
    ADD CONSTRAINT enemies_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- Name: releases releases_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.releases
    ADD CONSTRAINT releases_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- PostgreSQL database dump complete
--

