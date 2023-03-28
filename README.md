<!-- vim: set expandtab: -->
# What is nix from the perspective of nix derivations?

1. Nix source code: strings called expressions that can evaluate to other
   expressions that have base data types like numbers, strings, lists, and
   records and are commonly held in `.nix` files.
2. Nix derivations: data format that nix the package manager uses to reproduce
   builds typically stored with in `.drv` files and is commonly produced from
   nix expressions.
3. Nix build products: outputs that are produces from realized nix derivations
   are placed in a content addressable store called the "nix store" typically
   at `/nix/store/` and are addressed by `<hash>-<name>/...`

### Evaluating expressions and derivations in practice
Nix expressions are only useful to nix, the build tool, so long as expressions
evaluate to a special type of record type called a "derivation" (see `{ type =
"derivation"; ... }` and `./empty.nix`). Typically these derivations are
constructed using nix `builtins.derivation` function which requires the
arguments `name`, `system`, `builder` (see `./minimal.nix`). `name` is the name
of the derivation used in the `outPath`, `system` is the architecture and os
platform to build for represented as a string, and `builder` an executable that
takes an optional derivation field called `args` that is provided as std in.
The `builder` in order to build the derivation must write to a path stored in
its environment called `$out` in order to be realized (built) into the nix
store.

Evaluate a nix language expression (no derivations)
```console
$ nix-instantiate --eval --expr '2 + 2'
4
```

Evaluate a file that evaluates as a nix derivation (doesn't add to nix store with `--eval`)
```console
$ nix-instantiate --eval ./minimal.nix
{ all = [ «repeated» ]; builder = "/bin/sh"; drvAttrs = { builder = "/bin/sh";
 name = "example"; system = "x86_64-linux"; }; drvPath = "/nix/store/7h0dx6caidn
8m8n89xar3i9x045rfgka-example.drv"; name = "example"; out = «repeated»; outPat
h = "/nix/store/9mqgyhwrkkp2kpn815za9sd46rv50w8q-example"; outputName = "out"; s
ystem = "x86_64-linux"; type = "derivation"; }
```

This command evaluates a nix expression that evaluates the derivation expression in the file
```console
$ nix-instantiate --eval --expr 'import ./minimal.nix'
{ all = [ «repeated» ]; builder = "/bin/sh"; drvAttrs = { builder = "/bin/sh";
 name = "example"; system = "x86_64-linux"; }; drvPath = "/nix/store/7h0dx6caidn
8m8n89xar3i9x045rfgka-example.drv"; name = "example"; out = «repeated»; outPat
h = "/nix/store/9mqgyhwrkkp2kpn815za9sd46rv50w8q-example"; outputName = "out"; s
ystem = "x86_64-linux"; type = "derivation"; }
```

Instantiate derivation, add it to nix store (remove `--eval`), and add a
symlink (`--add-root result.drv`) that will ensure the derivation isn't gc'd
(add root appears in many other `nix` commands as well).
```console
$ nix-instantiate --add-root result.drv 'import ./minimal.nix'
{ all = [ «repeated» ]; builder = "/bin/sh"; drvAttrs = { builder = "/bin/sh";
 name = "example"; system = "x86_64-linux"; }; drvPath = "/nix/store/7h0dx6caidn
8m8n89xar3i9x045rfgka-example.drv"; name = "example"; out = «repeated»; outPat
h = "/nix/store/9mqgyhwrkkp2kpn815za9sd46rv50w8q-example"; outputName = "out"; s
ystem = "x86_64-linux"; type = "derivation"; }
```

### Nix operations on derivations
operations on the nix store, and for that matter the user's environment/package
ecosystem, use `nix-store --<op>`

Search a attributes of a derivation in the nix store
```console
nix-query --query --<attribute subquery> <path.drv>
```

Derivations also have an environment
```
$ nix-store --print-env <path.drv>
```

### On building
Files structure in the build environment can be viewed with
```
$ nix-instantiate --add-root ./result.drv ./find.nix && nix-store --realise ./result.drv
```

What about nix derivations that depend on other nix derivations?
```
$ nix-instantiate --add-root ./result.drv ./dep.nix && nix-store --realise ./result.drv
```
