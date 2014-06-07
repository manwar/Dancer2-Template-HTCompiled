use strict;
use warnings;
use Test::More tests => 4;
use Data::Dumper;
use Dancer2::Template::HTCompiled;

my $path = File::Spec->catfile("t", "data");
my $htc = Dancer2::Template::HTCompiled->new(config => {
    path => $path,
    tagstyle => [qw/ +tt /],
});

my $template = "test.html";
my $param = {
    bar => 23
};
my $out = $htc->render($template, $param);
cmp_ok($out, '=~', qr{foo.*23}s, "render template file");
$htc->config({
    path => "data",
    location => "t",
    tagstyle => [qw/ +tt /],
});
$out = $htc->render($template, $param);
cmp_ok($out, '=~', qr{foo.*23}s, "render template file with location");

$template = "foo [%= bar %]";
$out = $htc->render(\$template, $param);
cmp_ok($out, '=~', qr{foo.*23}s, "render template string");

$template = "foo [%= bar ";
$out = eval {
    $htc->render(\$template, $param);
};
is($out, undef, "invalid template");

