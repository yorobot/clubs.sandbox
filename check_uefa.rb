require_relative 'boot'



##  todo:
##  collect duplicates too (instead of exit 1) !!!



## datasets = Dir.glob( "./uefa/**/*.csv")
## datasets = Dir.glob( "./uefa/**/champ*.csv")
datasets = Dir.glob( "./uefa/**/europa*.csv")
puts "   #{datasets.size} datafile(s)"


missing_clubs =  {}


duplicates = {}


datasets.each_with_index do |path,i|

  basename = File.basename( path, File.extname( path))

  puts
  puts "===> #{i+1}/#{datasets.size}"

     recs = read_csv( path )
     puts "   #{recs.size} record(s)"


## sort by code
    recs = recs.sort { |l,r| l['code'] <=> r['code'] }


  recs.each_with_index do |rec,j|

    names = rec['names'].split( '|' )
    names  = names.map { |name| name.strip }

    code  = rec['code']

    ## quick fix for clubs in other country
    # Derry City FC | Derry      -- IRL => NIR
    # AS Monaco FC | Monaco      -- FRA => MON
    # Swansea City AFC|Swansea   -- ENG => WAL

    ## or use MCO for code (Monaco) - why? why not?
    code = 'MON' if names.include?( 'AS Monaco FC' )
    code = 'NIR' if names.include?( 'Derry City FC' )
    code = 'WAL' if names.include?( 'Swansea City AFC' )


    country = Country.find_by( code: code )
    if country.nil?
      puts "!! ERROR - no country found for code:"
      pp rec
      exit 1
    end

    names.each do |name|

      m = Club.match_by( name: name, country: country )

      if m.empty?
         puts "!! #{name}   -  #{names.join('|')}"
         missing_clubs[ code ] ||= {}
         stat = missing_clubs[ code ][ name ] ||= { names: names,
                                                    count: 0,
                                                    files: []
                                                  }
         stat[ :count ] += 1
         stat[ :files] << basename
      elsif m.size > 1
          puts
          puts "!! too many matches (#{m.size}) for club >#{name}<:"
          pp m

          stat = duplicates[ name ] ||= { names: names,
                                          count: 0,
                                          matches: m,
                                          files: []
                                        }
         stat[ :count ] += 1
         stat[ :files] << basename
         #  exit 1
      else  # bingo; match
          print "     OK "
          if name != m[0].name
              print "%-28s => %-28s" % [name, m[0].name]
          else
              print name
          end
          print " (#{code})"
          print "\n"
      end
    end
   end
end



if missing_clubs.size > 0
   puts
   puts "missing_clubs:"
   pp missing_clubs

   missing_clubs.each do |code, clubs|
      puts "  #{clubs.size} club name(s) in #{code}"
   end
end


puts
puts "  #{duplicates.size } duplicat(es):"
pp duplicates

puts "bye"