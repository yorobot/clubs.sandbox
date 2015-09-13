# encoding: utf-8


DE_REPO  = '../de-deutschland'
DE_TITLE = 'Germany (Deutschland)'



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
  make_rsssf_pages_summary( DE_TITLE, DE_REPO )
end




task :de2 do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = ->(year) {
    if year <= 1999
      {}  # no header; assume single league file; return empty hash
    else
      { header: '1\. Bundesliga' }
    end
  }
  cfg.dir_for_year = ->(year) { archive_dir_for_year(year) }

  ## for debugging - use filer (to process only some files)
  ## cfg.includes = [1964, 1965, 1971, 1972, 2014, 2015]

  stats += make_schedules( DE_REPO, cfg )


  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = ->(year) {  Hash[ header: 'DFB Pokal', cup: true ] }

  ## for debugging - use filer (to process only some files)
  cfg.includes = (1997..2015).to_a

  stats += make_schedules( DE_REPO, cfg )  ## note: use specific DE_CUP array

  make_readme( DE_TITLE, DE_REPO, stats )
end


