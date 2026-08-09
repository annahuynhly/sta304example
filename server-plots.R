# server-plots
#
# All of the reactive logic and outputs. This file is sourced (locally) by the
# server function in app.R so that it can see `input`, `output`, and `session`.

# Reactive: the survey data AFTER applying the two demographic filters. Every
# plot and every interpretation reads from filtered(), so a change to a filter
# updates the whole app at once.
filtered <- reactive({
  survey[survey$Gender %in% input$gender_filter &
         survey$Status %in% input$status_filter, ]
})

#####################################################
# Distribution of one variable (bar chart)          #
#####################################################

# The distribution can be a rating item (levels 1-7) or a categorical item
# (Gender, Status, ...). This small helper returns the right table of counts.
dist_counts <- reactive({
  d <- filtered()
  if (input$dist_var %in% unlist(quant_choices)) {
    table(factor(d[[input$dist_var]], levels = 1:7))   # rating item
  } else {
    table(d[[input$dist_var]])                          # categorical item
  }
})

# Rescale the y-axis slider to fit whatever is currently shown, so a sensible
# default is offered whether the user picks counts, percentages, a rating item,
# or a categorical item. They can still drag it afterwards.
observeEvent(list(input$dist_yaxis, input$dist_var,
                  input$gender_filter, input$status_filter), {
  counts <- dist_counts()
  if (sum(counts) == 0) return()
  if (input$dist_yaxis == "percent") {
    top <- max(as.numeric(prop.table(counts))) * 100
    updateSliderInput(session, "dist_ymax",
                      max = 100, value = min(100, ceiling((top + 10) / 5) * 5))
  } else {
    top <- max(as.numeric(counts))
    updateSliderInput(session, "dist_ymax",
                      max = max(50, ceiling(top / 5) * 5),
                      value = ceiling((top + 2) / 5) * 5)
  }
})

output$dist_plot <- renderPlot({
  d <- filtered()
  validate(need(nrow(d) > 0, "No students match the current filters."))

  counts   <- dist_counts()
  is_quant <- input$dist_var %in% unlist(quant_choices)
  xlab     <- if (is_quant) paste0(label_of(input$dist_var), " (1 = Low, 7 = High)")
              else label_of(input$dist_var)

  # counts vs percentages, controlled by the radio button
  if (input$dist_yaxis == "percent") {
    heights <- as.numeric(prop.table(counts)) * 100
    ylab    <- "Percentage of students (%)"
    labels  <- paste0(round(heights, 1), "%")
  } else {
    heights <- as.numeric(counts)
    ylab    <- "Number of students"
    labels  <- heights
  }

  # one colour, or one colour per response from the chosen palette
  bar_cols <- if (isTRUE(input$dist_multicolour)) {
    get(input$dist_palette)(length(heights))
  } else {
    input$dist_col
  }

  bp <- barplot(heights,
                names.arg = names(counts),
                main = paste("Distribution of", label_of(input$dist_var)),
                xlab = xlab,
                ylab = ylab,
                ylim = c(0, input$dist_ymax),
                col = bar_cols,
                border = "white")

  # print the count/percentage on top of each bar
  text(x = bp, y = heights, labels = labels, pos = 3, cex = 0.9, xpd = TRUE)
})

output$dist_text <- renderText({
  d <- filtered()
  validate(need(nrow(d) > 0, ""))

  counts <- dist_counts()
  pct    <- round(prop.table(counts) * 100, 1)
  top    <- names(counts)[which.max(counts)]

  if (input$dist_var %in% unlist(quant_choices)) {
    x <- d[[input$dist_var]]
    paste0("Showing ", nrow(d), " students. On average, respondents rated ",
           label_of(input$dist_var), " at ", round(mean(x), 1),
           " out of 7 (median ", median(x), "). The most common response was ",
           top, ", chosen by ", pct[[top]], "% of students.")
  } else {
    paste0("Showing ", nrow(d), " students. The most common ",
           label_of(input$dist_var), " category was \"", top, "\", making up ",
           pct[[top]], "% of respondents.")
  }
})

#####################################################
# Comparison across a group (side-by-side boxplots) #
#####################################################

