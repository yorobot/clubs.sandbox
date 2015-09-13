# encoding: utf-8


def make_readme( title, repo, stats )

  ## sort start by season (latest first) than by name (e.g. 1-bundesliga, cup, etc.)
  stats = stats.sort do |l,r|
    v =  r.season   <=> l.season
    v =  l.filename <=> r.filename  if v == 0  ## same season
    v
  end

  header =<<EOS

# #{title}

football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Archive Data for
#{title}

_Last Update: #{Time.now}_

EOS

  footer =<<EOS

## Questions? Comments?

Send them along to the
[Open Sports & Friends Forum](http://groups.google.com/group/opensport).
Thanks!
EOS


  txt = ''
  txt << header
  
  txt << "| Season | League, Cup | Rounds |\n"
  txt << "|:------ | :---------- | -----: |\n"

  stats.each do |stat|
    txt << "| #{stat.season} "
    txt << "| [#{stat.filename}](#{stat.path}/#{stat.filename}) "
    txt << "| #{stat.rounds} "
    txt << "|\n"
  end

  txt << "\n\n" 

  txt << footer


  ### save report as README.md in repo
  dest_path = "#{repo}/README.md"
  File.open( dest_path, 'w' ) do |f|
    f.write txt
  end
end  # method make_readme
