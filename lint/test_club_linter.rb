require 'cocos'

require 'sportdb/quick'    ## pull-in OutlineReader


require_relative 'club_linter'


path = '../clubs_misc/orf/2019-20/bel.txt'
nodes = SportDb::ClubLinter.read( path )


pp nodes

puts "bye"