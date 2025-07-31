# create a shiny app that allows the user to add a journal article to a data table, such that the data table is able to be sorted and filtered by the user. The inputs are authors, title, publication, publication year, url. The data table must have an export button that allows the user to export the data to json.
library(shiny)
library(DT)
library(knitr)
library(kableExtra)
# Define UI for application
ui <- fluidPage(
  titlePanel("Journal Article Manager"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("authors", "Authors"),
      textInput("title", "Title"),
      textInput("publication", "Publication"),
      numericInput("year", "Publication Year", value = 2023, min = 1900, max = 2100),
      textInput("url", "URL"),
      actionButton("add", "Add Article")
    ),
    
    mainPanel(
      DTOutput("articleTable"),
      downloadButton("downloadData", "Export Data Table")
    )
  )
)
# Define server logic
server <- function(input, output, session) {
  articles <- reactiveVal(data.frame(
    Authors = character(),
    Title = character(),
    Publication = character(),
    Year = integer(),
    URL = character(),
    stringsAsFactors = FALSE
  ))
  
  observeEvent(input$add, {
    new_article <- data.frame(
      Authors = input$authors,
      Title = input$title,
      Publication = input$publication,
      Year = input$year,
      URL = input$url,
      stringsAsFactors = FALSE
    )
    
    updated_articles <- rbind(articles(), new_article)
    articles(updated_articles)
    
    # Clear inputs after adding
    updateTextInput(session, "authors", value = "")
    updateTextInput(session, "title", value = "")
    updateTextInput(session, "publication", value = "")
    updateNumericInput(session, "year", value = 2023)
    updateTextInput(session, "url", value = "")
  })
  
  output$articleTable <- renderDT({
    datatable(articles(), options = list(pageLength = 10, autoWidth = TRUE, dom = 'Bfrtip', buttons = c('copy', 'csv', 'excel')), 
              filter = 'top', extensions = 'Buttons') #, 
             # options = list(dom = 'Bfrtip', buttons = c('copy', 'csv', 'excel')))
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("articles-", format(Sys.time(), "%Y-%m-%d-%H_%M"), ".csv", sep="")
    },
    content = function(file) {
      #assign("df", write.csv(articles(), file, row.names = FALSE, fileEncoding = "UTF-8"), envir = globalenv())
      kable(articles(), format = "html") %>%
        kable_styling("striped", full_width = F) %>%
        save_kable(paste("/Users/kinson2/Downloads/articles-", format(Sys.time(), "%Y-%m-%d-%H_%M"), ".html", sep=""))
      write.csv(articles(), file, row.names = FALSE, fileEncoding = "UTF-8")
    }
  )
}
# Run the application
shinyApp(ui = ui, server = server)

#convert csv to html
# Note: The export button in the datatable allows for copying the HTML of the data table.
# You can also use the download button to export the data as a CSV file.

# To convert the CSV to HTML, you can use the following code:
 
# df <- read.csv("articles.csv")
# kable(iris, format = "html") %>%
#   kable_styling("striped", full_width = F) %>%
#   save_kable("articles.html")
