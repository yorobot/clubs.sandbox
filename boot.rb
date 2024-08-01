$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-catalogs/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../sportdb/sport.db/catalog/catalog.db'


## fix - use CatalogDb::Metal.tables or such ???

puts "  #{CatalogDb::Metal::Country.count} countries"
puts "  #{CatalogDb::Metal::Club.count} clubs"
puts "  #{CatalogDb::Metal::NationalTeam.count} national teams"
puts "  #{CatalogDb::Metal::League.count} leagues"


require 'cocos'     ## note - cocos now pulled in by structs? or formats?


