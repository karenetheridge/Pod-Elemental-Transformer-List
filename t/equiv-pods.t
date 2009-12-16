#!perl
use strict;
use warnings;

use Test::More 'no_plan';

use Pod::Elemental;
use Pod::Elemental::Transformer::Pod5;
use Pod::Elemental::Transformer::List;

my $pod5 = Pod::Elemental::Transformer::Pod5->new;
my $list = Pod::Elemental::Transformer::List->new;

sub list_is {
  my ($input, $want) = @_;
  my $doc = Pod::Elemental->read_string($input);
  $pod5->transform_node($doc);
  $list->transform_node($doc);
  is($doc->as_pod_string, $want);
}

list_is(<<'IN_POD', <<'OUT_POD');

=for list
* foo
* bar
* baz

IN_POD

=over 4

=item *

foo

=item *

bar

=item *

baz

=back

OUT_POD

__END__
=begin list

* foo
* bar
* baz

=end list

--------------------------

=begin list

* foo

* bar

* baz

=end list

--------------------------

=for list
1. foo
2. bar
3. baz

=for list
1. foo
1. bar
1. baz

=for list
1. foo
   Foo is an important aspect of foo.  It really is.
2. bar
3. baz
   Baz is also important, but compared to Foo, Baz isn't even Bar.

--------------------------

It's important to realize that in this example, C<1. foo> makes the C<=item>
and then a standalone "foo" paragraph.  The rest of the content until the next
bullet becomes a single paragraph.

=for list
1. foo
Foo is an important aspect of L<Foo::Bar>.  It really is.
It's hard to explain I<just> how important.
2. bar
3. baz
Baz is also important, but compared to Foo, Baz isn't even Bar.

--------------------------

=begin list

1. foo

Foo is an important aspect of foo.

2. bar

Bar is also important, and takes options:

=begin list

= height

It's supplied in in pixels.

= width

It's supplied in inches.

And those are all of them.

=end list

3. baz

Reasons why Baz is important:

=for list
* it's delicious like L<Net::Delicious>
* it's nutritious
* it's seditious

=for list
= bananas
Yellow with a peel.
= Banderas
Fellow with appeal.

--------------------------

# OVERKILL, BUT AMUSING TO LOOK AT:

=begin list

1. foo

    Foo is an important aspect of foo.

2. bar

    Bar is also important, and takes options:

    = height

       It's supplied in in pixels.

    = width

       It's supplied in inches.

    And those are all of them.

3. baz

    Reasons why Baz is important:

    * it's delicious like L<Net::Delicious>
    * it's nutritious
    * it's seditious


