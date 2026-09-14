# Tasks

Two tasks, both targeting `container.shell`.

## Confirm the sandbox network is up

A sanity probe. It runs `hostname -i` inside the container, which only succeeds
once the container is attached to the network. If this ever fails, the startup
guard in `sandbox.hcl` has stopped working.

<instruqt-task id="net_ready"></instruqt-task>

## Fetch the nginx welcome page

A real two-container task. Pull the page from the `web` container and save it:

```sh
wget -qO /root/index.html http://web/
```

Then press **Check**. **Solve for me** runs the same command, so the solve path
can be exercised too.

<instruqt-task id="http_ok"></instruqt-task>
