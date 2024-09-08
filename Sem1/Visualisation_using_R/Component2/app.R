#Load R packages
#require(shiny)
#require(shinythemes)

load_pckg <- function(){
  if(!require('pacman'))install.packages('pacman')
  pacman::p_load(shiny,shinythemes)
}

load_pckg()
source('main.R')

  # Define UI
  ui <- fluidPage(theme = shinytheme("paper"),
    navbarPage(
      "Wordwide Suicides Control Dashboard",
      tabPanel("Worldwide",
               # Sidebar panel for inputs ----
               sidebarPanel(
                 h4("Worldwide General Overview to suicides in 1985-2015"),
                 
                 # Input: Slider for the number of bins ----
                 sliderInput("slider", label = h4("Years of Interest"), min = 1985, 
                             max = 2015,
                             value = c(1985, 2015),
                             sep = ''),
                 p("This dashboard is intended to provide some general insight on the delicate matter of suicides all over the world based on a dataset with data that range from 1985 to 2015 for every country accounting for sex, age and economic variables such as per capita GDP.", 
                   style = "font-family: 'times'; font-si16pt"),
                 
                 HTML(paste0(
                   "<script>",
                   "var today = new Date();",
                   "var yyyy = today.getFullYear();",
                   "</script>",
                   "<p style = 'text-align: center;'><small>&copy; - <a href='https://github.com/Gauranga2022' target='_blank'>Gauranga Kumar Baishya</a> - <script>document.write(yyyy);</script></small></p>")
                   
                 ),
                 
                 highchartOutput(outputId = "pie")
    
               ),
               
               # Main panel for displaying outputs ----
               mainPanel(
                 
                 # Output: Histogram ----
                 highchartOutput(outputId = "general"),
                 p(' '),
                 plotlyOutput(outputId = "age")
                 
               )
      
               
      ), # Navbar 1,
      tabPanel("Countries",  #Navbar 2 
               sidebarPanel(
                 h3("Global Overview per Country and Continent"),
                 p("In this page it is shown with an immediate graphical visualization how the figures are distributed all over the world with the map on the right.
                   It is possible to derank your own country with the below graph and to entail the consistency of the sex difference in figures in every single continent with the below-right representation",
                   style = "font-family: 'times'; font-si16pt"),

                  highchartOutput(outputId = 'bar')
                 
               ), #sidebar
               
               mainPanel(
                 highchartOutput(outputId = 'map'),
                 
                 highchartOutput(outputId ='sex_cont')
               )
               ),
      tabPanel("Analysis", #Navbar 3
               sidebarPanel(
                 h4("Data Analysis and Coparison"),
                 p("In this page you are going to be able to observe the trend of every possible country singularly or to compare one another according to your preference.",style = "font-family: 'times'; font-si16pt"),
                 
                 
                 # Input: Slider for the number of bins ----
                 selectInput("select", label = h5("Country Multiple Selection"), 
                             choices = country_list,
                             selected = 'Italy',
                             multiple = T,
                             selectize = T),
                
                 p("Furthermore, I ran a simple panel fixed effect regression on the data to disentangle the correlation between the number of suicides per 100K people and the per capita GDP, accounting for every other variable. 
                 The results displayed below show that, although significant, the effect of per capita GDP on the suicides figures is extremely weak. 
                 In the right below Graph is finally shown the relation between the avarage suicides number per 100K people over the 30 years considered and the avarage per capita GDP level over the same period per Country." 
                   ,em("Although graphically appealing"), "this graph representation is NOT to be considered significant but at best indicative given that it does not taker into consideration the change in time and every other variable.",
                   style = "font-family: 'times'; font-si16pt"),
                 
                 
                 HTML(res),
                 
               ),
               mainPanel(
                 plotlyOutput(outputId = "fnal"),
                 p(' '),
                 p(' '),
                 plotlyOutput(outputId = "scatter")
               )
               ),
      tabPanel("About", #Navbar 4
               h3("Hotlines and References"),
               includeMarkdown("about.md")
               )
  
    ) # navbarPage
  ) # fluidPage

  
  server <- function(input, output) {
    
    reactive_data <- reactive({
      country_year_tibble[country_year_tibble$country == input$select, ]
      })
      
    
    shared_data <- SharedData$new(reactive_data, group = "hello")
    
    output$fnal <- renderPlotly({
      plot_ly(shared_data, x = ~year, y = ~suicide_capita, 
              color = ~country, colors = sample(colours(), 120),
              type = 'scatter', mode = 'lines') %>%
        layout(showlegend = FALSE,
               title = "Suicide by Country",
               xaxis = list(title = "Year"),
               yaxis = list(title = "Suicides per 100K people")) %>%
        layout(plot_bgcolor = 'transparent') %>% 
        layout(paper_bgcolor = 'transparent') %>% 
        add_markers() %>% 
        highlight("plotly_click")
    })  
      
    
    
    output$scatter  <- renderPlotly({
      plot_ly(data = avg_dt, y = ~avg_sui, x= ~avg_gdp, color= ~country,size = ~avg_sui, type = 'scatter', mode = 'markers') %>%
        layout(title = "Avarage Suicides and Avarage PerCapita GDP by Country",
               xaxis = list(title = "Avarage Per Capita GDP"),
               yaxis = list(title = "Avarage Suicides per 100K people")
               )

    }) 
    
    output$general <- renderHighchart({
      highchart() %>% 
        hc_add_series(overall_tibble, hcaes(x = year, y = suicide_capita, color = suicide_capita), type = "line") %>%
        hc_tooltip(crosshairs = TRUE, borderWidth = 1.5, headerFormat = "", pointFormat = paste("Year: <b>{point.x}</b> <br> Suicides: <b>{point.y}</b>")) %>%
        hc_title(text = "Worldwide suicides by year") %>% 
        hc_subtitle(text = "1985-2015") %>%
        hc_xAxis(title = list(text = "Year"),
                 min = input$slider[1],
                 max = input$slider[2]) %>%
        hc_yAxis(title = list(text = "Suicides per 100K people"),
                 allowDecimals = FALSE,
                 plotLines = list(list(
                   color = "black", width = 1, dashStyle = "Dash", 
                   value = mean(overall_tibble$suicide_capita),
                   label = list(text = "Mean = 13.12", 
                                style = list(color = "black"))))) %>%
        hc_legend(enabled = FALSE) %>% 
        hc_add_theme(custom_theme)
      })
    
    
    output$age <- renderPlotly({
      
      plot_ly(age_tibble, y = ~suicide_capita, color= ~age, type = 'box', showlegend = FALSE) %>% layout(
        title = 'Worldwide Suicides Per Age Class',
        xaxis = list(title = 'Age Range'),
        yaxis = list(title = 'Suicide per 100K People'))                                                                     
      
      
      
    })
    
    output$pie <- renderHighchart({
      highchart() %>% 
        hc_add_series(pie_sex, hcaes(x = sex, y = suicide_capita, color = sex_color), type = "pie") %>%
        hc_tooltip(borderWidth = 1.5, headerFormat = "", pointFormat = paste("Gender: <b>{point.sex} ({point.percentage:.1f}%)</b> <br> Suicides per 100K: <b>{point.y}</b>")) %>%
        hc_title(text = "Worldwide suicides by <b>Gender<b>") %>% 
        hc_subtitle(text = "1985-2015") %>%
        hc_plotOptions(pie = list(dataLabels = list(distance = 15, 
                                                    style = list(fontSize = 10)), 
                                  size = 130)) %>% 
        hc_add_theme(custom_theme)
    })
    
    output$bar<- renderHighchart({
      highchart() %>%
        hc_add_series(country_bar, hcaes(x = country, y = suicide_capita, color = suicide_capita), type = "bar")  %>% 
        hc_tooltip(borderWidth = 1.5, 
                   pointFormat = paste("Suicides: <b>{point.y}</b>")) %>%
        hc_legend(enabled = FALSE) %>%
        hc_title(text = "Suicides by country") %>% 
        hc_subtitle(text = "1985-2015") %>%
        hc_xAxis(categories = country_bar$country, 
                 labels = list(step = 1),
                 min = 0, max = 30,
                 scrollbar = list(enabled = TRUE)) %>%
        hc_yAxis(title = list(text = "Suicides per 100K people")) %>%
        hc_plotOptions(bar = list(stacking = "normal", 
                                  pointPadding = 0, groupPadding = 0, borderWidth = 0.5)) %>% 
        hc_add_theme(custom_theme)
    })
    
    # Create interactive world map.
    output$map<- renderHighchart({
      highchart() %>%
        hc_add_series_map(worldgeojson, country_tibble, value = "suicide_capita", joinBy = c('name','country'))  %>% 
        #  hc_colorAxis(dataClasses = color_classes(c(seq(0, 30, by = 10), 50))) %>% 
        #  hc_colorAxis(minColor = "#FF0000", maxColor = "#F5F5F5") %>%
        hc_colorAxis(stops = color_stops()) %>% 
        hc_title(text = "Suicides by Country") %>% 
        hc_subtitle(text = "1985-2015") %>%
        hc_tooltip(borderWidth = 1.5, headerFormat = "", valueSuffix = " suicides (per 100K people)") %>% 
        hc_add_theme(custom_theme)
    })
    
    output$sex_cont <- renderHighchart({
      # Create histogram of suicides by sex and continent.
      highchart() %>%
        hc_add_series(continent_sex_tibble, hcaes(x = continent, y = suicide_capita, group = sex), type = "column")  %>% 
        hc_colors(colors = sex_color) %>%
        hc_tooltip(borderWidth = 1.5, pointFormat = paste("Gender: <b> {point.sex} </b> <br> Suicides: <b>{point.y}</b>")) %>%
        hc_title(text = "Suicides by continent and <b>Gender<b>") %>% 
        hc_subtitle(text = "1985-2015") %>%
        hc_xAxis(categories = c("Africa", "Asia", "Europe", "North <br> America", "Oceania", "South <br> America"), labels = list(style = list(fontSize = 10))) %>%
        hc_yAxis(labels = list(style = list(fontSize = 11)),
                 title = list(text = "Suicides per 100K people", 
                              style = list(fontSize = 12)),
                 plotLines = list(
                   list(color = "black", width = 1, dashStyle = "Dash", 
                        value = mean(overall_tibble$suicide_capita),
                        label = list(text = "Mean = 13.12", style = list(color = "black", fontSize = 10))))) %>%       
        hc_legend(verticalAlign = 'bottom', enabled = TRUE) %>% 
        hc_add_theme(custom_theme)
    })
  }
  
  # Create Shiny app ----
  shinyApp(ui = ui, server = server)
  