# encoding: utf-8

# script to generate pages.yml starter template


start_year = 1963
end_year   = 2015

link_base  = 'tablesd/duit'  ## e.g. tablesd/duit65.html 

(start_year..end_year).each do |year|
  yynext = (year+1)%100   # e.g. add one plus cut of leading digits (e.g. 1997 becomes 98 etc.)
  puts "%4d-%02d:  #{link_base}%02d.html" % [year, yynext, yynext]
end


