Sys.setenv(GCE_AUTH_FILE = '/Users/yue/Downloads/semiotic-vial-255604-401233702f0c.json')
library(googleComputeEngineR)

gce_global_project("semiotic-vial-255604")
gce_global_zone("us-central1-a")

## use updated Artifact Registry image path
tag <- "us-central1-docker.pkg.dev/semiotic-vial-255604/workshop/spatial:alpha"

the_list <- gce_list_instances()

vm1 <- gce_vm(template = "rstudio",
              name = "spatial",
              disk_size_gb = 500,
              predefined_type = "n2-standard-32",
              dynamic_image = tag,
              user = "rstudio",
              password = "test")

vm2 <- gce_vm(template = "rstudio",
              name = "spatial2",
              disk_size_gb = 500,
              predefined_type = "n2-standard-32",
              dynamic_image = tag,
              user = "rstudio",
              password = "test")

# using a debian machine if anything need testing
# because only debian machine has apt-get functionalities 
# gce_vm(
#   name = "debian-test",
#   image_project = "debian-cloud",
#   image_family = "debian-11",
#   predefined_type = "e2-standard-4"
# )
