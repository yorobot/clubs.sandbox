# encoding: utf-8

require_relative 'de/patch'



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
    txt = File.read_utf8( file )
    ## was: txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)

    basename = File.basename( file, '.txt' )  ## e.g. duit92.txt => duit92
    year     = year_from_name( basename )

    new_txt = yield( txt, basename, year )
    ## calculate hash to see if anything changed ?? why? why not??

    File.open( file, 'w' ) do |f|
      f.write new_txt
    end
  end # each file
end  ## patch_dir

