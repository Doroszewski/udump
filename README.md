udump.pl – Unicode dump, a Perl script.
=======================================

This is a little personal tool of mine. I use it when I need to debug my scripts
which deal with text in various ways. I release it publicly, as it may become
useful for someone else.

It gives very basic information on every Unicode character in the input, be it
`stdin`, a file or a set of files.

Usage
-----
The whole script is just a single Perl file. It should work with a default Perl
installation, no additional modules are needed.

If no arguments are passed, the standard input is analyzed. This is very useful
in pipes and that's the main way I use the script. Alternatively, filenames can
be given.

Things to do
------------
The tool is not finished yet. It should also:
* treat combining characters properly;
* treat all control characters properly (have I missed some?);
* recognize light terminal themes;
* do something else maybe?
