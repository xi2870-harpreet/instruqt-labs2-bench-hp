resource "service" "web" {
  target = resource.container.web
  port   = 80
  scheme = "http"
}

resource "terminal" "shell" {
  target = resource.container.shell
  shell  = "/bin/sh"
}

resource "external_website" "docs" {
  url                = "https://docs.labs.instruqt.com/introduction/overview/"
  open_in_new_window = true
}
