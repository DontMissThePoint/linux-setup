  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello
    pkgs.vivaldi pkgs.vivaldi-ffmpeg-codecs pkgs.xidlehook
    pkgs.udiskie pkgs.libgen-cli

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/shafiq/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # nonfree
  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnfreePredicate = (_: true);
    };
  };

  # locale
  home.language = {
    base = "en_US.UTF-8";
    ctype = "en_US.UTF-8";
    numeric = "en_US.UTF-8";
    time = "en_US.UTF-8";
    collate = "en_US.UTF-8";
    monetary = "en_US.UTF-8";
    messages = "en_US.UTF-8";
    paper = "en_US.UTF-8";
    name = "en_US.UTF-8";
    address = "en_US.UTF-8";
    telephone = "en_US.UTF-8";
    measurement = "en_US.UTF-8";
  };

  # systemd
    services.udiskie = {
    enable = true;
    notify = false;
    tray = "never";
    settings = {
      program_options = {
        file_manager = null;
      };
    };
  };

  # cursor
  home.pointerCursor = {
    gtk.enable = true;
    # x11.enable = true;
    name = "Afterglow-Recolored-Gruvbox-Black";
    package = pkgs.afterglow-cursors-recolored;
    size = 32;
  };

  # icons:fonts:man:etc
  fonts.fontconfig.enable = true;
  targets.genericLinux.enable = true;
  xdg.mime.enable = true;
}
