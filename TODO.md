# Todos




## de

Fix parsing errors

- missing (alt) team names ???
- check encoding (umlaut messed up) ??

log:

```
[debug] parsing round header line: >Round 33 [May 3]<
[debug]    [parse_date_time] hash: >{:month_en=>"May", :day=>"3"}<
[debug]    [calc_year] ????-5-3 -- start_at: 2013-08-09
[debug]    date: >2014-05-03 12:00<
[debug]    pos: >33<
[debug]   find_round_header_title! line-before: >>Round 33 [EN_MONTH_DD]<<
[debug]   find_round_title! line-after: >>Round 33<<
[debug]    title: >>Round 33<<
[debug]   line: >[ROUND.TITLE] [EN_MONTH_DD]<
[debug] create round:
[debug] {"title":"Round 33","title2":null,"knockout":false,"event_id":3,"pos":33,"start_at":"1911-11-11","end_at":"1911-11-11"}
[debug] parsing game (fixture) line: >NÃŒrnberg        0-2 Hannover<
[debug]   no game match (two teams required) found for line: >NÃŒrnberg        0-2 Hannover<
[info] skipping line (no match found): >NÃŒrnberg        0-2 Hannover<
[debug] parsing game (fixture) line: >Dortmund        3-2 Hoffenheim<
[debug]   no game match (two teams required) found for line: >Dortmund        3-2 Hoffenheim<
[info] skipping line (no match found): >Dortmund        3-2 Hoffenheim<
[debug] parsing game (fixture) line: >MÃ¶nchengladbach 3-1 Mainz<
[debug]   no game match (two teams required) found for line: >MÃ¶nchengladbach 3-1 Mainz<
[info] skipping line (no match found): >MÃ¶nchengladbach 3-1 Mainz<
[debug] parsing game (fixture) line: >Braunschweig    0-1 Augsburg<
[debug]      match for team  >braunschweig< >Braunschweig<
[debug]    team: >braunschweig<
[debug]   no game match (two teams required) found for line: >[TEAM]     0-1 Augsburg<
[debug]      match for team  >braunschweig< >Braunschweig<
[debug]    team: >braunschweig<
[info] skipping line (no match found): >Braunschweig    0-1 Augsburg<
[debug] parsing game (fixture) line: >Frankfurt       0-2 Leverkusen<
[debug]   no game match (two teams required) found for line: >Frankfurt       0-2 Leverkusen<
[info] skipping line (no match found): >Frankfurt       0-2 Leverkusen<
[debug] parsing game (fixture) line: >Hamburg         1-4 Bayern<
[debug]   no game match (two teams required) found for line: >Hamburg         1-4 Bayern<
[info] skipping line (no match found): >Hamburg         1-4 Bayern<
[debug] parsing game (fixture) line: >Freiburg        0-2 Schalke<
[debug]   no game match (two teams required) found for line: >Freiburg        0-2 Schalke<
[info] skipping line (no match found): >Freiburg        0-2 Schalke<
[debug] parsing game (fixture) line: >Stuttgart       1-2 Wolfsburg<
[debug]      match for team  >wolfsburg< >Wolfsburg<
[debug]      match for team  >stuttgart< >Stuttgart<
[debug]    team: >stuttgart<
[debug]    team: >wolfsburg<
[debug]    score: >1-2<
[debug]   line: >[TEAM]        [SCORE] [TEAM] <
[debug] create game:
[debug] {"score1":1,"score2":2,"score1et":null,"score2et":null,"score1p":null,"score2p":null,"play_at":"2014-05-03T12:00:00.000+00:00","play_at_v2":null,"postponed":false,"knockout":false,"ground_id":null,"group_id":null,"round_id":67,"team1_id":16,"team2_id":10,"pos":1}
[debug] parsing game (fixture) line: >Bremen          2-0 Hertha<
[debug]   no game match (two teams required) found for line: >Bremen          2-0 Hertha<
[info] skipping line (no match found): >Bremen          2-0 Hertha<
[debug] skipping blank line
[debug] parsing round header line: >Round 34 [May 10]<
[debug]    [parse_date_time] hash: >{:month_en=>"May", :day=>"10"}<
[debug]    [calc_year] ????-5-10 -- start_at: 2013-08-09
[debug]    date: >2014-05-10 12:00<
[debug]    pos: >34<
[debug]   find_round_header_title! line-before: >>Round 34 [EN_MONTH_DD]<<
[debug]   find_round_title! line-after: >>Round 34<<
[debug]    title: >>Round 34<<
[debug]   line: >[ROUND.TITLE] [EN_MONTH_DD]<
[debug] create round:
[debug] {"title":"Round 34","title2":null,"knockout":false,"event_id":3,"pos":34,"start_at":"1911-11-11","end_at":"1911-11-11"}
[debug] parsing game (fixture) line: >Leverkusen      2-1 Bremen<
[debug]   no game match (two teams required) found for line: >Leverkusen      2-1 Bremen<
[info] skipping line (no match found): >Leverkusen      2-1 Bremen<
[debug] parsing game (fixture) line: >Bayern          1-0 Stuttgart<
[debug]      match for team  >stuttgart< >Stuttgart<
[debug]    team: >stuttgart<
[debug]   no game match (two teams required) found for line: >Bayern          1-0 [TEAM] <
[debug]      match for team  >stuttgart< >Stuttgart<
[debug]    team: >stuttgart<
[info] skipping line (no match found): >Bayern          1-0 Stuttgart<
[debug] parsing game (fixture) line: >Augsburg        2-1 Frankfurt<
[debug]   no game match (two teams required) found for line: >Augsburg        2-1 Frankfurt<
[info] skipping line (no match found): >Augsburg        2-1 Frankfurt<
[debug] parsing game (fixture) line: >Mainz           3-2 Hamburg<
[debug]   no game match (two teams required) found for line: >Mainz           3-2 Hamburg<
[info] skipping line (no match found): >Mainz           3-2 Hamburg<
[debug] parsing game (fixture) line: >Hannover        3-2 Freiburg<
[debug]   no game match (two teams required) found for line: >Hannover        3-2 Freiburg<
[info] skipping line (no match found): >Hannover        3-2 Freiburg<
[debug] parsing game (fixture) line: >Hertha          0-4 Dortmund<
[debug]   no game match (two teams required) found for line: >Hertha          0-4 Dortmund<
[info] skipping line (no match found): >Hertha          0-4 Dortmund<
[debug] parsing game (fixture) line: >Hoffenheim      3-1 Braunschweig<
[debug]      match for team  >braunschweig< >Braunschweig<
[debug]    team: >braunschweig<
[debug]   no game match (two teams required) found for line: >Hoffenheim      3-1 [TEAM] <
[debug]      match for team  >braunschweig< >Braunschweig<
[debug]    team: >braunschweig<
[info] skipping line (no match found): >Hoffenheim      3-1 Braunschweig<
[debug] parsing game (fixture) line: >Schalke         4-1 NÃŒrnberg<
[debug]   no game match (two teams required) found for line: >Schalke         4-1 NÃŒrnberg<
[info] skipping line (no match found): >Schalke         4-1 NÃŒrnberg<
[debug] parsing game (fixture) line: >Wolfsburg       3-1 MÃ¶nchengladbach<
[debug]      match for team  >wolfsburg< >Wolfsburg<
[debug]    team: >wolfsburg<
[debug]   no game match (two teams required) found for line: >[TEAM]        3-1 MÃ¶nchengladbach<
[debug]      match for team  >wolfsburg< >Wolfsburg<
[debug]    team: >wolfsburg<
[info] skipping line (no match found): >Wolfsburg       3-1 MÃ¶nchengladbach<
```
