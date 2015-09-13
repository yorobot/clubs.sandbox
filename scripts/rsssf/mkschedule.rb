# encoding: utf-8


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
  :rounds         ## e.g. 36   -- note: numeric (integer)
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

    page = RsssfPage.from_file( file ) # note: always assume sources (already) converted to utf-8

    if cfg.find_schedule_opts_for_year.is_a?( Hash )
      opts = cfg.find_schedule_opts_for_year    ## just use as is 1:1 (constant/same for all years)
    else
      ## assume it's a proc/lambda (call to calculate)
      opts = cfg.find_schedule_opts_for_year.call( year ) 
    end
    pp opts

    schedule = page.find_schedule( opts )
    ## pp schedule

 
    if cfg.dir_for_year.nil?
      ## use default setting, that is, archive for dir (e.g. archive/1980s/1985-86 etc.)
      dir_for_year = archive_dir_for_year( year )
    else
      ## assume it's a proc/lambda
      dir_for_year = cfg.dir_for_year.call( year )
    end

    ## -- cfg.name               e.g. => 1-liga

    dest_path = "#{repo}/#{dir_for_year}/#{cfg.name}.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    schedule.save( dest_path )

    rec = RsssfScheduleStat.new
    rec.path     = dir_for_year
    rec.filename = "#{cfg.name}.txt"    ## change to basename - why?? why not?? 
    rec.year     = year
    rec.season   = season
    rec.rounds   = schedule.rounds

    stats << rec
  end

  stats  # return stats for reporting
end # method make_schedules

