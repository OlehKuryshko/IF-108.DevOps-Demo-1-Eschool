#---------------------------LB--------
resource "google_compute_instance" "lb" {
  count = "${length(var.name_lb)}"
  name                    = "load-balancer-${element(var.name_lb, count.index)}"
  machine_type            = "${var.machine_type}"
  tags                    = ["http-https", "web", "ssh"]
    network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
      access_config {
          nat_ip = ""
      }
  }
  boot_disk {
    initialize_params {
      image               = "${var.image}"
    }
  }
    metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file("${var.pub_key}")}"
  }
}
