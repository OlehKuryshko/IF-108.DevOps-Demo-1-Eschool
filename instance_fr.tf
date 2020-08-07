#----------------------------FRONT
resource "google_compute_instance" "server-fr" {
  count = "${length(var.name_count)}"
  name                    = "frontend-${element(var.name_count, count.index)}"
  machine_type            = "${var.machine_type}"
  tags                    = ["http-https", "web", "ssh"]
  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    network_ip = "${element(var.ip_fr_count, count.index)}"
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