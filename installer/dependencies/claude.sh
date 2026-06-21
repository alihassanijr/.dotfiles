#!/usr/bin/env bash
# Claude Code
# The official installer downloads a platform binary then runs `claude install`,
# which only copies that binary into ~/.local/bin. We skip that and drop the
# pinned binary straight into $LOCALDIR/bin ourselves, so it honors PROGRAMS_PATH.

CLAUDE_VERSION="2.1.178"

install_claude() {
    echo "Downloading Claude Code $CLAUDE_VERSION"

    # Detect platform the same way the official installer does.
    local os arch platform
    case "$(uname -s)" in
        Darwin) os="darwin" ;;
        Linux)  os="linux" ;;
        *) echo "Claude Code: unsupported OS $(uname -s)."; return 1 ;;
    esac
    case "$(uname -m)" in
        x86_64|amd64)  arch="x64" ;;
        arm64|aarch64) arch="arm64" ;;
        *) echo "Claude Code: unsupported arch $(uname -m)."; return 1 ;;
    esac
    # Rosetta 2: an x64 shell on an arm64 Mac should grab the native arm64 binary.
    if [ "$os" = "darwin" ] && [ "$arch" = "x64" ] && \
       [ "$(sysctl -n sysctl.proc_translated 2>/dev/null)" = "1" ]; then
        arch="arm64"
    fi
    # musl libc on Linux gets a different build.
    if [ "$os" = "linux" ] && \
       { [ -f /lib/libc.musl-x86_64.so.1 ] || [ -f /lib/libc.musl-aarch64.so.1 ] || ldd /bin/ls 2>&1 | grep -q musl; }; then
        platform="linux-${arch}-musl"
    else
        platform="${os}-${arch}"
    fi

    local PACKAGEURL="https://downloads.claude.ai/claude-code-releases/$CLAUDE_VERSION/$platform/claude"

    mkdir -p $LOCALDIR/bin
    fetch_package "$LOCALDIR/bin/claude" "$PACKAGEURL" && \
        chmod +x "$LOCALDIR/bin/claude"

    if [ $? -ne 0 ]; then
        echo "Claude Code install failed."
        rm -f "$LOCALDIR/bin/claude"
        return 1
    fi
}
