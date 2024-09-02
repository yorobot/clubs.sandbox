require 'cocos'

require 'sportdb/quick'    ## pull-in OutlineReader


require_relative '../lint/club_linter'


path = './at.txt'
nodes = SportDb::ClubLinter.read( path )
pp nodes

path = './bo.txt'
nodes = SportDb::ClubLinter.read( path )
pp nodes

puts "bye"