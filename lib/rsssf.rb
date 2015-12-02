# encoding: utf-8

def prepare_rsssf_for_country( cc, fixtures, include_path )

  ## todo/fix: allow cc or country obj ( check if WorldDb::Model::Country?)

  country = WorldDb::Model::Country.find_by!( key: cc )

  fixtures.each do |fx|
     if fx =~ %r{^clubs/}         ## e.g. clubs/1-bundesliga
       r = SportDb::TeamReader.from_file( "#{include_path}/#{fx}.txt", country_id: country.id )
       r.read
     elsif fx =~ %r{^leagues}     ## e.g. leagues
       r = SportDb::LeagueReader.from_file( "#{include_path}/#{fx}.txt", country_id: country.id )
       r.read
     elsif fx =~ %r{^[0-9\-]+/}   ## e.g. 2013-14/1-bundesliga
       r = SportDb::EventReader.from_file( "#{include_path}/#{fx}.yml" )   ## note: reads .yml
       r.read  
     else
       fail "*** unknow fixture type >#{fx}< for include_path >#{include_path}<"
     end
  end
end


def read_rsssf( fixtures, include_path )
  
  fixtures.each do |k,v|
    event_key = k      # e.g. at.2014/15
    fx        = v      # e.g. 2014-15/1-bundesliga
    
    txt = File.read_utf8( "#{include_path}/#{fx}.txt" )
    pp txt

    r = SportDb::RsssfGameReader.from_string( event_key, txt )
    r.read
  end
end

