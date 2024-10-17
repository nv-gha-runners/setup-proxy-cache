# setup-proxy-cache

This composite action is intended to be used on NVIDIA Self-Hosted runners.

It will setup a proxy as a cache for different package managers.

Currently this action supports the following package managers:
  - `pip`
  - `conda`

## Inputs

This action supports the following inputs

| Input          | Type   | Default | Description                               |
| -------------- | ------ | ------- | ----------------------------------------- |
| `enable-pip`   | `bool` | `true`  | Setup `pip` to use the proxy as a cache   |
| `enable-conda` | `bool` | `true`  | Setup `conda` to use the proxy as a cache |

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
