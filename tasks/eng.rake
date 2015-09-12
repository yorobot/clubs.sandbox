# encoding: utf-8

task :eng do
  fetch_rsssf( ENG_BASE, ENG, 'eng', ENG_REPO )
end

task :eng2 do
  stats = []

  cfg = ScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Premiership|Premier League' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  stats += make_schedules( ENG, 'eng', ENG_REPO, cfg )

  cfg.name = 'facup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'FA Cup', cup: true ] }

  stats += make_schedules( ENG, 'eng', ENG_REPO, cfg )

  cfg.name = 'leaguecup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'League Cup', cup: true ] }

  stats += make_schedules( ENG, 'eng', ENG_REPO, cfg )  


  make_readme( 'England (and Wales)', ENG_REPO, stats )
end


task :engii do
  ## sanitize_dir( "#{DE_REPO}/tables" )
  ## rsssf_pages_stats_for_dir( "#{DE_REPO}/tables" )
  make_summary( 'England (and Wales)', ENG_REPO )
end


task :debugeng do
  cfg = ScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Premiership|Premier League' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  make_schedules( [2015], 'eng', ENG_REPO, cfg )
end

