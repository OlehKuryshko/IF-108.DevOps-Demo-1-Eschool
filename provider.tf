#-----------GCP provider---------
provider "google" {
  version     = "~> 3.19"
  credentials = "${file("${var.key}")}"
  project     = "${var.project}"
  region      = "${var.region}"
  zone        = "${var.zone}"
}
#------------aws provider
provider "aws" {
  access_key  = "${var.aws_access_key}"
  secret_key  = "${var.aws_secret_key}"
  region      = "${var.region_aws}"
  version     = "~> 2.60"
}