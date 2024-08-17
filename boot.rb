$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-langs/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-structs/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-formats/lib' )
$LOAD_PATH.unshift( '../../sportdb/sport.db/sportdb-catalogs/lib' )
require 'sportdb/catalogs'

SportDb::Import.config.catalog_path = '../../sportdb/sport.db/catalog/catalog.db'


###
#  dump built-in table stats / record counts
CatalogDb::Metal.tables


##
## note - fix - pull in cocos by structs? or formats?
require 'cocos'


Country = Sports::Country  # or SportDb::Import::Country or WorldDB ???
Club    = Sports::Club     # or SportDb::Import::Club
League  = Sports::League



LIE = Country.find_by( name: 'Liechtenstein' )
MCO = Country.find_by( name: 'Monaco' )
NIR = Country.find_by( name: 'Northern Ireland' )
WAL = Country.find_by( name: 'Wales' )

class Club
   def self.match_by_and_autofix( name:, country: )

        ## change country for know
        if country
          country = LIE  if country.code == 'SUI' &&
                            ['FC Vaduz'].include?( name )
          country = MCO  if country.code == 'FRA' &&
                            ['AS Monaco',
                             'AS Monaco FC',
                             'Monaco'].include?( name )
          country = NIR  if country.code == 'IRL' &&
                            ['Derry City FC','Derry'].include?( name )
          country = WAL  if country.code == 'ENG' &&
                            ['Swansea City AFC','Swansea'].include?( name )
        end

        match_by( name:     name,
                  country:  country )
   end
end





__END__


## gems pull in by (hello) banner

alphabets/1.0.2 on Ruby 3.2.2 (2023-03-30)
date-formats/1.0.2 on Ruby 3.2.2 (2023-03-30)
season-formats/0.0.1 on Ruby 3.2.2 (2023-03-30)
score-formats/0.1.1 on Ruby 3.2.2 (2023-03-30)
sportdb-langs/0.1.1 on Ruby 3.2.2 (2023-03-30)
sportdb-structs/0.2.1 on Ruby 3.2.2 (2023-03-30)
sportdb-formats/1.2.1 on Ruby 3.2.2 (2023-03-30)
footballdb-data/2024.6.22 on Ruby 3.2.2 (2023-03-30)
sportdb-catalogs/1.2.0 on Ruby 3.2.2 (2023-03-30)
