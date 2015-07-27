# encoding: utf-8



## e.g. 2008/09
SEASON = '\d{4}\/\d{2}'  ## note: use single quotes - quotes do NOT get escaped (e.g. '\d' => "\\d")


BUNDESLIGA2 = [
  ## e.g. Second Level 2008/09
  ##      2.Bundesliga
  /^Second Level #{SEASON}\s+^2\.Bundesliga$/,
  ## e.g. 2.Bundesliga 
  /^2.Bundesliga$/,
]

LIGA3 = [
  ## e.g. Third Level 2008/09
  ##      3.Bundesliga
  /^Third Level #{SEASON}\s+^3\.Bundesliga$/,
]

CUP = [
  ## e.g. Germany Cup (DFB Pokal) 1998/99
  /^Germany Cup \(DFB Pokal\) #{SEASON}$/,
  ## e.g. DFB Pokal 2008/09
  /^DFB Pokal #{SEASON}$/,
]


###
## todo: move to patch.rb for (re)use ??

def patch_heading( txt, rxs, title )
  rxs.each do |rx|
    txt = txt.sub( rx ) do |match|
      match = match.gsub( "\n", '$$')  ## change newlines to $$ for single-line outputs/dumps
      puts "  found heading >#{match}<"
      "\n\n#### #{title}\n\n"
    end
  end
  txt
end



def patch_de( txt, name, year )
 
  if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
    ##  puts "  format -- year < 2010"
    ## try to add section header (marker)

    txt = patch_heading( txt, BUNDESLIGA2, '2. Bundesliga' )
    txt = patch_heading( txt, LIGA3,       '3. Liga'       )
    txt = patch_heading( txt, CUP,         'DFB Pokal'     )
  end # year < 2010

  txt
end # method patch_de


=begin


Germany 1998/99  2.Bundesliga
Germany 1998/99 Third Level (Regionalliga)
- Regionalliga Nord
- Regionalliga Nordost
- Regionalliga S&uuml;d
- Regionalliga West/S&uuml;dwest




Third Level 2008/09
3.Bundesliga

Third Level 2003/04
- Regionalliga Nord
- Regionalliga Süd

Fourth Level (Oberligen) 2003/04
 - Bayern
 - Baden-Württemberg
 - Hessen
 - Südwest
 - Nordrhein
 - Westfalen
 - Niedersachsen/Bremen
 - Hamburg/Schleswig-Holstein
 - Nordost Nord
 - Nordost Süd
 

Fourth Level 2008/09
 - Regionalliga Nord
 - Regionalliga West
 - Regionalliga Süd
 
1.Bundesliga
2.Bundesliga



duit99.txt
  check -> SG Hoechst - SG Quelle F"urth 0-2
  fix charset e.g.
  <META HTTP-EQUIV="Content-type" CONTENT="text/html; CHARSET=ISO-8859-1">

=end

