with import <nixpkgs> { };

let
  ## Chrome/Chromium screensharing is broken on Wayland on v100. This pins chromium to v99, which works. Rumour says 101 will work as well.
  chromium = (import
    (builtins.fetchTarball {
      url = "https://github.com/NixOS/nixpkgs/archive/011783008f76e07fe2063c17c652ef9049257b9e.tar.gz";
      sha256 = "sha256:066301prpvqgdfq9il3n2bmfbkbpnscpzafxqk9rb2fld5qrvf2q";
    })
    { }).chromium;


  wrapper = pkgs.writeShellScriptBin "chromium" ''
    source="$HOME/zram/chromium"
    target="$HOME/.cache/chromium"
    mkdir -p "$source"
    ln -s "$source" "$target"
    exec ${chromium}/bin/chromium \
      --enable-features=UseOzonePlatform,WebRTCPipeWireCapturer \
      --ozone-platform=wayland
  '';
in

pkgs.symlinkJoin {
  name = "chromium";
  paths = [
    wrapper
    chromium
  ];
}
