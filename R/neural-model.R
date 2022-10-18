library(tidymodels)
library(neuralnet)

pittsburgh_shiny <- pittsburgh_shiny %>%
  select(visits_by_day, st.oppo, st.ml, st.div, st.weekday, pi.oppo, pi.ml, pi.div,
         pi.weekday, pe.oppo, pe.ml, pe.div, pe.weekday, tempmax,
         tempmin, humidity, precip, precipprob, snow, windspeed, cloudcover, icon)

pittsburgh_shiny[is.na(pittsburgh_shiny)] <- 0

pittsburgh_split <- initial_split(pittsburgh_shiny)
pittsburgh_train <- training(pittsburgh_split)
pittsburgh_test <- testing(pittsburgh_split)

neural.model <- neuralnet(visits_by_day ~ ., data = pittsburgh_train,
                          hidden = 3, linear.output = FALSE)

save(neural.model, file = "trained-neural-model.rda")
save(pittsburgh_train, file = "pittsburgh_train.rds")
save(pittsburgh_test, file = "pittsburgh_test.rds")


neural.test <- subset(pittsburgh_test, select = -c(visits_by_day))
neural.results <- compute(neural.model, neural.test)
results <- data.frame(actual = pittsburgh_test$visits_by_day, prediction = neural.results$net.result)

roundedresults <- sapply(results, round, digits = 0)
roundedresults.df <- data.frame(roundedresults)
attach(roundedresults.df)
table(actual, prediction)

