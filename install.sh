#!/bin/bash
# Claude Code Starter Kit — Full Auto Installer
# Run: curl -fsSL https://raw.githubusercontent.com/pimpinpete/claude-code-starter-kit/main/install.sh | bash

set -e

REPO="https://raw.githubusercontent.com/pimpinpete/claude-code-starter-kit/main"
AGENTS_DIR="$HOME/.claude/agents"
CLAUDE_DIR="$HOME/.claude"

echo "================================================"
echo "  Claude Code Starter Kit — Installing..."
echo "================================================"
echo ""

# Step 1: Settings
echo "→ Writing settings.json..."
mkdir -p "$CLAUDE_DIR"
cat > "$CLAUDE_DIR/settings.json" << 'SETTINGS'
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  },
  "permissions": {
    "allow": [
      "*"
    ],
    "deny": [
      "Bash(rm -rf /:*)",
      "Bash(rm -rf ~:*)",
      "Bash(rm -rf /*:*)",
      "Bash(dd if=/dev/zero:*)",
      "Bash(mkfs:*)"
    ]
  },
  "effortLevel": "high"
}
SETTINGS
echo "   ✓ settings.json written"

# Step 2: Agents
echo ""
echo "→ Installing 34 specialist agents..."
mkdir -p "$AGENTS_DIR"

agents=(
  agent-expert ai-engineer api-documenter architecture-modernizer
  backend-architect business-analyst cloud-architect code-reviewer
  comprehensive-researcher data-analyst database-pro debugger
  devops-engineer fact-checker frontend-developer fullstack-developer
  incident-responder javascript-pro legal-advisor mcp-expert
  ml-engineer model-evaluator nlp-engineer performance-pro
  product-strategist prompt-engineer python-pro security-auditor
  security-engineer shell-scripting-pro technical-writer test-engineer
  typescript-pro ui-ux-designer
)

for agent in "${agents[@]}"; do
  curl -fsSL "$REPO/agents/$agent.md" -o "$AGENTS_DIR/$agent.md"
  echo "   ✓ $agent"
done

curl -fsSL "$REPO/agents/REGISTRY.json" -o "$AGENTS_DIR/REGISTRY.json"
echo "   ✓ REGISTRY.json"

# Step 3: CLAUDE.md template (only if none exists)
if [ ! -f "$HOME/CLAUDE.md" ]; then
  echo ""
  echo "→ Creating CLAUDE.md template..."
  cat > "$HOME/CLAUDE.md" << 'CLAUDEMD'
# My Claude Code Instructions

## Style
- Be concise. No fluff, no filler, no emojis unless asked.
- Never say "I cannot physically" — use tools to DO the task.

## Key Projects
| Project | Path | Notes |
|---------|------|-------|
| Example | `~/my-project/` | Description |

## Safety Rules
- Never send messages/emails without explicit confirmation
- Never run destructive git commands without confirmation
- Never expose API keys or credentials
CLAUDEMD
  echo "   ✓ ~/CLAUDE.md created (customize this with your projects)"
else
  echo ""
  echo "→ Skipping CLAUDE.md (already exists)"
fi

# Step 4: Plugins
echo ""
echo "→ Installing 24 plugins..."
echo "   (requires claude CLI — skipping any that fail)"

plugins=(
  superpowers frontend-design code-review feature-dev
  pr-review-toolkit commit-commands serena playwright
  context7 plugin-dev claude-md-management agent-sdk-dev
  claude-code-setup explanatory-output-style ralph-loop
  figma atlassian supabase code-simplifier security-guidance
  swift-lsp typescript-lsp pyright-lsp sonatype-guide
)

plugin_ok=0
plugin_fail=0
for plugin in "${plugins[@]}"; do
  if claude plugins install "$plugin" 2>/dev/null; then
    echo "   ✓ $plugin"
    ((plugin_ok++)) || true
  else
    echo "   ~ $plugin (skipped or already installed)"
    ((plugin_fail++)) || true
  fi
done

echo ""
echo "================================================"
echo "  Install Complete!"
echo "================================================"
echo ""
echo "  Agents:  $(ls $AGENTS_DIR/*.md 2>/dev/null | wc -l | tr -d ' ') installed → ~/.claude/agents/"
echo "  Settings: ~/.claude/settings.json"
echo "  Plugins:  $plugin_ok installed"
echo ""
echo "  Restart Claude Code to activate everything."
echo ""
