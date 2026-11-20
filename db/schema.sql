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
-- Name: rarity_colour; Type: DOMAIN; Schema: catalogue; Owner: -
--

CREATE DOMAIN catalogue.rarity_colour AS text
	CONSTRAINT rarity_colour_check CHECK ((VALUE = ANY (ARRAY['white'::text, 'green'::text, 'blue'::text, 'purple'::text, 'orange'::text, 'pearlescent'::text])));


--
-- Name: DOMAIN rarity_colour; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON DOMAIN catalogue.rarity_colour IS 'Style token for a rarity: white, green, blue, purple, orange or pearlescent. Used as a CSS class, not as a CSS colour name.';


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
-- Name: elements; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.elements (
    id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    summary catalogue.summary NOT NULL,
    description catalogue.non_empty
);


--
-- Name: TABLE elements; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.elements IS 'A damage element, such as incendiary or shock. Shared across games. Fire is incendiary. none is not a row.';


--
-- Name: COLUMN elements.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.elements.id IS 'Stable key, for example incendiary or shock. Not the public URL.';


--
-- Name: COLUMN elements.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.elements.slug IS 'Public URL segment. Editable without changing id.';


--
-- Name: COLUMN elements.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.elements.summary IS 'Required one-line catalogue summary. No line breaks.';


--
-- Name: COLUMN elements.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.elements.description IS 'Longer catalogue prose. No length limit.';


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
    summary catalogue.summary NOT NULL,
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

COMMENT ON COLUMN catalogue.enemies.summary IS 'Required one-line catalogue summary. No line breaks.';


--
-- Name: COLUMN enemies.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.enemies.description IS 'Longer catalogue prose. No length limit.';


--
-- Name: game_elements; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.game_elements (
    game_id catalogue.slug NOT NULL,
    element_id catalogue.slug NOT NULL
);


--
-- Name: TABLE game_elements; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.game_elements IS 'The elements that exist in one game. The site uses this list for a game filter. An item does not define it.';


--
-- Name: game_manufacturers; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.game_manufacturers (
    game_id catalogue.slug NOT NULL,
    manufacturer_id catalogue.slug NOT NULL
);


--
-- Name: TABLE game_manufacturers; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.game_manufacturers IS 'The manufacturers that exist in one game. The site uses this list for a game filter. An item does not define it.';


--
-- Name: game_rarities; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.game_rarities (
    game_id catalogue.slug NOT NULL,
    rarity_id catalogue.slug NOT NULL
);


--
-- Name: TABLE game_rarities; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.game_rarities IS 'The rarity tiers that exist in one game. The site uses this list for a game filter. An item does not define it.';


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
-- Name: locations; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.locations (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    dlc_id catalogue.slug,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    summary catalogue.summary NOT NULL,
    description catalogue.non_empty
);


--
-- Name: TABLE locations; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.locations IS 'A named place in one game, such as Skag Gully. A drop points at a location. The weapon, enemy and mission are separate rows.';


--
-- Name: COLUMN locations.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.id IS 'Stable key within the game, for example skag-gully.';


--
-- Name: COLUMN locations.game_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.game_id IS 'The game this location belongs to.';


--
-- Name: COLUMN locations.dlc_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.dlc_id IS 'DLC that introduced the location. Null for the base game.';


--
-- Name: COLUMN locations.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.slug IS 'Public URL segment, unique within the game.';


--
-- Name: COLUMN locations.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.summary IS 'Required one-line catalogue summary. No line breaks.';


--
-- Name: COLUMN locations.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.locations.description IS 'Longer catalogue prose. No length limit.';


--
-- Name: manufacturers; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.manufacturers (
    id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    summary catalogue.summary NOT NULL,
    description catalogue.non_empty
);


--
-- Name: TABLE manufacturers; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.manufacturers IS 'A brand that makes gear, such as Dahl or Jakobs. Shared across games. A game does not own the brand.';


--
-- Name: COLUMN manufacturers.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.manufacturers.id IS 'Stable key, for example jakobs or ss-munitions. Not the public URL.';


