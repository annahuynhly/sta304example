# STA304 Website Example — Student Survey Explorer

An example R Shiny app for the STA304 website checkpoint, built on a synthetic student
survey data set (`survey.csv`). **For educational purposes only — STA304 material.**
Do not submit this app as your own; swap in your data and make it yours.

**MAKE SURE IF YOU UPLOAD DATA THAT YOU REMOVED ALL SENSITIVE INFORMATION!**

## File layout

```
app.R              # UI (page_navbar: Explore / Analysis / About) + server
server-plots.R     # reactive filtering, plots, and interpretation text
survey.csv         # the cleaned data (loaded with a RELATIVE path)
R/
  site-helper.R        # readable-name lookups + helpers (shared by UI and server)
  ui-controls.R        # the sidebar widgets (variable selectors, filters, appearance)
  ui-text.R            # static text for the Analysis and About tabs
  ui-extra.R           # small explanatory link(s) for the sidebar
  ui-latex.R           # loads KaTeX so $...$ math renders in the app
  _disable_autoload.R  # (empty) turns off Shiny's alphabetical auto-sourcing of R/
```

Shiny (>= 1.5.0) auto-sources `R/` alphabetically before `app.R` runs. This app instead loads
those files in dependency order via the `source()` calls at the top of `app.R`, so the empty
`R/_disable_autoload.R` sentinel switches the automatic sourcing off to avoid a conflict. (See 
bottom of [here](https://shiny.posit.co/r/reference/shiny/latest/loadsupport.html).)

## Run it locally

Open `app.R` in RStudio and click **Run App**, or:

```r
install.packages(c("shiny", "bslib", "shinycssloaders", "colourpicker"))
shiny::runApp()
```
