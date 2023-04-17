#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
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

 siop <- read_csv("siop.csv")
 sioptable <- read_csv("sioptable.csv")
 

 

 siop$dotacoes <- factor(siop$dotacoes, levels = c("projeto_de_lei", "dotacao_inicial", "dotacao_atual", "empenhado", "liquidado", "pago"))



fluidPage( 

  theme = shinytheme("cerulean"),
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "custom.css")),
     navbarPage("Orçamento Federal",
              tabPanel("Função do Gasto",
                       sidebarLayout(
                         sidebarPanel(
                           selectInput(inputId ="FUNCAO", 
                                       label = "Funcao do gasto",
                                       choice = c(unique(siop$funcao))
                                       
                                       ),
                           radioButtons( "ANO", "Ano", choices = c(unique(siop$ano)),
                                         selected = c(2023))
                         ),
                         
                         # Show a plot of the generated distribution
                         mainPanel(
                           plotlyOutput("GGPLOT"),
                           plotOutput("GGLINE1"),
                         )
                       )),
             
              tabPanel("Tabelas",
                       DT:: dataTableOutput(outputId = "TABLE"))
                )
)
    

