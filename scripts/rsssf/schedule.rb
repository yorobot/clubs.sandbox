# encoding: utf-8


class RsssfSchedule

def self.from_string( txt )
  self.new( txt )
end

attr_accessor :rounds     # track no of rounds
  
def initialize( txt )
  @txt = txt
  
  @rounds = nil   # undefined
end


def save( path )
  File.open( path, 'w' ) do |f|
    f.write @txt
  end    
end

end  ## class RsssfSchedule


