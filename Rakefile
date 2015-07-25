# encoding: utf-8


require './scripts/html2txt'



ENG_BASE = 'http://rsssf.com/tablese'
ENG      = %w[eng2011 eng2012 eng2013 eng2014 eng2015]
## ENG      = %w[eng2011]
## e.g. http://rsssf.com/tablese/eng2015.html

ENG_REPO = '../en-england'


task :eng do

  ENG.each do |name|
    src_url = "#{ENG_BASE}/#{name}.html"
    html  = fetch( src_url )
    txt   = html_to_txt( html )

    header = <<EOS
<!--
   source: #{src_url}
   html to text conversion on #{Time.now}
  -->

EOS

    dest_path = "#{ENG_REPO}/tables/#{name}.txt"
    File.open( dest_path, 'w' ) do |f|
      f.write header
      f.write txt
    end
  end
end

