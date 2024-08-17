require_relative 'boot'




datasets = ['cz',  # czech republic
            'co',  # columbia
            'eg',  # egypt
            'il',  # isreal
            'bo',  # bolivia
            'ec',  # ecuador
            'py',  # paraguay
            'tr',  # turkey

             'fr',  # france
             'it', # italy
             'es', # spain

            'at',  # austria
            'ch',  # switzerland +
            'li',  # lichtenstein
            'de',  # germany
  ]


totals = Hash.new(0)

datasets.each_with_index do |code,i|
  country = Country.find_by( code: code )
  puts
  puts "===> #{i+1}/#{datasets.size}"
  pp country

     txt = read_data( "./clubs/#{code}.txt" )
     puts "   #{txt.size} record(s)"
  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.
  missing_clubs = Hash.new(0)  ## index by league code



  txt.each_with_index do |(name,_),j|

    m = Club.match_by( name: name, country: country )

    if m.empty?
       puts "!! #{name}"
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
     totals[country.name] = missing_clubs
   end
end



if totals.size > 0
   puts
   puts "totals:"
   pp totals

   totals.each do |country_name, clubs|
      puts "  #{clubs.size} club name(s) in #{country_name}"
   end
end


puts "bye"