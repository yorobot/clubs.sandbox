# football.db RSSSF (Rec.Sport.Soccer Statistics Foundation) Skripts 

## Update Archives

Use

**Step 1 - Fetch Pages**

Uses the 

```
$ rake dei      ## uses DE_REPO.fetch_pages
```


**Step 2 - Patch Pages**

```
$ rake deii     ## uses DE_REPO.patch_pages
```

**Step 3 - Make Pages Summary**

```
$ rake deiii    ## uses DE_REPO.make_pages_summary
```


## Update Match Schedules

Use

```
$ rake dev    ## uses DE_REPO.make_schedules
```

