#
temp = list.files(path = '/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/reading-group-papers/papers-data/', pattern = "\\.csv$", full.names = TRUE)
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
d5$Title = toupper(d5$Title)
d5$Publication = toupper(d5$Publication)

readr::write_csv(d5, file = '/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/reading-group-papers/papers-data/papers-dataset.csv')
