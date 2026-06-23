# heatwaveR

# step 1: detect extreme events and their properties (number, duration, intensity, ...)

- for each variable of interest:
1. rechunk data so that one chunk dim is the complete time dim (see `~/bin/rechunk.r`)
2. run `calc_heatwaveR.r` (or `calc_heatwaveR_loop.r`) on rechunked data

# optional step 1a: compound events: detect compound events from step 1

1. run `compound_heatwaveR.r` (or `compound_heatwaveR_loop.r`) with result of step 1

# step 2: aggregate extreme event statistics to global nc files

1. run `post_calc_heatwaveR.r` (`post_calc_heatwaveR_loop.r`) with result of steps 1 or 1a

# optional step 2a: save time- and space-indices of all events as lists

1. run `post_calc_heatwaveR.r` (`post_calc_heatwaveR_loop.r`) with arg `calc_selection_inds=T` with result of steps 1 or 1a

- example indices from `post_calc_heatwaveR.r`:
```
file 1/1, loci 8/46719: -d time,"2686-01-11","2686-01-31 23:59:59" -d time,"2686-02-19","2686-06-09 23:59:59" -d time,"2686-06-22","2686-06-26 23:59:59" -d nodes_2d,14
file 1/1, loci 9/46719: -d time,"2686-05-20","2686-05-26 23:59:59" -d time,"2686-08-07","2686-08-12 23:59:59" -d nodes_2d,16
file 1/1, loci 10/46719: -d time,"2686-03-17","2686-03-23 23:59:59" -d time,"2686-09-09","2686-09-14 23:59:59" -d nodes_2d,18
file 1/1, loci 11/46719: -d time,"2686-02-07","2686-03-11 23:59:59" -d time,"2686-04-01","2686-05-12 23:59:59" -d nodes_2d,19
file 1/1, loci 12/46719: -d time,"2686-02-03","2686-02-10 23:59:59" -d time,"2686-10-07","2686-10-14 23:59:59" -d time,"2686-12-20","2686-12-31 23:59:59" -d nodes_2d,21
file 1/1, loci 13/46719: -d time,"2686-02-17","2686-03-12 23:59:59" -d time,"2686-04-02","2686-04-29 23:59:59" -d time,"2686-05-11","2686-05-22 23:59:59" -d time,"2686-05-28","2686-07-04 23:59:59" -d time,"2686-08-12","2686-08-16 23:59:59" -d time,"2686-08-20","2686-09-10 23:59:59" -d time,"2686-10-05","2686-10-14 23:59:59" -d nodes_2d,23
file 1/1, loci 14/46719: -d time,"2686-07-03","2686-07-16 23:59:59" -d time,"2686-11-01","2686-11-11 23:59:59" -d time,"2686-11-28","2686-12-02 23:59:59" -d time,"2686-12-08","2686-12-15 23:59:59" -d time,"2686-12-24","2686-12-31 23:59:59" -d nodes_2d,31
file 1/1, loci 15/46719: -d time,"2686-01-06","2686-01-13 23:59:59" -d time,"2686-01-18","2686-02-10 23:59:59" -d time,"2686-12-03","2686-12-09 23:59:59" -d nodes_2d,32
file 1/1, loci 16/46719: -d time,"2686-01-07","2686-01-17 23:59:59" -d time,"2686-04-13","2686-05-25 23:59:59" -d nodes_2d,34
```

- different date listing of events that cross months and/or years:
```
# event_inds_an_res_day
year,from,to,nodes_2d
2688,2688-09-28,2688-12-24 23:59:59,122103 # across months & exact dates

# event_inds_an_res_mon
year,from,to,nodes_2d
2688,2688-09-01,2688-12-31 23:59:59,122103 # across months & full months

# event_inds_mon_res_day
year,month,from,to,nodes_2d
2688,9,2688-09-28,2688-09-30 23:59:59,122103 # individual months & exact dates
2688,10,2688-10-01,2688-10-31 23:59:59,122103
2688,11,2688-11-01,2688-11-30 23:59:59,122103
2688,12,2688-12-01,2688-12-24 23:59:59,122103

# event_inds_mon_res_mon
year,month,from,to,nodes_2d
2688,9,2688-09-01,2688-09-30 23:59:59,122103 # individual months & full months
2688,10,2688-10-01,2688-10-31 23:59:59,122103
2688,11,2688-11-01,2688-11-30 23:59:59,122103
2688,12,2688-12-01,2688-12-31 23:59:59,122103
```

# optional step 3: composite: calc arbitrary data stats over all event inds from step 2

1. rechunk data to calc event-composite of, so that one chunk dim is the complete time dim (see `~/bin/rechunk.r`)
2. run `composite_heatwaverR.r` (or `composite_heatwaveR_loop.r`)
3. follow step 2 to get global nc files

# todo

todo `plot_calc_heatwaveR.r` --> compare results of `calc_heatwaver.r`
todo `plot_composite_heatwaveR.r` --> compare results of `composite_heatwaver.r`

