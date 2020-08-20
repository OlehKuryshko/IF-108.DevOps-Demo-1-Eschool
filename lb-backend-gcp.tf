#------------------instance_group
resource "google_compute_instance_group" "backend" {
  depends_on = ["google_compute_instance.server-be"]
  name        = "webservers-backend"
  zone        = "${var.zone}"
  description = "Terraform webserver instance group"
  instances   = ["${google_compute_instance.server-be[0].self_link}", "${google_compute_instance.server-be[1].self_link}"]
  named_port {
    name = "http"
    port = "8080"
  }
}
#-----------------Backend Service
resource "google_compute_backend_service" "backend" {
  name                      = "backend-service-backend"
  health_checks             = ["${google_compute_health_check.tcp-health-check.self_link}"]
    backend {
      group                 = "${google_compute_instance_group.backend.self_link}"
      balancing_mode        = "RATE"
      max_rate_per_instance = 100
  }
}
#----------------------- tcp_health_check
resource "google_compute_health_check" "tcp-health-check" {
  name = "tcp-health-check"
  timeout_sec        = 1
  check_interval_sec = 1
  tcp_health_check {
    port = "8080"
  }
}
#-------------------forwarding_rule
resource "google_compute_global_forwarding_rule" "global_forwarding_rule_be" {
  name        = "webserver-global-forwarding-rule-backend"
  project     = "${var.project}"
  target      = "${google_compute_target_http_proxy.target_http_proxy_backned.self_link}"
  port_range  = "80"
}
#-------------------target_http_proxy
resource "google_compute_target_http_proxy" "target_http_proxy_backned" {
  name    = "target-http-proxy-backend"
  project = "${var.project}"
  url_map = "${google_compute_url_map.url_map_backend.self_link}"
}
#-------------------url_map
resource "google_compute_url_map" "url_map_backend" {
  name            = "webservers-load-balancer-backend"
  project         = "${var.project}"
  default_service = "${google_compute_backend_service.backend.self_link}"
}
#---------------------output IP
output "load-balancer-ip-address-lb-backend" {
  value = "${google_compute_global_forwarding_rule.global_forwarding_rule_be.ip_address}"
}