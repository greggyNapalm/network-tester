<p align="center">
  <a href="https://oack.io/">
    <img src="https://assets.oack.io/public/icons/icon-transparent.svg" alt="Oack" width="120" />
  </a>
</p>

<h3 align="center">network-tester</h3>

<p align="center">
  Distributed network checker agent for <a href="https://oack.io/">Oack</a> — the uptime &amp; performance monitoring platform.
</p>

---

## What is this?

`network-tester` is the checker agent that powers [Oack](https://oack.io/). It runs on your infrastructure (bare metal, VM, or Docker) and performs HTTP health checks against your monitors, reporting results back to the Oack platform.

## Quick Start

### Binary (Linux / macOS / FreeBSD)

```bash
curl -sSfL "https://raw.githubusercontent.com/greggyNapalm/network-tester/refs/heads/main/install-network-tester.sh" | bash
```

#### Installer options

| Flag | Default | Description |
|------|---------|-------------|
| `--version VERSION` | `latest` | Install a specific release |
| `--dir DIR` | `/usr/local/bin` | Installation directory |
| `--repo OWNER/REPO` | `greggyNapalm/network-tester` | GitHub repository |

### Docker

```bash
docker pull greggynapalm/network-tester:latest

mkdir -p $HOME/.net-checker-data
docker run --rm \
    -v $HOME/.net-checker-data:/data \
    greggynapalm/network-tester:latest \
    --token-db /data/tokens.db --mode shared
```

## Supported Platforms

| OS | Architecture |
|----|-------------|
| Linux | amd64, arm64 |
| macOS | amd64 (Intel), arm64 (Apple Silicon) |
| FreeBSD | amd64, arm64 |

## Learn More

- [Oack — Uptime & Performance Monitoring](https://oack.io/)
- [Report an issue](https://github.com/greggyNapalm/network-tester/issues)

## License

`network-tester` is **free to use** but **closed source**. Pre-built binaries are available on the [releases page](https://github.com/greggyNapalm/network-tester/releases).
