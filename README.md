# setup-proxy-cache

This composite action is intended to be used on NVIDIA Self-Hosted runners.

It will setup a proxy as a cache for different package managers.

Currently this action supports the following package managers:

- `pip`
- `conda`
- `pypi-anaconda`
- `apt`
- Maven Central

## Inputs

This action supports the following inputs

| Input                  | Type   | Default | Description                                                                          |
| ---------------------- | ------ | ------- | ------------------------------------------------------------------------------------ |
| `enable-pip`           | `bool` | `true`  | Setup `pip` to use the proxy as a cache                                              |
| `enable-conda`         | `bool` | `true`  | Setup `conda` to use the proxy as a cache                                            |
| `enable-pypi-anaconda` | `bool` | `true`  | Export the pypi-anaconda proxy cache URL to `NV_GHA_RUNNERS_PYPI_ANACONDA_CACHE_URL` |
| `enable-apt`           | `bool` | `false` | Setup `apt` to use the proxy as a cache                                              |
| `enable-maven-central` | `bool` | `false` | Configure Maven to use the Maven Central proxy cache                                |
| `maven-central-cache-url` | `string` | none | Maven Central proxy-cache URL; required when Maven support is enabled               |

## Example

```yaml
name: Use proxy cache

on:
  push:
    branches:
      - main

jobs:
  example:
    runs-on: linux-amd64-cpu4
    container:
      image: rapidsai/ci-conda:cuda11.8.0-ubuntu22.04-py3.10
    steps:
      - name: Setup proxy cache
        uses: nv-gha-runners/setup-proxy-cache@main
      - name: Install rapids with conda
        run: conda install rapids=24.10
```

### Maven Central

Maven support is opt-in while the cache service is rolled out. The action writes a standard
`~/.m2/settings.xml` that mirrors only the repository named `central`, and exposes the selected
endpoint as `NV_GHA_RUNNERS_MAVEN_CENTRAL_CACHE_URL`. The URL is explicit because the service
endpoint is supplied by the deployment rather than defined in this repository.

The setup step never overwrites an existing Maven settings file. Run it before Maven is used on
a clean ephemeral runner, or merge the mirror into your repository's existing settings when the
workflow needs custom repositories, credentials, or other Maven configuration.

```yaml
- name: Setup Maven Central proxy cache
  uses: nv-gha-runners/setup-proxy-cache@main
  with:
    enable-pip: false
    enable-conda: false
    enable-pypi-anaconda: false
    enable-maven-central: true
    maven-central-cache-url: ${{ vars.NV_GHA_RUNNERS_MAVEN_CENTRAL_CACHE_URL }}

- name: Resolve dependencies through the cache
  run: mvn --batch-mode dependency:go-offline
```
