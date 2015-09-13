# encoding: utf-8


AT_REPO  = '../at-austria'
AT_TITLE = 'Austria (Österreich)'


task :at do
  fetch_rsssf_pages( AT_REPO, YAML.load_file( "#{AT_REPO}/tables/config.yml") )
end


task :atup do
  patch_dir( "#{AT_REPO}/tables" ) do |txt, name, year|
    puts "patching #{year} (#{name})..."
    ## to be done
    ## patch_at( txt, name, year )
  end
end


task :atii do
  make_rsssf_pages_summary( AT_TITLE, AT_REPO )
end




task :at2 do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'Bundesliga' ] }  ## fix: check opt - allow hash or proc (simplify)!!!
  cfg.dir_for_year                = ->(year) { archive_dir_for_year(year) }   ## fix: make it default if not set!!!

  stats += make_schedules( AT_REPO, cfg )


  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'ÖFB Cup', cup: true ] }

  stats += make_schedules( AT_REPO, cfg )

  make_readme( AT_TITLE, AT_REPO, stats )
end


task :debugat do
  cfg = RsssfScheduleConfig.new
  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'ÖFB Cup', cup: true ] }
  cfg.dir_for_year = ->(year) { archive_dir_for_year(year) }
  cfg.includes = [2013]
  make_schedules( AT_REPO, cfg )
end


