require_relative 'boot'


require 'sportdb/quick'
require_relative './lint/club_linter'


datasets = ['cz',  # czech republic
            'co',  # columbia
            'eg',  # egypt
            'il',  # isreal
            'ec',  # ecuador
            'py',  # paraguay
            'tr',  # turkey

             'fr',  # france
             'it', # italy
             'es', # spain

            'de',  # germany
  ]

datasets = [
   'at',  # austria
   'bo',  # bolivia
   'ch',  # switzerland +
   'li',  # lichtenstein
]


totals = Hash.new(0)

datasets.each_with_index do |code,i|
   path = "./clubs/#{code}.txt"
   nodes = SportDb::ClubLinter.read( path )

   nodes.each do |country_name, clubs|
     country = Country.find_by( name: country_name )
     puts
     puts "===> #{i+1}/#{datasets.size}"
     pp country

     puts "   #{clubs.size} record(s)"

     ###
  ## todo - use unaccent to avoid duplicates with different accents/diacritics/etc.
  missing_clubs = Hash.new(0)  ## index by league code

       clubs.each_with_index do |h,j|
         names = h[:names]
         geos  = h[:geos]

         names.each_with_index do |name,k|

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
               if names.size > 1
                  if k==0
                     print "     OK "
                     print "#{k+1}/#{names.size}  "
                  else
                     print "         "
                     print "#{k+1}    "
                  end
               else
                  print "     OK "
                  print '     ' # 5 spaces
               end
               if name != m[0].name
                 print "%-28s => %-28s" % [name, m[0].name]
               else
                 print name
               end
               print "\n"
            end
         end # each names
      end  # each clubs

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
end # each nodes
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