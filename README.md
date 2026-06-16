# Trigger AWX action
A GitHub Action that triggers execution of a named template on an [AWX] server.
In addition to running the template you can inject a value for a template
variable. If no `template-var` is provided the template is launched without
any extra variables.

This action essentially allows you to run templates in a remote
AWX server, given a template name, and template user credentials.

This action is typically used after you've built and published a container
image, and you then want to trigger an AWX template that would deploy that
image, say to a Kubernetes cluster.

>   Version 1 of the Action used the legacy [ansible-tower-cli] package
    to trigger the template. Version 2 uses the [awxkit] package.
    Version 4 adds optional template variables and values,
    and uses Python 3.14 and the `awxkit` published by `alanbchristie`.

>   Remember that Job Templates that you expect to run on AWX must be
    executable by the user you provide.

>   Any AWX Job Template you execute should have the **PROMPT ON LAUNCH**
    option selected in the **EXTRA VARIABLES** section. If not, variables
    passed-in via the underlying tower-cli command will be ignored.

## Inputs

### `template`
**Required** The name of the AWX template to run

### `template-host`
**Required** The hostname of the AWX server

### `template-user`
**Required** The username of a user that can execute the template

### `template-user-password`
**Required** The template user's password

### `template-var`
A template variable. If omitted, the template is launched without any extra variables

### `template-var-value`
A value for the template variable

## Example usage
Here we trigger the AWX template **My Template**, where the user is
expected to have **Execute** permissions for the template.

```yaml
uses: informaticsmatters/trigger-awx-action@v3
with:
  template: My Template
  template-host: https://example.com
  template-user: ${{ secrets.AWX_USER }}
  template-user-password: ${{ secrets.AWX_USER_PASSWORD }}
```

You can also define the value of a template variable. For example,
here we set the variable **ma_image_tag** to **latest** when triggering
**My Template**: -

```yaml
uses: informaticsmatters/trigger-awx-action@v3
with:
  template: My Template
  template-host: https://example.com
  template-user: ${{ secrets.AWX_USER }}
  template-user-password: ${{ secrets.AWX_USER_PASSWORD }}
  template-var: ma_image_tag
  template-var-value: latest
```

>   As AWX might be considered an **Environment** you'd typically store your
    secrets in a GitHub **Environment** rather than use **Repository** or
    **Organisation** secrets.

---

[ansible-tower-cli]: https://pypi.org/project/ansible-tower-cli/
[awx]: https://github.com/ansible/awx
[awxkit]: https://pypi.org/project/awxkit/
