resource "network" "main" {
  subnet = "10.0.240.0/24"
}

# ---------------------------------------------------------------------------
# Every container here waits for the sandbox network before running its real
# entrypoint. That is deliberate: containers are started ~1.6s BEFORE they are
# attached to the network, so any startup that resolves DNS or looks up its own
# address dies and surfaces as a confusing CNI "Statfs /proc/<pid>/ns/net"
# error. See instruqt-guacamole-lab-hp, FINDINGS.md (G2).
#
# Keeping the guard in the bench means a failure here is a real finding, not
# that known startup-ordering bug biting again.
# ---------------------------------------------------------------------------

resource "container" "web" {
  image {
    name = "nginx:alpine"
  }

  port {
    local = 80
  }

  resources {
    cpu    = 1000
    memory = 512
  }

  network {
    id      = resource.network.main.meta.id
    aliases = ["web"]
  }

  health_check {
    timeout = "60s"

    http {
      address       = "http://localhost:80"
      success_codes = [200]
    }
  }
}

resource "container" "shell" {
  image {
    name = "alpine:3.20"
  }

  entrypoint = ["/bin/sh", "-c"]
  command    = ["until hostname -i >/dev/null 2>&1; do sleep 0.2; done; exec sleep infinity"]

  resources {
    cpu    = 1000
    memory = 512
  }

  network {
    id      = resource.network.main.meta.id
    aliases = ["shell"]
  }
}
