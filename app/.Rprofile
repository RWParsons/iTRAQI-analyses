if (file.exists("renv")) {
  source("renv/activate.R")
} else {
  # The `renv` directory is automatically skipped when deploying with rsconnect.
  message("No 'renv' directory found; renv won't be activated.")
}

Sys.setenv(MAPBOX_PUBLIC_TOKEN=keyring::key_get("mapbox", "rex.parsons94@gmail.com"))

# Allow absolute module imports (relative to the app root).
options(box.path = getwd())
