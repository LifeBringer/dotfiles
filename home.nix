{ config, pkgs, user, treehouse, ... }:

let
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in

{
  home.username = user;
  home.homeDirectory = "/Users/${user}";
  home.stateVersion = "24.11";
  manual.manpages.enable = false;
  home.packages = with pkgs; [
    # cli i use constantly
    ripgrep   # fast search
    fd        # fast find
    fzf       # fuzzy finder
    jq        # json on the command line
    lazygit
    neovim
    tree-sitter  # nvim-treesitter (main) needs the CLI to build parsers; LazyVim would otherwise pull it via mason
    # LazyVim health checks and extras
    lua5_1                  # lazy.nvim builds rockspec plugins against Lua 5.1
    lua51Packages.luarocks  # the luarocks that matches it
    imagemagick             # snacks.image: `magick` and `convert` for inline images
    ghostscript             # snacks.image: `gs` for PDF rendering
    go                      # lang.go extra installs gopls, gofumpt, goimports with `go install`
    nixfmt                  # lang.nix extra formats with nixfmt via conform but does not install it
    nil                     # nix language server; mason would build it with cargo, which is not installed
    yt-dlp    # video downloader
    cloudflared  # Cloudflare Tunnel; wrangler is an Automic Vault Isotope in configuration.nix
    pip-audit    # audit Python dependencies for known vulnerabilities
    duckdb       # duckdb command line
    python-tools # python with websockets, duckdb, python-pptx, pypdf, nbformat, reportlab, pillow; not `python3`, which stays /usr/bin/python3
    # pi.dev coding agent. Provider wiring lives in home/.pi/agent/extensions/foundry.ts.
    pi-coding-agent
    acpx      # headless Agent Client Protocol client, the model layer under backpass
    backpass  # proposes AGENTS.md / CLAUDE.md edits from past agent sessions
    muse      # Meta Muse Code; installs its writable runtime on first launch
    nodejs    # pi shells out to npm for the settings.json "packages"; brew's node is only a transitive dep of mermaid-cli
  ] ++ [
    # From the treehouse flake input, not nixpkgs: a pool of reusable git
    # worktrees so each agent session gets its own isolated checkout.
    treehouse.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
  fonts.fontconfig.enable = true;
  home.sessionPath = [ "$HOME/go/bin" ];  # `go install` binaries such as bootdev
  home.sessionVariables.EDITOR = "nvim";
  home.sessionVariables.CLAUDE_CODE_USE_FOUNDRY = "1";
  home.sessionVariables.ANTHROPIC_DEFAULT_SONNET_MODEL = "claude-sonnet-5";
  home.sessionVariables.ANTHROPIC_DEFAULT_OPUS_MODEL = "claude-opus-5";
  home.sessionVariables.ANTHROPIC_DEFAULT_HAIKU_MODEL = "claude-haiku-4-5";
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;
      format = "$directory$git_branch$git_status$cmd_duration$line_break$character";
      character = {
        success_symbol = "[❯](purple)";
        error_symbol = "[❯](red)";
      };
      cmd_duration.format = "[$duration]($style) ";
    };
  };

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;      # ghost text from history
    syntaxHighlighting.enable = true;  # commands turn green when valid
    initContent = ''
      bindkey '^f' autosuggest-accept

      # Private Variables Load
      [ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"

      # Work around Foundry rejecting Codex tool definitions with an empty
      # description. The proxy fills it in and is started only when needed.
      codex() {
        # A proxy left running from a previous AZURE_OPENAI_FOUNDRY_RESOURCE
        # keeps the port bound and 401s every request, so check where it points.
        local want="https://$AZURE_OPENAI_FOUNDRY_RESOURCE/openai/v1"
        local pids=$(lsof -ti :8900 2>/dev/null)
        if [ -n "$pids" ] && \
           [ "$(curl -fsS --max-time 2 http://127.0.0.1:8900/__upstream 2>/dev/null)" != "$want" ]; then
          kill $pids 2>/dev/null
          sleep 0.5
        fi

        if ! lsof -ti :8900 >/dev/null 2>&1; then
          (/usr/bin/python3 ~/.local/bin/codex-foundry-proxy.py \
            >>~/Library/Logs/codex-foundry-proxy.log 2>&1 &)
          local i
          for i in {1..30}; do
            lsof -ti :8900 >/dev/null 2>&1 && break
            sleep 0.1
          done
        fi
        command codex "$@"
      }
    '';
    shellAliases = {
      ".." = "cd ..";
      add = "git add .";
      push = "git push";
      pull = "git pull";
      m = "git switch main";
      cc = "claude --dangerously-skip-permissions";
      co = "codex --ask-for-approval never";
      typora = "open -a Typora";
    };
  };

  home.file.".config/wezterm".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/wezterm";
  # Ghostty checks its macOS Application Support path before XDG_CONFIG_HOME.
  home.file."Library/Application Support/com.mitchellh.ghostty/config.ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/ghostty/config.ghostty";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/nvim";
  home.file.".config/herdr".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.config/herdr";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";

  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";

  # Keep pi's credential and runtime state local by linking only authored files
  # and directories. Foundry provider wiring is an extension, not models.json,
  # because pi cannot read the hostname from the environment in models.json.
  home.file.".pi/agent/themes".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/themes";
  home.file.".pi/agent/extensions".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/extensions";
  home.file.".pi/agent/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.pi/agent/settings.json";

  # AGENTS.md tells agents to read the OPINIONS.md next to it, so the file has
  # to sit beside every copy.
  home.file.".claude/OPINIONS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/OPINIONS.md";
  home.file.".codex/OPINIONS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/OPINIONS.md";
  home.file.".config/opencode/OPINIONS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/OPINIONS.md";
}
