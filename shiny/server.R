library(shiny)


shinyServer(function(input, output) {
  
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



#shinyServer(function(input, output) {
#  
#  output$rekvizit <- renderPlot({
#    graf.rekvizit <- ecg %>% 
#      mutate(skupina=modelK_rekviziti$cluster) %>%
#      ggplot(aes(x=tekmovalka, y=koncna_ocena, col=skupina)) +
#      geom_point()+
#      labs( y = "končna ocena")+
#      geom_text_repel(  #dodamo imena tekmovalk, ki se ne prekrivajo
#        aes(label=tekmovalka),
#        size=1.5,
#        color='black',
#        min.segment.length = 0, #črtica do vsake pikice
#        #box.padding = 0.05,
#        #nudge_x = 0.05,
#        #nudge_y = 0.5
#      )+
#      scale_y_continuous(breaks=c(2.5, 5, 7.5, 10, 12.5, 15, 17.5, 20, 22.5, 25))+
#      theme_bw()+ #brez sivega ozadja
#      theme(legend.position = "none" #brez legende
#            ,axis.ticks.x = element_blank() #brez črtic na x osi
#            ,axis.text.x = element_blank() #brez value na x osi
#            ,axis.title.x = element_blank()
#            ,axis.text.y = element_text(size = 6)
#            ,panel.grid.major = element_blank() #navpične črte
#            ,panel.grid.minor = element_blank() #vodoravne črte
#            #,strip.background = element_blank() #ozadje pri ball clubs...
#            #,panel.border = element_blank()
#            ,plot.title = element_text(hjust=0.5)#naslovna sredini
#            
#      )
#    
#    print(graf.rekvizit)
#  })
#})  
  