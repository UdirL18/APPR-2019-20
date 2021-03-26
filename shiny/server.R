library(shiny)

#------------------------------------------------------------------------------------
#shinyServer ustvarjanja funkcije, ki uporabniške vnose preslikajo v različne vrste 
#izhodnih podatkov.  
#-------------------------------------------------------------------------------------
shinyServer(function(input, output) {
  #----------------------------------------------------------------------------------
  #renderPlot je reaktivna funkcija, ki lahko zajema vhodne podatke iz ui.R in ga vstavite v server.R.
  #Nato informacije v okviru svoje funkcije aktivno posodablja.
  #----------------------------------------------------------------------------------
  output$tekmovalka <- renderPlot({
    graf.tekmovalka <- ggplot(induvidualne %>% filter(tekmovalka == input$tekmovalka)) +
      aes(x=D, y=E, color=rekvizit, shape = tekma) +
      geom_point() +
      labs( x='D', y = 'E') + 
      scale_fill_manual(values=c('lightblue', 'purple', 'blue', 'black')) + 
      #scale_x_continuous(breaks = seq(2009, 2018, by=1), limits = c(2008,2019)) +
      theme_minimal()
    
    print(graf.tekmovalka)
  })
  
  
  output$tekma <- renderPlot({
    graf.skupinske <- ggplot(skupinske %>% filter(tekma == input$tekma), aes(x=D, y=E, color=rekvizit)) +
      geom_point() +
      labs( x='D', y = 'E') + 
      #scale_fill_manual(values=c('lightblue', 'purple')) + 
      scale_x_continuous(breaks = seq(18, 26, by=1)) +
      geom_text_repel(
        aes(label=drzava),
        size=4,
        color='black',
        nudge_x = 0.05,
        nudge_y = 0.05
      )+
      theme_minimal()
    
    print(graf.skupinske)
  })

 
})

