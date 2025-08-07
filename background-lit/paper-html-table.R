# convert imported data to kable table
papers <- read.csv('https://uofi.box.com/shared/static/kjrzka2w87l0re815egj4gwbb0wnhd6d.csv')
papers$ClickURL <- papers$URL
library(knitr)
library(kableExtra)
kp01 <- kable(papers, format = 'html')
kp02 <- kable_styling(kp01, full_width = F, position = 'left')
kp03 <- column_spec(kp02, 6, link = papers$ClickURL, color = 'blue')

# export to HTML
save_kable(kp03, file = '/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/INTER-LAB/background-lit-papers-data/papers.html', self_contained = TRUE)
