resource "aws_secretsmanager_secret" "application" {
  name = "${var.project_name}/${var.environment}/application"

  description = "CareGrid application runtime secrets"

  recovery_window_in_days = 7
}
