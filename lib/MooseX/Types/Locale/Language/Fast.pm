package MooseX::Types::Locale::Language::Fast;


# ****************************************************************
# general dependence(-ies)
# ****************************************************************

use 5.008_001;
use Locale::Language;
use MooseX::Types::Moose qw(
    Str
);
use MooseX::Types (
    -declare => [qw(
        LanguageName
        LanguageCode
    )],
);


# ****************************************************************
# namespace clearer
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public class variable(s)
# ****************************************************************

our $VERSION = "0.000";


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# language code as defined in ISO 639-1
# ----------------------------------------------------------------
subtype LanguageCode,
    as Str,
        where {
            code2language($_);
        },
        message {
            "Validation failed for code failed with value ($_) because: " .
            "Specified language code does not exist in ISO 639-1";
        };

# ----------------------------------------------------------------
# language name as defined in ISO 639-1
# ----------------------------------------------------------------
subtype LanguageName,
    as Str,
        where {
            language2code($_);
        },
        message {
            "Validation failed for name failed with value ($_) because: " .
            "Specified language name does not exist in ISO 639-1";
        };


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

MooseX::Types::Locale::Language::Fast - Locale::Language related constraints for Moose (without coercions)

=head1 SYNOPSIS

    {
        package Foo;

        use Moose;
        use MooseX::Types::Locale qw(
            LanguageCode
            LanguageName
        );

        has 'code' => (
            isa         => LanguageCode,
            is          => 'rw',
        );

        has 'name' => (
            isa         => LanguageName,
            is          => 'rw',
        );

        __PACKAGE__->meta->make_immutable;
    }

    my $foo = Foo->new(
        code => 'JA',
        name => 'JAPANESE',
    );
    print $foo->code;   # 'JA' (not 'ja')
    print $foo->name;   # 'JAPANESE' (not 'Japanese')


=head1 DESCRIPTION

This module packages several L<Moose::Util::TypeConstraints>,
designed to work with the values of L<Locale::Language>.

This module does not provide coercions.
Therefore, it works faster than L<MooseX::Types::Locale::Language>.

=head1 CONSTRAINTS

=over 4

=item C<LanguageCode>

A subtype of C<Str>, which should be defined in ISO 639-1 language code.

=item C<LanguageName>

A subtype of C<Str>, which should be defined in ISO 639-1 language name.

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language>

=item * L<MooseX::Types::Locale::Language>

=item * L<MooseX::Types::Locale::Country::Fast>

=back

=head1 VERSION CONTROL

This module is maintained using git.
You can get the latest version from
L<git://github.com/gardejo/p5-moosex-types-locale-language.git>.

=head1 AUTHOR

=over 4

=item MORIYA Masaki ("Gardejo")

C<< <moriya at ermitejo dot com> >>,
L<http://ttt.ermitejo.com/>

=back

=head1 COPYRIGHT

Copyright (c) 2009 by MORIYA Masaki ("Gardejo"),
L<http://ttt.ermitejo.com>.

This library is free software;
you can redistribute it and/or modify it under the same terms as Perl itself.
See L<perlgpl> and L<perlartistic>.

=cut
