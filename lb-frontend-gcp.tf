#------------------instance_group
resource "google_compute_instance_group" "webservers" {
  name        = "webservers-frontend"
  zone        = "${var.zone}"
  description = "Terraform webserver instance group"
  instances   = ["${google_compute_instance.server-fr[0].self_link}", "${google_compute_instance.server-fr[1].self_link}"]
  named_port {
    name      = "http80"
    port      = "80"
  }
}
#-----------------Backend Service
resource "google_compute_backend_service" "default" {
  name                      = "backend-service"
  health_checks             = ["${google_compute_http_health_check.default.self_link}"]
    backend {
      group                 = "${google_compute_instance_group.webservers.self_link}"
      balancing_mode        = "RATE"
      max_rate_per_instance = 100
  }
}
#----------------------http_health_check
resource "google_compute_http_health_check" "default" {
  name               = "health-check"
  request_path       = "/"
  check_interval_sec = 1
  timeout_sec        = 1
}
#-------------------forwarding_rule
resource "google_compute_global_forwarding_rule" "global_forwarding_rule" {
  name        = "webserver-global-forwarding-rule"
  project     = "${var.project}"
  target      = "${google_compute_target_http_proxy.target_http_proxy.self_link}"
  port_range  = "80"
}
#-------------------target_http_proxy
resource "google_compute_target_http_proxy" "target_http_proxy" {
  name    = "target-http-proxy"
  project = "${var.project}"
  url_map = "${google_compute_url_map.url_map.self_link}"
}
#-------------------url_map
resource "google_compute_url_map" "url_map" {
  name            = "webservers-load-balancer"
  project         = "${var.project}"
  default_service = "${google_compute_backend_service.default.self_link}"
}
#---------------------output IP
output "load-balancer-ip-address-lb-frontend" {
  value = "${google_compute_global_forwarding_rule.global_forwarding_rule.ip_address}"
}