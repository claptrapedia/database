-- migrate:up
CREATE DOMAIN catalogue.slug AS text
  CONSTRAINT slug_check CHECK (VALUE ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$');

CREATE DOMAIN catalogue.enemy_kind AS text
  CONSTRAINT enemy_kind_check CHECK (VALUE IN ('named', 'boss', 'mob'));

CREATE DOMAIN catalogue.rarity_colour AS text
  CONSTRAINT rarity_colour_check CHECK (VALUE IN (
    'white',
    'green',
    'blue',
    'purple',
    'orange',
    'pearlescent'
  ));

CREATE DOMAIN catalogue.non_empty AS text
  CONSTRAINT non_empty_check CHECK (char_length(btrim(VALUE)) > 0);

CREATE DOMAIN catalogue.summary AS catalogue.non_empty
  CONSTRAINT summary_check CHECK (VALUE !~ '[\n\r]');

-- migrate:down
DROP DOMAIN IF EXISTS catalogue.summary;
DROP DOMAIN IF EXISTS catalogue.non_empty;
DROP DOMAIN IF EXISTS catalogue.rarity_colour;
DROP DOMAIN IF EXISTS catalogue.enemy_kind;
DROP DOMAIN IF EXISTS catalogue.slug;
