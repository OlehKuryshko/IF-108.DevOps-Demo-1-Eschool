#---------------------------Ansible--------
resource "google_compute_instance" "ansible" {
  name                    = "ansible-host"
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