package Data::IEEE754;

use strict;
use warnings;
use utf8;

use Config;

use Exporter qw( import );

our @EXPORT_OK = qw(
    pack_double_be
    pack_float_be
    unpack_double_be
    unpack_float_be
);

# This code is all copied from Data::MessagePack::PP by Makamaka
# Hannyaharamitu, and was then tweaked by Dave Rolsky. Blame Dave for the
# bugs.
#
# Perl 5.10 introduced the ">" and "<" modifiers for pack which can be used to
# force a specific endianness.
if ( $] < 5.010 ) {
    my $bo_is_le = ( $Config{byteorder} =~ /^1234/ );

    if ($bo_is_le) {
        *pack_float_be = sub {
            return pack( 'N1', unpack( 'V1', pack( 'f', $_[0] ) ) );
        };
        *pack_double_be = sub {
            my @v = unpack( 'V2', pack( 'd', $_[0] ) );
            return pack( 'N2', @v[ 1, 0 ] );
        };

        *unpack_float_be = sub {
            my @v = unpack( 'v2', $_[0] );
            return unpack( 'f', pack( 'n2', @v[ 1, 0 ] ) );
        };
        *unpack_double_be = sub {
            my @v = unpack( 'V2', $_[0] );
            return unpack( 'd', pack( 'N2', @v[ 1, 0 ] ) );
        };
    }
    else {    # big endian
        *pack_float_be = sub {
            return pack 'f', $_[0];
        };
        *pack_double_be = sub {
            return pack 'd', $_[0];
        };

        *unpack_float_be
            = sub { return unpack( 'f', $_[0] ); };
        *unpack_double_be
            = sub { return unpack( 'd', $_[0] ); };
    }
}
else {
    *pack_float_be = sub {
        return pack 'f>', $_[0];
    };
    *pack_double_be = sub {
        return pack 'd>', $_[0];
    };

    *unpack_float_be = sub {
        return unpack( 'f>', $_[0] );
    };
    *unpack_double_be = sub {
        return unpack( 'd>', $_[0] );
    };
}

1;
