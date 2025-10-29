resource "google_service_account" "service-a" {
    account_id = "service-a"  
}

resource "google_project_iam_member" "service-a" {
  project = "tutorialgcp001"
  role = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.service-a.email}"
}

resource "google_service_account_iam_member" "service-a" {
  service_account_id = google_service_account.service-a.id
  role = "roles/iam.workloadIdentityUser"
  member = "serviceAccount:adept-storm-460018-c7.svc.id.goog[staging/service-a]"
}