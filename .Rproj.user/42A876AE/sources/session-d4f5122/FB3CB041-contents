# ui-text
#
# Static content for the "Analysis" and "About" tabs. Keeping the prose here
# keeps app.R focused on layout. Students: replace this text with your own!

analysis_content <- div(
  style = "max-width: 800px;",

  h3("Summary of Findings"),

  p("This section is where you write up what the survey actually found, in plain",
    "language, so a reader who never touches the Explore tab still learns",
    "something. The text below is an EXAMPLE based on the demonstration data;",
    "replace it with your own results."),

  p("Across all 50 respondents, the average rating for each item was:"),

  tableOutput("summary_table"),

  p("For example, students rated their Perceived Interest in the Course highest",
    "on average, while Confidence in Coding was rated lowest. Using the Explore",
    "tab, a two-sample t-test found no statistically significant difference in",
    "Enjoyment of Writing between domestic and international students",
    "($p$ = 0.17), and the rating items were only weakly correlated with one",
    "another. A fuller write-up would connect these findings back to your",
    "research question and note any statistical tests you ran."),
)

about_content <- div(
  style = "max-width: 800px;",

  h3("About This Survey"),

  p("This is a demonstration app for the STA304 website checkpoint. It uses a",
    "small example data set of student survey responses to show the kinds of",
    "interactivity we expect: filterable, adjustable plots with plain-language",
    "interpretations. Replace this description with a short summary of YOUR",
    "project: the research question, who you surveyed, and how."),

  h4("The Sample"),

  p("The example data contains 50 (synthetic) student responses. Each student",
    "reported their gender and domestic/international status, whether they like",
    "assignments, and rated five statements on a 1-to-7 scale."),

  h4("Caveats"),

  tags$ul(
    tags$li("The respondents are a convenience sample, not a random sample, so",
            "results may not generalise to all students."),
    tags$li("The rating items are ordinal (1-7), so means and fitted lines",
            "should be read with some caution."),
    tags$li("With only 50 responses, subgroup comparisons can be noisy."),
  ),
)