output$compare_plot <- renderPlot({
  d <- filtered()
  validate(need(nrow(d) > 0, "No students match the current filters."))

  form <- as.formula(paste(input$compare_var, "~", input$compare_by))

  # one colour, or one colour per group from the chosen palette. There is one
  # box per group still present after filtering.
  n_groups <- length(unique(d[[input$compare_by]]))
  box_cols <- if (isTRUE(input$compare_multicolour)) {
    get(input$compare_palette)(n_groups)
  } else {
    input$compare_col
  }

  boxplot(form, data = d,
          main = paste(label_of(input$compare_var), "by",
                       group_label_of(input$compare_by)),
          xlab = group_label_of(input$compare_by),
          ylab = label_of(input$compare_var),
          col = box_cols,
          border = "#282B30",
          lwd = 2)
})

output$compare_text <- renderText({
  d <- filtered()
  validate(need(nrow(d) > 0, ""))

  groups <- d[[input$compare_by]]
  levels_present <- unique(groups)

  # If exactly two groups are present, report a two-sample t-test so the reader
  # gets a plain-language comparison, not just a picture.
  if (length(levels_present) == 2) {
    g1 <- d[[input$compare_var]][groups == levels_present[1]]
    g2 <- d[[input$compare_var]][groups == levels_present[2]]
    res <- t.test(g1, g2)
    verdict <- if (res$p.value < 0.05) "a statistically significant difference"
               else "no statistically significant difference"
    paste0("Comparing ", label_of(input$compare_var), " between ",
           levels_present[1], " (mean ", round(mean(g1), 1), ") and ",
           levels_present[2], " (mean ", round(mean(g2), 1), "), a two-sample ",
           "t-test finds ", verdict, " (p = ", round(res$p.value, 3), ").")
  } else {
    paste0("Showing ", length(levels_present), " groups. Select filters that ",
           "leave exactly two groups to see a two-sample t-test here.")
  }
})

#####################################################
# Relationship between two variables (scatterplot)  #
#####################################################

output$scatter_plot <- renderPlot({
  d <- filtered()
  validate(need(nrow(d) > 0, "No students match the current filters."))

  # The responses are ordinal (integers 1-7), so many points land on top of one
  # another. A little jitter makes the cloud of points readable.
  plot(jitter(d[[input$scatter_x]]), jitter(d[[input$scatter_y]]),
       xlab = label_of(input$scatter_x),
       ylab = label_of(input$scatter_y),
       main = paste(label_of(input$scatter_y), "vs.", label_of(input$scatter_x)),
       xlim = c(1, 7),
       ylim = input$scatter_ylim,
       pch = as.numeric(input$scatter_pch),
       col = input$scatter_col)

  abline(lm(d[[input$scatter_y]] ~ d[[input$scatter_x]]),
         col = "#EE4266", lwd = 2)
})

output$scatter_text <- renderText({
  d <- filtered()
  validate(need(nrow(d) > 1, ""))
  r <- cor(d[[input$scatter_x]], d[[input$scatter_y]])

  strength <- if (abs(r) < 0.2) "essentially no"
              else if (abs(r) < 0.4) "a weak"
              else if (abs(r) < 0.6) "a moderate"
              else "a strong"
  direction <- if (r >= 0) "positive" else "negative"

  paste0("The correlation between ", label_of(input$scatter_x), " and ",
         label_of(input$scatter_y), " is ", round(r, 2), ", indicating ",
         strength, " ", direction, " linear relationship. Remember these are ",
         "ordinal responses, so interpret the fitted line with caution.")
})

#####################################################
# Analysis tab: overall summary table               #
#####################################################

# Mean / median / SD of every rating item across ALL respondents (this table is
# a fixed overview, so it does not use the Explore-tab filters).
output$summary_table <- renderTable({
  items <- unlist(quant_choices)
  data.frame(
    Variable = names(quant_choices),
    Mean     = sapply(items, function(v) round(mean(survey[[v]]), 1)),
    Median   = sapply(items, function(v) median(survey[[v]])),
    SD       = sapply(items, function(v) round(sd(survey[[v]]), 1)),
    row.names = NULL,
    check.names = FALSE
  )
})
