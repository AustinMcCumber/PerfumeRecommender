#Import packages
#library(shiny)
library(cluster)
library(readxl)
#library(shinyWidgets)
#library(rsconnect)



# Import data from excel
parfumomaster <- read_excel("./parfumomaster.xlsx")

# Subset data. Columns 2, 3, 5, 6, and 7 were removed. We will only keep columns for fragrance name, sex, and the various accords
parfumosubset <- parfumomaster[c(-2,-3,-5,-6,-7)]

#Convert remaining columns to be categorical

catcolumns <- c(2:22)
parfumosubset[catcolumns] <- lapply(parfumosubset[catcolumns], factor)

# Calculate dissimilarity df and return as matrix
gower_dist <- daisy(parfumosubset[2:22], metric = "gower", type = list())
gower_matrix <- as.matrix(gower_dist)

# Create user interface for Shiny
ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectizeInput("query_name", "Type or select a fragrance name:", 
                     choices = sort(unique(parfumosubset$fragrance)), 
                     options = list(placeholder = "Type to search...")),
      verbatimTextOutput("results") 
    ),
    mainPanel(
     
    )
  )
)

# Define server logic
server <- function(input, output) {
  
  # Find similar fragrances based on previously calculated dissimilarity matrix and user input
  similar_fragrances <- reactive({
    if (input$query_name == "") {
      return(NULL)
    } else {
      query_index <- which(parfumosubset$fragrance == input$query_name) #Pulls index from matrix based on user submission 
      dissimilarity_scores <- gower_matrix[query_index, ] #Pulls scores for given index
      top_3_indices <- order(dissimilarity_scores)[1:3] #Returns the 3 most similar indices
      top_3_entries <- parfumosubset[top_3_indices, ] #Returns the fragrance names based on previous indices
      #New function that returns columns where each pair has a common accord
      matching_cols <- lapply(top_3_indices, function(i) {
        match_cols <- colnames(parfumosubset)[catcolumns][which(parfumosubset[i, catcolumns] == "yes" &
                                                                  parfumosubset[query_index, catcolumns] == "yes")]
        match_cols
      })
      return(list(fragrances = top_3_entries, matching_cols = matching_cols))
    }
  })
  
  # Render text output of similar fragrances
  output$results <- renderPrint({
    similar_fragrances <- similar_fragrances()
    
    if (is.null(similar_fragrances)) {
      return("")
    }
    
    fragrances <- similar_fragrances$fragrances
    matching_cols <- similar_fragrances$matching_cols
    
    output_text <- "You may also like:\n"
    
    for (i in 1:nrow(fragrances)) {
      output_text <- paste(output_text, fragrances[i, "fragrance"], "\n")
      
      if (length(matching_cols[[i]]) > 0) {
        output_text <- paste(output_text, "Similar Accords: ", 
                             paste(matching_cols[[i]], collapse = ", "), "\n")
      } else {
        output_text <- paste(output_text, "No matching factors found.\n")
      }
    }
    
    cat(output_text)
  })
  
}



# Run the app
shinyApp(ui = ui, server = server)