--
-- Name: COLUMN manufacturers.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.manufacturers.slug IS 'Public URL segment. Editable without changing id.';


--
-- Name: COLUMN manufacturers.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.manufacturers.summary IS 'Required one-line catalogue summary. No line breaks.';


--
-- Name: COLUMN manufacturers.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.manufacturers.description IS 'Longer catalogue prose. No length limit.';


--
-- Name: mission_enemies; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.mission_enemies (
    mission_id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    enemy_id catalogue.slug NOT NULL
);


--
-- Name: TABLE mission_enemies; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.mission_enemies IS 'A named enemy or boss that a mission sends you to fight. Not a mob in the area, and not a drop. The same enemy can appear in more than one mission.';


--
-- Name: missions; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.missions (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    dlc_id catalogue.slug,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    story boolean NOT NULL,
    summary catalogue.summary NOT NULL,
    description catalogue.non_empty
);


--
-- Name: TABLE missions; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.missions IS 'A mission in one game, such as Skags at the Gate. A drop points at a mission. The reward is a drop, not a column on the mission.';


--
-- Name: COLUMN missions.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.id IS 'Stable key within the game, for example skags-at-the-gate.';


--
-- Name: COLUMN missions.game_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.game_id IS 'The game this mission belongs to.';


--
-- Name: COLUMN missions.dlc_id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.dlc_id IS 'DLC that introduced the mission. Null for the base game.';


--
-- Name: COLUMN missions.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.slug IS 'Public URL segment, unique within the game.';


--
-- Name: COLUMN missions.story; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.story IS 'True for a story mission. False for a side mission. An optional objective inside a mission is not its own row.';


--
-- Name: COLUMN missions.summary; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.summary IS 'Required one-line catalogue summary. No line breaks.';


--
-- Name: COLUMN missions.description; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.missions.description IS 'Longer catalogue prose. No length limit.';


--
-- Name: rarities; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.rarities (
    id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    colour catalogue.rarity_colour NOT NULL,
    "position" integer NOT NULL
);


--
-- Name: TABLE rarities; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON TABLE catalogue.rarities IS 'A shared rarity tier, such as common or legendary. Not a colour name, and not owned by one game. An item can use more than one tier.';


--
-- Name: COLUMN rarities.id; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.rarities.id IS 'Stable key, for example legendary or pearlescent. Not the public URL.';


--
-- Name: COLUMN rarities.slug; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.rarities.slug IS 'Public URL segment. Editable without changing id.';


--
-- Name: COLUMN rarities.colour; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.rarities.colour IS 'Style token for this tier. white is common, green uncommon, blue rare, purple epic, orange legendary, pearlescent pearlescent.';


--
-- Name: COLUMN rarities."position"; Type: COMMENT; Schema: catalogue; Owner: -
--

COMMENT ON COLUMN catalogue.rarities."position" IS 'Display order of the ladder, from common upwards. Unique.';


--
-- Name: releases; Type: TABLE; Schema: catalogue; Owner: -
--

CREATE TABLE catalogue.releases (
    id catalogue.slug NOT NULL,
    game_id catalogue.slug NOT NULL,
    slug catalogue.slug NOT NULL,
    name catalogue.non_empty NOT NULL,
    summary catalogue.summary NOT NULL,
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

COMMENT ON COLUMN catalogue.releases.summary IS 'Required one-line catalogue summary. No line breaks.';


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
-- Name: elements elements_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.elements
    ADD CONSTRAINT elements_pkey PRIMARY KEY (id);


--
-- Name: elements elements_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.elements
    ADD CONSTRAINT elements_slug_key UNIQUE (slug);


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
-- Name: game_elements game_elements_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_elements
    ADD CONSTRAINT game_elements_pkey PRIMARY KEY (game_id, element_id);


--
-- Name: game_manufacturers game_manufacturers_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_manufacturers
    ADD CONSTRAINT game_manufacturers_pkey PRIMARY KEY (game_id, manufacturer_id);


--
-- Name: game_rarities game_rarities_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_rarities
    ADD CONSTRAINT game_rarities_pkey PRIMARY KEY (game_id, rarity_id);


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
-- Name: locations locations_game_id_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.locations
    ADD CONSTRAINT locations_game_id_slug_key UNIQUE (game_id, slug);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id, game_id);


