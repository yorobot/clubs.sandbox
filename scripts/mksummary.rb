# encoding: utf-8


RsssfPageStat = Struct.new(
  :source,     ## e.g. http://rsssf.org/tabled/duit89.html
  :basename,   ## e.g. duit89   -- note: filename w/o extension (and path)
  :year,       ## e.g. 1989     -- note: always four digits
  :season,     ## e.g. 1990-91  -- note: always a string (NOT a number)
  :authors,
  :last_updated,
  :line_count,  ## todo: rename to (just) lines - why? why not?
  :char_count,  ## todo: rename to (just) char(ectar)s  - why? why not?
  :sections)


def rsssf_pages_stats_for_dir( root )
  ## assume all text files are converted rsssf table pages

  stats = []

  files = Dir[ "#{root}/*.txt" ]

  files.each do |file|
    txt = File.read_utf8( file )    # note: always assume sources (already) converted to utf-8 
    ## was: txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)
    
    source       = nil
    authors      = nil
    last_updated = nil

    ### find source ref
    if txt =~ /source: ([^ \n]+)/im
      source = $1.to_s
      puts "source: >#{source}<"
    end


    ##
    ## fix/todo: move authors n last updated  whitespace cleanup to sanitize - why? why not?? 

    if txt =~ /authors?:\s+(.+?)\s+last updated:\s+(\d{1,2} [a-z]{3,10} \d{4})/im
      last_updated = $2.to_s   # note: save a copy first (gets "reset" by next regex)
      authors      = $1.to_s.strip.gsub(/\s+/, ' ' )  # cleanup whitespace; squish-style
      authors = authors.gsub( /[ ]*,[ ]*/, ', ' )    # prettify commas - always single space after comma (no space before)
      puts "authors: >#{authors}<"
      puts "last updated: >#{last_updated}<"
    end

    puts "*** !!! missing source"  if source.nil?
    puts "*** !!! missing authors n last updated"   if authors.nil? || last_updated.nil?

    sections = []

    ## count lines
    line_count = 0
    txt.each_line do |line|
      line_count +=1

      ### find sections
      ## todo: add more patterns? how? why?
      if line =~ /####\s+(.+)/
        puts "  found section >#{$1}<"
        sections << $1.strip
      end
    end


    # get path from url
    url  = URI.parse( source )
    ## pp url
    ## puts url.host
    path = url.path
    extname  = File.extname( path )
    basename = File.basename( path, extname )  ## e.g. duit92.txt or duit92.html => duit92
    year     = year_from_name( basename )
    season   = year_to_season( year )

    rec = RsssfPageStat.new
    rec.source       = source         # e.g. http://rsssf.org/tabled/duit89.html   -- use source_url - why?? why not??
    rec.basename     = basename       # e.g. duit89
    rec.year         = year           # e.g. 89 => 1989  -- note: always four digits
    rec.season       = season
    rec.authors      = authors
    rec.last_updated = last_updated
    rec.line_count   = line_count
    rec.char_count   = txt.size      ## fix: use "true" char count not byte count
    rec.sections     = sections

    stats << rec
  end # each file
  
  stats  # return collected stats
end  # method rsssf_pages_stats



def make_rsssf_pages_summary( title, repo )
  stats = rsssf_pages_stats_for_dir( "#{repo}/tables" )

  stats = stats.sort do |l,r|
    r.year <=> l.year
  end


  header =<<EOS

# #{title}

football.db RSSSF Archive Data Summary for #{title}

_Last Update: #{Time.now}_

EOS

  txt = ''
  txt << header

  txt << "| Season | File   | Authors  | Last Updated | Lines (Chars) | Sections |\n"
  txt << "| :----- | :----- | :------- | :----------- | ------------: | :------- |\n"

  stats.each do |stat|
    txt << "| #{stat.season} "
    txt << "| [#{stat.basename}.txt](#{stat.basename}.txt) "
    txt << "| #{stat.authors} "
    txt << "| #{stat.last_updated} "
    txt << "| #{stat.line_count} (#{stat.char_count}) "
    txt << "| #{stat.sections.join(', ')} "
    txt << "|\n"
  end

  txt << "\n\n" 


  ### save report as README.md in tables/ folder in repo
  dest_path = "#{repo}/tables/README.md"
  File.open( dest_path, 'w' ) do |f|
    f.write txt
  end

end  # method make_summary
