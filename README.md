# Labs 2.0 probe bench

A deliberately boring Instruqt Labs 2.0 lab whose only job is to **start
reliably**, so it can be used as a stable base for probing features and
reproducing bugs.

## Why a bench

Every previous probe lab doubled as its own bug repro, which meant a failed
start could be the thing under test *or* a known platform bug, and telling them
apart cost time. This one is built to always work, so anything that breaks in it
is a real finding.

## What it exercises

| Area | Covered by |
|---|---|
| Networking between containers | `container.web` + `container.shell` on `network.main` |
| Health checks | `http` probe on `container.web` |
| Tab types | `terminal`, `service`, `external_website` |
| Layout | two columns, three tabs, instructions pane |
| Content | two chapters, three pages |
| Tasks | `net_ready` (check only), `http_ok` (check + solve) |
| Quiz | all four question types, `show_hints` and `show_answers` on |

## The startup guard

Containers start roughly **1.6 seconds before** they are attached to the sandbox
network. Any startup that resolves DNS or looks up its own address dies in that
window and surfaces as a misleading CNI error:

```
plugin type="bridge" failed (add): failed to open netns "/proc/<pid>/ns/net"
```

So `container.shell` wraps its entrypoint:

```hcl
entrypoint = ["/bin/sh", "-c"]
command    = ["until hostname -i >/dev/null 2>&1; do sleep 0.2; done; exec sleep infinity"]
```

Root cause and evidence: `instruqt-guacamole-lab-hp`, `FINDINGS.md` (G2) and
`artifacts/pid1-boot.log`.

## Using it

Change one thing, run it, and see what happens. Keep each probe on its own
branch so `main` stays a known-good baseline.
