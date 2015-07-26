# encoding: utf-8


def year_from_name( name )
  if name =~ /(\d+)/
    digits = $1.to_s
    num    = digits.to_i

    if digits.size == 4   ## e.g. 1980 or 2011 etc.
      num
    elsif digits.size == 2  ## e.g. 00, 20 or 99 etc.
      if num <= 16  ## assume 20xx for now from 00..16
        2000+num
      else               ## assume 19xx for now
        1900+num
      end
    else
      fail( "no year found in name #{name}; expected two or four digits")
    end
  else
    fail( "no year found in name #{name}")
  end
end  # method year_from_name



def patch_de( txt, name )
 
   ## todo/fix: move into patch for (re)use for everyone!!
   ### todo: sort files by year first (before processing!!!
  year = year_from_name( name )

  if year < 2010   # note: duit2010 starts a new format w/ heading 4 sections etc.
    ##  puts "  format -- year < 2010"

    ## try to add section header (marker)

    ## e.g. Second Level 2008/09
    ##      2.Bundesliga
    txt = txt.sub( /^Second Level \d{4}\/\d{2}\s+^2\.Bundesliga$/ ) do |match|
      puts "  found heading >#{match}<"
      "\n\n#### 2. Bundesliga\n\n"
    end

#    txt = txt.sub( /^2.Bundesliga$/ ) do |match|
#      puts "  found heading >#{match}<"
#      "\n\n#### 2. Bundesliga\n\n"
#    end


    txt = txt.sub( /^Third Level \d{4}\/\d{2}\s+^3\.Bundesliga$/ ) do |match|
      puts "  found heading >#{match}<"
      "\n\n#### 3. Bundesliga\n\n"
    end

    ## e.g. Germany Cup (DFB Pokal) 1998/99
    txt = txt.sub( /^Germany Cup \(DFB Pokal\) \d{4}\/\d{2}$/ ) do |match|
      puts "  found heading >#{match}<"
      "\n\n#### DFB Pokal\n\n"
    end

    ## e.g. DFB Pokal 2008/09
    txt = txt.sub( /^DFB Pokal \d{4}\/\d{2}$/ ) do |match|
      puts "  found heading >#{match}<"
      "\n\n#### DFB Pokal\n\n"
    end

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

