#---------------------------
resource "null_resource" "ansibleProvision" {
  depends_on = ["null_resource.update_file_db", "google_compute_instance.ansible"]

  connection {
    host = "${google_compute_instance.ansible.network_interface.0.access_config.0.nat_ip}"
    type = "ssh"
    user = "centos"
    private_key = "${file("${var.pvt_key}")}"
    agent = "false"
  }
  provisioner "file" {
     source = "${var.pvt_key}"
     destination = "/home/centos/.ssh/id_rsa"
     }
  provisioner "remote-exec" {
    inline = ["sudo chmod 600 /home/centos/.ssh/id_rsa"]
  }

  provisioner "remote-exec" {
    inline = [ "sudo yum -y update", "sudo yum -y install ansible"]
  }
  provisioner "remote-exec" {
    inline = [ "rm -rf /tmp/ansible" ]
  }
  provisioner "file" {
    source = "ansible"
    destination = "/tmp/ansible"
  }
  provisioner "remote-exec" {
    inline = ["sudo sed -i -e 's+#host_key_checking+host_key_checking+g' /etc/ansible/ansible.cfg"]
  }
  provisioner "remote-exec" {
    inline = ["ansible-playbook -i /tmp/ansible/hosts.txt /tmp/ansible/playbook.yml"]
  }
}
#-------generate inventory file
resource "null_resource" "update_file_lb" {
  provisioner "local-exec" {
    command = "echo [lb] >> ${var.hosts} && echo ${google_compute_instance.lb[0].name} ansible_host=${google_compute_instance.lb[0].network_interface.0.access_config.0.nat_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts} && echo ${google_compute_instance.lb[1].name} ansible_host=${google_compute_instance.lb[1].network_interface.0.access_config.0.nat_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts}"
}
  depends_on = [google_compute_instance.lb]
}
resource "null_resource" "update_file_fr" {
  provisioner "local-exec" {
    command = "echo [frontend] >> ${var.hosts} && echo ${google_compute_instance.server-fr[0].name} ansible_host=${google_compute_instance.server-fr[0].network_interface.0.network_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts} && echo ${google_compute_instance.server-fr[1].name} ansible_host=${google_compute_instance.server-fr[1].network_interface.0.network_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts}"
}
  depends_on = [google_compute_instance.server-fr, null_resource.update_file_lb]
}
resource "null_resource" "update_file_be" {
  provisioner "local-exec" {
    command = "echo [backend] >> ${var.hosts} && echo ${google_compute_instance.server-be[0].name} ansible_host=${google_compute_instance.server-be[0].network_interface.0.network_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts} && echo ${google_compute_instance.server-be[1].name} ansible_host=${google_compute_instance.server-be[1].network_interface.0.network_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts}"
}
  depends_on = [google_compute_instance.server-be, null_resource.update_file_fr]

}
resource "null_resource" "update_file_db" {
  provisioner "local-exec" {
    command = "echo [db] >> ${var.hosts} && echo ${google_compute_instance.server-db.name} ansible_host=${google_compute_instance.server-db.network_interface.0.network_ip} ansible_user=${var.gce_ssh_user} ansible_ssh_private_key_file=${var.pvt_key_ansible} >> ${var.hosts}"
}
  depends_on = [google_compute_instance.server-db, null_resource.update_file_be]
}