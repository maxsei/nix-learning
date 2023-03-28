derivation {
  name = "minimal";
  system = builtins.currentSystem;
  # Any path that is included in a .nix expression is realized in the nix store
  # and referenced in the code as it's nix store path.
  builder = ./touch; # complied with: gcc -o touch ./main.c
  # This is optional and passed a cli args to the executable "builder".
  # args = ["foo" "bar"];
}
