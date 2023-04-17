#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
library(shiny)
library(tidyverse)
library(plotly)
library(shinythemes)
library(DT)


# Define server logic required to draw a histogram
function(input, output, session) {
  
 
  
  siop_filter2 <- reactive(
    siop2 |> 
      filter(ano == input$ANO) |>
      filter(orgao_orcamentario == input$ORGAO)
  )
  
  siop_filter <- reactive(
    siop |> 
      filter(ano == input$ANO) |> 
      filter(funcao == input$FUNCAO)
  )
  
  output$GGPLOT <- renderPlotly({
    
    
    plot_ly(siop_filter(),  x = ~dotacoes, y = ~valores, type = "bar") |>
      layout(title = "Orçamento por Função do Gasto",
                 xaxis = list(title = ""),
                 yaxis = list(title = "Valores (bi)"))
    
  })
  
  

  
   output$GGLINE1 <- renderPlot({
     
     custom_palette <- c("#00587A", "#FDB515", "#7FB069", "steelblue", "#0A9182", "#970D0D")
     custom_linetypes <- c("solid", "dashed", "dotted", "dotdash", "dotdash", "twodash")
     
    g <-  ggplot(siop |>  filter(funcao == input$FUNCAO) %>%  filter(!ano == 2023), aes(x = ano, y = valores, color = dotacoes, group = dotacoes,linetype = dotacoes)) +
       geom_line()+
       geom_point() +
       labs(title = "Evolução orçamentária", x = "Ano", y = "Valores (bi)") +
       scale_color_manual(values = custom_palette, 
                          labels = c("Projeto de Lei", "Dotação Inicial","Dotação Atual", "Empenhado", "Liquidado","Pago")) +
       scale_linetype_manual( values = custom_linetypes, 
                             labels = c("Projeto de Lei", "Dotação Inicial","Dotação Atual", "Empenhado", "Liquidado","Pago")) +
       theme_minimal() +
       theme(legend.position = "bottom", 
             axis.text.x = element_text(angle = 45, vjust = 0.5, size = 12),
             axis.text.y = element_text(size = 8),
             axis.title = element_text(size = 14, face = "bold"),
             legend.text = element_text(size = 12),
             legend.title = element_text(size = 14, face = "bold")) +
      theme(legend.title= element_blank())
    g
  
   })
   
 
  output$TABLE <-   DT::renderDataTable(
    siopbruto, server = TRUE, rownames = FALSE,
    colnames = c("Ano","Cod. Órgão", "Órgao orçamentário","cod. Função", "Função do Gasto", "Projeto de Lei (mi)", "Dotação Inicial (mi)", "Dotação Atual (mi)", "Empenhado (mi)", "Liquidado (mi)", "Pago (mi)"),
    filter = 'top', options = list(pageLength = 5, autoWidth = TRUE))
  
}
