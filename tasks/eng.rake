# encoding: utf-8


ENG_REPO  = '../eng-england'
ENG_TITLE = 'England (and Wales)'

## Premiership  in 2011,2012, 2013
## Premier League in 2014, 2015
##
## todo/fix:
### reading >../en-england/tables/eng2014.txt<
##  includes  invalid byte sequence in UTF-8 !!!



task :eng do
  fetch_rsssf_pages( ENG_REPO, YAML.load_file( "#{ENG_REPO}/tables/config.yml") )
end


task :eng2 do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = { header: 'Premiership|Premier League' }

  ## for debugging/testing use includes
  ## ENG      = [2011, 2012, 2013, 2014, 2015]
  ## ENG      = [2011]
  cfg.includes = [2011,2014]

  stats += make_schedules( ENG_REPO, cfg )


  cfg.name = 'facup'
  cfg.find_schedule_opts_for_year = { header: 'FA Cup', cup: true }

  stats += make_schedules( ENG_REPO, cfg )


  cfg.name = 'leaguecup'
  cfg.find_schedule_opts_for_year = { header: 'League Cup', cup: true }

  stats += make_schedules( ENG_REPO, cfg )  


  make_readme( ENG_TITLE, ENG_REPO, stats )
end



task :engii do
  ## sanitize_dir( "#{DE_REPO}/tables" )
  ## rsssf_pages_stats_for_dir( "#{DE_REPO}/tables" )
  make_summary( ENG_TITLE, ENG_REPO )
end



task :debugeng do
  cfg = RsssfScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = { header: 'Premiership|Premier League' }
  cfg.includes = [2015]

  make_schedules( ENG_REPO, cfg )
end


