output "spn_pswd" {
      value = azuread_service_principal_password.avd_spn_pswd.value
      sensitive = true
}

output "spn_app_id" {
  value = azuread_application.avd_sp.application_id
}