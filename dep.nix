let
  pkgs = import <nixpkgs> {};
  touch = builtins.toPath "${pkgs.coreutils}/bin/touch";
in
derivation {
  name = "minimal";
  system = builtins.currentSystem;
  builder = builtins.toPath "${pkgs.bash}/bin/bash";

  # This bash script depends on `touch` and the builder (`bash`)...
  args = [ ./touch.sh ];
  # Here's a way how I could inject it into the build environment...
  inherit touch;
  src = [
    pkgs.coreutils
  ];
  # And by naming touch with environment variable in `./touch.sh`
}
