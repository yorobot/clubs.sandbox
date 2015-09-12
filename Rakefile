# encoding: utf-8

require './scripts/fetch.rb'
require './scripts/html2txt'
require './scripts/schedule'

require './scripts/mkreadme'
require './scripts/mksummary'

require './scripts/utils'
require './scripts/patch'


##
# fix/fix!!! use (new) year_to_season fn

YEAR_TO_SEASON =
{
  64   => '1963-64',
  65   => '1964-65',
  66   => '1965-66',
  67   => '1966-67',
  2011 => '2010-11',
  2012 => '2011-12',
  2013 => '2012-13',
  2014 => '2013-14',
  2015 => '2014-15',
  2016 => '2015-16',
}



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



AT_BASE = 'http://www.rsssf.com/tableso'
AT      = [2011, 2012, 2013, 2014, 2015, 2016]
## e.g. http://www.rsssf.com/tableso/oost2015.html 
AT_REPO = '../at-austria'



ES_BASE = 'http://www.rsssf.com/tabless'
ES      = [2011, 2012, 2013, 2014, 2015]
## e.g. http://www.rsssf.com/tabless/span2013.html

ES_REPO = '../es-espana'



BR_BASE = 'http://www.rsssf.com/tablesb'
BR      = [2011, 2012, 2013, 2014, 2015]   ## note: no season 
## e.g. http://www.rsssf.com/tablesb/braz2012.html

BR_REPO = '../br-brazil'



ScheduleConfig = Struct.new(
                  :name,
                  :find_schedule_opts_for_year,
                  :dir_for_year)


def make_schedules( years, shortcut, repo, cfg )

  ## note: return stats (for report eg. README)
  stats = []

  years.each do |year|
    src_txt = "#{repo}/tables/#{shortcut}#{year}.txt"
    puts "  reading >#{src_txt}<"
    txt   = File.read( src_txt )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)
    
    
    ## header: 'Primera' --  ## fix: use utf-8 e.g. Primera División
    opts = cfg.find_schedule_opts_for_year.call(year)
    pp opts
    rounds, schedule = find_schedule( txt, opts )
    ## pp schedule

    ## -- cfg.name               e.g. => 1-liga
    ## -- cfg.dir_for_year(2011) e.g. => YEAR_TO_SEASON[2011]

    dest_path = "#{repo}/#{cfg.dir_for_year.call(year)}/#{cfg.name}.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    File.open( dest_path, 'w' ) do |f|
      f.write schedule
    end

    stats << [cfg.dir_for_year.call(year), "#{cfg.name}.txt", rounds]
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
