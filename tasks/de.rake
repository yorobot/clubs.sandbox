# encoding: utf-8


DE_REPO_PATH  = '../de-deutschland'
DE_TITLE      = 'Germany (Deutschland)'

DE_REPO = RsssfRepo.new( DE_REPO_PATH, title: DE_TITLE )      


task :de => [:dei,:deii,:deiii] do
end



task :dei do
  DE_REPO.fetch_pages
end

task :deib do
  ## note: sanitize is part of html2txt (gets called at the end)
  ##  use deiib for testing/debugging/development/etc.
  DE_REPO.sanitize_pages
end


task :deii do
  patcher_de = RsssfPatcherDe.new
  DE_REPO.patch_pages( patcher_de )
end

task :deiii do
  DE_REPO.make_pages_summary
end



task :dev do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-bundesliga'
  cfg.opts_for_year = ->(year) {
    if year <= 1999
      {}  # no header; assume single league file; return empty hash
    else
      { header: '1\. Bundesliga' }
    end
  }
  ## for debugging - use filer (to process only some files)
  ## cfg.includes = [1964, 1965, 1971, 1972, 2014, 2015]

  stats += DE_REPO.make_schedules( cfg )


  cfg.name = 'cup'
  cfg.opts_for_year =  { header: 'DFB Pokal', cup: true }

  ## for debugging - use filer (to process only some files)
  cfg.includes = (1997..2015).to_a

  stats += DE_REPO.make_schedules( cfg )

  DE_REPO.make_schedules_summary( stats )
end


