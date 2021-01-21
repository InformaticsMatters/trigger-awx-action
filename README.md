# Trigger AWX action
A GitHub Action that triggers execution of a named template on an [AWX] server.
In addition to running the template you can inject a value for a template
variable. If unused, the variable `image_tag` is set to the value `latest`.

This action essentially allows you to run templates in a remote
AWX server, given a template name, and template user credentials.

This action is typically used after you've built and published a container
image, and you then want to trigger an AWX template that would deploy that
image, say to a Kubernetes cluster.

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
A template variable, default `image_tag`

### `template-var-value`
A value for the template variable, default `latest`

## Example usage
Here we trigger the AWX template **My Template**, expected to be
on the server **https://example.com**. The user must have **Execute**
permissions for the chosen template.

```yaml
uses: informaticsmatters/trigger-awx-action@v1
with:
  template: My Template
  template-host: https://example.com
  template-user: ${{ secrets.AWX_USER }}
  template-user-password: ${{ secrets.AWX_USER_PASSWORD }}
```

You can also define the value of a template variable. For example,
here we set the variable `ma_image_tag` to `latest` when triggering
**My Template**: -

```yaml
uses: informaticsmatters/trigger-awx-action@v1
with:
  template: My Template
  template-host: https://example.com
  template-user: ${{ secrets.AWX_USER }}
  template-user-password: ${{ secrets.AWX_USER_PASSWORD }}
  template-var: ma_image_tag
  template-var-value: latest
```

As AWX might be considered an **Environment** you'd typically store your
secrets in a GitHub **Environment** rather than use **Repository** or
**Organisation** secrets.

---

[awx]: https://github.com/ansible/awx
