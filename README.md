# Trigger AWX action
A GitHub Action that triggers execution of a named template on an [AWX] server.
In addition to running the template you can inject a value for a template
variable. If unused, the variable 'image_tag' is set to the value 'latest'.

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
```yaml
uses: informaticsmatters/trigger-awx-action@v1
with:
  template: My Template
  template-host: https://example.com
  template-user: ${{ secrets.AWX_TEMPLATE_USER }}
  template-user-password: ${{ secrets.AWX_TEMPLATE_USER_PASSWORD }}
```

[awx]: https://github.com/ansible/awx
