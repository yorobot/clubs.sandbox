# encoding: utf-8


ENG_REPO_PATH  = '../eng-england'
ENG_TITLE      = 'England (and Wales)'

ENG_REPO = RsssfRepo.new( ENG_REPO_PATH, title: ENG_TITLE )

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


