#!/bin/bash
# setup-claude-plugins.sh — 一鍵安裝團隊 Claude Code 插件
#
# 用法: bash setup-claude-plugins.sh [--all | --core | --lsp]
#   --core  只安裝核心插件（預設）
#   --lsp   只安裝 LSP 插件
#   --all   安裝全部

set -euo pipefail

CORE_PLUGINS=(
  superpowers
  commit-commands
  code-review
  feature-dev
  pr-review-toolkit
  code-simplifier
  claude-md-management
  claude-code-setup
  context7
  skill-creator
  coderabbit
  sourcegraph
  frontend-design
  figma
  vercel
  agent-sdk-dev
  supabase
  serena
)

LSP_PLUGINS=(
  typescript-lsp
  pyright-lsp
  gopls-lsp
  jdtls-lsp
  kotlin-lsp
  rust-analyzer-lsp
  csharp-lsp
  clangd-lsp
  swift-lsp
  lua-lsp
)

install_plugins() {
  local plugins=("$@")
  local total=${#plugins[@]}
  local i=0
  for p in "${plugins[@]}"; do
    i=$((i + 1))
    printf "[%2d/%d] Installing %s..." "$i" "$total" "$p"
    if claude plugins add "$p" >/dev/null 2>&1; then
      echo " done"
    else
      echo " FAILED"
    fi
  done
}

MODE="${1:---core}"

case "$MODE" in
  --all)
    echo "=== Installing ALL plugins (${#CORE_PLUGINS[@]} core + ${#LSP_PLUGINS[@]} LSP) ==="
    install_plugins "${CORE_PLUGINS[@]}"
    install_plugins "${LSP_PLUGINS[@]}"
    ;;
  --lsp)
    echo "=== Installing LSP plugins (${#LSP_PLUGINS[@]}) ==="
    install_plugins "${LSP_PLUGINS[@]}"
    ;;
  --core|*)
    echo "=== Installing core plugins (${#CORE_PLUGINS[@]}) ==="
    install_plugins "${CORE_PLUGINS[@]}"
    ;;
esac

echo ""
echo "Done! Run 'claude config set effortLevel high' for enhanced features."
echo "Restart Claude Code to activate all plugins."
