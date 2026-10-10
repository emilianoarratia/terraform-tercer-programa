# Convención derivada del nombre de la Web App del profesor.
# La ubicación efectiva debe verificarse contra políticas y disponibilidad F1.
locals {
  suffix   = "utvt-integradora-web-qa-${var.location_code}-001"
  location = var.location
  tags = {
    project     = "utvt-integradora-web"
    environment = "qa"
    managed_by  = "terraform"
    practice    = "tercer-programa"
  }
}
