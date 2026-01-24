# aria2c Static Builds for macOS

Pre-built static aria2c binaries for macOS (Intel x86_64 and Apple Silicon arm64).

## Download

Download the latest release from the [Releases](../../releases) page.

## Features

- ✅ Fully static builds (no external dependencies)
- ✅ Universal binary support (both Intel and Apple Silicon)
- ✅ Built from official aria2 source
- ✅ Automated builds via GitHub Actions

## Usage

```bash
# Download
curl -LO https://github.com/YOUR_USERNAME/aria2c-macos-static/releases/latest/download/aria2c-universal

# Make executable
chmod +x aria2c-universal

# Run
./aria2c-universal --version
```

## Building Locally

### Prerequisites

```bash
brew install autoconf automake libtool pkg-config
```

### Build

```bash
# Build for current architecture
./build-static.sh

# Build for specific architecture
./build-static.sh arm64
./build-static.sh x86_64

# Create universal binary
./build-universal.sh
```

## License

aria2 is licensed under GPL-2.0. See https://github.com/aria2/aria2 for details.
