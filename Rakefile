# encoding: utf-8

require './scripts/fetch.rb'
require './scripts/html2txt'
require './scripts/schedule'

require './scripts/mkreadme'
require './scripts/mksummary'

require './scripts/utils'
require './scripts/patch'





ENG_BASE = 'http://rsssf.com/tablese'
ENG      = [2011, 2012, 2013, 2014, 2015]
## ENG      = [2011]
## e.g. http://rsssf.com/tablese/eng2015.html

ENG_REPO = '../eng-england'

## Premiership  in 2011,2012, 2013
## Premier League in 2014, 2015
##
## todo/fix:
### reading >../en-england/tables/eng2014.txt<
##  includes  invalid byte sequence in UTF-8 !!!





ES_BASE = 'http://www.rsssf.com/tabless'
ES      = [2011, 2012, 2013, 2014, 2015]
## e.g. http://www.rsssf.com/tabless/span2013.html

ES_REPO = '../es-espana'



BR_BASE = 'http://www.rsssf.com/tablesb'
BR      = [2011, 2012, 2013, 2014, 2015]   ## note: no season 
## e.g. http://www.rsssf.com/tablesb/braz2012.html

BR_REPO = '../br-brazil'



RsssfScheduleConfig = Struct.new(
  :name,
  :find_schedule_opts_for_year,
  :dir_for_year,
  :includes
)


RsssfScheduleStat = Struct.new(
  :path,          ## e.g. 2012-13 or archive/1980s/1984-85
  :filename,      ## e.g. 1-bundesliga.txt   -- note: w/o path
  :year,          ## e.g. 2013      -- note: numeric (integer)
  :season,        ## e.g. 2012-13   -- note: is a string
  :rounds        ## e.g. 36   -- note: numeric (integer)
)


def make_schedules( repo, cfg )

  ## note: return stats (for report eg. README)
  stats = []
  
  files = Dir[ "#{repo}/tables/*.txt" ]
  files.each do |file|

    
    extname  = File.extname( file )
    basename = File.basename( file, extname )
    year     = year_from_name( basename )
    season   = year_to_season( year )

    if cfg.includes && cfg.includes.include?( year ) == false
      puts "   skipping #{basename}; not listed in includes"
      next
    end


    puts "  reading >#{basename}<"

    txt = File.read_utf8( file )    # note: always assume sources (already) converted to utf-8 
  
        
    ## check/todo/fix -- header: 'Primera' --  ## fix: use utf-8 e.g. Primera División
    opts = cfg.find_schedule_opts_for_year.call( year )
    pp opts
    rounds, schedule = find_schedule( txt, opts )
    ## pp schedule

    ## -- cfg.name               e.g. => 1-liga
    ## -- cfg.dir_for_year(2011) e.g. => YEAR_TO_SEASON[2011]

    dest_path = "#{repo}/#{cfg.dir_for_year.call( year )}/#{cfg.name}.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    File.open( dest_path, 'w' ) do |f|
      f.write schedule
    end

    rec = RsssfScheduleStat.new
    rec.path     = cfg.dir_for_year.call(year)
    rec.filename = "#{cfg.name}.txt"    ## change to basename - why?? why not?? 
    rec.year     = year
    rec.season   = season
    rec.rounds   = rounds

    stats << rec
  end

  stats  # return stats for reporting
end # method make_schedules




############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts "  importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end
