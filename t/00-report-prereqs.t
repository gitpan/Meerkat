#!perl

use strict;
use warnings;

# This test was generated by Dist::Zilla::Plugin::Test::ReportPrereqs 0.013

use Test::More tests => 1;

use ExtUtils::MakeMaker;
use File::Spec::Functions;
use List::Util qw/max/;
use version;

# hide optional CPAN::Meta modules from prereq scanner
# and check if they are available
my $cpan_meta = "CPAN::Meta";
my $cpan_meta_req = "CPAN::Meta::Requirements";
my $HAS_CPAN_META = eval "require $cpan_meta"; ## no critic
my $HAS_CPAN_META_REQ = eval "require $cpan_meta_req; $cpan_meta_req->VERSION('2.120900')";

# Verify requirements?
my $DO_VERIFY_PREREQS = 1;

sub _merge_requires {
    my ($collector, $prereqs) = @_;
    for my $phase ( qw/configure build test runtime develop/ ) {
        next unless exists $prereqs->{$phase};
        if ( my $req = $prereqs->{$phase}{'requires'} ) {
            my $cmr = CPAN::Meta::Requirements->from_string_hash( $req );
            $collector->add_requirements( $cmr );
        }
    }
}

my %include = map {; $_ => 1 } qw(

);

my %exclude = map {; $_ => 1 } qw(

);

# Add static prereqs to the included modules list
my $static_prereqs = do { my $x = {
       'configure' => {
                        'requires' => {
                                        'ExtUtils::MakeMaker' => '6.17'
                                      }
                      },
       'develop' => {
                      'requires' => {
                                      'Dist::Zilla' => '5.013',
                                      'Dist::Zilla::PluginBundle::DAGOLDEN' => '0.056',
                                      'File::Spec' => '0',
                                      'File::Temp' => '0',
                                      'IO::Handle' => '0',
                                      'IPC::Open3' => '0',
                                      'Pod::Coverage::TrustPod' => '0',
                                      'Test::CPAN::Meta' => '0',
                                      'Test::More' => '0',
                                      'Test::Pod' => '1.41',
                                      'Test::Pod::Coverage' => '1.08'
                                    }
                    },
       'runtime' => {
                      'requires' => {
                                      'Carp' => '0',
                                      'DateTime' => '0',
                                      'Module::Runtime' => '0',
                                      'MongoDB' => '0',
                                      'MongoDB::OID' => '0',
                                      'Moose' => '2',
                                      'Moose::Role' => '2',
                                      'MooseX::AttributeShortcuts' => '0',
                                      'MooseX::Role::Logger' => '0',
                                      'MooseX::Role::MongoDB' => '0.006',
                                      'MooseX::Storage' => '0',
                                      'MooseX::Storage::Engine' => '0',
                                      'MooseX::Types' => '0',
                                      'Scalar::Util' => '0',
                                      'Syntax::Keyword::Junction' => '0',
                                      'Try::Tiny' => '0',
                                      'Try::Tiny::Retry' => '0.002',
                                      'Type::Params' => '0',
                                      'Types::Standard' => '0',
                                      'aliased' => '0',
                                      'namespace::autoclean' => '0',
                                      'perl' => 'v5.10.0',
                                      'strict' => '0',
                                      'warnings' => '0'
                                    }
                    },
       'test' => {
                   'recommends' => {
                                     'CPAN::Meta' => '0',
                                     'CPAN::Meta::Requirements' => '2.120900'
                                   },
                   'requires' => {
                                   'Data::Faker' => '0',
                                   'DateTime::Tiny' => '0',
                                   'ExtUtils::MakeMaker' => '0',
                                   'File::Spec::Functions' => '0',
                                   'List::Util' => '0',
                                   'MooX::Types::MooseLike::Base' => '0',
                                   'Test::Deep' => '0',
                                   'Test::FailWarnings' => '0',
                                   'Test::Fatal' => '0',
                                   'Test::More' => '0',
                                   'Test::Requires' => '0',
                                   'Test::Roo' => '0',
                                   'Test::Roo::Role' => '0',
                                   'Time::HiRes' => '0',
                                   'lib' => '0',
                                   'version' => '0'
                                 }
                 }
     };
  $x;
 };

delete $static_prereqs->{develop} if not $ENV{AUTHOR_TESTING};
$include{$_} = 1 for map { keys %$_ } map { values %$_ } values %$static_prereqs;

# Merge requirements for major phases (if we can)
my $all_requires;
if ( $DO_VERIFY_PREREQS && $HAS_CPAN_META_REQ ) {
    $all_requires = $cpan_meta_req->new;
    _merge_requires($all_requires, $static_prereqs);
}


# Add dynamic prereqs to the included modules list (if we can)
my ($source) = grep { -f } 'MYMETA.json', 'MYMETA.yml';
if ( $source && $HAS_CPAN_META ) {
  if ( my $meta = eval { CPAN::Meta->load_file($source) } ) {
    my $dynamic_prereqs = $meta->prereqs;
    delete $dynamic_prereqs->{develop} if not $ENV{AUTHOR_TESTING};
    $include{$_} = 1 for map { keys %$_ } map { values %$_ } values %$dynamic_prereqs;

    if ( $DO_VERIFY_PREREQS && $HAS_CPAN_META_REQ ) {
        _merge_requires($all_requires, $dynamic_prereqs);
    }
  }
}
else {
  $source = 'static metadata';
}

my @modules = sort grep { ! $exclude{$_} } keys %include;
my @reports = [qw/Version Module/];
my @dep_errors;
my $req_hash = defined($all_requires) ? $all_requires->as_string_hash : {};

for my $mod ( @modules ) {
  next if $mod eq 'perl';
  my $file = $mod;
  $file =~ s{::}{/}g;
  $file .= ".pm";
  my ($prefix) = grep { -e catfile($_, $file) } @INC;
  if ( $prefix ) {
    my $ver = MM->parse_version( catfile($prefix, $file) );
    $ver = "undef" unless defined $ver; # Newer MM should do this anyway
    push @reports, [$ver, $mod];

    if ( $DO_VERIFY_PREREQS && $all_requires ) {
      my $req = $req_hash->{$mod};
      if ( defined $req && length $req ) {
        if ( ! defined eval { version->parse($ver) } ) {
          push @dep_errors, "$mod version '$ver' cannot be parsed (version '$req' required)";
        }
        elsif ( ! $all_requires->accepts_module( $mod => $ver ) ) {
          push @dep_errors, "$mod version '$ver' is not in required range '$req'";
        }
      }
    }

  }
  else {
    push @reports, ["missing", $mod];

    if ( $DO_VERIFY_PREREQS && $all_requires ) {
      my $req = $req_hash->{$mod};
      if ( defined $req && length $req ) {
        push @dep_errors, "$mod is not installed (version '$req' required)";
      }
    }
  }
}

if ( @reports ) {
  my $vl = max map { length $_->[0] } @reports;
  my $ml = max map { length $_->[1] } @reports;
  splice @reports, 1, 0, ["-" x $vl, "-" x $ml];
  diag "\nVersions for all modules listed in $source (including optional ones):\n",
    map {sprintf("  %*s %*s\n",$vl,$_->[0],-$ml,$_->[1])} @reports;
}

if ( @dep_errors ) {
  diag join("\n",
    "\n*** WARNING WARNING WARNING WARNING WARNING WARNING WARNING WARNING ***\n",
    "The following REQUIRED prerequisites were not satisfied:\n",
    @dep_errors,
    "\n"
  );
}

pass;

# vim: ts=4 sts=4 sw=4 et:
