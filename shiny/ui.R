library(shiny)

shinyUI(fluidPage(
  navbarPage("Analiza rezultatov tekmovanj ritmične gimnastike:",
             
             
             tabPanel("Tekmovalke",
                      titlePanel("Rezultati individualnih tekmovalk"),
                      sidebarPanel(
                        selectInput(inputId = "tekmovalka",
                                    label = "Izberite tekmovalko",
                                    choices = unique(induvidualne$tekmovalka))),
                      mainPanel(plotOutput("tekmovalka"))),
             
             
             tabPanel("Skupinske sestave",
                      titlePanel("Rezultati skupinskih sestav"),
                      sidebarPanel(
                        selectInput(inputId = "tekma",
                                    label = "Izberite tekmo",
                                    choices = unique(skupinske$tekma))),
                      mainPanel(plotOutput("tekma")))
             
             
             #tabPanel("Rekvizit",
            #          titlePanel("SKUPINE INDIVIDUALNIH TEKMOVALK ZA VSAK REKVIZIT"),
            #          sidebarPanel(
            #            selectInput(inputId = "rekvizit",
            #                        label = "Izberite rekvizit",
            #                        choices = unique(ecg$rekvizit))),
            #          mainPanel(plotOutput("rekvizit")))
             
             
  )))

#shinyUI(fluidPage(
#  navbarPage("SKUPINE INDIVIDUALNIH TEKMOVALK ZA VSAK REKVIZIT:",
#             
#             
#             tabPanel("Rekvizit",
#                      titlePanel("SKUPINE INDIVIDUALNIH TEKMOVALK ZA VSAK REKVIZIT"),
#                      sidebarPanel(
#                        selectInput(inputId = "rekvizit",
#                                    label = "Izberite rekvizit",
#                                    choices = unique(ecg$rekvizit))),
#                      mainPanel(plotOutput("rekvizit"))),
#             
#             
#             
#  )))