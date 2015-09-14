# encoding: utf-8


AT_REPO_PATH  = '../at-austria'
AT_TITLE      = 'Austria (Österreich)'

AT_REPO = RsssfRepo.new( AT_REPO_PATH, title: AT_TITLE )


task :at => [:ati,:atii,:atiii] do
end


task :ati do
  AT_REPO.fetch_pages
end

task :atii do
  ## AT_REPO.patch_pages( patcher )
end

task :atiii do
  AT_REPO.make_pages_summary
end





task :atv do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.opts_for_year = { header: 'Bundesliga' }

  stats += AT_REPO.make_schedules( cfg )


  cfg.name = 'cup'
  cfg.opts_for_year = { header: 'ÖFB Cup', cup: true }

  stats += AT_REPO.make_schedules( cfg )


  AT_REPO.make_schedules_summary( stats )   ## e.g. update README.md
end


task :debugat do
  cfg = RsssfScheduleConfig.new
  cfg.name = 'cup'
  cfg.opts_for_year = { header: 'ÖFB Cup', cup: true }
  cfg.includes = [2013]

  AT_REPO.make_schedules( cfg )
end


