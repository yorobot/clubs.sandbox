# encoding: utf-8

## stdlibs
require 'pp'
require 'yaml'
require 'uri'

## 3rd party gems/libs
require 'fetcher'


def fetch( src )
  ## Fetcher::Worker.new.read_utf8!( src )
  Fetcher::Worker.new.read( src )  ## assume plain 7-bit ascii for now
end


def fetch_rsssf_pages( repo, cfg )

  puts "fetch_rsssf_pages:"
  pp cfg

  dl_base = 'http://rsssf.com'

  cfg.each do |k,v|
    ## season = k   # as string e.g. 2011-12  or 2011 etc.
    path      = v  # as string e.g. tablesd/duit2011.html

    ## note: assumes extension is .html
    #    e.g. tablesd/duit2011.html => duit2011
    basename = File.basename( path, '.html' )

    src_url   = "#{dl_base}/#{path}"
    dest_path = "#{repo}/tables/#{basename}.txt"

    fetch_rsssf_worker( src_url, dest_path )
  end # each year
end # method fetch_rsssf


def fetch_rsssf( dl_base, years, shortcut, repo )

  years.each do |year|
    src_url   = "#{dl_base}/#{shortcut}#{year}.html"
    dest_path = "#{repo}/tables/#{shortcut}#{year}.txt"
    
    fetch_rsssf_worker( src_url, dest_path )
  end # each year
end # method fetch_rsssf



def fetch_rsssf_worker( src_url, dest_path )
  html  = fetch( src_url )

  ### todo/fix: first check if html is all ascii-7bit e.g.
  ## includes only chars from 64 to 127!!!


  ## normalize newlines
  ##   remove \r (form feed) used by Windows; just use \n (new line)
  html = html.gsub( "\r", '' )

  ## note:
  ##   assume (default) to ISO 3166-15 (an updated version of ISO 3166-1) for now
  ##
  ##  other possible alternatives - try:
  ##  - Windows CP 1562  or
  ##  - ISO 3166-2  (for eastern european languages )
  ##
  ## note: german umlaut use the same code (int)
  ##    in ISO 3166-1/15 and 2 and Windows CP1562  (other chars ARE different!!!)

  html = html.force_encoding( Encoding::ISO_8859_15 )
  html = html.encode( Encoding::UTF_8 )    # try conversion to utf-8

  txt   = html_to_txt( html )

  header = <<EOS
<!--
   source: #{src_url}
  -->

EOS

## note: move timestamp out for now (to let git track changes; do NOT introduce "noise")
##  e.g. html to text conversion on #{Time.now}


  File.open( dest_path, 'w' ) do |f|
    f.write header
    f.write txt
  end
end
