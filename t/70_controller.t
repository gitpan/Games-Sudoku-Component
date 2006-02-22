use strict;
use warnings;
use Test::More;

# If you want to see the outputs, set to 1.
my $Verbose = 0;

use Games::Sudoku::Component::Controller;

my ($c, $c2, $c3);
my @tests;

# These tests will be always executed.

@tests = (

  sub {
    $c = Games::Sudoku::Component::Controller->new;
    ok(ref $c eq 'Games::Sudoku::Component::Controller');
  },
  sub {
    ok($c->table->size == 9);
  },

  sub {
    $c2 = Games::Sudoku::Component::Controller->new(
      size => 16,
    );
    ok(ref $c2 eq 'Games::Sudoku::Component::Controller');
  },
  sub {
    ok($c2->table->size == 16);
  },

  sub {
    $c3 = Games::Sudoku::Component::Controller->new(
      block_width  => 2,
      block_height => 3,
    );
    ok(ref $c3 eq 'Games::Sudoku::Component::Controller');
  },
  sub {
    ok($c3->table->size == 6);
  },

  sub {
    diag "Tests hereafter may take minutes";
    $c->solve;
    if ($Verbose) {
      diag("\n(9x9)\n".$c->table->as_string);
    }
    ok(1);
  },

  sub {
    my $pzl = $c3->table->as_string;
    $c3->solve;
    if ($Verbose) {
      diag("\n(6x6)\n".$c3->table->as_string);
    }

    $c3->rewind;
    if ($Verbose) {
      diag("\n(6x6) rewinded one\n".$c3->table->as_string);
    }

    $c3->rewind_all;
    if ($Verbose) {
      diag("\n(6x6) rewinded all\n".$c3->table->as_string);
    }
    ok($pzl eq $c3->table->as_string);
  },

  sub {
    $c3->solve;
    $c3->make_blank(20);
    $c3->history->clear;
    my $pzl = $c3->table->as_string;
    if ($Verbose) {
      diag("\n(6x6) create a new puzzle\n".$c3->table->as_string);
    }

    $c3->solve;
    if ($Verbose) {
      diag("\n(6x6) solved\n".$c3->table->as_string);
    }

    $c3->rewind_all;
    if ($Verbose) {
      diag("\n(6x6) rewinded all\n".$c3->table->as_string);
    }
    ok($pzl eq $c3->table->as_string);
  },
);

# We have some exception tests.

eval "use Test::Exception";
unless ($@) {
  push @tests, (

  );
}

plan tests => scalar @tests;

foreach my $cest (@tests) { $cest->(); }
