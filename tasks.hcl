# Sanity probe: proves the container really is on the network by the time
# activities run. If this ever fails, the startup-ordering guard in sandbox.hcl
# stopped working.
resource "task" "net_ready" {
  description     = "Confirm the sandbox network is up"
  success_message = "The container can resolve its own address, so the network is attached."

  config {
    target  = resource.container.shell
    timeout = "30s"
  }

  condition "dns_works" {
    description = "The shell container can resolve its own address"

    check {
      script          = "scripts/task/net_ready/check.sh"
      failure_message = "hostname -i failed, so the container has no network"
    }
  }
}

# A real two-container task: fetch from the web container and save the result.
resource "task" "http_ok" {
  description     = "Fetch the nginx welcome page from the web container"
  success_message = "Cross-container networking works."

  config {
    target  = resource.container.shell
    timeout = "60s"
  }

  condition "saved_index" {
    description = "/root/index.html contains the nginx welcome page"

    check {
      script          = "scripts/task/http_ok/check.sh"
      failure_message = "/root/index.html is missing or does not look like the nginx page"
    }

    solve {
      script = "scripts/task/http_ok/solve.sh"
    }
  }
}
