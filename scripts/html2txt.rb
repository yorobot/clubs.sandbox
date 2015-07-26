# encoding: utf-8

require 'pp'
require 'fetcher'
require 'yaml'
require 'uri'


def fetch( src )
  ## Fetcher::Worker.new.read_utf8!( src )
  Fetcher::Worker.new.read( src )  ## assume plain 7-bit ascii for now
end



def html_to_txt( html )

###
#   todo: check if any tags (still) present??


  ## cut off everything before body
  html = html.sub( /.+?<BODY>\s*/im, '' )

  ## cut off everything after body (closing)
  html = html.sub( /<\/BODY>.*/im, '' )


  ## remove cite
  html = html.gsub( /<CITE>([^<]+)<\/CITE>/im ) do |_|
    puts " remove cite >#{$1}<"
    "#{$1}"
  end

  html = html.gsub( /\s*<HR>\s*/im ) do |_|
    puts " replace horizontal rule (hr)"
    "\n=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n"    ## check what hr to use use  - . - . - or =-=-=-= or somehting distinct?
  end

  ## replace break (br)
  html = html.gsub( /<BR>\n?/i ) do |_|    ## note: include (swallow) "extra" newline
    puts " replace break (br)"
    "\n"
  end

  ## remove anchors (a href)
  #    note: heading 4 includes anchor (thus, let anchors go first)
  html = html.gsub( /<A[^>]*>(.+?)<\/A>/im ) do |_|   ## note: use .+? non-greedy match
    puts " replace anchor (a) >#{$1}<"
    "#{$1}"
  end

  ## replace paragrah (p)
  html = html.gsub( /\s*<P>\s*/im ) do |_|    ## note: include (swallow) "extra" newline
    puts " replace paragraph (p)"
    "\n\n"
  end
  html = html.gsub( /<\/P>/i, '' )  ## replace paragraph (p) closing w/ nothing for now

  ## remove i
  html = html.gsub( /<I>([^<]+)<\/I>/im ) do |_|
    puts " remove italic (i) >#{$1}<"
    "#{$1}"
  end


  ## heading 2
  html = html.gsub( /\s*<H2>([^<]+)<\/H2>\s*/im ) do |_|
    puts " replace heading 2 (h2) >#{$1}<"
    "\n\n## #{$1}\n\n"    ## note: make sure to always add two newlines
  end

  ## heading 4
  html = html.gsub( /\s*<H4>([^<]+)<\/H4>\s*/im ) do |_|
    puts " replace heading 4 (h4) >#{$1}<"
    "\n\n#### #{$1}\n\n"    ## note: make sure to always add two newlines
  end


  ## remove b   - note: might include anchors (thus, call after anchors)
  html = html.gsub( /<B>([^<]+)<\/B>/im ) do |_|
    puts " remove bold (b) >#{$1}<"
    "**#{$1}**"
  end

  ## replace preformatted (pre)
  html = html.gsub( /<PRE>|<\/PRE>/i ) do |_|
    puts " replace preformatted (pre)"
    ''  # replace w/ nothing for now (keep surrounding newlines)
  end

=begin
  puts
  puts
  puts "html:"
  puts html[0..2000]
  puts "-- snip --"
  puts html[-1000..-1]   ## print last hundred chars
=end


  ## cleanup whitespaces
  txt = ''
  html.each_line do |line|
     line = line.gsub( "\t", '  ' ) # replace all tabs w/ two spaces for nwo
     line = line.rstrip             # remove trailing whitespace (incl. newline/formfeed)

     txt << line
     txt << "\n"
  end

  ### remove emails etc.
  txt = sanitize( txt )

  txt
end # method html_to_text



def sanitize( txt )
  ### remove emails for (spam/privacy) protection
  ## e.g. (selamm@example.es)
  ##      (buuu@mscs.dal.ca)
  ##      (kaxx@rsssf.com)
  ##      (Manu_Maya@yakoo.co)

  email_pattern = "\\([a-z][a-z0-9_]+@[a-z]+(\\.[a-z]+)+\\)"   ## note: just a string; needs to escape \\ twice!!!

  ## check for "free-standing e.g. on its own line" emails only for now
  txt = txt.gsub( /\n#{email_pattern}\n/i ) do |match|
    puts "removing (free-standing) email >#{match}<"
    "\n"   # return empty line
  end

  txt = txt.gsub( /#{email_pattern}/i ) do |match|
    puts "remove email >#{match}<"
    ''
  end


  txt  
end # method sanitize


def sanitize_dir( root )
  files = Dir[ "#{root}/*.txt" ]

  files.each do |file|
    txt = File.read( file )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)

    new_txt = sanitize( txt )

    File.open( file, 'w' ) do |f|
      f.write new_txt
    end
  end # each file
end  ## sanitize_dir

