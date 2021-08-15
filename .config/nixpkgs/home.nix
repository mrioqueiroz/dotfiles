{ pkgs, ... }: {
  home.packages = with pkgs;
    [

    ];

  programs = {

    autojump = {
      enable = true;
      enableFishIntegration = true;
    };

    fish = {
      enable = true;
      functions = {
        fish_user_key_bindings = {
          body = "fish_default_key_bindings";
        };
      };
      shellInit = builtins.readFile ./config.fish;
      shellAbbrs = {
        br = "br -sdp --hidden";
        k = "kubectl";
        ll = "exa -lhag -H --git --icons";
        ns = "nix-shell";
        nsp = "nix-shell --pure";
        nsu = "nix-shell -I nixpkgs=channel:nixpkgs-unstable";
        q = "exit";
        v = "vim";
      };
    };

    fzf = {
      enable = true;
      defaultOptions = [
        "--cycle --height=50% --border=rounded --keep-right "
      ];
      defaultCommand = "rg --no-follow --files --hidden --no-ignore-vcs";
      fileWidgetCommand = "rg --no-follow --files --hidden --no-ignore-vcs";
    };

    gh = { enable = true; };

    go = { enable = true; };

    neovim = {
      enable = true;
      viAlias = true;
      vimdiffAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        ale
        coc-nvim
        coc-rls
        coc-rust-analyzer
        fzf-vim
        gruvbox
        lightline-ale
        lightline-vim
        nerdtree
        vim-fish
        vim-grepper
        vim-indent-object
        vim-nix
        vim-obsession
      ];
      extraConfig = builtins.readFile ./init.vim;
    };

    tmux = {
      enable = true;
      terminal = "screen-256color";
      newSession = false;
      clock24 = true;
      keyMode = "vi";
      shortcut = "Space";
      escapeTime = 60;
      disableConfirmationPrompt = true;
      plugins = with pkgs.tmuxPlugins; [
        extrakto
        gruvbox
        jump
        logging
        yank
      ];
      extraConfig = builtins.readFile ./tmux.conf;
    };
  };
}
