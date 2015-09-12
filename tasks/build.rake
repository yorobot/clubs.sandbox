# encoding: utf-8

## build database (for import)


$RUBYLIBS_DEBUG = true

# 3rd party libs/gems
require 'worlddb/models'   ## todo/check: just require worlddb/models - why, why not??
require 'sportdb/models'   ## todo/check: just require sportdb/models - why, why not??
require 'logutils/activerecord' ## add db logging

# our own code
require './settings'     ## move to Rakefile - why/why not??


DB_CONFIG = {
  adapter:   'sqlite3',
  database:  ':memory:'
}

###
# for testing/debuggin change to file

## DB_CONFIG = {
##  adapter:   'sqlite3',
##  database:  './build/sport.db'
## }



task :env do
  pp DB_CONFIG
  ActiveRecord::Base.establish_connection( DB_CONFIG )

  db_adapter  = DB_CONFIG[ 'adapter' ]   || DB_CONFIG[ :adapter ] 
  db_database = DB_CONFIG[ 'database' ]  || DB_CONFIG[ :database ]
  if db_adapter == 'sqlite3' && db_database != ':memory:'
    puts "*** sqlite3 database on filesystem; try speedup..."
    ## try to speed up sqlite
    ##   see http://www.sqlite.org/pragma.html
    c = ActiveRecord::Base.connection
    c.execute( 'PRAGMA synchronous=OFF;' )
    c.execute( 'PRAGMA journal_mode=OFF;' )
    c.execute( 'PRAGMA temp_store=MEMORY;' )
  end
end

task :config  => :env  do
  logger = LogUtils::Logger.root
  # logger.level = :info

  ## log all warns, errors, fatals to db
  LogDb.setup
  logger.warn "Rakefile - #{Time.now}"  # say hello; log to db (warn level min)  
end

task :configworld => :config do
  logger = LogUtils::Logger.root
  logger.level = :info
end

task :configsport => :config do
  logger = LogUtils::Logger.root
  ## logger.level = :info
  logger.level = :debug
end


task :create => :env do
  SportDb.create_all
end


task :importworld => :configworld do
  # populate world tables
  #  use countries only for now (faster)
  WorldDb.read_setup( 'setups/countries', WORLD_DB_INCLUDE_PATH, skip_tags: true )
end

task :importbuiltin => :env do
  SportDb.read_builtin
end




####################################################
#  move to main Rakefile - why? why not??
#   or to scripts/utils.rb ????

def debug?
  debug_value = ENV['DEBUG']
  if debug_value &&  ['true', 't', 'yes', 'y'].include?( debug_value.downcase )
    true
  else
    false
  end 
end



task :importde => :importbuiltin do

  de = WorldDb::Model::Country.find_by!( key: 'de' )

  ## read in clubs
  ##  note: requires country_id   e.g. de.id
  ['1-bundesliga', '2-bundesliga2'].each do |clubs|
    r = SportDb::TeamReader.from_file( "#{DE_INCLUDE_PATH}/clubs/#{clubs}.txt", country_id: de.id)
    r.read
  end

  ## read in leagues
  ##  note: requires country_id   e.g. de.id
  r = SportDb::LeagueReader.from_file( "#{DE_INCLUDE_PATH}/leagues.txt", country_id: de.id )
  r.read

  ## read in event configs (no fixtures)
  ['2015-16', '2014-15', '2013-14'].each do |season|
    r = SportDb::EventReader.from_file( "#{DE_INCLUDE_PATH}/#{season}/1-bundesliga.yml" )
    r.read  
  end
  
  ## last but not least read rsssf files (from rsssf repo)
  ['2014-15', '2013-14'].each do |season|
    ## note: rsssf text read in as iso-8859-15 for now (fix: convert in importer to utf-8!!)
    txt = File.open( "../de-deutschland/#{season}/1-bundesliga.txt", "r:iso-8859-15" ).read
    txt = txt.encode( "utf-8" )
    
    pp txt
    event_key = "de.#{season.tr('-','/')}"    ## e.g. 2014-15 => de.2014/15
    r = SportDb::RsssfGameReader.from_string( event_key, txt )
    r.read
  end

end



task :importall => [:importde] do
end



#########################################################
# note: change deps to what you want to import for now

##
# default to worldcup (if no key given)
#
# e.g. use like
#  $ rake build  DATA=en
#  etc.


DATA_KEY = ENV['DATA'] || ENV['DATASET'] || 'all'
puts "  using DATA_KEY >#{DATA_KEY}<"

## note: use import prefix for now e.g. import+de => importde etc.
task :importsport => [:configsport, "import#{DATA_KEY}".to_sym] do
  # nothing here
end


desc 'build football.db from scratch (default)'
task :build => [:create, :importworld, :importsport] do
  puts 'Done.'
end

