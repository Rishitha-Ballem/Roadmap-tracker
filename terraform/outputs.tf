output "instance_id" {
  value = aws_instance.roadmap_app.id
}

output "public_ip" {
  value = aws_instance.roadmap_app.public_ip
}

output "web_url" {
  description = "URL to access the application"
  value       = "http://${aws_instance.roadmap_app.public_ip}"
}
