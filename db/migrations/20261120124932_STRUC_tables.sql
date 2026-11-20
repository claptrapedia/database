-- migrate:up

-- --------------------------------------------------------------------
-- Tables
-- --------------------------------------------------------------------

CREATE TABLE catalogue.games (
  id catalogue.slug PRIMARY KEY,
  slug catalogue.slug NOT NULL UNIQUE,
  name catalogue.non_empty NOT NULL,
  position integer NOT NULL UNIQUE
);

CREATE TABLE catalogue.releases (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  summary catalogue.summary NOT NULL,
  position integer NOT NULL,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  UNIQUE (game_id, position)
);

CREATE TABLE catalogue.dlcs (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  position integer NOT NULL,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  UNIQUE (game_id, position)
);

CREATE TABLE catalogue.rarities (
  id catalogue.slug PRIMARY KEY,
  slug catalogue.slug NOT NULL UNIQUE,
  name catalogue.non_empty NOT NULL,
  colour catalogue.rarity_colour NOT NULL,
  position integer NOT NULL UNIQUE
);

CREATE TABLE catalogue.game_rarities (
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id) ON DELETE CASCADE,
  rarity_id catalogue.slug NOT NULL REFERENCES catalogue.rarities (id) ON DELETE CASCADE,
  PRIMARY KEY (game_id, rarity_id)
);

CREATE TABLE catalogue.elements (
  id catalogue.slug PRIMARY KEY,
  slug catalogue.slug NOT NULL UNIQUE,
  name catalogue.non_empty NOT NULL,
  summary catalogue.summary NOT NULL,
  description catalogue.non_empty
);

CREATE TABLE catalogue.game_elements (
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id) ON DELETE CASCADE,
  element_id catalogue.slug NOT NULL REFERENCES catalogue.elements (id) ON DELETE CASCADE,
  PRIMARY KEY (game_id, element_id)
);

CREATE TABLE catalogue.manufacturers (
  id catalogue.slug PRIMARY KEY,
  slug catalogue.slug NOT NULL UNIQUE,
  name catalogue.non_empty NOT NULL,
  summary catalogue.summary NOT NULL,
  description catalogue.non_empty
);

CREATE TABLE catalogue.game_manufacturers (
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id) ON DELETE CASCADE,
  manufacturer_id catalogue.slug NOT NULL REFERENCES catalogue.manufacturers (id) ON DELETE CASCADE,
  PRIMARY KEY (game_id, manufacturer_id)
);

CREATE TABLE catalogue.enemies (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  dlc_id catalogue.slug,
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  kind catalogue.enemy_kind NOT NULL,
  family catalogue.slug,
  rank catalogue.slug,
  summary catalogue.summary NOT NULL,
  description catalogue.non_empty,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  CONSTRAINT enemies_dlc_fkey
    FOREIGN KEY (dlc_id, game_id)
    REFERENCES catalogue.dlcs (id, game_id)
);

CREATE TABLE catalogue.locations (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  dlc_id catalogue.slug,
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  summary catalogue.summary NOT NULL,
  description catalogue.non_empty,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  CONSTRAINT locations_dlc_fkey
    FOREIGN KEY (dlc_id, game_id)
    REFERENCES catalogue.dlcs (id, game_id)
);

CREATE TABLE catalogue.missions (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  dlc_id catalogue.slug,
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  story boolean NOT NULL,
  summary catalogue.summary NOT NULL,
  description catalogue.non_empty,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  CONSTRAINT missions_dlc_fkey
    FOREIGN KEY (dlc_id, game_id)
    REFERENCES catalogue.dlcs (id, game_id)
);

CREATE TABLE catalogue.mission_enemies (
  mission_id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL,
  enemy_id catalogue.slug NOT NULL,
  PRIMARY KEY (mission_id, game_id, enemy_id),
  CONSTRAINT mission_enemies_mission_fkey
    FOREIGN KEY (mission_id, game_id)
    REFERENCES catalogue.missions (id, game_id) ON DELETE CASCADE,
  CONSTRAINT mission_enemies_enemy_fkey
    FOREIGN KEY (enemy_id, game_id)
    REFERENCES catalogue.enemies (id, game_id) ON DELETE CASCADE
);

-- --------------------------------------------------------------------
-- Indexes
-- --------------------------------------------------------------------

CREATE INDEX enemies_game_kind_idx ON catalogue.enemies (game_id, kind);
CREATE INDEX enemies_game_family_idx ON catalogue.enemies (game_id, family);

-- migrate:down
DROP TABLE IF EXISTS catalogue.mission_enemies;
DROP TABLE IF EXISTS catalogue.missions;
DROP TABLE IF EXISTS catalogue.locations;
DROP TABLE IF EXISTS catalogue.enemies;
DROP TABLE IF EXISTS catalogue.game_manufacturers;
DROP TABLE IF EXISTS catalogue.manufacturers;
DROP TABLE IF EXISTS catalogue.game_elements;
DROP TABLE IF EXISTS catalogue.elements;
DROP TABLE IF EXISTS catalogue.game_rarities;
DROP TABLE IF EXISTS catalogue.rarities;
DROP TABLE IF EXISTS catalogue.dlcs;
DROP TABLE IF EXISTS catalogue.releases;
DROP TABLE IF EXISTS catalogue.games;
