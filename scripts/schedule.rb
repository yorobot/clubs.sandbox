# encoding: utf-8



LEAGUE_ROUND_REGEX = /\b
                     Round
                     \b/ix

CUP_ROUND_REGEX  = /\b(
                     Round         |
                     1\/8\sFinals  |
                     Quarterfinals |
                     Semifinals    |
                     Final
                    )\b/ix

def find_schedule( txt, opts={} )

  ## find match schedule/fixtures in multi-league doc
  new_txt = ''

  ## note: keep track of statistics
  ##   e.g. number of rounds found
  
  round_count = 0

  header = opts[:header]
  if header
    league_header_found        = false
  else
    league_header_found        = true   # default (no header; assume single league file)
  end


  if opts[:cup]
    round_regex = CUP_ROUND_REGEX   ## note: only allow final, quaterfinals, etc. if knockout cup
  else
    round_regex = LEAGUE_ROUND_REGEX
  end


  ## stages
  first_round_header_found   = false
  round_header_found         = false
  round_body_found           = false   ## allow round header followed by blank lines

  blank_found = false


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
      if line =~ round_regex
        puts "!!! bingo - found first round >#{line}<"
        round_count += 1
        first_round_header_found = true
        round_header_found       = true
        round_body_found         = false
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
        if round_body_found
          round_header_found = false
          blank_found        = true    ## keep track of blank (lines) - allow inside round block (can continue w/ date header/marker)
          new_txt << line
        else
          ## note: skip blanks following header
          next
        end
      else
        round_body_found = true
        new_txt << line   ## keep going until next blank line
      end
    else
      ## skip (more) blank lines
      if line =~ /^\s*$/
        next  ## continue; skip extra blank line
      elsif line =~ round_regex
        puts "!!! bingo - found new round >#{line}<"
        round_count += 1
        round_header_found = true   # more rounds; continue
        round_body_found   = false
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif blank_found && line =~ /\[[a-z]{3} \d{1,2}\]/i   ## e.g. [Mar 13] or [May 5] with leading blank line; continue round
        puts "!!! bingo - continue round >#{line}<"
        round_header_found = true
        blank_found        = false  # reset blank tracker
        new_txt << line
      elsif line =~ /=-=-=-=/
        puts "!!! stop schedule; hit section marker (horizontal rule)"
        break;
      else
        blank_found  = false
        puts "skipping line in schedule >#{line}<"
        next # continue
      end
    end
  end  # each line

  [round_count, new_txt]  # note: return number of rounds and text for schedule
end  # method find_schedule
