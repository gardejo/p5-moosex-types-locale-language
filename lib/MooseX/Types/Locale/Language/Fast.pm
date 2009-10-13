package MooseX::Types::Locale::Language::Fast;


# ****************************************************************
# general dependency(-ies)
# ****************************************************************

use 5.008_001;
# MooseX::Types turns strict/warnings pragmas on,
# however, kwalitee can not detect such mechanism.
# (Perl::Critic can it, with equivalent_modules parameter)
use strict;
use warnings;

use Locale::Language;
use MooseX::Types::Moose qw(
    Str
);
use MooseX::Types (
    -declare => [qw(
        LanguageName
        Alpha2Language
        LanguageCode
    )],
    # (ISO 639-2/3 three letter codes comming soon...)
    # BibliographicLanguage = Alpha3Language
    # TerminologyLanguage
);


# ****************************************************************
# namespace clearer
# ****************************************************************

use namespace::clean;


# ****************************************************************
# public class variable(s)
# ****************************************************************

our $VERSION = "0.003";


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# language code as defined in ISO 639-1
# ----------------------------------------------------------------
foreach my $subtype (LanguageCode, Alpha2Language) {
    subtype $subtype,
        as Str,
            where {
                code2language($_);
            },
            message {
                "Validation failed for code failed with value ($_) because: " .
                "Specified language code does not exist in ISO 639-1";
            };
}

# # ----------------------------------------------------------------
# # language code as defined in ISO 639-2 (alpha-3 bibliographic)
# # ----------------------------------------------------------------
# foreach my $subtype (Alpha3Language, BibliographicLanguage) {
#     subtype $subtype,
#         as Str,
#             where {
#                 code2language($_, LOCALE_CODE_BIBLIOGRAPHIC);
#             },
#             message {
#                 "Validation failed for code failed with value ($_) because: " .
#                 "Specified language code does not exist in ISO 639-2/3 " .
#                 "(bibliographic)";
#             };
# }

# # ----------------------------------------------------------------
# # language code as defined in ISO 639-2 (alpha-3 terminology)
# # ----------------------------------------------------------------
# subtype TerminologyLanguage,
#     as Str,
#         where {
#                 code2language($_, LOCALE_CODE_TERMINOLOGY);
#         },
#         message {
#             "Validation failed for code failed with value ($_) because: " .
#             "Specified language code does not exist in ISO 639-2/3 " .
#             "(terminology)";
#         };

# ----------------------------------------------------------------
# language name as defined in ISO 639
# ----------------------------------------------------------------
subtype LanguageName,
    as Str,
        where {
            language2code($_);
        },
        message {
            "Validation failed for name failed with value ($_) because: " .
            "Specified language name does not exist in ISO 639";
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
        use MooseX::Types::Locale::Language qw(
            LanguageCode
            LanguageName
        );

        has 'code'
            => ( isa => LanguageCode, is => 'rw' );
        has 'name'
            => ( isa => LanguageName, is => 'rw' );

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

=item C<Alpha2Language>

A subtype of C<Str>, which should be defined in language code of ISO 639-1
alpha-2.

=item C<LanguageCode>

Alias of C<Alpha2Language>.

=item C<LanguageName>

A subtype of C<Str>, which should be defined in ISO 639-1 language name.

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language>

=item * L<MooseX::Types::Locale::Language>

=item * L<MooseX::Types::Locale::Country::Fast>

=back

=head1 TO DO

See L<TO DO section of MooseX::Types::Locale::Language|MooseX::Types::Locale::Language/TO_DO>.

=head1 INCOMPATIBILITIES

None reported.

=head1 BUGS AND LIMITATIONS

No bugs have been reported.

=head2 Making suggestions and reporting bugs

Please report any found bugs, feature requests, and ideas for improvements
to C<bug-moosex-types-locale-language at rt.cpan.org>,
or through the web interface
at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=MooseX-Types-Locale-Language>.
I will be notified, and then you'll automatically be notified of progress
on your bugs/requests as I make changes.

When reporting bugs, if possible,
please add as small a sample as you can make of the code
that produces the bug.
And of course, suggestions and patches are welcome.

=head1 SUPPORT

You can find documentation for this module with the C<perldoc> command.

    perldoc MooseX::Types::Locale::Language::Fast

You can also look for information at:

=over 4

=item RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=MooseX-Types-Locale-Language>

=item AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/MooseX-Types-Locale-Language>

=item Search CPAN

L<http://search.cpan.org/dist/MooseX-Types-Locale-Language>

=item CPAN Ratings

L<http://cpanratings.perl.org/d/MooseX-Types-Locale-Language>

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
