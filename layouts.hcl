resource "layout" "default" {
  column {
    width = "60"

    tab "shell" {
      title  = "Shell"
      target = resource.terminal.shell
      active = true
    }

    tab "web" {
      title  = "Web"
      target = resource.service.web
    }

    tab "docs" {
      title  = "Docs"
      target = resource.external_website.docs
    }
  }

  column {
    width = "40"

    instructions {
      active = true
    }
  }
}
