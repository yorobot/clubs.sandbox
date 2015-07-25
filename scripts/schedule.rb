# encoding: utf-8


def find_schedule( txt, header )

  ## find match schedule/fixtures in multi-league doc
  new_txt = ''

  ## stages
  league_header_found        = false
  first_round_header_found   = false
  round_header_found         = false


  txt.each_line do |line|
    
    if league_header_found == false
      ## first find start of league header/section
      ## assumes heading 4 for now
      
      if line =~ /####\s+(#{header})/i
        puts "!!! bingo - found header >#{line}<"
        league_header_found = true
        new_txt << line
        new_txt << "\n"
      end
    elsif first_round_header_found == false
      ## next look for first round (starting w/ Round)
      if line =~ /Round/i
        puts "!!! bingo - found first round >#{line}<"
        first_round_header_found = true
        round_header_found       = true
        new_txt << line
      elsif line =~ /=-=-=-=/
        puts "*** no rounds found; hit section marker (horizontal rule)"
        break
      else
        next ## continue; searching
      end
    elsif round_header_found == true
      ## collect rounds;
      ##   assume text block until next blank line
      ##   new block must allways start w/ round
      if line =~ /^\s*$/   ## blank line?
        round_header_found = false  
        new_txt << line
      else
        new_txt << line   ## keep going until next blank line
      end
    else
      ## skip (more) blank lines
      if line =~ /^\s*$/
        next  ## continue; skip extra blank line
      elsif line =~ /Round/i
        puts "!!! bingo - found new round >#{line}<"
        round_header_found = true   # more rounds; continue
        new_txt << line
      elsif line =~ /=-=-=-=/
        puts "!!! stop schedule; hit section marker (horizontal rule)"
        break;
      else
        puts "skipping line in schedule >#{line}<"
        next # continue
      end
    end
  end  # each line

  new_txt
end  # method find_schedule
