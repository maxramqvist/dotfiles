{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/master.tar.gz";
in
{
  imports =
    [
      (import "${home-manager}/nixos")
      ./alacritty/alacritty.nix
      ./waybar/waybar.nix
      ./sway/sway.nix
      ./nvim/nvim.nix
    ];
  # Home Manager
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.users.max = {
    home.packages = [
      pkgs.bat
      pkgs.lsd
      pkgs.kanshi
    ];
    gtk = {
      enable = true;
      iconTheme = {
        name = "Qogir";
      };
      theme = {
        name = "Dracula";
      };
      font = {
        name = "Sauce Code Pro Nerd Font Complete";
        size = 12;
      };
    };
    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/chrome" = "chromium.desktop";
        "text/html" = "chromium.desktop";
        "application/x-extension-htm" = "chromium.desktop";
        "application/x-extension-html" = "chromium.desktop";
        "application/x-extension-shtml" = "chromium.desktop";
        "application/xhtml+xml" = "chromium.desktop";
        "application/x-extension-xhtml" = "chromium.desktop";
        "application/x-extension-xht" = "chromium.desktop";
        "x-scheme-handler/msteams" = "teams.desktop";
      };
      associations.added = {
        "x-scheme-handler/https" = "chromium.desktop";
        "x-scheme-handler/chrome" = "chromium.desktop";
        "text/html" = "chromium.desktop";
        "application/x-extension-htm" = "chromium.desktop";
        "application/x-extension-html" = "chromium.desktop";
        "application/x-extension-shtml" = "chromium.desktop";
        "application/xhtml+xml" = "chromium.desktop";
        "application/x-extension-xhtml" = "chromium.desktop";
        "application/x-extension-xht" = "chromium.desktop";
      };

    };
    services = {
      kanshi = {
        enable = true;
        profiles = {
          bara_laptop = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "enable";
                position = "0,0";
              }
            ];
          };
          jobbet = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "Unknown HP Z27n G2 6CM8060FV2";
                status = "enable";
                position = "0,0";
                mode = "2560x1440@74.971Hz";
              }
            ];
          };
          jobbet2 = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "DP-3";
                status = "enable";
                position = "0,0";
                mode = "3840x2160@60.000Hz";
                scale = 2.0;
              }
            ];
          };
          jobbet3 = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "DP-7";
                status = "enable";
                position = "0,0";
                mode = "1920x1080@60.000Hz";
                scale = 1.0;
              }
            ];
          };
          hemma = {
            outputs = [
              {
                criteria = "eDP-1";
                status = "disable";
              }
              {
                criteria = "Unknown HP Z27n G2 6CM80602TX";
                status = "enable";
                position = "0,0";
                mode = "2560x1440@74.971Hz";
              }
            ];
          };
        };
      };
    };
    programs = {
      firefox = {
        enable = true;

        profiles.default = {
          settings = {
            "gfx.webrender.enabled" = true;
            "gfx.webrender.all" = true;

            "browser.tabs.warnOnCloseOtherTabs" = false;
            "browser.tabs.warnOnClose" = false;

            "general.smoothScroll.currentVelocityWeighting" = 0;
            "general.smoothScroll.mouseWheel.durationMaxMS" = 250;
            "general.smoothScroll.stopDecelerationWeighting" = "0.82";
            "mousewheel.min_line_scroll_amount" = 25;

            "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
            "extensions.webextensions.ExtensionStorageIDB.migrated.addon@darkreader.org" = true;
            "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
            "ui.systemUsesDarkTheme" = 1;
            "devtools.theme" = "dark";

            "browser.newtabpage.activity-stream.feeds.section.highlights" = false;
            "browser.newtabpage.activity-stream.feeds.section.topstories" = false;
            "browser.newtabpage.activity-stream.feeds.topsites" = false;
            "browser.newtabpage.activity-stream.feeds.snippets" = false;
            "browser.newtabpage.activity-stream.showSearch" = false;

            # https://ffprofile.com

            "app.normandy.api_url" = "";
            "app.normandy.enabled" = false;
            "app.shield.optoutstudies.enabled" = false;
            "app.update.auto" = false;
            "breakpad.reportURL" = "";
            "browser.aboutConfig.showWarning" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit" = false;
            "browser.crashReports.unsubmittedCheck.autoSubmit2" = false;
            "browser.crashReports.unsubmittedCheck.enabled" = false;
            "browser.disableResetPrompt" = true;
            "browser.newtab.preload" = false;
            "browser.newtabpage.activity-stream.section.highlights.includePocket" = false;
            "browser.newtabpage.enabled" = false;
            "browser.newtabpage.enhanced" = false;
            "browser.newtabpage.introShown" = true;
            "browser.safebrowsing.appRepURL" = "";
            "browser.safebrowsing.blockedURIs.enabled" = false;
            "browser.safebrowsing.downloads.enabled" = false;
            "browser.safebrowsing.downloads.remote.enabled" = false;
            "browser.safebrowsing.downloads.remote.url" = "";
            "browser.safebrowsing.enabled" = false;
            "browser.safebrowsing.malware.enabled" = false;
            "browser.safebrowsing.phishing.enabled" = false;
            "browser.selfsupport.url" = "";
            "browser.shell.checkDefaultBrowser" = false;
            "browser.startup.homepage_override.mstone" = "ignore";
            "browser.tabs.crashReporting.sendReport" = false;
            "browser.urlbar.trimURLs" = false;
            "datareporting.healthreport.service.enabled" = false;
            "datareporting.healthreport.uploadEnabled" = false;
            "datareporting.policy.dataSubmissionEnabled" = false;
            "device.sensors.ambientLight.enabled" = false;
            "device.sensors.enabled" = false;
            "device.sensors.motion.enabled" = false;
            "device.sensors.orientation.enabled" = false;
            "device.sensors.proximity.enabled" = false;
            "experiments.activeExperiment" = false;
            "experiments.enabled" = false;
            "experiments.manifest.uri" = "";
            "experiments.supported" = false;
            "extensions.getAddons.cache.enabled" = false;
            "extensions.getAddons.showPane" = false;
            "extensions.pocket.enabled" = false;
            "extensions.screenshots.upload-disabled" = true;
            "extensions.shield-recipe-client.api_url" = "";
            "extensions.shield-recipe-client.enabled" = false;
            "extensions.webservice.discoverURL" = "";
            "media.autoplay.default" = 1;
            "media.autoplay.enabled" = false;
            "media.eme.enabled" = false;
            "media.gmp-widevinecdm.enabled" = false;
            "network.allow-experiments" = false;
            "network.captive-portal-service.enabled" = false;
            "network.trr.mode" = 5;
            "services.sync.prefs.sync.browser.newtabpage.activity-stream.showSponsoredTopSite" = false;
            "toolkit.telemetry.archive.enabled" = false;
            "toolkit.telemetry.bhrPing.enabled" = false;
            "toolkit.telemetry.cachedClientID" = "";
            "toolkit.telemetry.enabled" = false;
            "toolkit.telemetry.firstShutdownPing.enabled" = false;
            "toolkit.telemetry.hybridContent.enabled" = false;
            "toolkit.telemetry.newProfilePing.enabled" = false;
            "toolkit.telemetry.prompted" = 2;
            "toolkit.telemetry.rejected" = true;
            "toolkit.telemetry.reportingpolicy.firstRun" = false;
            "toolkit.telemetry.server" = "";
            "toolkit.telemetry.shutdownPingSender.enabled" = false;
            "toolkit.telemetry.unified" = false;
            "toolkit.telemetry.unifiedIsOptIn" = false;
            "toolkit.telemetry.updatePing.enabled" = false;
          };
        };
      };
      chromium = {
        enable = true;
        commandLineArgs = [ "--enable-features=UseOzonePlatform,WebRTCPipeWireCapturer,VaapiVideoDecoder,VaapiVideoEncoder" "--ozone-platform=wayland" ];
        extensions = [
          { id = "hdokiejnpimakedhajhdlcegeplioahd"; } # lastpass
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
        ];
      };
      foot = {
        enable = true;
        server = {
          enable = true;
        };
        settings = {
          main = {
            font = "Sauce Code Pro Nerd Font Complete:size=18";
            dpi-aware = "yes";
          };
          cursor = {
            color = "eeeeee 9f515a";
          };
          colors = {
            foreground = "dbdee9";
            background = "0e1420";
            regular0 = "5b6272";
            regular1 = "bf616a";
            regular2 = "a3be8c";
            regular3 = "ebcb8b";
            regular4 = "81a1c1";
            regular5 = "b48ead";
            regular6 = "88c0d0";
            regular7 = "e5e9f0";
            bright0 = "4c566a";
            bright1 = "bf616a";
            bright2 = "a3be8c";
            bright3 = "ebcb8b";
            bright4 = "81a1c1";
            bright5 = "b48ead";
            bright6 = "8fbcbb";
            bright7 = "eceff4";
          };
          mouse = {
            hide-when-typing = "yes";
          };
        };
      };
      git = {
        enable = true;
        userName = "maxramqvist";
        userEmail = "max.ramqvist@gmail.com";
      };
      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[➜](bold red)";
          };
        };
      };
      zsh = {
        enable = true;
        autocd = true;
        enableAutosuggestions = true;
        enableCompletion = true;
        enableSyntaxHighlighting = true;
        shellAliases = {
          ll = "lsd -l --group-dirs first";
          tree = "lsd --tree";
          tf = "terraform";
          aw = "$HOME/git/aw/tooling-awesome-cli-js/bin/run";
          awl = "AWESOME_API=http://localhost:5050 $HOME/git/aw/tooling-awesome-cli-js/bin/run";
          v = "nvim";
          ip = "ip --color";
          ssh = "TERM=xterm-256color ssh";
          cat = "bat -pp";
        };
        initExtraBeforeCompInit = ''
          [ -f ~/zshrc ] && source ~/zshrc
          unalias z 2> /dev/null
          z() {
            [ $# -gt 0 ] && _z "$*" && return
            cd "$(_z -l 2>&1 | fzf --height 40% --nth 2.. --reverse --inline-info +s --tac --query "''${*##-* }" | sed 's/^[0-9,.]* *//')"
          }
          zstyle ':completion:*' menu select
        '';
        history = {
          size = 10000;
          ignoreDups = true;
          extended = true;
          share = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "git"
            "z"
          ];
          #          theme = "agnoster";
        };
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };
  };
}
