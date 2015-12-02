# encoding: utf-8


ENG_RSSSF_PATH  = "#{RSSSF_ROOT}/eng-england"
ENG_TITLE      = 'England (and Wales)'

ENG_REPO = RsssfRepo.new( ENG_RSSSF_PATH, title: ENG_TITLE )

## Premiership  in 2011,2012, 2013
## Premier League in 2014, 2015



task :eng do
  ENG_REPO.fetch_pages
end

task :engii do
  ## ENG_REPO.sanitize_pages  ## - note: alreay included in html2txt filter; (re)run for debugging/testing
  ENG_REPO.make_pages_summary
end


task :eng2 do
  stats = []

  cfg = RsssfScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = { header: 'Premiership|Premier League' }

  ## for debugging/testing use includes
  ## ENG      = [2011, 2012, 2013, 2014, 2015]
  ## ENG      = [2011]
  cfg.includes = [2011,2014]

  stats += make_schedules( ENG_REPO, cfg )


  cfg.name = 'facup'
  cfg.find_schedule_opts_for_year = { header: 'FA Cup', cup: true }

  stats += make_schedules( ENG_REPO, cfg )


  cfg.name = 'leaguecup'
  cfg.find_schedule_opts_for_year = { header: 'League Cup', cup: true }

  stats += make_schedules( ENG_REPO, cfg )  


  make_readme( ENG_TITLE, ENG_REPO, stats )
end



task :debugeng do
  cfg = RsssfScheduleConfig.new
  cfg.name = '1-premierleague'
  cfg.find_schedule_opts_for_year = { header: 'Premiership|Premier League' }
  cfg.includes = [2015]

  make_schedules( ENG_REPO, cfg )
end


##
#  for testing for now try:
#
#  $ rake build recalc_eng DATA=eng

task :importeng => :importbuiltin do

  fx1 = [
   'clubs/1-premierleague',
   'clubs/2-championship',
   'clubs/wales',
   'leagues', 
   '2015-16/1-premierleague',
   '2014-15/1-premierleague',
   '2013-14/1-premierleague'
  ]

  prepare_rsssf_for_country( 'eng', fx1, ENG_INCLUDE_PATH )

  fx2 = {
    'en.2014/15' => '2014-15/1-premierleague',
    'en.2013/14' => '2013-14/1-premierleague'
  }

  read_rsssf( fx2, ENG_RSSSF_PATH )   ## note: use en for league key (NOT eng)  
end


task :recalc_eng => :configsport do
  out_root = debug? ? './build/eng-england' : ENG_RSSSF_PATH

  [['en.2013/14'],
   ['en.2014/15']].each do |event_key|
     recalc_standings( event_key, out_root: out_root )
     ## recalc_stats( out_root: out_root )
  end
end
