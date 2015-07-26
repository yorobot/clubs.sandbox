# encoding: utf-8


require_relative 'de/patch'


def patch_dir( root )
  files = Dir[ "#{root}/*.txt" ]
  ## pp files

  files.each do |file|
    txt = File.read( file )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)

    basename = File.basename( file, '.txt' )  ## e.g. duit92.txt => duit92

    new_txt = yield( txt, basename )
    ## calculate hash to see if anything changed ?? why? why not??

    File.open( file, 'w' ) do |f|
      f.write new_txt
    end
  end # each file
end  ## patch_dir

