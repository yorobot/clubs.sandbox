# encoding: utf-8

require './scripts/rsssf'

require './scripts/repo'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts "  importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end

