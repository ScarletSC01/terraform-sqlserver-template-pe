terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 4.0"
    }
  }
}
 
provider "google" {
  credentials = file(var.credentials_file)
  project     = var.project
  region      = var.region
}
 
resource "google_sql_database_instance" "sqlserver_instance" {
  name             = "sqlserver-instance-pe"
  region           = var.region
  database_version = "SQLSERVER_2017_STANDARD"
  deletion_protection = false
  settings {
    tier = "db-custom-4-15360"
    ip_configuration {
      ipv4_enabled = true
      authorized_networks {
        name  = "allow-all"
        value = "0.0.0.0/0"
      }
    }
  }
 
  root_password = "Strong!Passw0rd"
}
 
resource "google_sql_database" "empresa_db" {
  name     = "empresa"
  instance = google_sql_database_instance.sqlserver_instance.name
}
 
output "sqlserver_ip" {
  value = google_sql_database_instance.sqlserver_instance.ip_address[0].ip_address
}
