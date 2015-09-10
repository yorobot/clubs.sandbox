
# input repo sources config

# --- world.db ---

OPENMUNDI_ROOT        = "../../openmundi"
WORLD_DB_INCLUDE_PATH = "#{OPENMUNDI_ROOT}/world.db"

# --- football.db ---

OPENFOOTBALL_ROOT = "../../openfootball"

AT_INCLUDE_PATH          = "#{OPENFOOTBALL_ROOT}/at-austria"
DE_INCLUDE_PATH          = "#{OPENFOOTBALL_ROOT}/de-deutschland"
ENG_INCLUDE_PATH         = "#{OPENFOOTBALL_ROOT}/eng-england"
ES_INCLUDE_PATH          = "#{OPENFOOTBALL_ROOT}/es-espana"
IT_INCLUDE_PATH          = "#{OPENFOOTBALL_ROOT}/it-italy"


## check - paths in use??? remove - why? why not??
OPENFOOTBALL_PATHS = [
  AT_INCLUDE_PATH,
  DE_INCLUDE_PATH,
  ENG_INCLUDE_PATH,
  ES_INCLUDE_PATH,
  IT_INCLUDE_PATH
]
