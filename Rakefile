# encoding: utf-8


require './scripts/html2txt'
require './scripts/schedule'


YEAR_TO_SEASON =
{
  2011 => '2010-11',
  2012 => '2011-12',
  2013 => '2012-13',
  2014 => '2013-14',
  2015 => '2014-15',
  2016 => '2015-16',
}


ENG_BASE = 'http://rsssf.com/tablese'
ENG      = [2011, 2012, 2013, 2014, 2015]
## ENG      = [2011]
## e.g. http://rsssf.com/tablese/eng2015.html

ENG_REPO = '../en-england'


## Premiership  in 2011,2012, 2013
## Premier League in 2014, 2015
##
## todo/fix:
### reading >../en-england/tables/eng2014.txt<
##  includes  invalid byte sequence in UTF-8 !!!


task :eng2 do
  ENG.each do |year|
    src_txt = "#{ENG_REPO}/tables/eng#{year}.txt"
    puts "  reading >#{src_txt}<"
    txt   = File.read( src_txt )
    txt.force_encoding( 'ASCII-8BIT' )  ## fix: check for chars > 127 (e.g. not 7-bit)
    ## pp txt
    schedule = find_schedule( txt, 'Premiership|Premier League' )
    pp schedule

    dest_path = "#{ENG_REPO}/#{YEAR_TO_SEASON[year]}/1-premierleague.txt"
    puts "  save to >#{dest_path}<"
    FileUtils.mkdir_p( File.dirname( dest_path ))
    File.open( dest_path, 'w' ) do |f|
      f.write schedule
    end
  end
end


task :eng do

  ENG.each do |name|
    src_url = "#{ENG_BASE}/eng#{year}.html"
    html  = fetch( src_url )
    txt   = html_to_txt( html )

    header = <<EOS
<!--
   source: #{src_url}
   html to text conversion on #{Time.now}
  -->

EOS

    dest_path = "#{ENG_REPO}/tables/eng#{year}.txt"
    File.open( dest_path, 'w' ) do |f|
      f.write header
      f.write txt
    end
  end
end

