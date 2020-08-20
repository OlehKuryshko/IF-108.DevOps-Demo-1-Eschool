#----------------------------FRONT
resource "google_compute_instance" "server-fr" {
  count = "${var.count_number}"
  name                    = "frontend-${count.index + 1}"
  machine_type            = "${var.machine_type}"
  tags                    = ["http-https", "web", "ssh"]
  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
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