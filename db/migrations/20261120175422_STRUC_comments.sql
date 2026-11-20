-- migrate:up

-- --------------------------------------------------------------------
-- Domains
-- --------------------------------------------------------------------

COMMENT ON DOMAIN catalogue.slug IS
  'Lowercase kebab-case key or URL segment, such as bone-head. No spaces, underscores or capitals.';
COMMENT ON DOMAIN catalogue.enemy_kind IS
  'named for a unique enemy that is not a boss. boss for a boss. mob for a repeating archetype.';
COMMENT ON DOMAIN catalogue.rarity_colour IS
  'Style token for a rarity: white, green, blue, purple, orange or pearlescent. Used as a CSS class, not as a CSS colour name.';
COMMENT ON DOMAIN catalogue.non_empty IS
  'Text that contains something other than whitespace. Null is still allowed where the column is optional.';
COMMENT ON DOMAIN catalogue.summary IS
  'One line of non-empty text. Line breaks are rejected.';

-- --------------------------------------------------------------------
-- Tables
-- --------------------------------------------------------------------

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
  'Required one-line catalogue summary. No line breaks.';
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

COMMENT ON TABLE catalogue.rarities IS
  'A shared rarity tier, such as common or legendary. Not a colour name, and not owned by one game. An item can use more than one tier.';
COMMENT ON COLUMN catalogue.rarities.id IS
  'Stable key, for example legendary or pearlescent. Not the public URL.';
COMMENT ON COLUMN catalogue.rarities.slug IS
  'Public URL segment. Editable without changing id.';
COMMENT ON COLUMN catalogue.rarities.colour IS
  'Style token for this tier. white is common, green uncommon, blue rare, purple epic, orange legendary, pearlescent pearlescent.';
COMMENT ON COLUMN catalogue.rarities.position IS
  'Display order of the ladder, from common upwards. Unique.';

COMMENT ON TABLE catalogue.game_rarities IS
  'The rarity tiers that exist in one game. The site uses this list for a game filter. An item does not define it.';

COMMENT ON TABLE catalogue.elements IS
  'A damage element, such as incendiary or shock. Shared across games. Fire is incendiary. none is not a row.';
COMMENT ON COLUMN catalogue.elements.id IS
  'Stable key, for example incendiary or shock. Not the public URL.';
COMMENT ON COLUMN catalogue.elements.slug IS
  'Public URL segment. Editable without changing id.';
COMMENT ON COLUMN catalogue.elements.summary IS
  'Required one-line catalogue summary. No line breaks.';
COMMENT ON COLUMN catalogue.elements.description IS
  'Longer catalogue prose. No length limit.';

COMMENT ON TABLE catalogue.game_elements IS
  'The elements that exist in one game. The site uses this list for a game filter. An item does not define it.';

COMMENT ON TABLE catalogue.manufacturers IS
  'A brand that makes gear, such as Dahl or Jakobs. Shared across games. A game does not own the brand.';
COMMENT ON COLUMN catalogue.manufacturers.id IS
  'Stable key, for example jakobs or ss-munitions. Not the public URL.';
COMMENT ON COLUMN catalogue.manufacturers.slug IS
  'Public URL segment. Editable without changing id.';
COMMENT ON COLUMN catalogue.manufacturers.summary IS
  'Required one-line catalogue summary. No line breaks.';
COMMENT ON COLUMN catalogue.manufacturers.description IS
  'Longer catalogue prose. No length limit.';

COMMENT ON TABLE catalogue.game_manufacturers IS
  'The manufacturers that exist in one game. The site uses this list for a game filter. An item does not define it.';

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
  'named for a unique enemy that is not a boss, such as Bone Head. boss for a boss, such as Sledge. mob for a repeating archetype such as Skag.';
COMMENT ON COLUMN catalogue.enemies.family IS
  'Species or archetype, such as skag, bandit or rakk. Shared by every tier of that species.';
COMMENT ON COLUMN catalogue.enemies.rank IS
  'Tier within the family, such as whelp, elder or badass. Null when the enemy is not a tier. Not the display order.';
COMMENT ON COLUMN catalogue.enemies.summary IS
  'Required one-line catalogue summary. No line breaks.';
COMMENT ON COLUMN catalogue.enemies.description IS
  'Longer catalogue prose. No length limit.';

-- migrate:down

