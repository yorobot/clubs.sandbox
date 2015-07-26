# encoding: utf-8


def make_readme( title, repo, stats )

  ## sort start by season (latest first) than by name (e.g. 1-bundesliga, cup, etc.)
  stats = stats.sort do |l,r|
    v =  r[0] <=> l[0]
    v =  l[1] <=> r[1]  if v == 0  ## same season
    v
  end

  header =<<EOS

# #{title}

football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Archive Data for
#{title}

_Last Update: #{Time.now}_

EOS

  questions =<<EOS

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
    txt << "| #{stat[0]} "
    txt << "| [#{stat[1]}](#{stat[0]}/#{stat[1]}) "
    txt << "| #{stat[2]} "
    txt << "|\n"
  end

  txt << "\n\n" 

  txt << questions


  ### save report as README.md in repo
  dest_path = "#{repo}/README.md"
  File.open( dest_path, 'w' ) do |f|
    f.write txt
  end
end  # method make_readme
