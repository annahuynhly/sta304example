# ui-controls
#
# The sidebar input widgets, grouped into three pieces:
#   var_selectors    -> which variable(s) to plot (always visible)
#   data_filters     -> demographic filters       (shown when modifying "data")
#   graph_appearance -> colours, symbols, limits   (shown when modifying "graph")
#
# Splitting the sidebar this way keeps app.R short and readable.

# ---- which variable(s) to plot -------------------------------------------
# These depend on the plot type, so each plot gets its own conditionalPanel.
var_selectors <- div(

  conditionalPanel(
    condition = "input.plot_type == 'dist'",
    selectInput(inputId = "dist_var",
                label = "Which variable would you like to see?",
                choices = dist_choices)
  ),

  conditionalPanel(
    condition = "input.plot_type == 'compare'",
    selectInput(inputId = "compare_var",
                label = "Which variable would you like to compare?",
                choices = quant_choices),
    selectInput(inputId = "compare_by",
                label = "Compare across which group?",
                choices = group_choices)
  ),

  conditionalPanel(
    condition = "input.plot_type == 'scatter'",
    selectInput(inputId = "scatter_x",
                label = "Variable for the x-axis:",
                choices = quant_choices,
                selected = "Collaboration"),
    selectInput(inputId = "scatter_y",
                label = "Variable for the y-axis:",
                choices = quant_choices,
                selected = "Writing")
  ),
)

# ---- demographic filters (the required "filter by a demographic") ---------
data_filters <- div(
  conditionalPanel(
    condition = "input.modify_type == 'data'",

    checkboxGroupInput(inputId = "gender_filter",
                       label = "Include which genders?",
                       choices = c("Female", "Male", "Other"),
                       selected = c("Female", "Male", "Other")),

    checkboxGroupInput(inputId = "status_filter",
                       label = "Include which student status?",
                       choices = c("Domestic", "International"),
                       selected = c("Domestic", "International")),
  ), # End conditionalPanel
)

# ---- graph appearance (colours / symbols / axis limits) -------------------
graph_appearance <- div(
  conditionalPanel(
    condition = "input.modify_type == 'graph'",

    # appearance for the distribution (bar chart)
    conditionalPanel(
      condition = "input.plot_type == 'dist'",

      radioButtons(inputId = "dist_yaxis",
                   label = "Show each response as a:",
                   choices = c("Count"      = "count",
                               "Percentage" = "percent"),
                   selected = "count"),

      checkboxInput(inputId = "dist_multicolour",
                    label = "Use a different colour for each response?",
                    value = FALSE),

      # a single colour is used when the box above is unchecked ...
      conditionalPanel(
        condition = "input.dist_multicolour == false",
        colourInput(inputId = "dist_col",
                    label = "Input the bar colour.",
                    value = "#6699FF"),
      ),

      # ... otherwise the user picks a palette (one colour per response)
      conditionalPanel(
        condition = "input.dist_multicolour == true",
        selectInput(inputId = "dist_palette",
                    label = "Colour palette (one colour per response):",
                    choices = list("Rainbow" = "rainbow",
                                   "Heat"    = "heat.colors",
                                   "Terrain" = "terrain.colors",
                                   "Topo"    = "topo.colors"),
                    selected = "rainbow"),
      ),

      sliderInput(inputId = "dist_ymax",
                  label = "Maximum y-axis value.",
                  min = 5, max = 40, value = 20),
    ), # End conditionalPanel

    # appearance for the group comparison (boxplot)
    conditionalPanel(
      condition = "input.plot_type == 'compare'",

      checkboxInput(inputId = "compare_multicolour",
                    label = "Use a different colour for each group?",
                    value = FALSE),

      # a single colour is used when the box above is unchecked ...
      conditionalPanel(
        condition = "input.compare_multicolour == false",
        colourInput(inputId = "compare_col",
                    label = "Input the box colour.",
                    value = "#FF6666"),
      ),

      # ... otherwise the user picks a palette (one colour per group)
      conditionalPanel(
        condition = "input.compare_multicolour == true",
        selectInput(inputId = "compare_palette",
                    label = "Colour palette (one colour per group):",
                    choices = list("Rainbow" = "rainbow",
                                   "Heat"    = "heat.colors",
                                   "Terrain" = "terrain.colors",
                                   "Topo"    = "topo.colors"),
                    selected = "rainbow"),
      ),
    ), # End conditionalPanel

    # appearance for the relationship (scatterplot)
    conditionalPanel(
      condition = "input.plot_type == 'scatter'",

      pch_types,   # link explaining the symbols; see R/ui-extra.R

      selectInput(inputId = "scatter_pch",
                  label = "Select the point symbol.",
                  choices = 0:25,
                  selected = 19),

      colourInput(inputId = "scatter_col",
                  label = "Input the point colour.",
                  value = "#5b10a7"),

      sliderInput(inputId = "scatter_ylim",
                  label = "y-axis range to display.",
                  min = 1, max = 7, value = c(1, 7)),
    ), # End conditionalPanel
  ), # End conditionalPanel (modify_type == 'graph')
)
