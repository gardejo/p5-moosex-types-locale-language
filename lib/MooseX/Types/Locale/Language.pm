package MooseX::Types::Locale::Language;


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
        LanguageCode
        Alpha2Language
        LanguageName
    )],
    # (ISO 639-2 three letter codes comming soon...)
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
# private class variable(s)
# ****************************************************************

# Because language2code($_) cannot coerce 'japanese' to 'Japanese'.
my %alpha2;
@alpha2{ all_language_codes() } = ();

# my %bibliographic;
# @bibliographic{ all_language_codes(LOCALE_CODE_BIBLIOGRAPHIC) } = ();

# my %terminology;
# @terminology{ all_language_codes(LOCALE_CODE_TERMINOLOGY) } = ();

# Because code2language($_) cannot coerce 'JA' to 'ja'.
my %name;
@name{ all_language_names() } = ();


# ****************************************************************
# subtype(s) and coercion(s)
# ****************************************************************

# ----------------------------------------------------------------
# language code as defined in ISO 639-1 (alpha-2)
# ----------------------------------------------------------------
foreach my $subtype (LanguageCode, Alpha2Language) {
    subtype $subtype,
        as Str,
            where {
                exists $alpha2{$_};
            },
            message {
                "Validation failed for code failed with value ($_) because: " .
                "Specified language code does not exist in ISO 639-1";
            };

    coerce $subtype,
        from Str,
            via {
                # - Converts 'EN' into 'en'.
                # - ISO 639 recommended lower-case.
                return lc $_;
            };
}

# # ----------------------------------------------------------------
# # language code as defined in ISO 639-2 (alpha-3 bibliographic)
# # ----------------------------------------------------------------
# foreach my $subtype (Alpha3Language, BibliographicLanguage) {
#     subtype $subtype,
#         as Str,
#             where {
#                 exists $bibliographic{$_};
#             },
#             message {
#                 "Validation failed for code failed with value ($_) because: " .
#                 "Specified language code does not exist in ISO 639-2 " .
#                 "(bibliographic)";
#             };
# 
#     coerce $subtype,
#         from Str,
#             via {
#                 # Converts 'ENG' into 'eng'.
#                 return lc $_;
#             };
# }

# # ----------------------------------------------------------------
# # language code as defined in ISO 639-2 (alpha-3 terminology)
# # ----------------------------------------------------------------
# subtype TerminologyLanguage,
#     as Str,
#         where {
#             exists $terminology{$_};
#         },
#         message {
#             "Validation failed for code failed with value ($_) because: " .
#             "Specified language code does not exist in ISO 639-2 " .
#             "(terminology)";
#         };
# 
# coerce TerminologyLanguage,
#     from Str,
#         via {
#             # Converts 'ENG' into 'eng'.
#             return lc $_;
#         };

# ----------------------------------------------------------------
# language name as defined in ISO 639
# ----------------------------------------------------------------
subtype LanguageName,
    as Str,
        where {
            exists $name{$_};
        },
        message {
            "Validation failed for name failed with value ($_) because: " .
            "Specified language name does not exist in ISO 639";
        };

coerce LanguageName,
    from Str,
        via {
            # - Converts 'eNgLiSh' into 'English'.
            # - Cannot use 'ucfirst lc', because there is 'Rhaeto-Romance'.
            # - In case of invalid name, returns original $_
            #   to use it in exception message.
            return code2language( language2code($_) ) || $_;
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

MooseX::Types::Locale::Language - Locale::Language related constraints and coercions for Moose

=head1 SYNOPSIS

    {
        package Foo;

        use Moose;
        use MooseX::Types::Locale::Language qw(
            LanguageCode
            LanguageName
        );

        has 'code'
            => ( isa => LanguageCode, is => 'rw', coerce => 1 );
        has 'name'
            => ( isa => LanguageName, is => 'rw', coerce => 1 );

        __PACKAGE__->meta->make_immutable;
    }

    my $foo = Foo->new(
        code => 'JA',
        name => 'JAPANESE',
    );
    print $foo->code;   # 'ja'
    print $foo->name;   # 'Japanese'

=head1 DESCRIPTION

This module packages several L<Moose::Util::TypeConstraints> with coercions,
designed to work with the values of L<Locale::Language>.

=head1 CONSTRAINTS AND COERCIONS

=over 4

=item C<Alpha2Language>

A subtype of C<Str>, which should be defined in language code of ISO 639-1
alpha-2.
If you turned C<coerce> on, C<Str> will be lower-case.
For example, C<'JA'> will convert to C<'ja'>.

=item C<LanguageCode>

Alias of C<Alpha2Language>.

=item C<LanguageName>

A subtype of C<Str>, which should be defined in ISO 639-1 language name.
If you turned C<coerce> on, C<Str> will be same case as canonical name.
For example, C<'JAPANESE'> will convert to C<'Japanese'>.

=back

=head1 SEE ALSO

=over 4

=item * L<Locale::Language>

=item * L<MooseX::Types::Locale::Language::Fast>

=item * L<MooseX::Types::Locale::Country>

=back

=head1 INCOMPATIBILITIES

None reported.

=head1 TO DO

=over 4

=item * I will send patch on L<Locale::Language> to NEILB,
        to solve RT #11730. (The patch supports ISO 639-2 alpha-3
        bibliographic/terminology codes).
        cf. L<http://rt.cpan.org/Public/Bug/Display.html?id=11730>

=item * By doing this, this module will support ISO 639-2 alpha-3
        bibliographic/terminology codes.

=item * As necessary, L<Locale::Language> and this module may support
        ISO 639-3 alpha-3 codes (comprehensive coverage of language).

=back

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

    perldoc MooseX::Types::Locale::Language

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
