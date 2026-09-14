# Labs 2.0 probe bench

A deliberately boring lab. It exists to **start reliably**, so it can be used as
a base for probing Labs 2.0 features and reproducing bugs without fighting the
sandbox itself.

## What is in the sandbox

| Resource | What it is | Reachable as |
|---|---|---|
| `container.web` | `nginx:alpine`, with an HTTP health check | `web:80` |
| `container.shell` | `alpine:3.20`, where activity scripts run | `shell` |
| `network.main` | `10.0.240.0/24` | — |

## The startup guard, and why it is there

Containers are started roughly **1.6 seconds before** they are attached to the
sandbox network. Any startup that resolves DNS or looks up its own address dies
in that window, and the failure surfaces as a confusing CNI error:

```
plugin type="bridge" failed (add): failed to open netns "/proc/<pid>/ns/net"
```

So `container.shell` wraps its entrypoint:

```hcl
command = ["until hostname -i >/dev/null 2>&1; do sleep 0.2; done; exec sleep infinity"]
```

Keeping that guard in means **a failure in this bench is a real finding**, not
the known ordering bug biting again.

Background: `instruqt-guacamole-lab-hp`, `FINDINGS.md` (G2).

## Tabs

Three tab types are wired up, so each can be exercised: a **terminal**
(`terminal.shell`), a **service** (`service.web`), and an **external website**
(`external_website.docs`).
