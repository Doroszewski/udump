#!/usr/bin/perl

use Getopt::Long qw(:config bundling);
use Term::ANSIColor;
use Unicode::UCD 'charinfo';
use open qw(:std :utf8);
use utf8;
use v5.36;

### KOLORY
my $colors   = 1;
my $c_code   = 'bright_black';
my $c_char   = 'bold white';
my $c_char_d = 'bright_black';
my $c_name   = 'white';
my $c_block  = 'bright_black';
my $help     = undef;
my $version  = undef;

GetOptions(
  'colors!' => \$colors,
  'help'    => \$help,
  'version' => \$version
);


my $help_text  = <<HEREDOC;
This program gives basic information on every Unicode character in the input.

  $0 [options] [files ...]

Options:
  -c, --colors               enable colors
      --nocolors             disable colors
      --help                 show this help
      --version              show version information
HEREDOC

my $version_text = <<HEREDOC;
udump.pl 0.8
2023, Piotr Doroszewski
HEREDOC

if ($help) {
  print $help_text;
  exit 0;
}
if ($version) {
  print $version_text;
  exit 0;
}


sub c ($t, $c) {
  if ($colors) {
    return colored($t, $c);
  } else {
    return $t;
  }
}

sub line($code, $char, $name, $block, $dim=undef) {
   my $line = '';
   $line .= c($code, $c_code);
   $line .= (' ' x (10-length($code)));
   if ($dim) {
     $line .= c($char, $c_char_d);
   } else {
     $line .= c($char, $c_char);
   }
   $line .= (' ' x (5-length($char)));
   $line .= c($name, $c_name);
   $line .= (' ' x (40-length($name)));
   $line .= c($block, $c_block);
   return $line;
}

while (<>) {
  foreach (split(//)) {
    my %charinfo = %{charinfo(ord)};
    my $number   = sprintf("U+%04X", ord);
    my $name     = $charinfo{name};
    my $block    = $charinfo{block};
    my $category = $charinfo{category};
    my $x        = $_;
    my $dim      = undef;
    if ($name eq '<control>') {
      $name = $charinfo{unicode10};
      $x = ((ord($_) < 128) ? chr(ord($_) + 0x2400) : ' ');
      $dim  = 1;
    }
    if ($category eq 'Cf' ||
        $category eq 'Cs' ||
        $category eq 'Co' ||
        $category eq 'Cn') {
      $x    = ' ';
      $dim  = 1;
    }

    say line($number, $x, $name, $block, $dim);
  }
}

# HISTORIA ZMIAN
# --------------
# * 2023-11-24 – +zastępowanie znaków kontrolnych z ASCII odpowiednikiem
#                graficznym, a reszty spacją
# * 2023-10-07 – -wymóg pakietu utf8::all, naprawa --nocolors
# * 2023-01-24 – reorganizacja kodu
# * 2022-11-24 – dodano obsługę kolorów
# * 2018-12-06 – +utf8::all; bezpośrednie użycie ␊ w kodzie zamiast \x
# * 2018-10-13 – drobna poprawka: znak LF jest wyświetlany jako ␊, nie ␤
# * 2018-08-15 – pierwsza wersja
