# site-helper
#
# Shared lookups and small helpers used by BOTH the UI (R/ui-controls.R) and the
# server (server-plots.R). Sourcing this first means the readable variable names
# live in exactly one place.

# Readable labels for each quantitative (Likert 1-7) survey item. Reports and
# graphs should use THESE names, not the short code book names. The named list
# is written as "what the reader sees" = "column name in survey.csv".
quant_choices <- list(
  "Preference for Collaboration" = "Collaboration",
  "Enjoyment of Writing"         = "Writing",
  "Interest in the Course"       = "Interesting",
  "Level of Understanding"       = "Understanding",
  "Confidence in Coding"         = "Coding"
)

# Categorical items / groups a student can be split or compared across, again
# with readable labels.
group_choices <- list(
  "Gender"            = "Gender",
  "Student Status"    = "Status",
  "Likes Assignments" = "LikesAssignments"
)

# The distribution view can show EITHER a rating item or a categorical item, so
# its drop-down offers both, organised into two labelled groups (optgroups).
dist_choices <- list(
  "Rating (1-7) Items" = quant_choices,
  "Categorical Items"  = group_choices
)

#' Readable label for any survey column
#' @description Given a column name (e.g., "Collaboration" or "Status"), return
#' the readable label the reader should see (e.g., "Preference for
#' Collaboration" or "Student Status"). Looks in the rating items first, then the
#' categorical items.
#' @param v A column name from survey.csv.
#' @return The corresponding readable label as a character string.
label_of <- function(v) {
  lab <- names(quant_choices)[match(v, quant_choices)]
  if (is.na(lab)) lab <- names(group_choices)[match(v, group_choices)]
  lab
}

#' Readable label for a grouping column
#' @description Same idea as label_of(), but for the grouping variables.
#' @param v A grouping column name (e.g., "Status").
#' @return The corresponding readable label (e.g., "Student Status").
group_label_of <- function(v) names(group_choices)[match(v, group_choices)]
