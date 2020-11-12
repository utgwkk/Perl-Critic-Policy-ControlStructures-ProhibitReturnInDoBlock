package Perl::Critic::Policy::ControlStructures::ProhibitReturnInDoBlock;
use 5.008001;
use strict;
use warnings;
use parent 'Perl::Critic::Policy';
use List::Util qw(any);
use Perl::Critic::Utils qw(:severities);
use constant DESC => '`return` statement in `do` block';
use constant EXPL => 'A `return` in `do` block causes confusing behavior. Do not use it.';

our $VERSION = "0.01";

sub supported_parameters { return (); }
sub default_severity     { return $SEVERITY_HIGHEST; }
sub default_themes       { return qw(core bugs); }
sub applies_to           { return 'PPI::Structure::Block'; }

sub violates {
    my ($self, $elem, undef) = @_;

    return if !_is_do_block($elem);

    my @stmts = $elem->schildren;
    return if !@stmts;

    for my $stmt (@stmts) {
        return $self->violation(DESC, EXPL, $stmt) if _is_return($stmt);
    }

    return;
}

sub _is_do_block {
    my ($elem) = @_;

    return 0 if !$elem->sprevious_sibling;
    return $elem->sprevious_sibling->content eq 'do';
}

sub _is_return {
    my ($stmt) = @_;

    return any { $_->content eq 'return' } $stmt->schildren;
}

1;
__END__

=encoding utf-8

=head1 NAME

Perl::Critic::Policy::ControlStructures::ProhibitReturnInDoBlock - It's new $module

=head1 SYNOPSIS

    use Perl::Critic::Policy::ControlStructures::ProhibitReturnInDoBlock;

=head1 DESCRIPTION

Perl::Critic::Policy::ControlStructures::ProhibitReturnInDoBlock is ...

=head1 LICENSE

Copyright (C) utgwkk.

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

utgwkk E<lt>utagawakiki@gmail.comE<gt>

=cut

