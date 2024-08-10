require_relative 'boot'


### check club names in sports newspapers/magazines



datasets = Dir.glob( './newspapers/**/*.csv' )



totals = Hash.new(0)

datasets.each_with_index do |path,i|

   basename = File.basename( path, File.extname( path ))
   code = basename  ## country code via (file) basename


  puts
  puts "===> #{i+1}/#{datasets.size}"

     recs = read_csv( path )
     puts "   #{recs.size} record(s)"
  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.
  missing_clubs = Hash.new(0)  ## index by league code

  if code == 'uefa'
    country = nil
  else
     country = Country.find_by( code: code )
     pp country
  end

  recs.each_with_index do |rec,j|

    name = rec['name']

    if code == 'uefa'
       country = Country.find_by( code: rec['code'] )
       if country.nil?
         puts "!! ERROR - no country found for:"
         pp rec
         exit 1
       end
    end


    m = Club.match_by( name: name, country: country )

    if m.empty?
       puts "!! #{name} (#{country.code})"
       missing_clubs[ name ] += 1
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
        print "  - #{country.key} #{country.name} (#{country.code})"
        print "\n"
    end
  end


   if missing_clubs.size > 0
     puts
     pp missing_clubs
     puts "  #{missing_clubs.size} record(s)"

     puts
     puts "---"
     missing_clubs.each do |name, _|
       puts name
     end
     puts

     ## adding missing clubs for country to totals
     totals[code] = missing_clubs
   end
end



if totals.size > 0
   puts
   puts "totals:"
   pp totals

   totals.each do |code, clubs|
      puts "  #{clubs.size} club name(s) in #{code}"
   end
end


puts "bye"