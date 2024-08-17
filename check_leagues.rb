require_relative 'boot'



datasets = ['tipp3',
            'footballsquads',
           ]


datasets.each do |code|

  txt = read_data( "./leagues/#{code}.txt" )
  puts "   #{txt.size} record(s)"

  ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.

  missing_leagues = Hash.new(0)  ## index by league code


  txt.each_with_index do |(name,_),i|

    m = League.match_by( name: name )

    if m.empty?
       puts "!! #{name}"
       missing_leagues[ name ] += 1
    elsif m.size > 1
        puts "!! too many matches (#{m.size}) for league >#{name}<:"
        pp m
        exit 1
      else  # bingo; match
        print "     OK "
        if name != m[0].name
            print "%-20s => %-20s" % [name, m[0].name]
            print ", #{m[0].country.name}"   unless m[0].intl?
        else
            print name
        end
        print "\n"
      end
   end

   if missing_leagues.size > 0
     puts
     pp missing_leagues
     puts "  #{missing_leagues.size} record(s)"

     puts
     puts "---"
     missing_leagues.each do |name, _|
       puts name
     end
     puts
   end
end


puts "bye"