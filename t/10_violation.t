use Test2::V0;
use Perl::Critic;
use Perl::Critic::Policy::ControlStructures::ProhibitReturnInDoBlock;

my @testcases = (
    {
        description => 'single violation',
        filename    => 't/data/single.pl',
        expected    => array {
            item object {
                call description   => '`return` statement in `do` block';
                call line_number   => 8;
                call column_number => 9;
            };
            end;
        },
    },
    {
        description => 'anonymous subroutine call is OK',
        filename    => 't/data/anonymous-subroutine-call.pl',
        expected    => [],
    },
);

for my $testcase (@testcases) {
    my $code = do {
        open my $fh, '<', $testcase->{filename} or die "Cannot open $testcase->{filename}: $!";
        local $/;
        <$fh>;
    };
    my $critic = Perl::Critic->new(
        '-single-policy' => 'ControlStructures::ProhibitReturnInDoBlock',
    );
    my @violations = $critic->critique( \$code );

    is \@violations, $testcase->{expected}, $testcase->{description};
}

done_testing;
