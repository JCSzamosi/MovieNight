Movie Night Voting Tabulation
=============================

## Setup

<details><summary>Click here for setup code</summary>


```r
setwd('~/Personal/MovieNight')
library(tidyverse)
library(pheatmap)
devtools::load_all('~/MyProjects/AfterSl1p/')
theme_set(theme_bw())

cols = c('#878787','#FDDBC7','#B2182B')
ranklevs = c('I would NOT come to watch this film',
		  'I do not love this film but would still show up',
		  'I would REALLY LIKE to watch this film')
make_rank = function(x){
	x = factor(x, levels = ranklevs)
	x = as.numeric(x) -2
	return(x)
}
```

</details>

## Import and Clean Data

The voting data are available as a .csv file [here](./data/current_week.csv).

<details><summary>Click here for data wrangling code</summary>


```r
dat = read.csv('data/current_week.csv', stringsAsFactors = FALSE, header = FALSE)
datm = as.matrix(dat[,-1])

tdf = read.csv('data/current_movies.csv', row.names = 1, header = FALSE, 
			   stringsAsFactors = FALSE)
titles = tdf[[1]]
names(titles) = rownames(tdf)

datm[datm %in% names(titles)] = titles[datm[datm %in% names(titles)]]

colnames(datm) = datm[1,]
datm = datm[-1,]
```

</details>


## Tabulate the results


```r
dat_num = (datm
		   %>% data.frame()
		   %>% mutate_all(make_rank))
results = sort(colSums(dat_num), decreasing = TRUE)
res_df = data.frame(results)
res_df
```

```
##                results
## LostBoys             9
## BatmanAndRobin       6
## BatmanForever        4
## TheWiz               3
## TheClient            2
## StElmosFire          1
## PhoneBooth           0
## Phantom             -1
```

#### Lost Boys Wins!

**The Lost Boys** is the winner with 9 points!

## Pics or it didn't happen

<details><summary>Click here for plotting code</summary>


```r
brk_levs = c('I would NOT come\nto watch this film',
			 'I do not love this film\nbut would still show up',
			 'I would REALLY LIKE\nto watch this film')
dat_long = (datm
			%>% data.frame()
			%>% gather(Movies, Votes)
			%>% mutate(Votes = factor(Votes, levels = ranklevs,
									  labels = brk_levs),
					   Movies = factor(Movies, levels = names(results))))
plt = ggplot(dat_long, aes(x = Movies, fill = Votes)) +
	geom_histogram(stat = 'count') +
	scale_fill_manual(values = cols, name = 'Vote Value') +
	ylab('Vote Count') +
	rotate_ticks() +
	theme(legend.text = element_text(margin = margin(t = 0.5,
													 b = 0.5,
													 unit = 'lines')))

png(filename = 'results/current_week.png', height = 480, width = 800)
plt +
	theme(axis.title = element_text(size = 20),
		  axis.text.y = element_text(size = 15),
		  axis.text.x = element_text(size = 15,
		  						  angle = 90,
		  						  hjust = 1,
		  						  vjust = 0.5),
		  legend.text = element_text(size = 15, margin = margin(t = 0.5,
		  													  b = 0.5,
		  													  unit = 'lines')),
		  legend.title = element_text(size = 20))
		  #legend.key = element_rect(colour = 'white', size = 10))
dev.off()

(dat_long
	%>% count(Movies, Votes)
	%>% filter(Movies == 'Phantom'))
```

```
## png 
##   2 
## # A tibble: 3 x 3
##   Movies  Votes                                                  n
##   <fct>   <fct>                                              <int>
## 1 Phantom "I would NOT come\nto watch this film"                 4
## 2 Phantom "I do not love this film\nbut would still show up"     6
## 3 Phantom "I would REALLY LIKE\nto watch this film"              3
```
</details>

![](./results/current_week.png)


You can download a .png of the plot [here](./results/current_week.png).

## Executive Summaries Go At the Bottom

The options this week were highly controversial.

* The survey was completed 14 times
* **The Lost Boys** is the clear winner with the most positive votes (9) and 
the fewest negative votes (0).
* Every other movie garnered at least one negative vote, and Phantom earned the
most with four. This drove Phantom into a negative score, with -1 points.
