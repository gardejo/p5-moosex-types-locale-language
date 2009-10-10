package Test::MooseX::Types::Locale::Language::Base;


# ****************************************************************
# pragma(s)
# ****************************************************************

use strict;
use warnings;


# ****************************************************************
# superclass(es)
# ****************************************************************

use base qw(
    Test::Class
);


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use Test::Exception;
use Test::More;


# ****************************************************************
# test(s)
# ****************************************************************

sub test_new : Tests(3) {
    my $self = shift;

    my $mock_class = $self->mock_class;

    $self->test_constraint($mock_class);
    $self->test_exceptions_of_constraints($mock_class);

    return;
}


# ****************************************************************
# test snippet(s)
# ****************************************************************

sub test_constraint {
    my ($self, $mock_class) = @_;

    ok $mock_class->new(
        code => 'ja',
        name => 'Japanese',
    ) => 'Instantiated object using export types';

    return;
}

sub test_exceptions_of_constraints {
    my ($self, $mock_class) = @_;

    throws_ok {
        $mock_class->new( code => 'junk!!' )
    } qr{language code .+ ISO 639-1},
        => 'Constraint of code';

    throws_ok {
        $mock_class->new( name => 'junk!!' )
    } qr{language name .+ ISO 639-1},
        => 'Constraint of name';

    return;
}

sub test_coercion_for_code {
    my ($self, $mock_instance, $from, $to) = @_;

    $self->_test_coercion_for('code', $mock_instance, $from, $to);

    return;
}

sub test_coercion_for_name {
    my ($self, $mock_instance, $from, $to) = @_;

    $self->_test_coercion_for('name', $mock_instance, $from, $to);

    return;
}


# ****************************************************************
# other method(s)
# ****************************************************************

sub mock_class {
    return 'Foo';
}

sub mock_instance {
    my $self = shift;

    my $mock_class = $self->mock_class;

    return $mock_class->new(@_);
}

sub _test_coercion_for {
    my ($self, $attribute, $mock_instance, $from, $to) = @_;

    $mock_instance->$attribute($from);

    if (defined $to) {
        ok $mock_instance->$attribute eq $to
            => "Coercion of ($attribute)";
    }
    else {
        ok $mock_instance->$attribute eq $from
            => "Coercion of ($attribute) does not work";
    }

    return;
}


# ****************************************************************
# return true
# ****************************************************************

1;
__END__


# ****************************************************************
# POD
# ****************************************************************

=pod

=head1 NAME

Test::MooseX::Types::Locale::Language::Base - Testing baseclass for MooseX::Types::Locale::Language::*

=head1 SYNOPSIS

    package Test::MooseX::Types::Locale::Language;

    use base qw(
        Test::MooseX::Types::Locale::Language::Base
    );

    # ...

=head1 DESCRIPTION

This module tests L<MooseX::Types::Locale::Language> and
L<MooseX::Types::Locale::Language::Fast>.

=head1 AUTHOR

=over 4

=item MORIYA Masaki ("Gardejo")

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright (c) 2009 by MORIYA Masaki ("Gardejo"),
L<http://ttt.ermitejo.com>.

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl> and L<perlartistic>.

=cut
