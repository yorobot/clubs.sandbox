# encoding: utf-8


require './scripts/html2txt'
require './scripts/schedule'


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


DE_BASE = 'http://www.rsssf.com/tablesd'
DE      = [64, 65, 66, 67, 2011, 2012, 2013, 2014, 2015]
## DE = [64, 65, 66, 67]
## DE = [2015]
## e.g. http://www.rsssf.com/tablesd/duit2014.html
##      http://www.rsssf.com/tablesd/duit64.html

DE_REPO = '../de-deutschland'


AT_BASE = 'http://www.rsssf.com/tableso'
AT      = [2011, 2012, 2013, 2014, 2015]
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



task :eng do
  fetch_rsssf( ENG_BASE, ENG, 'eng', ENG_REPO )
end

task :eng2 do
  cfg = ScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Premiership|Premier League' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  make_schedules( ENG, 'eng', ENG_REPO, cfg )
end



task :de do
  fetch_rsssf( DE_BASE, DE, 'duit', DE_REPO )
end

task :de2 do
  cfg = ScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = ->(year) {
    if year < 100
      Hash[]  # no header; assume single league file
    else
      Hash[ header: '1\. Bundesliga' ]
    end
  }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  make_schedules( DE, 'duit', DE_REPO, cfg )
end


task :at do
  fetch_rsssf( AT_BASE, AT, 'oost', AT_REPO )
end

task :at2 do
  cfg = ScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Bundesliga' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  make_schedules( AT, 'oost', AT_REPO, cfg )
end



task :es do
  fetch_rsssf( ES_BASE, ES, 'span', ES_REPO )
end

task :es2 do
  cfg = ScheduleConfig.new
  cfg.name = '1-liga'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'Primera' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }
  ## fix: use utf-8 e.g. Primera División

  make_schedules( ES, 'span', ES_REPO, cfg )
end


task :br do
  fetch_rsssf( BR_BASE, BR, 'braz', BR_REPO )
end

task :br2 do
  cfg = ScheduleConfig.new
  cfg.name = '1-seriea'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'S.rie A' ] }
  cfg.dir_for_year = ->(year) { year.to_s }   ## note: no mapping (season runs all year)
   ## Série A
   ## fix: utf-8 issue;  use S.rie A for now

  make_schedules( BR, 'braz', BR_REPO, cfg )
end




ScheduleConfig = Struct.new(
                  :name,
                  :find_schedule_opts_for_year,
                  :dir_for_year)


def make_schedules( years, shortcut, repo, cfg )

  years.each do |year|
    src_txt = "#{repo}/tables/#{shortcut}#{year}.txt"
    puts "  reading >#{src_txt}<"
    txt   = File.read( src_txt )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)
    
    
    ## header: 'Primera' --  ## fix: use utf-8 e.g. Primera División
    opts = cfg.find_schedule_opts_for_year.call(year)
    pp opts
    schedule = find_schedule( txt, opts )
    ## pp schedule

    ## -- cfg.name               e.g. => 1-liga
    ## -- cfg.dir_for_year(2011) e.g. => YEAR_TO_SEASON[2011]

    dest_path = "#{repo}/#{cfg.dir_for_year.call(year)}/#{cfg.name}.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    File.open( dest_path, 'w' ) do |f|
      f.write schedule
    end
  end

end # method make_schedules


def fetch_rsssf( dl_base, years, shortcut, repo )

  years.each do |year|
    src_url = "#{dl_base}/#{shortcut}#{year}.html"
    html  = fetch( src_url )
    txt   = html_to_txt( html )

    header = <<EOS
<!--
   source: #{src_url}
   html to text conversion on #{Time.now}
  -->

EOS

    dest_path = "#{repo}/tables/#{shortcut}#{year}.txt"
    File.open( dest_path, 'w' ) do |f|
      f.write header
      f.write txt
    end
  end # each year
end # method fetch_rsssf

