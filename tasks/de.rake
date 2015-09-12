# encoding: utf-8


DE_BASE = 'http://www.rsssf.com/tablesd'
DE      = [64, 65, 66, 67, 2011, 2012, 2013, 2014, 2015]
DE_CUP  = [2011, 2012, 2013, 2014, 2015]
## DE = [64, 65, 66, 67]
## DE = [2015]
## e.g. http://www.rsssf.com/tablesd/duit2014.html
##      http://www.rsssf.com/tablesd/duit64.html

DE_REPO = '../de-deutschland'



task :de do
  fetch_rsssf_pages( DE_REPO, YAML.load_file( "#{DE_REPO}/tables/config.yml") )
end


task :deup do
  patch_dir( "#{DE_REPO}/tables" ) do |txt, name, year|
    puts "patching #{year} (#{name})..."
    patch_de( txt, name, year )
  end
end

task :deiib do
  ## note: sanitize is part of html2txt (gets called at the end)
  ##  use deiib for testing/debugging/development/etc.
  sanitize_dir( "#{DE_REPO}/tables" )
end


task :deii do
  make_rsssf_pages_summary( 'Germany (Deutschland)', DE_REPO )
end



task :de2 do
  stats = []

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

  stats += make_schedules( DE, 'duit', DE_REPO, cfg )

  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) { Hash[ header: 'DFB Pokal', cup: true ] }

  stats += make_schedules( DE_CUP, 'duit', DE_REPO, cfg )  ## note: use specific DE_CUP array

  make_readme( 'Germany (Deutschland)', DE_REPO, stats )
end


