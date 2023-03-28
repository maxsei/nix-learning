#include <stdio.h>
#include <stdlib.h>

int main(int argc, char **argv) {
	// Demonstration of `args` in `./minimal.nix` but uneccary for producing a
	// minimal viable nix derivation that builds.
  if (argc > 1) {
    for (char **pargv = argv + 1; *pargv != argv[argc]; pargv++)
      printf("%s\n", *pargv);
  }
  char *out;
  FILE *fp;

  // NECESSARY!
  out = getenv("out");
  fp = fopen(out, "w");
  fclose(fp);
}