--
-- Name: manufacturers manufacturers_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.manufacturers
    ADD CONSTRAINT manufacturers_pkey PRIMARY KEY (id);


--
-- Name: manufacturers manufacturers_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.manufacturers
    ADD CONSTRAINT manufacturers_slug_key UNIQUE (slug);


--
-- Name: mission_enemies mission_enemies_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.mission_enemies
    ADD CONSTRAINT mission_enemies_pkey PRIMARY KEY (mission_id, game_id, enemy_id);


--
-- Name: missions missions_game_id_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.missions
    ADD CONSTRAINT missions_game_id_slug_key UNIQUE (game_id, slug);


--
-- Name: missions missions_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.missions
    ADD CONSTRAINT missions_pkey PRIMARY KEY (id, game_id);


--
-- Name: rarities rarities_pkey; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.rarities
    ADD CONSTRAINT rarities_pkey PRIMARY KEY (id);


--
-- Name: rarities rarities_position_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.rarities
    ADD CONSTRAINT rarities_position_key UNIQUE ("position");


--
-- Name: rarities rarities_slug_key; Type: CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.rarities
    ADD CONSTRAINT rarities_slug_key UNIQUE (slug);


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
-- Name: game_elements game_elements_element_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_elements
    ADD CONSTRAINT game_elements_element_id_fkey FOREIGN KEY (element_id) REFERENCES catalogue.elements(id) ON DELETE CASCADE;


--
-- Name: game_elements game_elements_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_elements
    ADD CONSTRAINT game_elements_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id) ON DELETE CASCADE;


--
-- Name: game_manufacturers game_manufacturers_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_manufacturers
    ADD CONSTRAINT game_manufacturers_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id) ON DELETE CASCADE;


--
-- Name: game_manufacturers game_manufacturers_manufacturer_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_manufacturers
    ADD CONSTRAINT game_manufacturers_manufacturer_id_fkey FOREIGN KEY (manufacturer_id) REFERENCES catalogue.manufacturers(id) ON DELETE CASCADE;


--
-- Name: game_rarities game_rarities_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_rarities
    ADD CONSTRAINT game_rarities_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id) ON DELETE CASCADE;


--
-- Name: game_rarities game_rarities_rarity_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.game_rarities
    ADD CONSTRAINT game_rarities_rarity_id_fkey FOREIGN KEY (rarity_id) REFERENCES catalogue.rarities(id) ON DELETE CASCADE;


--
-- Name: locations locations_dlc_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.locations
    ADD CONSTRAINT locations_dlc_fkey FOREIGN KEY (dlc_id, game_id) REFERENCES catalogue.dlcs(id, game_id);


--
-- Name: locations locations_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.locations
    ADD CONSTRAINT locations_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- Name: mission_enemies mission_enemies_enemy_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.mission_enemies
    ADD CONSTRAINT mission_enemies_enemy_fkey FOREIGN KEY (enemy_id, game_id) REFERENCES catalogue.enemies(id, game_id) ON DELETE CASCADE;


--
-- Name: mission_enemies mission_enemies_mission_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.mission_enemies
    ADD CONSTRAINT mission_enemies_mission_fkey FOREIGN KEY (mission_id, game_id) REFERENCES catalogue.missions(id, game_id) ON DELETE CASCADE;


--
-- Name: missions missions_dlc_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.missions
    ADD CONSTRAINT missions_dlc_fkey FOREIGN KEY (dlc_id, game_id) REFERENCES catalogue.dlcs(id, game_id);


--
-- Name: missions missions_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.missions
    ADD CONSTRAINT missions_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- Name: releases releases_game_id_fkey; Type: FK CONSTRAINT; Schema: catalogue; Owner: -
--

ALTER TABLE ONLY catalogue.releases
    ADD CONSTRAINT releases_game_id_fkey FOREIGN KEY (game_id) REFERENCES catalogue.games(id);


--
-- PostgreSQL database dump complete
--

