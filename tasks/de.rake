# encoding: utf-8


DE_RSSSF_PATH  = "#{RSSSF_ROOT}/de-deutschland"
DE_TITLE       = 'Germany (Deutschland)'

DE_REPO = RsssfRepo.new( DE_RSSSF_PATH, title: DE_TITLE )      


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




##
#  for testing for now try:
#
#  $ rake build recalc_de DATA=de

task :importde => :importbuiltin do

  de = WorldDb::Model::Country.find_by!( key: 'de' )

  ## read in clubs
  ##  note: requires country_id   e.g. de.id
  ['1-bundesliga', '2-bundesliga2'].each do |clubs|
    r = SportDb::TeamReader.from_file( "#{DE_INCLUDE_PATH}/clubs/#{clubs}.txt", country_id: de.id)
    r.read
  end

  ## read in leagues
  ##  note: requires country_id   e.g. de.id
  r = SportDb::LeagueReader.from_file( "#{DE_INCLUDE_PATH}/leagues.txt", country_id: de.id )
  r.read

  ## read in event configs (no fixtures)
  ['2015-16', '2014-15', '2013-14'].each do |season|
    r = SportDb::EventReader.from_file( "#{DE_INCLUDE_PATH}/#{season}/1-bundesliga.yml" )
    r.read  
  end
  
  ## last but not least read rsssf files (from rsssf repo)
  ['2014-15', '2013-14'].each do |season|
    ## note: rsssf text read in as iso-8859-15 for now (fix: convert in importer to utf-8!!)
    ## txt = File.open( "#{DE_RSSSF_PATH}/#{season}/1-bundesliga.txt", "r:iso-8859-15" ).read
    ## txt = txt.encode( "utf-8" )
    txt = File.read_utf8( "#{DE_RSSSF_PATH}/#{season}/1-bundesliga.txt" )
    
    pp txt
    event_key = "de.#{season.tr('-','/')}"    ## e.g. 2014-15 => de.2014/15
    r = SportDb::RsssfGameReader.from_string( event_key, txt )
    r.read
  end

end

task :recalc_de => :configsport do
  out_root = debug? ? './build/de-deutschland' : DE_RSSSF_PATH

  [['de.2013/14'],
   ['de.2014/15']].each do |event_key|
     recalc_standings( event_key, out_root: out_root )
     ## recalc_stats( out_root: out_root )
  end
end

