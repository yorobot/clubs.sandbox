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
end  # method make_pages_summary  


def patch_pages
  ## lets you run/use custom (repo/country-specific patches e.g. for adding/patching headings etc.)
  patch_dir( "#{@repo_path}/tables" ) do |txt, name, year|
    puts "patching #{year} (#{name}) (#{@repo_path})..."
    yield( txt, name, year )   ## note: must be last (that is, will return t(e)xt to be patched)
  end
end ## method  patch_pages

def sanitize_pages
   ## for debugging/testing lets you (re)run sanitize  (alreay incl. in html2txt filter by default)
   sanitize_dir( "#{@repo_path}/tables" )
end


private
def patch_dir( root )
  files = Dir[ "#{root}/*.txt" ]
  ## pp files

  ## sort files by year (latest first)
  files = files.sort do |l,r|
    lyear = year_from_file( l )
    ryear = year_from_file( r )
    
    ryear <=> lyear
  end

  files.each do |file|
    txt = File.read_utf8( file )    ## note: assumes already converted to utf-8

    basename = File.basename( file, '.txt' )  ## e.g. duit92.txt => duit92
    year     = year_from_name( basename )

    new_txt = yield( txt, basename, year )
    ## calculate hash to see if anything changed ?? why? why not??

    File.open( file, 'w' ) do |f|
      f.write new_txt
    end
  end # each file
end  ## patch_dir

def sanitize_dir( root )
  files = Dir[ "#{root}/*.txt" ]

  files.each do |file|
    txt = File.read_utf8( file )    ## note: assumes already converted to utf-8

    new_txt = sanitize( txt )

    File.open( file, 'w' ) do |f|
      f.write new_txt
    end
  end # each file
end  ## sanitize_dir


end  ## class RsssfRepo

