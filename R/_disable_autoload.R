# This empty sentinel file turns OFF Shiny's automatic sourcing of the R/ folder.
#
# By default (Shiny >= 1.5.0) Shiny sources every .R file in R/ ALPHABETICALLY,
# into the global environment, BEFORE app.R runs. That order does not match this
# app's dependencies (e.g., ui-controls.R uses pch_types from ui-extra.R, which
# sorts later; and it calls colourInput() before app.R's library() calls run).
#
# With autoload disabled, the explicit, correctly-ordered source() calls at the
# top of app.R are the single source of truth. Delete this file if you would
# rather rely on autoloading (and then rename files / load packages accordingly).

# See: https://shiny.posit.co/r/reference/shiny/latest/loadsupport.html for source