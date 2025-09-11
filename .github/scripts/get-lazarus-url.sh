#!/bin/bash

# Script to fetch the latest direct Windows 32-bit Lazarus installer URL from SourceForge
# This bypasses the timer/redirect page by using multiple methods to find the latest version

set -e

echo "Fetching latest Lazarus release information from SourceForge..."

# Function to test if a URL is accessible
test_url() {
    local url="$1"
    local timeout="${2:-10}"
    curl -s -o /dev/null -w "%{http_code}" --connect-timeout "$timeout" --max-time "$timeout" -L --max-redirs 0 "$url" 2>/dev/null || echo "000"
}

# Method 1: Try to parse SourceForge directory listing for latest version
echo "Method 1: Attempting to fetch via SourceForge directory listing..."
DIRECTORY_URL="https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2032%20bits/"

# Try to get the directory page and extract version numbers
VERSION_LIST=$(curl -s --connect-timeout 15 "$DIRECTORY_URL" 2>/dev/null | \
    grep -o 'Lazarus%20[0-9][^"]*' | \
    sed 's/Lazarus%20//' | \
    sort -V | \
    tail -5)  # Get the 5 most recent versions

if [ -n "$VERSION_LIST" ]; then
    echo "Found potential versions from directory listing:"
    echo "$VERSION_LIST"
    
    # Test each version from newest to oldest
    for VERSION in $(echo "$VERSION_LIST" | tac); do
        # Try different FPC version combinations that are commonly used
        for FPC_VERSION in "3.2.2" "3.2.0" "3.0.4"; do
            POTENTIAL_URL="https://downloads.sourceforge.net/project/lazarus/Lazarus%20Windows%2032%20bits/Lazarus%20$VERSION/lazarus-$VERSION-fpc-$FPC_VERSION-win32.exe"
            echo "Testing: $POTENTIAL_URL"
            
            STATUS=$(test_url "$POTENTIAL_URL" 15)
            if [ "$STATUS" = "200" ] || [ "$STATUS" = "302" ]; then
                DIRECT_URL="$POTENTIAL_URL"
                echo "✓ Found working version: $VERSION with FPC $FPC_VERSION"
                break 2
            fi
        done
    done
fi

# Method 2: Fallback to known recent version patterns
if [ -z "$DIRECT_URL" ]; then
    echo "Method 2: Directory listing failed, trying known version patterns..."
    
    # List of recent Lazarus versions to try (update this list periodically)
    # Format: version:fpc_version
    KNOWN_VERSIONS="
        2.2.6:3.2.2
        2.2.4:3.2.2
        2.2.2:3.2.2
        2.2.0:3.2.2
        2.0.12:3.2.0
        2.0.10:3.0.4
        3.0:3.2.2
        3.2:3.2.2
        3.4:3.2.2
    "
    
    for VERSION_FPC in $KNOWN_VERSIONS; do
        VERSION=$(echo "$VERSION_FPC" | cut -d: -f1)
        FPC_VERSION=$(echo "$VERSION_FPC" | cut -d: -f2)
        
        POTENTIAL_URL="https://downloads.sourceforge.net/project/lazarus/Lazarus%20Windows%2032%20bits/Lazarus%20$VERSION/lazarus-$VERSION-fpc-$FPC_VERSION-win32.exe"
        echo "Testing known version $VERSION (FPC $FPC_VERSION)..."
        
        STATUS=$(test_url "$POTENTIAL_URL" 10)
        if [ "$STATUS" = "200" ] || [ "$STATUS" = "302" ]; then
            DIRECT_URL="$POTENTIAL_URL"
            echo "✓ Found working known version: $VERSION"
            break
        fi
    done
fi

# Method 3: Try alternative URL patterns
if [ -z "$DIRECT_URL" ]; then
    echo "Method 3: Trying alternative URL patterns..."
    
    # Some releases might have different naming conventions
    for VERSION in "2.2.6" "2.2.4" "2.2.2"; do
        # Try pattern without FPC version in filename
        ALT_URL="https://downloads.sourceforge.net/project/lazarus/Lazarus%20Windows%2032%20bits/Lazarus%20$VERSION/lazarus-$VERSION-win32.exe"
        echo "Testing alternative pattern: $ALT_URL"
        
        STATUS=$(test_url "$ALT_URL" 10)
        if [ "$STATUS" = "200" ] || [ "$STATUS" = "302" ]; then
            DIRECT_URL="$ALT_URL"
            echo "✓ Found working alternative version: $VERSION"
            break
        fi
    done
fi

# Final validation and output
if [ -z "$DIRECT_URL" ]; then
    echo "Error: Could not determine latest Lazarus download URL"
    echo "All methods failed to find an accessible Lazarus installer"
    echo "Please check SourceForge manually: https://sourceforge.net/projects/lazarus/files/Lazarus%20Windows%2032%20bits/"
    echo ""
    echo "This might be due to:"
    echo "1. SourceForge being temporarily unavailable"
    echo "2. Changes in SourceForge URL structure"
    echo "3. Network connectivity issues"
    echo ""
    echo "The workflow will use the fallback version specified in the GitHub Actions workflow."
    exit 1
fi

echo "=========================================="
echo "✓ Successfully found Lazarus installer URL"
echo "URL: $DIRECT_URL"
echo "=========================================="

# Final verification with a longer timeout
echo "Performing final verification..."
FINAL_STATUS=$(test_url "$DIRECT_URL" 20)

if [ "$FINAL_STATUS" = "200" ] || [ "$FINAL_STATUS" = "302" ]; then
    echo "✓ URL verified successfully (HTTP $FINAL_STATUS)"
    
    # Set GitHub Actions output if running in CI
    if [ -n "$GITHUB_OUTPUT" ]; then
        echo "LAZARUS_DOWNLOAD_URL=$DIRECT_URL" >> $GITHUB_OUTPUT
        echo "✓ GitHub Actions output variable set"
    fi
    
    # Output the URL for capture by calling scripts
    echo "$DIRECT_URL"
else
    echo "Error: Final URL verification failed (HTTP $FINAL_STATUS)"
    echo "URL may be temporarily unavailable"
    exit 1
fi