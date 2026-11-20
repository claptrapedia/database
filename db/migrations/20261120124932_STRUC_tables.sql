-- migrate:up
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
  summary catalogue.summary,
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

CREATE TABLE catalogue.enemies (
  id catalogue.slug NOT NULL,
  game_id catalogue.slug NOT NULL REFERENCES catalogue.games (id),
  dlc_id catalogue.slug,
  slug catalogue.slug NOT NULL,
  name catalogue.non_empty NOT NULL,
  kind catalogue.enemy_kind NOT NULL,
  family catalogue.slug,
  rank catalogue.slug,
  summary catalogue.summary,
  description catalogue.non_empty,
  PRIMARY KEY (id, game_id),
  UNIQUE (game_id, slug),
  CONSTRAINT enemies_dlc_fkey
    FOREIGN KEY (dlc_id, game_id)
    REFERENCES catalogue.dlcs (id, game_id)
);

CREATE INDEX enemies_game_kind_idx ON catalogue.enemies (game_id, kind);
CREATE INDEX enemies_game_family_idx ON catalogue.enemies (game_id, family);

COMMENT ON TABLE catalogue.games IS
  'A Borderlands title, such as Borderlands 1. Distinct from a release and from a DLC.';
COMMENT ON COLUMN catalogue.games.id IS
  'Stable key, for example bl1. Not the public URL.';
COMMENT ON COLUMN catalogue.games.slug IS
  'Public URL segment. Editable without changing id.';
COMMENT ON COLUMN catalogue.games.position IS
  'Display order across the whole catalogue. Unique.';

COMMENT ON TABLE catalogue.releases IS
  'An edition of one game, such as the original, GOTY or GOTY Enhanced. Not a patch and not a DLC.';
COMMENT ON COLUMN catalogue.releases.id IS
  'Stable key within the game, for example goty-enhanced.';
COMMENT ON COLUMN catalogue.releases.game_id IS
  'The game this release belongs to.';
COMMENT ON COLUMN catalogue.releases.slug IS
  'Public URL segment, unique within the game.';
COMMENT ON COLUMN catalogue.releases.summary IS
  'One-line catalogue summary. No line breaks.';
COMMENT ON COLUMN catalogue.releases.position IS
  'Display order within the game. Each game has its own 1, 2, 3.';

COMMENT ON TABLE catalogue.dlcs IS
  'A downloadable pack that introduced content for one game. Not a location where something drops.';
COMMENT ON COLUMN catalogue.dlcs.id IS
  'Stable key within the game, for example zombie-island.';
COMMENT ON COLUMN catalogue.dlcs.game_id IS
  'The game this DLC belongs to.';
COMMENT ON COLUMN catalogue.dlcs.slug IS
  'Public URL segment, unique within the game.';
COMMENT ON COLUMN catalogue.dlcs.position IS
  'Display order within the game. Each game has its own 1, 2, 3.';

COMMENT ON TABLE catalogue.enemies IS
  'A named enemy or a repeating mob. Skag and Badass Skag are separate rows.';
COMMENT ON COLUMN catalogue.enemies.id IS
  'Stable key within the game, for example bone-head.';
COMMENT ON COLUMN catalogue.enemies.game_id IS
  'The game this enemy belongs to.';
COMMENT ON COLUMN catalogue.enemies.dlc_id IS
  'DLC that introduced the enemy. Null for the base game. Not the DLC of a place where it appears.';
COMMENT ON COLUMN catalogue.enemies.slug IS
  'Public URL segment, unique within the game.';
COMMENT ON COLUMN catalogue.enemies.kind IS
  'named for a unique enemy such as Bone Head. mob for a repeating archetype such as Skag.';
COMMENT ON COLUMN catalogue.enemies.family IS
  'Species or archetype, such as skag, bandit or rakk. Shared by every tier of that species.';
COMMENT ON COLUMN catalogue.enemies.rank IS
  'Tier within the family, such as whelp, elder or badass. Null when the enemy is not a tier. Not the display order.';
COMMENT ON COLUMN catalogue.enemies.summary IS
  'One-line catalogue summary. No line breaks.';
COMMENT ON COLUMN catalogue.enemies.description IS
  'Longer catalogue prose. No length limit.';

-- migrate:down
DROP TABLE IF EXISTS catalogue.enemies;
DROP TABLE IF EXISTS catalogue.dlcs;
DROP TABLE IF EXISTS catalogue.releases;
DROP TABLE IF EXISTS catalogue.games;
