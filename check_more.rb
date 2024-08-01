require_relative 'boot'



## fix - use new style  e.g.   Club.find_by
##                             Country.find_by etc.
##   no reference to SportDb::Import needed

COUNTRIES = SportDb::Import.world.countries
CLUBS     = SportDb::Import.catalog.clubs


datasets = ['ch',  # switzerland +
            'li',  # lichtenstein
            'cz',  # czech republic 
            'co',  # columbia 
            'eg',  # egypt
            'il',  # isreal
            'bo',  # bolivia
            'ec',  # ecuador
            'py',  # paraguay
            'fr',  # france
            'tr',  # turkey
            'de',  # germany
          ]



datasets.each do |code|
  country = COUNTRIES.find_by_code( code )
  pp country
 
     txt = read_data( "more_clubs/#{code}.txt" )
     puts "   #{txt.size} record(s)"
  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.
  missing_clubs = Hash.new(0)  ## index by league code


  txt.each_with_index do |(name,_),i|

    m = CLUBS.match_by( name: name, country: country )

    if m.empty?
       puts "!! #{name}"
       missing_clubs[ name ] += 1
    elsif m.size > 1
        puts "!! too many matches (#{m.size}) for club >#{name}<:"
        pp m
        exit 1
      else  # bingo; match
        print "     OK "
        if name != m[0].name
            print "%-20s => %-20s" % [name, m[0].name] 
        else
            print name
        end
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

     exit 1
   end
end


puts "bye"