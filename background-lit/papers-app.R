# wrangling the papers-dataset.csv
# separate each author and then by last name
p1 <- read.csv('/Users/kinson2/Library/CloudStorage/Box-Box/Employee Documents/Teaching Associate Professor/INTER-LAB/background-lit-papers-data/papers-dataset.csv')
names(p1)
library(tidyverse)
p1list <- str_split(p1$Authors, '\\,\\s*') # split by comma and optional space
p1list
p1list2 <- Map(function(a) str_split(a, '\\s+'), p1list) # split by space
p1list2

p1list2length <- lapply(p1list2, length)
p2 <- lapply(p1list2, function(x) {
  sapply(x, function(y) {
    #if (length(y) > 1) {
      last_name <- y[length(y)]
      # first initial of first name
      first_initial <- substr(y[1], 1, 1)
      return(paste0(first_initial, '. ', last_name))
    #} else {
    #  return(c(NA, y))
    })
})

# Create a sample data frame
df <- data.frame(col1 = c(1, 2), col2 = c("A", "B"))

# Duplicate each row 3 times
n_replications <- 3
duplicated_df <- do.call("rbind", replicate(n_replications, df, simplify = FALSE))
print(duplicated_df)


bigdf <- data.frame()
for (i in 1:length(p2)){
  bigdf <- rbind(bigdf, do.call("rbind", replicate(length(p2[[i]]), p1[i,], simplify = FALSE)))
  #rbind(bigdf, as.data.frame(rep(p1[i, ], times = )))
}
bigdf2 <- as.data.frame(bigdf)  
dim(bigdf2)
head(bigdf2)
bigdf2$AuthorsSeparated <- unlist(p2)
head(bigdf2)
str_which(bigdf2$AuthorsSeparated, "\\.\\s$")
bigdf2[str_which(bigdf2$AuthorsSeparated, "\\.\\s$"), ]
bigdf2[bigdf2$AuthorsSeparated=="A. ", "AuthorsSeparated"] <- "A. COUNSELL"
bigdf2[bigdf2$AuthorsSeparated=="J. ", "AuthorsSeparated"] <- "J. RIDGWAY"
str_which(bigdf2$AuthorsSeparated, "\\.\\s$")
df_final <- select(bigdf2, AuthorsSeparated, everything())

# build a shiny app with the df_final data frame that allows users to sort and search a data table
library(shiny)
library(DT)
ui <- fluidPage(
  titlePanel("Background Literature Papers"),
    mainPanel(
      DTOutput("table")
    )
)
server <- function(input, output) {
  output$table <- renderDT({
    filtered_data <- df_final
    datatable(filtered_data, options = list(pageLength = 10, autoWidth = TRUE))
  })
}
shinyApp(ui = ui, server = server)
