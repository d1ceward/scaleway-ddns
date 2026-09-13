# scaleway-ddns (v2.3.1)
![GitHub Workflow Status (main)](https://github.com/d1ceward/scaleway-ddns/actions/workflows/ci.yml/badge.svg?branch=master)
[![Docker Pulls](https://img.shields.io/docker/pulls/d1ceward/scaleway-ddns.svg?logo=docker)](https://hub.docker.com/r/d1ceward/scaleway-ddns)
[![GHCR](https://img.shields.io/badge/GHCR-Available-blue?logo=github)](https://github.com/users/d1ceward/packages/container/package/scaleway-ddns)
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
      ENABLE_IPV6: false  # Optional, enables IPv6 address updates (default: true)
```

**Environment Variables:**
- `SCW_SECRET_KEY` (**required**): Your Scaleway API secret key.
- `IDLE_MINUTES`: Minutes between IP checks (default: 60, min: 1, max: 1440).
- `DOMAIN_LIST`: Comma-separated domains to update, see below.
- `ENABLE_IPV4`: Set to `true` or `false` to enable/disable IPv4 updates (default: `true`).
- `ENABLE_IPV6`: Set to `true` or `false` to enable/disable IPv6 updates (default: `true`).

**Domains and DNS zones:**

Scaleway stores every record inside a DNS zone, so each `DOMAIN_LIST` entry is split in two: the zone
to query, and the name of the record to update inside that zone. The zone is assumed to be the last
two labels of the entry, which covers `example.com` and anything below it. If your zone has more
labels, such as `example.co.uk`, write it explicitly after a colon.

| `DOMAIN_LIST` entry                | Zone queried    | Record updated |
| ---------------------------------- | --------------- | -------------- |
| `example.com`                      | `example.com`   | the zone apex  |
| `home.example.com`                 | `example.com`   | `home`         |
| `nas.home.example.com`             | `example.com`   | `nas.home`     |
| `home.example.co.uk:example.co.uk` | `example.co.uk` | `home`         |

The record has to exist beforehand: the service refreshes the address of an existing `A` or `AAAA`
record and never creates one, logging a warning when no record matches. An entry made of a single
label, or whose name does not belong to the zone written after the colon, is skipped with a warning
while the remaining entries are still updated.

---

### Linux

Download the executable:

```shell
wget --no-verbose -O scaleway-ddns https://github.com/d1ceward/scaleway-ddns/releases/download/v2.3.1/scaleway-ddns-linux-amd64
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

1. Install corresponding version of Crystal lang (cf: `.tool-versions` file)
2. Install Crystal dependencies with `shards install`
3. Build with `shards build`

The newly created binary should be at `bin/scaleway-ddns`

### Running tests

```shell
crystal spec
```

## Contributors

- [d1ceward](https://github.com/d1ceward) - creator and maintainer
