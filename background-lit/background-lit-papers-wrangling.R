#
temp = list.files(path = '/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/INTER-LAB/background-lit-papers-data/', pattern = "\\.csv$", full.names = TRUE)
temp
d0 = lapply(temp, read.csv)
length(d0)
lapply(d0, dim)
lapply(d0, names)
d2 = lapply(d0, function(a){ if(any(names(a)=="X")) a[,-1] else a})
lapply(d2, names)
d3 = do.call("rbind", d2)
d3
# Check for duplicates
duplicates <- duplicated(d3)
sum(duplicates)
# Remove duplicates
d4 <- d3[!duplicates, ]
d4

d5 = d4
d5$Authors = stringr::str_replace_all(toupper(d4$Authors), "\\s\\|", ",")
sort(d5$Authors)
d5$Title

duplicates2 <- duplicated(d5$URL)
d6 <- d5[!duplicates2, ]

d6$Title = toupper(d6$Title)
d6$Publication = toupper(d6$Publication)
ids <- stringr::str_which(d6$URL, "doi|http")
setdiff(1:nrow(d6),ids)
d7 <- d6[-setdiff(1:nrow(d6),ids), ]
d7
duplicated(d7)

readr::write_csv(d7, file = '/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/INTER-LAB/background-lit-papers-data/papers-dataset.csv')
