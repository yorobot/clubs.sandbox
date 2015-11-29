# football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Skripts 

## Update Archives

Use

**Step 1 - Fetch Pages**

Uses the `tables/config.yml` file listing all pages to fetch.

```
$ rake dei      ## uses RsssfRepo#fetch_pages
```


**Step 2 - Patch Pages**

```
$ rake deii     ## uses RsssfRepo#patch_pages
```

**Step 3 - Make Pages Summary**

```
$ rake deiii    ## uses RsssfRepo#make_pages_summary
```


## Update Match Schedules

Use

```
$ rake dev    ## uses RsssfRepo#make_schedules
```

