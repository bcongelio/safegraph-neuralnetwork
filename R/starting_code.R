library(neuralnet)

model.select <- model.select %>%
  filter(visits_by_day > 0)

model.select[is.na(model.select)] <- 0

n3 <- neuralnet(
  visits_by_day ~ .,
  data = model.select,
  hidden = c(2,5),
  err.fct = "sse",
  linear.output = FALSE
)

plot(n3)
