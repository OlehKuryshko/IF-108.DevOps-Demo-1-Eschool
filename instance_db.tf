#----------------------------DB
resource "google_compute_instance" "server-db" {
  name                    = "db-mysql"
  machine_type            = "${var.machine_type}"
  tags                    = ["db", "ssh"]
  network_interface {
    subnetwork = "${google_compute_subnetwork.private_subnetwork.name}"
    network_ip = "${var.ip_db}"
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