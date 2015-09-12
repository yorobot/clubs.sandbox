# encoding: utf-8

task :at do
  fetch_rsssf( AT_BASE, AT, 'oost', AT_REPO )
end

task :at2 do
  stats = []

  cfg = ScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Bundesliga' ] }
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  stats += make_schedules( AT, 'oost', AT_REPO, cfg )

  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: '.FB Cup', cup: true ] }  ## fix: utf8- for ÖFB Cup

  stats += make_schedules( AT, 'oost', AT_REPO, cfg )

  make_readme( 'Austria (Österreich)', AT_REPO, stats )
end

task :debugat do
  cfg = ScheduleConfig.new
  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: '.FB Cup', cup: true ] }  ## fix: utf8- for ÖFB Cup
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  make_schedules( [2013], 'oost', AT_REPO, cfg )
end


