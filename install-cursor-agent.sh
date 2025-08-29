#!/usr/bin/env bash
set -e

echo "🚀 Installing Cursor Agent..."

# 1. Run official installer
curl -fsSL https://cursor.com/install | bash

# 2. Fix ownership of ~/.local (if root owns it)
if [ "$(stat -f '%Su' ~/.local 2>/dev/null || echo '')" = "root" ]; then
  echo "🔧 Fixing ownership of ~/.local..."
  sudo chown -R "$USER":staff ~/.local
fi

# 3. Ensure ~/.local/bin exists
mkdir -p ~/.local/bin

# 4. Find latest version installed
LATEST=$(ls -1 "$HOME/.local/share/cursor-agent/versions" | sort -V | tail -n1)

# 5. Create/overwrite symlink
ln -sf "$HOME/.local/share/cursor-agent/versions/$LATEST/cursor-agent" "$HOME/.local/bin/cursor-agent"

# 6. Ensure ~/.local/bin is in PATH
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc"; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
  echo "✅ Added ~/.local/bin to PATH in ~/.zshrc"
fi

# 7. Reload zsh config
source "$HOME/.zshrc"

echo "🎉 Installation complete!"
which cursor-agent
cursor-agent --version || echo "⚠️ Run 'source ~/.zshrc' or restart terminal to use cursor-agent."