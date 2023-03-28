let pkgs = import <nixpkgs> { };
in derivation {
  name = "find-example";
  system = builtins.currentSystem;
  builder = pkgs.findutils + /bin/find;
  args = [ "/" ];
}
