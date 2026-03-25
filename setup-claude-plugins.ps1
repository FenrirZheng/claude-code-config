# setup-claude-plugins.ps1 — 一鍵安裝團隊 Claude Code 插件
#
# 用法: .\setup-claude-plugins.ps1 [-Mode all|core|lsp]
#   core  只安裝核心插件（預設）
#   lsp   只安裝 LSP 插件
#   all   安裝全部

param(
    [ValidateSet("all", "core", "lsp")]
    [string]$Mode = "core"
)

$CorePlugins = @(
    "superpowers"
    "commit-commands"
    "code-review"
    "feature-dev"
    "pr-review-toolkit"
    "code-simplifier"
    "claude-md-management"
    "claude-code-setup"
    "context7"
    "skill-creator"
    "coderabbit"
    "sourcegraph"
    "frontend-design"
    "figma"
    "vercel"
    "agent-sdk-dev"
    "supabase"
    "serena"
)

$LspPlugins = @(
    "typescript-lsp"
    "pyright-lsp"
    "gopls-lsp"
    "jdtls-lsp"
    "kotlin-lsp"
    "rust-analyzer-lsp"
    "csharp-lsp"
    "clangd-lsp"
    "swift-lsp"
    "lua-lsp"
)

function Install-Plugins {
    param([string[]]$Plugins)
    $total = $Plugins.Count
    for ($i = 0; $i -lt $total; $i++) {
        $p = $Plugins[$i]
        Write-Host ("[{0,2}/{1}] Installing {2}..." -f ($i + 1), $total, $p) -NoNewline
        try {
            $null = & claude plugins add $p 2>&1
            Write-Host " done" -ForegroundColor Green
        } catch {
            Write-Host " FAILED" -ForegroundColor Red
        }
    }
}

switch ($Mode) {
    "all" {
        Write-Host "=== Installing ALL plugins ($($CorePlugins.Count) core + $($LspPlugins.Count) LSP) ==="
        Install-Plugins $CorePlugins
        Install-Plugins $LspPlugins
    }
    "lsp" {
        Write-Host "=== Installing LSP plugins ($($LspPlugins.Count)) ==="
        Install-Plugins $LspPlugins
    }
    default {
        Write-Host "=== Installing core plugins ($($CorePlugins.Count)) ==="
        Install-Plugins $CorePlugins
    }
}

Write-Host ""
Write-Host "Done! Run 'claude config set effortLevel high' for enhanced features."
Write-Host "Restart Claude Code to activate all plugins."
