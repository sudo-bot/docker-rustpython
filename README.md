# A docker rustpython image

This is a Docker image for the [RustPython](https://github.com/RustPython/RustPython#readme) project.
It had the default feature flags + `freeze-stdlib`.

You can find it on [Docker Hub](https://hub.docker.com/r/botsudo/docker-rustpython) and the sources on [GitHub](https://github.com/sudo-bot/docker-rustpython).

## Pull it

```sh
docker pull botsudo/docker-rustpython:latest
```

## Example usage

```sh
# A test script
echo -e "import json\nprint(json.dumps([{'server': [{'tls': False}]}]))" > test.py
# Will print: [{"server": [{"tls": false}]}]
docker run -v $PWD/test.py:/app/test.py:ro --rm botsudo/docker-rustpython:latest /app/test.py
# See help
docker run --rm botsudo/docker-rustpython:latest --help
```

## Is my architecture supported ?

We support as much as possible, the list is:

- `linux/386`
- `linux/amd64`
- `linux/arm/v6`
- `linux/arm/v7`
- `linux/arm64/v8`
- `linux/ppc64le`

For `linux/s390x`, it needs fixing:
- See: https://github.com/nix-rust/nix/issues/1968
- See: https://github.com/nix-rust/nix/pull/1835
