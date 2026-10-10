variable "subscription_id" {
  description = "The Azure subscription ID."
  type        = string
  sensitive   = true
  validation {
    condition     = can(regex("^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$", var.subscription_id))
    error_message = "Usa el ID real de la suscripción verificada con Azure CLI."
  }
}


variable "service_plan_sku_name" {
  type    = string
  default = "F1"
  validation {
    condition     = var.service_plan_sku_name == "F1"
    error_message = "Esta práctica utiliza F1; no cambiar automáticamente a un plan de pago."
  }
}

variable "application_type" {
  description = "Application type for the Azure Application Insights resource"
  type        = string
  default     = "web"
}

variable "node_version" {
  description = "Node.js version for the Azure Linux Web App"
  type        = string
  default     = "24-lts"
}

variable "log_analytics_sku" {
  description = "SKU del espacio de trabajo de Log Analytics"
  type        = string
  default     = "PerGB2018"
}


variable "web_app_name" {
  description = "Nombre de la aplicación web del entorno QA"
  type        = string
  validation {
    condition     = length(var.web_app_name) >= 2 && length(var.web_app_name) <= 60 && can(regex("^[a-z0-9][a-z0-9-]*[a-z0-9]$", var.web_app_name))
    error_message = "Usa un nombre global único de 2 a 60 caracteres alfanuméricos o guiones."
  }
}

variable "location" {
  description = "Región confirmada en Azure para los cinco recursos."
  type        = string
}

variable "location_code" {
  description = "Abreviatura de la región usada en la nomenclatura; mxc corresponde a Mexico Central."
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]{2,8}$", var.location_code))
    error_message = "Usa una abreviatura en minúsculas de 2 a 8 caracteres."
  }
}

