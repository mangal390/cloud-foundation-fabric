provider "google" {
  impersonate_service_account = "billing-account-user-mangal@terraform-project-023.iam.gserviceaccount.com"
}

provider "google-beta" {
  impersonate_service_account = "billing-account-user-mangal@terraform-project-023.iam.gserviceaccount.com"
}
# tftest skip