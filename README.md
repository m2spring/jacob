# JACOB

(Just A Compiler for OBeron-2)
Version 0.2
5/31/98

## Building and running this fork (2026)

This branch is a working port of the original 1998 Jacob source (the rest of
this README, below) to build and run on a modern x86_64 Linux system via
32-bit compatibility. The instructions below are current and specific to
this fork; everything from "Introduction" onward is the original project's
own README, kept for history and still largely accurate about the language
implementation itself.

### Prerequisites

Two external toolchains are required, neither of which is part of this
repository:

* **Mocka** — a Modula-2 compiler, used to bootstrap Jacob's own source
  (Jacob is written in Modula-2/Oberon-2 and compiles itself). Use
  `MOCKA 9903` (1999) from
  [GunterMueller/Mocka_Modula-2_Compilers_and_Murus](https://github.com/GunterMueller/Mocka_Modula-2_Compilers_and_Murus)
  — the oldest, and only currently-known-working, public Mocka: it's the
  last one still using `.mi`/`.md` source extensions, matching Jacob's
  own tree (see "Other Mocka releases tried" below for what doesn't
  work). Just clone it; `./configure` (below) does everything else —
  patching it for a modern glibc/x86_64 host, generating a `bin/mc`, and
  linking its standard library source into `src/`:

  ```sh
  git clone https://github.com/GunterMueller/Mocka_Modula-2_Compilers_and_Murus
  ```

  This release has one known correctness bug: `LONGREAL` constants lose
  precision during compile-time constant folding. See "Test" below.

  <details>
  <summary>Other Mocka releases tried (public ones don't work; the one
  that does isn't public)</summary>

  * **`trijezdci/MOCKA`** ([github](https://github.com/trijezdci/MOCKA),
    `ver1807`/`ver1808`) and the same mirror's **`Mocka_0605` folder**
    (mislabeled — it's actually `0608m`) both use `.mod`/`.def` source
    extensions instead of `.mi`/`.md` (a deliberate upstream change,
    confirmed by [FU Berlin's own Mocka course
    page](http://web.archive.org/web/20151007012404/http://lwb.mi.fu-berlin.de:80/inf/mocka/installation.shtml),
    which has only ever offered post-`0605` releases). `./configure
    --mocka=PATH` can still target one — it'll generate `.mod`/`.def`
    symlinks next to every `.mi`/`.md` so it finds Jacob's modules at
    all — but `trijezdci`'s compiler then **segfaults** partway through
    Jacob's own sources (around module `OT`): a crash in that binary on
    this codebase, not something fixable from here.
  * **`MOCKA 0605`** (Universität Karlsruhe, May 2006) is the version
    Jacob's source tree was actually developed against, and has no known
    correctness bugs at all (see "Test" below) — but it was never
    published anywhere we could find, including FU Berlin's own archived
    Mocka mirror. The only copy known to exist is a personal one, sent by
    Josef Grosch (Mocka's original author) directly over email in 2015,
    along with his own patches for a modern Linux host — the same three
    fixes `./configure` now applies to `Mocka 9903` (see below). If you
    have independent access to a `0605` copy, `./configure --mocka=PATH`
    accepts it too — the same patching/symlinking runs either way, but
    is a no-op on an install that's already patched and doesn't need the
    symlinks (`Makefile`'s `shims` step falls back to copying `0605`'s
    precompiled `Exceptions.o`/`LREAL.o` instead of assembling them from
    source, since `0605` doesn't ship that source).
  </details>
* **cocktail2110** — Dr. Josef Grosch's Cocktail compiler-construction
  toolbox (rex/lalr/puma/ast/ag), used to regenerate Jacob's scanner,
  parser, and tree-walking modules from their `.pum`/`.rex`/`.ast` sources.

  ```sh
  git clone https://github.com/cocolab8/cocktail.git
  cd cocktail
  ./config CC="cc -m32"
  make
  make install DIR=$(pwd)
  ./bin/puma -h   # should print usage/options text
  cd ..
  ```

  The `Makefile`'s `COCKTAIL` variable (from `config.mk`) needs to point
  at this `cocktail/bin/`. All of `puma`, `rex`, `lark`, and `ast` (the
  four tools this build actually invokes) come from this same install.

You do **not** need to reproduce Beg (the 1994 backend generator that
originally generated Jacob's code generator modules `Cons`, `Emit`,
`GcgTab`, `IR`, `RegAlloc`) — that output is committed directly in `src/`.
Beg itself is the one piece of this toolchain that genuinely did need
emulation (a 1994 Linux/i386 `a.out` binary, run via QEMU + a Slackware
2.0.0 image), but that was a one-time historical step to produce those
already-committed files, not something a fresh build needs to repeat.

Also needed: gcc/as/ld with 32-bit multilib support (`gcc-multilib` /
`libc6-dev-i386` or your distro's equivalent), and python3.

### Build

```sh
git clone <this repo> jacob && cd jacob
./configure            # locates MOCKA and cocktail, writes config.mk
make                   # incremental build
make clean && make     # forces full puma/rex/lark/ast regeneration first
```

`./configure` expects `MOCKA` and `cocktail` cloned as sibling directories
of this repo (`../MOCKA/ver1807/bin/Mocka`, `../cocktail/bin/puma`); pass
`--mocka=PATH` / `--cocktail=PATH` to point elsewhere. It writes their
locations to `config.mk`, which the `Makefile` includes instead of
hardcoding paths. `configure` is a small hand-written script, not
generated by GNU Autoconf/Automake — it just follows their `./configure`
convention.

This produces the `Jacob` compiler binary at the repo root.

### Test

```sh
./test.sh       # runs both suites (default)
./test.sh of    # front-end only: scan/parse/type-check vs. reference dumps
./test.sh oc    # back-end only: compile+link+run vs. reference program output
```

This runs the original 1998 conformance suite under `src/OberonTest/`. As of
this writing, six back-end tests fail regardless of which working Mocka
built Jacob (see `src/OberonTest/CTest/alldiffs` for the full picture, not
just `test.sh`'s own truncated summary):

* Two (`Oper03`, `Oper05`) fail with "Compiler Error: No executable
  created!" — the code generator emits `fild` without a size suffix and an
  invalid `decb %ax` register combination, both of which the original-era
  GNU assembler tolerated but a modern one rejects.
* Four (`Simple06`, `Simple07`, `Simple11`, `Oper02`) print `REAL`/
  `LONGREAL` values with different trailing digits than the reference
  output (e.g. `0.99999994039535522` vs. the reference's
  `0.99999994039535522460`) — a pre-existing floating-point formatting
  discrepancy, not a regression from any particular Mocka.

The front-end suite passes cleanly when Jacob is built with `Mocka0605`.
Built with the publicly-reproducible `Mocka_9903` (see Prerequisites), it
has one additional, `Mocka_9903`-specific regression: `LONGREAL` constants
lose precision during compile-time constant folding (`eaex001t.ob2`,
e.g. `-2.0` becomes `-1.9999997615814`) — a bug in that 1999 compiler
itself, not something this repo's build tooling can work around.
`checkof` treats this one file as a known, expected skip rather than a
failure, so `./test.sh of` still exits clean rather than reporting it.

### Compile and run an Oberon-2 program

```sh
./bin/oc yourprogram.ob2
./yourprogram
```

Two things that aren't obvious from the error messages if you hit them
writing your first test program:

* The module name must match the source filename (`MODULE hello;` needs to
  live in `hello.ob2`).
* Oberon-2 requires all `CONST`/`TYPE`/`VAR` declarations before any
  `PROCEDURE` declaration in a module — they can't be interleaved.

## Introduction

This is the second public release of our Oberon-2 compiler Jacob. Jacob (as
the name says ;-) is a stand-alone Oberon-2 compiler under Linux. It compiles a
single Oberon-2 module together with its imported modules and links all the
stuff together to an executable program whose name is the module name.

As the practical result of our diploma thesis, Jacob owes its existance from
the use of compiler generating tools: The front-end was generated with the
Compiler Construction Tool Box "Cocktail" (Version 9209) of Dr. J. Grosch. In
particular the tools Rex, Lalr, Puma, Ast and Ag were used. For the back-end we
used Beg (Version 1.75) of H. Emmelmann to produce GNU assembler code.

There is still a lot of debug code in Jacob so the execution speed is not
optimal. The various command-line options allows tracing of the compile phase
and looking at intermediate results which are often hidden within a compiler.

## Features

* Jacob implements the full Oberon-2 language as reported in "The
  Programming Language Oberon-2" (March 1995).
* External modules allow to write library modules in other Languages.
* Instead of an explicit dispose function a garbage collector is implemented
  using a mark-and-sweep algorithm.
* Command-line options for enabling and disabling NIL, index, range 
  and assertion checks.

## Implementation extensions/restrictions

* The underscore character is legal in identifiers.
* The maximum length of identifiers is 255.
* Procedures can be nested up to a maximum of 30.
* A type extension hierarchy can have a maximum depth of 8.
* The difference between the smallest and the largest case label may not be
  greater than 4096.
* SYSTEM.NEW is only valid for pointers which base type doesn't contain any
  pointer.

##Disclaimer

This software package is FREE, so you can do with it whatever is in your mind, 
BUT: whatever you do with this package, YOU are responsible and you do it ON
YOUR OWN RISK. This simply means we disclaim warranties of any kind.

Because of the early version of Jacob it is definitely possible that there are
bugs in the implementation. If you find one (or several) don't despair. Please
let us know about it (see section Bug Report below).

## Requirements

Jacob only requires the GNU assembler as. We use version 2.7
(i586-unknown-linux).

## Installation

Un-tar the package wherever you want (/usr is recommended).
This will result in the subdirectory tree:

> jacob
> jacob/lib
> jacob/sys
> jacob/test
   
If you decide to use a home directory other than /usr
you have to edit the script files oc and sys/oc.linker and
to adjust the directory specifications in these scripts.

Copy, move or link the script oc into a directory which is included
by your PATH environment variable.

To test your installation change the current work directory to 
jacob/test, compile the Test module by "oc Test". This will also
generate the object files of the library modules, if you have
write permissions to jacob/lib.

## Invocation

By typing jacob -h you get the usual description of the usage with a short
explanation of the available command-line options. 

Assembler and object files are written into the directory which
contains the source file.

## Library Modules

We have (up to now) implemented a (very) quick'n'dirty set of library modules. 
These are:

* Out      : output of some basic types
* Storage  : heap and garbage collector functions
* SysLib   : interface to the linux os
* RawFiles : basic file i/o
* Lib      : command-line arguments, random numbers and others
* Str      : string Handling

A more detailed description can be found at the end of this file.

## Bug Report

If you find an error in the implementation or you have comments regarding
Jacob, PLEASE send it to us. Help us to improve Jacob by sending e-mail to the
following address:
    
     sepp@cs.tu-berlin.de

It is useful to send a small example program which shows the bug.

## Future Work

As future work we plan:

* A hand-written front-end which is implemented using Jacob itself
* More sufficient library modules
* The use of symbol files to speed up the import stage
* An improved memory management especially a faster mark algorithm

## Changes from Version 0.1.1 to 0.2

* Scanner recognizes an identifier with a length greater 255 and
  emits an appropriate error message instead of dumping its core.
* Fixed this bug in the code generator which caused the message
  "Str.s:1104: Error: register does not match opcode suffix"
  when compiling lib/Str.ob2.
* source code is also available. 

## Changes from Version 0.1 to 0.1.1

## Changes from Version 0 to 0.1

* Jacob runs now as ELF executable and produces ELF output.
  * External modules (former "foreign" modules):
  * Changed syntax (with respect to the Oakwood Guidelines):
 
    <pre>
        Module      = MODULE ident ';' 
                      [ImportList] 
                      DeclSeq 
                      [BEGIN StatementSeq] END ident 
                    | XModule .
        ...
        XModule     = MODULE ident EXTERNAL '[' string ']' ';' 
                      [ImportList] 
                      XDeclSeq 
                      END ident '.' .
        XDeclSeq    = { CONST     {ConstDecl ';'} 
                      | TYPE      {TypeDecl  ';'} 
                      | VAR       {VarDecl   ';'}
                      | PROCEDURE IdentDef [XFormalPars] ';' 
                      } .
        XFormalPars = '(' [XFPSections] ')' [':' Qualident] .
        XFPSections = FPSection {';' FPSection} [';' '..'] .
     </pre>
 
     External modules are identified by the keyword EXTERNAL following the
     module's name. The following bracket-enclosed string will be passed
     unchanged to the linker.
     
     Constants, types, variables and procedures may be declared in any order.
     This allows grouping of types and functions which belong together,
     e.g. for writing interfaces for large libraries. Type-bound procedures
     aren't allowed.
     
     A procedure declaration consists only of the procedure header. The last
     formal parameter of a non-empty formal parameter list may be '..', in
     which case any non-empty actual parameter list starting at the 
     corresponding position is legal. 
   
  * Changed parameter passing mechanisms for external procedures:
    * No hidden parameters (type tags, array lengths) will be passed.
    * The following "objects" will be passed according the kind/type of
      the formal/actual parameter ('..' is treated like an open-array
      value parameter):
<pre>
formal parameter     | actual parameter         | passed object
===================================================================
variable parameter   | any                      | address of actual 
                     |                          | parameter
-------------------------------------------------------------------
non-open-array value | any                      | value of actual
parameter            |                          | parameter
-------------------------------------------------------------------
open-array value     | character constant;      | address of actual
parameter            | string constant; array   | parameter
-------------------------------------------------------------------
open-array value     | SYSTEM.BYTE; SYSTEM.PTR; | value of actual
parameter            | BOOLEAN; CHAR variable;  | parameter
                     | SET; integer type; real  |
                     | type; NIL; pointer,      |
                     | procedure or record type |
-------------------------------------------------------------------
..                   | character constant;      | address of actual
                     | string constant; array   | parameter
-------------------------------------------------------------------
..                   | SYSTEM.BYTE; SYSTEM.PTR; | value of actual
                     | BOOLEAN; CHAR variable;  | parameter
                     | SET; integer type; real  |
                     | type; NIL; pointer,      |
                     | procedure or record type |
---------------------+--------------------------+------------------
</pre>
 
  * External variables declarable and accessible.
  * There are no type descriptors for records.
  * If external procedures are assigned to procedure variables, the
    programmer should exactly know what (s)he's doing...
* Code improvements:
  * Displays in stack frames are more compact.
  * Jump optimization (not only) for boolean short-circuit.
* Improved memory handling at compile-time.
* New command line options.
* Various bug fixes:
  * Comparison of two function results with a real type.
  * Recompilation if a indirectly imported module is younger than
    the client module.
  * A SYSTEM.VAL at a variable parameter position gets now coded correctly.
  * ...
* Library modules:
  * argc, argv, env and errno now directly accessible through module SysLib.
