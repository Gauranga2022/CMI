require(flexdashboard) # Dashboard package
require(highcharter) # Interactive data visualizations
require(viridis) # Color gradients
require(tidyverse) 
require(countrycode) # Converting country names/codes
require(DT) # Displaying data tables
require(crosstalk) # Provides interactivity for HTML widgets
require(plotly) # Interactive data visualizations
require(shiny) #shiny
require(sandwich)
require(stargazer)
require(Rcpp)

# This function makes life easier to who is going to open the app through `runGitHub()` because it installs every needed package automatically
automate_loading <- function(){
            if(!require('pacman'))install.packages('pacman')
            pacman::p_load(tidyverse,shiny,readr,sandwich,stargazer,flexdashboard,highcharter,viridis,countrycode,plotly,Rcpp,crosstalk,DT)
}

automate_loading()

data_path <- file.path(".","master.csv")


data <- read_csv(data_path) %>% filter(year != 2016, country != 'Dominica', country != 'Saint Kitts and Nevis')

# Fix the names of some of the countries in our data to match the country names 
# used by our map later on so that they'll be interpreted and displayed. 

data <- data %>% mutate(
            country = fct_recode(country, "The Bahamas" = "Bahamas"),
            country = fct_recode(country, "Cape Verde" = "Cabo Verde"),
            country = fct_recode(country, "South Korea" = "Republic of Korea"),
            country = fct_recode(country, "Russia" = "Russian Federation"),
            country = fct_recode(country, "Republic of Serbia" = "Serbia"),
            country = fct_recode(country, "United States of America" = "United States")
            )


# Reorder levels of age to be in chronological order.
data$age <- factor(data$age, levels = c("5-14 years", "15-24 years", "25-34 years", "35-54 years", "55-74 years", "75+ years"))

custom_theme <- hc_theme(
            colors = c('#5CACEE', 'green', 'red'),
            chart = list(
                        backgroundColor = '#FAFAFA', 
                        plotBorderColor = "black"),
            xAxis = list(
                        gridLineColor = "C9C9C9", 
                        labels = list(style = list(color = "#333333")), 
                        lineColor = "#C9C9C9", 
                        minorGridLineColor = "#C9C9C9", 
                        tickColor = "#C9C9C9", 
                        title = list(style = list(color = "#333333"))), 
            yAxis = list(
                        gridLineColor = "#C9C9C9", 
                        labels = list(style = list(color = "#333333")), 
                        lineColor = "#C9C9C9", 
                        minorGridLineColor = "#C9C9C9", 
                        tickColor = "#C9C9C9", 
                        tickWidth = 1, 
                        title = list(style = list(color = "#333333"))),   
            title = list(style = list(color = '#333333', fontFamily = "Lato")),
            subtitle = list(style = list(color = '#666666', fontFamily = "Lato")),
            legend = list(
                        itemStyle = list(color = "#333333"), 
                        itemHoverStyle = list(color = "#FFF"), 
                        itemHiddenStyle = list(color = "#606063")), 
            credits = list(style = list(color = "#666")),
            itemHoverStyle = list(color = 'gray'))

# Create tibble for our line plot.  
overall_tibble <- data %>%
            select(year, suicides_no, population) %>%
            group_by(year) %>%
            summarise(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2)) 

sex_color <- c("#83c99d", "#95a2f0") # baby blue & pink

sex_tibble <- data %>%
            select(year, sex, suicides_no, population) %>%
            group_by(year,sex) %>%
            summarise(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2))

pie_sex <- data %>%
            select(sex, suicides_no, population) %>%
            group_by(sex) %>%
            summarise(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2))


# Create tibble for age so we can use it when creating our line plot.  
age_tibble <- data %>%
            select(year, age, suicides_no, population) %>%
            group_by(year, age) %>%
            summarise(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2))

# Create tibble for overall suicides by country
country_bar <- data %>%
            select(country, suicides_no, population) %>%
            group_by(country) %>%
            summarise(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2)) %>%
            arrange(desc(suicide_capita))

# Create a tibble with suicide per capita by country for 1985-2015. 
country_tibble <- data %>%
            select(country, suicides_no, population) %>%
            group_by(country) %>%
            summarize(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2))


# Create new column in our data for continent. Use countrycode() to extract continents from country names. 
data$continent <- countrycode(sourcevar = data$country,
                              origin = "country.name",
                              destination = "continent")

# Reclassify countries that have been coded as 'Americas', by countrycode(), into 'North America' and 'South America'. 
south_america <- c('Argentina', 'Brazil', 'Chile', 'Colombia', 'Ecuador', 'Guyana', 'Paraguay', 'Suriname', 'Uruguay')

data$continent[data$country %in% south_america] <- 'South America'
data$continent[data$continent=='Americas'] <- 'North America'

# Create a tibble for continent and sex.  -----

continent_sex_tibble <- data %>%
            select(continent, sex, suicides_no, population) %>%
            group_by(continent, sex) %>%
            summarize(suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2))

dt <- data %>%
            select(country, year, suicides_no, population, `gdp_per_capita ($)`,`suicides/100k pop`) %>%
            group_by(country, year, `gdp_per_capita ($)`,`suicides/100k pop`)

avg_dt <- dt %>%
            group_by(country)%>%
            summarise(avg_gdp = round(sum(`gdp_per_capita ($)`)/length(`gdp_per_capita ($)`)),
                      avg_sui = sum(`suicides/100k pop`)/length(`suicides/100k pop`)
                      )

country_year_tibble <- data %>% select(
            country, year, suicides_no, population) %>% group_by(
                        country, year) %>% summarise(
                        suicide_capita = round((sum(suicides_no)/sum(population))*100000, 2)) 

### Let's perform some basic analysy 
plm_id_fix <- lm(`suicides/100k pop` ~ `gdp_per_capita ($)` + sex + age+ country -1, data = data)

summary(plm_id_fix)

# robust standard errors
rob_se_pan <- list(sqrt(diag(vcovHC(plm_id_fix, type = "HC1"))))

res <- stargazer(plm_id_fix,covariate.labels = "GDP Per Capita",
                 header = F, 
                 type = "html",
                 omit.table.layout = "n",
                 digits = 3,
                 dep.var.labels.include = T,
                 se = rob_se_pan)

a <- res[1:13] 
res <- append(a, res[319:325])




# I have to create a list of named countries with their 'value' associated 'cause that's  
# the input that the slider takes.  -----

list_x <- as.character(avg_dt$country)

Rcpp::sourceCpp('enlist.cpp',showOutput=F,verbose = F)
country_list <- enlist(list_x)

### Same function but in base R and consequent benchmark to compare their speed  -----

### Here I comment the code because my optimization would be pointless otherwise -----

# list_countries <- function(country) {
#              x <- vector()
#              x <- list(country)
#              names(x) <- country
#              return(x)
#  }
#  
# xd <- vector(mode = 'list')
# for (i in list_x){
#              xd <- append(xd, list_countries(i))
#              }


#### Let's prove that the Rcpp function is more than 100x faster with a simple test -----

# microbenchmark(for (i in list_x){xd <- append(xd, list_countries(i))}, enlist(list_x)) 