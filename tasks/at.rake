# encoding: utf-8


AT_RSSSF_PATH  = "#{RSSSF_ROOT}/at-austria"
AT_TITLE       = 'Austria (Österreich)'

AT_REPO = RsssfRepo.new( AT_RSSSF_PATH, title: AT_TITLE )


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



##
#  for testing for now try:
#
#  $ rake build recalc_at DATA=at

task :importat => :importbuiltin do

  fx1 = [
   'clubs/1-bundesliga',
   'clubs/2-liga1',
   'leagues', 
   '2015-16/1-bundesliga',
   '2014-15/1-bundesliga',
   '2013-14/1-bundesliga'
  ]

  prepare_rsssf_for_country( 'at', fx1, AT_INCLUDE_PATH )

  fx2 = {
    'at.2014/15' => '2014-15/1-bundesliga',
    'at.2013/14' => '2013-14/1-bundesliga'
  }

  read_rsssf( fx2, AT_RSSSF_PATH ) 
end


task :recalc_at => :configsport do
  out_root = debug? ? './build/at-austria' : AT_RSSSF_PATH

  [['at.2013/14'],
   ['at.2014/15']].each do |event_key|
     recalc_standings( event_key, out_root: out_root )
     ## recalc_stats( out_root: out_root )
  end
end
