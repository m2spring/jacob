# Jacob — Troubleshooting

Problems seen while getting this fork building on a new machine, and how
to resolve them, organized to mirror README.md's own section structure.
If your problem isn't listed here, check the main
[README.md](README.md)'s Prerequisites and Test sections first — several
known, non-fixable limitations of the toolchain are documented there
rather than here.

## Prerequisites

### Cocktail

#### `cc -m32` / `gcc -m32` can't create any executable

Symptoms include, from `cocktail`'s `./config CC="cc -m32"`:

```
checking whether the C compiler works... no
config: error: C compiler cannot create executables
```

or similar `-m32`-related failures from `./configure` or `make` — they
also invoke `gcc -m32` and `/usr/bin/as --32` directly, for the Mocka
runtime shims and Jacob's own ELF back-end.

**Cause:** 32-bit compatibility libraries for the C compiler aren't
installed. This whole toolchain — Mocka, Jacob, and the Oberon-2 programs
it compiles — targets 32-bit x86 even when built and run on a 64-bit
host (see README.md's Prerequisites).

**Fix:** install your distro's 32-bit multilib packages:

* Debian/Ubuntu: `sudo apt install gcc-multilib g++-multilib`
* Fedora/RHEL: `sudo dnf install glibc-devel.i686 libgcc.i686`
* Arch: enable the `multilib` repository in `/etc/pacman.conf`, then
  `sudo pacman -S lib32-glibc lib32-gcc-libs`

Confirm it worked before retrying:

```sh
echo 'int main(){return 0;}' | cc -m32 -x c - -o /tmp/test32 && /tmp/test32 && echo OK
```

If that still fails, check `cocktail`'s `config.log` for the exact
compiler invocation and error — it's usually more specific than the
one-line summary `./config` prints.
