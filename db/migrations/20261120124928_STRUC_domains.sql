-- migrate:up
CREATE DOMAIN catalogue.slug AS text
  CONSTRAINT slug_check CHECK (VALUE ~ '^[a-z0-9]+(?:-[a-z0-9]+)*$');

CREATE DOMAIN catalogue.enemy_kind AS text
  CONSTRAINT enemy_kind_check CHECK (VALUE IN ('named', 'boss', 'mob'));

CREATE DOMAIN catalogue.non_empty AS text
  CONSTRAINT non_empty_check CHECK (char_length(btrim(VALUE)) > 0);

CREATE DOMAIN catalogue.summary AS catalogue.non_empty
  CONSTRAINT summary_check CHECK (VALUE !~ '[\n\r]');

COMMENT ON DOMAIN catalogue.slug IS
  'Lowercase kebab-case key or URL segment, such as bone-head. No spaces, underscores or capitals.';
COMMENT ON DOMAIN catalogue.enemy_kind IS
  'named for a unique enemy that is not a boss. boss for a boss. mob for a repeating archetype.';
COMMENT ON DOMAIN catalogue.non_empty IS
  'Text that contains something other than whitespace. Null is still allowed where the column is optional.';
COMMENT ON DOMAIN catalogue.summary IS
  'One line of non-empty text. Line breaks are rejected.';

-- migrate:down
DROP DOMAIN IF EXISTS catalogue.summary;
DROP DOMAIN IF EXISTS catalogue.non_empty;
DROP DOMAIN IF EXISTS catalogue.enemy_kind;
DROP DOMAIN IF EXISTS catalogue.slug;
