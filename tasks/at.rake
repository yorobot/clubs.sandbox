# encoding: utf-8


AT_REPO_PATH  = '../at-austria'
AT_TITLE      = 'Austria (Österreich)'

AT_REPO = RsssfRepo.new( AT_REPO_PATH, title: AT_TITLE )



task :at do
  AT_REPO.fetch_pages
end

task :atii do
  AT_REPO.make_pages_summary
end


task :atup do
  patch_dir( "#{AT_REPO}/tables" ) do |txt, name, year|
    puts "patching #{year} (#{name})..."
    ## to be done
    ## patch_at( txt, name, year )
  end
end




task :at2 do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.find_schedule_opts_for_year = { header: 'Bundesliga' }

  stats += make_schedules( AT_REPO, cfg )


  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = { header: 'ÖFB Cup', cup: true }

  stats += make_schedules( AT_REPO, cfg )


  report = RsssfScheduleReport.new( stats, title: AT_TITLE )
  report.save( "#{AT_REPO}/README.md" )
end


task :debugat do
  cfg = RsssfScheduleConfig.new
  cfg.name = 'cup'
  cfg.find_schedule_opts_for_year = { header: 'ÖFB Cup', cup: true }
  cfg.includes = [2013]

  make_schedules( AT_REPO, cfg )
end


