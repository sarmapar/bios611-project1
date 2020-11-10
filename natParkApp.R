#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(tidyverse)
library(ggplot2)
library(plotly)


###Pre-processing####

parks <- read_csv("derived_data/parks.csv") 
species <- read_csv("derived_data/species.csv")
visits <- read_csv("derived_data/visits.csv")

parks <- inner_join(parks,visits,by="ParkName")

speciesCounts <- species %>% 
    subset(Occurrence=="Present") %>%
    group_by(CommonNames) %>% 
    summarize(numParks=n()) %>%
    arrange(desc(numParks))

top25SpeciesNames <- speciesCounts[3:27,] 
top25Species <- subset(species, Occurrence == "Present" & CommonNames %in% top25SpeciesNames$CommonNames)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Visitation of US National Parks Which Include Selected Species"),

    # Sidebar with checkboxes 
    sidebarLayout(
        sidebarPanel(
            checkboxGroupInput("checkGroup", "25 Most Common Species:", 
                               choices = top25SpeciesNames$CommonNames)),

        # Show a plot
        mainPanel(
            plotlyOutput(outputId="thePlot")
        )
    )

)

# Define server logic required to draw a plot
server <- function(input, output) {
    
output$thePlot <- renderPlotly({
    parksWithChosenSpecies <- top25Species %>%
        group_by(ParkName) %>%
        summarize(species=CommonNames %in% input$checkGroup) %>%
        summarize(numChosenSpecies=sum(species)) %>%
        subset(numChosenSpecies==length(input$checkGroup))
    
    parksWithChosenSpecies <- parksWithChosenSpecies$ParkName
    
    data <- parks[,c("ParkName","Avg10YrVisits")] %>%
       subset(ParkName %in% parksWithChosenSpecies) %>%
       arrange(desc(Avg10YrVisits))
    
    ggplot(data,aes(x=reorder(ParkName, Avg10YrVisits),y=Avg10YrVisits)) + 
                                     geom_bar(stat='identity', position = 'dodge') +
                                      coord_flip() +
                                           labs(title="Annual Visitation of US National Parks with Selected Species", x="US National Park", y="Annual Visitors (10 Year Average)", fill="Category")})
}

# Run the application 
shinyApp(ui = ui, server = server,options=list(port=8080))