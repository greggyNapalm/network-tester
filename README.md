<p align="center">
  <a href="https://oack.io/">
    <img src="https://assets.oack.io/public/icons/icon-transparent.svg" alt="Oack" width="120" />
  </a>
</p>

<h3 align="center">network-tester</h3>

<p align="center">
  Distributed network checker agent for <a href="https://oack.io/">Oack</a> — the uptime &amp; performance monitoring platform.<br/>
  <a href="https://oack.io/docs">Documentation</a> · <a href="https://github.com/oack-io/network-tester/releases">Releases</a> · <a href="https://github.com/oack-io/homebrew-tap">Homebrew Tap</a>
</p>

---

## What is this?

`network-tester` is the checker agent that powers [Oack](https://oack.io/). It runs on your infrastructure (bare metal, VM, or Docker) and performs HTTP health checks against your monitors, reporting results back to the Oack platform.

### Features

- **HTTP probing** — per-phase latency breakdown (DNS, TCP connect, TLS handshake, send, wait, receive)
- **TCP_INFO metrics** — kernel-level RTT, retransmits, congestion window (Linux)
- **Traceroute** — ICMP traceroute with automatic UDP fallback, per-hop RTT and loss stats (Linux, requires `CAP_NET_RAW`)
- **Pcap capture** — optional per-probe packet capture in debug mode (requires `-tags pcap` build, CGO, libpcap)
- **Real-time streaming** — results sent over WebSocket with automatic reconnection
- **Offline buffer** — SQLite ring buffer stores probes when API is unreachable, replays on reconnect
- **OAuth device flow** — secure authentication with local token cache

## Install

### Homebrew (macOS / Linux)

```bash
brew tap oack-io/tap
brew install network-tester
```

### Shell script

```bash
curl -sSfL "https://raw.githubusercontent.com/oack-io/network-tester/refs/heads/main/install-network-tester.sh" | bash
```

#### Installer options

| Flag | Default | Description |
|------|---------|-------------|
| `--version VERSION` | `latest` | Install a specific release |
| `--dir DIR` | `/usr/local/bin` | Installation directory |

### Docker

```bash
docker pull greggynapalm/network-tester:latest

mkdir -p $HOME/.net-checker-data
docker run --rm \
    --cap-add NET_RAW \
    -v $HOME/.net-checker-data:/data \
    greggynapalm/network-tester:latest \
    --token-db /data/tokens.db --mode shared
```

### Manual download

Download the latest release from the [Releases](https://github.com/oack-io/network-tester/releases) page.

| OS | Arch | Download |
|----|------|----------|
| Linux | x86_64 | `network-tester_*_linux_amd64.tar.gz` |
| Linux | ARM64 | `network-tester_*_linux_arm64.tar.gz` |
| macOS | Apple Silicon | `network-tester_*_darwin_arm64.tar.gz` |
| macOS | Intel | `network-tester_*_darwin_amd64.tar.gz` |
| FreeBSD | x86_64 | `network-tester_*_freebsd_amd64.tar.gz` |
| FreeBSD | ARM64 | `network-tester_*_freebsd_arm64.tar.gz` |

## Linux capabilities

Traceroute requires raw ICMP sockets. Grant `CAP_NET_RAW` via one of:

**systemd (recommended):**
```ini
[Service]
AmbientCapabilities=CAP_NET_RAW
```

**setcap on the binary:**
```bash
sudo setcap cap_net_raw+ep /usr/local/bin/network-tester
```

**Docker:**
```bash
docker run --cap-add NET_RAW ...
```

Without `CAP_NET_RAW`, the agent still runs HTTP probes normally — traceroute is silently skipped.

The agent logs its capabilities at startup:
```json
{"msg":"network-tester","cap_net_raw":true,"pcap":false,"version":"0.7.1"}
```

## Supported Platforms

| OS | Architecture | Traceroute |
|----|-------------|------------|
| Linux | amd64, arm64 | ICMP + UDP fallback |
| macOS | amd64 (Intel), arm64 (Apple Silicon) | not supported |
| FreeBSD | amd64, arm64 | not supported |

## Documentation

Full platform documentation is available at **[oack.io/docs](https://oack.io/docs)**.

## Learn More

- [Oack — Uptime & Performance Monitoring](https://oack.io/)
- [oackctl — CLI for the Oack API](https://github.com/oack-io/oackctl)
- [Report an issue](https://github.com/oack-io/network-tester/issues)

## License

`network-tester` is **free to use** but **closed source**. Pre-built binaries are available on the [releases page](https://github.com/oack-io/network-tester/releases).
