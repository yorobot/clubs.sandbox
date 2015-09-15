# encoding: utf-8


## 3rd party libs/gems
require 'rsssf'         # note: rsssf code moved to gem; see sportdb/rsssf

## add patch configs
require './scripts/de/patch'


############################################
# add more tasks (keep build script modular)

Dir.glob('./tasks/**/*.rake').each do |r|
  puts "  importing task >#{r}<..."
  import r
  # see blog.smartlogicsolutions.com/2009/05/26/including-external-rake-files-in-your-projects-rakefile-keep-your-rake-tasks-organized/
end

