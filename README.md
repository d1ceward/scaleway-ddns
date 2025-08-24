# scaleway-ddns (v2.1.1)
![GitHub Workflow Status (main)](https://github.com/d1ceward/scaleway-ddns/actions/workflows/main.yml/badge.svg?branch=master)
[![Docker Pulls](https://img.shields.io/docker/pulls/d1ceward/scaleway-ddns.svg)](https://hub.docker.com/r/d1ceward/scaleway-ddns)
[![GHCR Pulls](https://img.shields.io/badge/dynamic/json?color=blue&label=GHCR%20Pulls&query=downloads&url=https://ghcr.io/v2/d1ceward/scaleway-ddns/stats/pulls&logo=github)](https://github.com/users/d1ceward/packages/container/package/scaleway-ddns)
[![GitHub issues](https://img.shields.io/github/issues/d1ceward/scaleway-ddns)](https://github.com/d1ceward/scaleway-ddns/issues)
[![GitHub license](https://img.shields.io/github/license/d1ceward/scaleway-ddns)](https://github.com/d1ceward/scaleway-ddns/blob/master/LICENSE)

Simple Scaleway dynamic DNS service by API written in Crystal.

:rocket: Suggestions for new improvements are welcome in the issue tracker.

## Installation and Usage

### Docker

You can run `scaleway-ddns` using Docker or Docker Compose. Replace example values with your actual configuration.

#### Docker Hub

Run directly from Docker Hub:

```shell
docker run -d \
  --name scaleway-ddns \
  -e SCW_SECRET_KEY="your-scaleway-secret-key" \
  -e IDLE_MINUTES="10" \
  -e DOMAIN_LIST="myfirstdomain.com,anotherone.com" \
  -e ENABLE_IPV4="true" \
  -e ENABLE_IPV6="false" \
  d1ceward/scaleway-ddns:latest
```

#### GitHub Packages

Run from GitHub Container Registry:

```shell
docker run -d \
  --name scaleway-ddns \
  -e SCW_SECRET_KEY="your-scaleway-secret-key" \
  -e IDLE_MINUTES="10" \
  -e DOMAIN_LIST="myfirstdomain.com,anotherone.com" \
  -e ENABLE_IPV4="true" \
  -e ENABLE_IPV6="false" \
  ghcr.io/d1ceward/scaleway-ddns:latest
```

#### Docker Compose

Recommended for multi-container setups or easier management:

```yaml
services:
  scaleway_ddns:
    image: d1ceward/scaleway-ddns:latest # Use Docker Hub image
    # Or use GitHub Packages:
    # image: ghcr.io/d1ceward/scaleway-ddns:latest
    restart: unless-stopped
    environment:
      SCW_SECRET_KEY: your-scaleway-secret-key
      IDLE_MINUTES: 10
      DOMAIN_LIST: myfirstdomain.com,anotherone.com
      ENABLE_IPV4: true   # Optional, enables IPv4 address updates (default: true)
      ENABLE_IPV6: false  # Optional, enables IPv6 address updates (default: false)
```

**Environment Variables:**
- `SCW_SECRET_KEY` (**required**): Your Scaleway API secret key.
- `IDLE_MINUTES`: Minutes between IP checks (default: 60).
- `DOMAIN_LIST`: Comma-separated domains to update.
- `ENABLE_IPV4`: Set to `true` or `false` to enable/disable IPv4 updates.
- `ENABLE_IPV6`: Set to `true` or `false` to enable/disable IPv6 updates.

---

### Linux

Download the executable:

```shell
wget --no-verbose -O scaleway-ddns https://github.com/d1ceward/scaleway-ddns/releases/download/v2.1.1/scaleway-ddns-linux-amd64
```

Make it executable:

```shell
chmod +x scaleway-ddns
```

Run the service:

```shell
./scaleway-ddns run
```

Documentation available here : https://d1ceward.github.io/scaleway-ddns/

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/d1ceward/scaleway-ddns. By contributing you agree to abide by the Code of Merit.

1. Fork it (<https://github.com/d1ceward/scaleway-ddns/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Development building and running

1. Install corresponding version of Crystal lang (cf: `.crystal-version` file)
2. Install Crystal dependencies with `shards install`
3. Build with `shards build`

The newly created binary should be at `bin/scaleway-ddns`

### Running tests

```shell
crystal spec
```

## Environment Variables

- `SCW_SECRET_KEY` (**required**): Secret key from Scaleway required for IP update.
- `IDLE_MINUTES`: Number of minutes of inactivity between IP checks (default: 60, min: 1, max: 1440).
- `DOMAIN_LIST`: Comma-separated list of domains to update (e.g., `example.com,another.com`).
- `ENABLE_IPV4`: Enables IPv4 address updates. Set to `false` to disable (default: `true`).
- `ENABLE_IPV6`: Enables IPv6 address updates. Set to `true` to enable (default: `false`).

## Contributors

- [d1ceward](https://github.com/d1ceward) - creator and maintainer
