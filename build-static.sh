#!/bin/bash
# Build statically-linked aria2c for macOS

set -e

ARIA2_VERSION="${ARIA2_VERSION:-1.37.0}"
ARCH="${1:-$(uname -m)}"
ROOT_DIR="$(pwd)"
BUILD_DIR="${ROOT_DIR}/build-${ARCH}"
INSTALL_DIR="${ROOT_DIR}/install-${ARCH}"

echo "🔨 Building aria2c ${ARIA2_VERSION} for ${ARCH}"
echo "   Root directory: ${ROOT_DIR}"
echo "   Build directory: ${BUILD_DIR}"
echo "   Install directory: ${INSTALL_DIR}"

# Create directories
mkdir -p "${BUILD_DIR}"
mkdir -p "${INSTALL_DIR}"

# Download source if not exists
if [ ! -f "aria2-${ARIA2_VERSION}.tar.xz" ]; then
    echo "📦 Downloading aria2 ${ARIA2_VERSION}..."
    curl -LO "https://github.com/aria2/aria2/releases/download/release-${ARIA2_VERSION}/aria2-${ARIA2_VERSION}.tar.xz"
fi

# Extract
echo "📂 Extracting source..."
cd "${BUILD_DIR}"
tar xf "../aria2-${ARIA2_VERSION}.tar.xz"
cd "aria2-${ARIA2_VERSION}"

# Configure flags for static build
export CC="clang"
export CXX="clang++"

# Only set -arch flag when cross-compiling
NATIVE_ARCH=$(uname -m)
if [ "${ARCH}" = "${NATIVE_ARCH}" ]; then
    export CFLAGS="-O2 -mmacosx-version-min=10.13"
    export CXXFLAGS="-O2 -mmacosx-version-min=10.13 -std=c++11"
    export LDFLAGS=""
else
    export CFLAGS="-arch ${ARCH} -O2 -mmacosx-version-min=10.13"
    export CXXFLAGS="-arch ${ARCH} -O2 -mmacosx-version-min=10.13 -std=c++11"
    export LDFLAGS="-arch ${ARCH}"
fi

echo "   Native arch: ${NATIVE_ARCH}, Target arch: ${ARCH}"
echo "   CFLAGS: ${CFLAGS}"

# For completely static build, we need to disable features that require external libs
echo "⚙️  Configuring..."
./configure \
    --prefix="${INSTALL_DIR}" \
    --enable-static \
    --disable-shared \
    --without-libxml2 \
    --without-libexpat \
    --without-sqlite3 \
    --without-libz \
    --without-libcares \
    --without-libssh2 \
    --without-gnutls \
    --without-openssl \
    --without-libnettle \
    --without-libgmp \
    --without-libgcrypt \
    --disable-bittorrent \
    --disable-metalink \
    --disable-websocket \
    --disable-nls \
    CC="${CC}" \
    CXX="${CXX}" \
    CFLAGS="${CFLAGS}" \
    CXXFLAGS="${CXXFLAGS}" \
    LDFLAGS="${LDFLAGS}"

# Build
echo "🔧 Building..."
make -j$(sysctl -n hw.ncpu)

# Install
echo "📦 Installing..."
make install

# Verify
echo ""
echo "✅ Build complete!"
echo "   Binary: ${INSTALL_DIR}/bin/aria2c"
echo ""

# Test the binary
echo "🧪 Testing binary..."
file "${INSTALL_DIR}/bin/aria2c"
echo ""
otool -L "${INSTALL_DIR}/bin/aria2c"
echo ""
"${INSTALL_DIR}/bin/aria2c" --version | head -1

# Copy to root for convenience
cp "${INSTALL_DIR}/bin/aria2c" "${ROOT_DIR}/aria2c-${ARCH}"
echo ""
echo "📋 Output: ${ROOT_DIR}/aria2c-${ARCH}"
