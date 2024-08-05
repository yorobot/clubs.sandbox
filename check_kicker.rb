require_relative 'boot'



paths = Dir.glob( './kicker/**/*.csv' )
puts "   #{paths.size} datasets(s)"



missing_clubs = {}  ## index by league code


paths.each_with_index do |path,i|

   basename = File.basename( path, File.extname( path ))
   league, season, _ = basename.split( '_' )

   code = league.split('.')[0]

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
 
  if code == 'uefa'
     country = nil
  else
     country = Country.find_by( code: code )
     pp country
  end

  recs.each_with_index do |rec,j|
     name = rec['name']

    m = Club.match_by( name: name, country: country )

    if m.empty?
       puts "!! #{name}"
       stat = missing_clubs[ name ] ||= [0,[]] 
       ## up - count (integer) and season (array)
       stat[0] += 1
       stat[1] << "#{league}_#{season}"
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
        print "\n"
    end
  end
end


if missing_clubs.size > 0
   puts
   missing_clubs.each do |name, (count, seasons)|
     print "%-30s" % name
     print "  (%d) " % count
     print seasons.join(',')
     print "\n"
   end
   puts "  #{missing_clubs.size} record(s)"
   puts
end

puts "bye"