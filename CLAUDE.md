# CLAUDE.md

## Purpose

This repository is a Docker-based GitHub Action (`informaticsmatters/trigger-awx-action`)
that launches a named Job Template on a remote [AWX] server and waits for it to
finish. It is typically used at the end of a CI pipeline — after a container image
has been built and published — to trigger an AWX template that deploys that image
(for example, to a Kubernetes cluster).

## How it works

The Action runs as a Docker container. The flow is:

1. `action.yaml` declares the Action's inputs and passes them, in order, as
   positional `args` to the container entrypoint.
2. `Dockerfile` builds from `python:3.14.6` and `pip install`s the dependencies
   from `requirements.txt` (currently `alanbchristie-awxkit >= 1.0.2`, a fork of
   `awxkit` that still provides the `awx` CLI). The entrypoint is `entrypoint.sh`.
3. `entrypoint.sh` maps the six positional arguments to variables and exports the
   AWX connection details as the environment variables `awxkit` expects
   (`CONTROLLER_HOST`, `CONTROLLER_USERNAME`, `CONTROLLER_PASSWORD`). It then
   launches the template, **only** injecting an extra variable when `template-var`
   is non-empty:

   ```sh
   if [ -n "${TEMPLATE_VAR}" ]; then
     EXTRA_VARS={\"${TEMPLATE_VAR}\":\"${TEMPLATE_VAR_VALUE}\"}
     awx job_templates launch --monitor -e ${EXTRA_VARS} "${TEMPLATE}" > /dev/null
   else
     awx job_templates launch --monitor "${TEMPLATE}" > /dev/null
   fi
   ```

   `--monitor` makes the command block until the AWX job completes. Standard output
   is redirected to `/dev/null` because the AWX job output can contain sensitive
   variables that must not leak into the GitHub Action log.

## Inputs (defined in `action.yaml`)

| Input | Required | Default | Notes |
|-------|----------|---------|-------|
| `template` | yes | — | Name of the AWX Job Template to run |
| `template-host` | yes | — | AWX server URL, e.g. `https://example.com` |
| `template-user` | yes | — | A user permitted to execute the template |
| `template-user-password` | yes | — | The user's password |
| `template-var` | no | _(none)_ | Name of a single template variable to inject. If omitted, the template is launched with no extra variables |
| `template-var-value` | no | _(none)_ | Value for that template variable |

The argument order in `action.yaml` (`template`, `template-host`, `template-user`,
`template-user-password`, `template-var`, `template-var-value`) must stay in sync
with the positional `$1`..`$6` assignments in `entrypoint.sh`.

## AWX requirements

- The supplied user must have **Execute** permission on the Job Template.
- The Job Template must have **PROMPT ON LAUNCH** enabled in its **EXTRA VARIABLES**
  section, otherwise the injected variable is ignored.

## Versions / branches

- **v1** used the legacy `ansible-tower-cli` package.
- **v2** and **v3** use `awxkit` (the `awx` CLI).
- **v4** uses the `alanbchristie-awxkit` fork (still the `awx` CLI).
- Released versions are referenced by tag in workflows, e.g.
  `informaticsmatters/trigger-awx-action@v3`.

## Conventions when changing this Action

- Only one template variable can currently be injected per run, and it is optional —
  when `template-var` is empty the template is launched with no extra variables.
- Never echo the AWX job output to stdout — keep the `> /dev/null` redirect so
  secrets are not exposed in the Action log.
- If you add or reorder inputs, update **both** `action.yaml` (the `args` list) and
  the positional variable assignments in `entrypoint.sh`.

[awx]: https://github.com/ansible/awx
