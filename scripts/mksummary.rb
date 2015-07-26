# encoding: utf-8


def rsssf_pages_stats_for_dir( root )
  ## assume all text files are converted rsssf table pages

  stats = []

  files = Dir[ "#{root}/*.txt" ]

  files.each do |file|
    txt = File.read( file )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)

    source       = nil
    authors      = nil
    last_updated = nil

    ### find source ref
    if txt =~ /source: ([^ \n]+)/im
      source = $1.to_s
      puts "source: >#{source}<"
    end

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

    stats << [source, authors, last_updated, line_count, txt.size, sections ]

  end # each file
  
  stats  # return collected stats
end  # method rsssf_pages_stats



def make_summary( title, repo )
  stats = rsssf_pages_stats_for_dir( "#{repo}/tables" )

  ## fix: add missing 19/20 if two digits for proper sorting??
  ## sort start by season (latest first) than by name (e.g. 1-bundesliga, cup, etc.)
  stats = stats.sort do |l,r|
    v =  r[0] <=> l[0]
    v =  l[1] <=> r[1]  if v == 0  ## same season
    v
  end


  header =<<EOS

# #{title}

football.db RSSSF Archive Data Summary for #{title}

_Last Update: #{Time.now}_

EOS

  txt = ''
  txt << header
  
  txt << "| File   | Authors  | Last Updated | Lines (Chars) | Sections | \n"
  txt << "|:------ | :------- | :----------- | ------------: | :------- |\n"

  stats.each do |stat|

    # get path from url
    url  = URI.parse( stat[0] )
    ## pp url
    ## puts url.host
    path = url.path
    basename = File.basename( path, '.html')

    txt << "| [#{basename}.txt](#{basename}.txt) "
    txt << "| #{stat[1]} "
    txt << "| #{stat[2]} "
    txt << "| #{stat[3]} (#{stat[4]}) "
    txt << "| #{stat[5].join(', ')} "
    txt << "|\n"
  end

  txt << "\n\n" 


  ### save report as README.md in tables/ folder in repo
  dest_path = "#{repo}/tables/README.md"
  File.open( dest_path, 'w' ) do |f|
    f.write txt
  end

end  # method make_summary
