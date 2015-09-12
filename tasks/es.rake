# encoding: utf-8

task :es do
  fetch_rsssf( ES_BASE, ES, 'span', ES_REPO )
end

task :es2 do
  stats = []

  cfg = ScheduleConfig.new
  cfg.name = '1-liga'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'Primera' ] }   ## fix: use utf-8 e.g. Primera División
  cfg.dir_for_year = ->(year) { YEAR_TO_SEASON[year] }

  stats +=  make_schedules( ES, 'span', ES_REPO, cfg )

  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'Copa del Rey', cup: true ] }

  stats +=  make_schedules( ES, 'span', ES_REPO, cfg )

  make_readme( 'España (Spain)', ES_REPO, stats )
end


