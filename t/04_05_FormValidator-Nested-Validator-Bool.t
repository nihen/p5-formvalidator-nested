use strict;
use Test::More tests => 6;

use FormValidator::Nested;
use FormValidator::Nested::ProfileProvider::YAML;
use Class::Param;

use utf8;

my ($fvt, $res, @error_params);

$fvt = FormValidator::Nested->new({
    profile_provider => FormValidator::Nested::ProfileProvider::YAML->new({
        dir => 't/var/profile',
    }),
});

{ # bool
    check({
        valid_flg => '1',
    }, 'validator/bool', 0);
    check({
        valid_flg => '0',
    }, 'validator/bool', 0);
    check({
        valid_flg => '01',
    }, 'validator/bool', 1, 'valid_flg', '状態の入力形式が正しくありません');
    check({
        valid_flg => 'a',
    }, 'validator/bool', 1, 'valid_flg', '状態の入力形式が正しくありません');
}


sub check {
    my ($param, $key, $error, $param_name, $msg) = @_;

    $res = $fvt->validate(Class::Param->new($param), $key);

    is $res->has_error => $error;

    my $error_params = $res->error_params;

    if ( $error ) {
        is $error_params->{$param_name}->[0]->msg => $msg;
    }
}
