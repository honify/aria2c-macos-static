#!/bin/bash
# Create universal binary from arm64 and x86_64 builds

set -e

echo "🔗 Creating universal binary..."

if [ ! -f "aria2c-arm64" ]; then
    echo "❌ aria2c-arm64 not found. Run: ./build-static.sh arm64"
    exit 1
fi

if [ ! -f "aria2c-x86_64" ]; then
    echo "❌ aria2c-x86_64 not found. Run: ./build-static.sh x86_64"
    exit 1
fi

# Create universal binary
lipo -create \
    -output aria2c-universal \
    aria2c-arm64 \
    aria2c-x86_64

# Make executable
chmod +x aria2c-universal

# Verify
echo ""
echo "✅ Universal binary created!"
echo ""
file aria2c-universal
echo ""
lipo -info aria2c-universal
echo ""

# Test both architectures
echo "🧪 Testing arm64..."
arch -arm64 ./aria2c-universal --version | head -1

echo ""
echo "🧪 Testing x86_64..."
arch -x86_64 ./aria2c-universal --version | head -1

echo ""
echo "📋 Output: $(pwd)/aria2c-universal"
