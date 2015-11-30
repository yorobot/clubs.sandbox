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

