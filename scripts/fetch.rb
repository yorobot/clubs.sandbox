# encoding: utf-8


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
  txt   = html_to_txt( html )

  header = <<EOS
<!--
   source: #{src_url}
   html to text conversion on #{Time.now}
  -->

EOS

  File.open( dest_path, 'w' ) do |f|
    f.write header
    f.write txt
  end
end
