# network-tester
Binary releases of the TT network-tester tool

To launch as binary on Linux/MacOS/FreeBSD
```
curl -sSfL "https://raw.githubusercontent.com/greggyNapalm/network-tester/refs/heads/main/install-network-tester.sh" | bash
```

To launch in Docker
```
docker pull greggynapalm/network-tester:latest

mkdir $HOME/.net-checker-data
docker run --rm \
    -v $HOME/.net-checker-data:/data \
    greggynapalm/network-tester:latest \
    --token-db /data/tokens.db --mode shared
```
