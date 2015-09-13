# encoding: utf-8


####
## todo/check: move to rsssf module - why? why not??


class RsssfRepo

def initialize( path, opts )   ## pass in title etc.
  @repo_path = path
  @opts      = opts
end


def fetch_pages
  puts "fetch_pages:"
  cfg = YAML.load_file( "#{@repo_path}/tables/config.yml") 
  pp cfg

  dl_base = 'http://rsssf.com'

  cfg.each do |k,v|
    ## season = k   # as string e.g. 2011-12  or 2011 etc.
    path      = v  # as string e.g. tablesd/duit2011.html

    ## note: assumes extension is .html
    #    e.g. tablesd/duit2011.html => duit2011
    basename = File.basename( path, '.html' )

    src_url   = "#{dl_base}/#{path}"
    dest_path = "#{@repo_path}/tables/#{basename}.txt"

    page = RsssfPage.from_url( src_url )
    page.save( dest_path )
  end # each year
end # method fetch_pages


def make_pages_summary
  stats = []

  files = Dir[ "#{@repo_path}/tables/*.txt" ]
  files.each do |file|
    page = RsssfPage.from_file( file )
    stats << page.build_stat
  end

  ### save report as README.md in tables/ folder in repo
  report = RsssfPageReport.new( stats, @opts )    ## pass in title etc.  
  report.save( "#{@repo_path}/tables/README.md" )
end  # method rssssf_pages_summary  

end  ## class RsssfRepo

