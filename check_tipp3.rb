require_relative 'boot'



paths = Dir.glob( './tipp3/**/*.csv' )
puts "   #{paths.size} datasets(s)"



missing_clubs = {}  ## index by country (name)


paths.each_with_index do |path,i|

   basename = File.basename( path, File.extname( path ))

   ## next if code == 'uefa'   ### skip int'l for now
   ## next if league.index('cup')   ## skip cups for now
   ## next if code != 'uefa'
   ## next if league == 'ch.cup'

  puts
  puts "===> #{i+1}/#{paths.size}"
     recs = read_csv( path )
     puts "   #{recs.size} record(s)"
  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.

  country = nil

  if basename == 'intl'   ## note skip intl/international dataset for now
     next
  else
     code = basename
     country = Country.find_by( code: code )
     pp country
  end

  recs.each_with_index do |rec,j|
     name    = rec['name']
     leagues = rec['leagues']

    ## m = Club.match_by( name: name, country: country )
    m = Club.match_by_and_autofix( name: name, country: country )

    if m.empty?
       print "!! #{name}"
       print " - #{country.key} #{country.name} (#{country.code})"
       print " -- #{leagues}"
       print "\n"

       missing_clubs[ country.name ] ||= {}
       stat = missing_clubs[ country.name ][ name ] ||= [0,[]]
       ## up - count (integer) and season (array)
       stat[0] += 1
       stat[1] << "#{leagues}"
    elsif m.size > 1
        puts
        puts "!! too many matches (#{m.size}) for club >#{name}<:"
        pp m
        exit 1
    else  # bingo; match
        print "     OK "
        if name != m[0].name
            print "%-28s => %-28s" % [name, m[0].name]
        else
            print name
        end
        print " - #{country.key} #{country.name} (#{country.code})"
        print " -- #{leagues}"
        print "\n"
    end
  end
end



if missing_clubs.size > 0
   puts
   missing_clubs.each do |country_name, clubs|
     puts "==> #{country_name}  -  #{clubs.size} record(s)"
     clubs.each do |name, (count, basenames)|
       print "%-30s" % name
       print "  (%d) " % count
       print basenames.join(',')
       print "\n"
     end
   puts
   end
end


## pp missing_clubs

puts "bye"