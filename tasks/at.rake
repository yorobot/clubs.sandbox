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

  at = WorldDb::Model::Country.find_by!( key: 'at' )

  ## read in clubs
  ##  note: requires country_id
  ['1-bundesliga', '2-liga1'].each do |clubs|
    r = SportDb::TeamReader.from_file( "#{AT_INCLUDE_PATH}/clubs/#{clubs}.txt", country_id: at.id)
    r.read
  end

  ## read in leagues
  ##  note: requires country_id 
  r = SportDb::LeagueReader.from_file( "#{AT_INCLUDE_PATH}/leagues.txt", country_id: at.id )
  r.read

  ## read in event configs (no fixtures)
  ['2015-16', '2014-15', '2013-14'].each do |season|
    r = SportDb::EventReader.from_file( "#{AT_INCLUDE_PATH}/#{season}/1-bundesliga.yml" )
    r.read  
  end
  
  ## last but not least read rsssf files (from rsssf repo)
  ['2014-15', '2013-14'].each do |season|
    txt = File.read_utf8( "#{AT_RSSSF_PATH}/#{season}/1-bundesliga.txt" )
    pp txt

    event_key = "at.#{season.tr('-','/')}"    ## e.g. 2014-15 => at.2014/15
    r = SportDb::RsssfGameReader.from_string( event_key, txt )
    r.read
  end

end

task :recalc_at => :configsport do
  out_root = debug? ? './build/at-austria' : AT_RSSSF_PATH

  [['at.2013/14'],
   ['at.2014/15']].each do |event_key|
     recalc_standings( event_key, out_root: out_root )
     ## recalc_stats( out_root: out_root )
  end
end
