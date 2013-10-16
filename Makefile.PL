
use strict;
use warnings;

use 5.010000;

use ExtUtils::MakeMaker 6.17;



my %WriteMakefileArgs = (
  "ABSTRACT" => "Manage MongoDB documents as Moose objects",
  "AUTHOR" => "David Golden <dagolden\@cpan.org>",
  "BUILD_REQUIRES" => {},
  "CONFIGURE_REQUIRES" => {
    "ExtUtils::MakeMaker" => "6.17"
  },
  "DISTNAME" => "Meerkat",
  "EXE_FILES" => [],
  "LICENSE" => "apache",
  "NAME" => "Meerkat",
  "PREREQ_PM" => {
    "Carp" => 0,
    "DateTime" => 0,
    "Module::Runtime" => 0,
    "MongoDB" => 0,
    "MongoDB::OID" => 0,
    "Moose" => 2,
    "Moose::Role" => 2,
    "MooseX::AttributeShortcuts" => 0,
    "MooseX::Role::Logger" => 0,
    "MooseX::Role::MongoDB" => "0.002",
    "MooseX::Storage" => 0,
    "MooseX::Storage::Engine" => 0,
    "MooseX::Types" => 0,
    "Scalar::Util" => 0,
    "Syntax::Keyword::Junction" => 0,
    "Try::Tiny" => 0,
    "Type::Params" => 0,
    "Types::Standard" => 0,
    "aliased" => 0,
    "namespace::autoclean" => 0,
    "strict" => 0,
    "warnings" => 0
  },
  "TEST_REQUIRES" => {
    "Data::Faker" => 0,
    "DateTime::Tiny" => 0,
    "ExtUtils::MakeMaker" => 0,
    "File::Spec::Functions" => 0,
    "List::Util" => 0,
    "MooX::Types::MooseLike::Base" => 0,
    "Test::Deep" => 0,
    "Test::FailWarnings" => 0,
    "Test::Fatal" => 0,
    "Test::More" => 0,
    "Test::Requires" => 0,
    "Test::Roo" => 0,
    "Test::Roo::Role" => 0,
    "Time::HiRes" => 0,
    "lib" => 0
  },
  "VERSION" => "0.006",
  "test" => {
    "TESTS" => "t/*.t"
  }
);


unless ( eval { ExtUtils::MakeMaker->VERSION(6.63_03) } ) {
  my $tr = delete $WriteMakefileArgs{TEST_REQUIRES};
  my $br = $WriteMakefileArgs{BUILD_REQUIRES};
  for my $mod ( keys %$tr ) {
    if ( exists $br->{$mod} ) {
      $br->{$mod} = $tr->{$mod} if $tr->{$mod} > $br->{$mod};
    }
    else {
      $br->{$mod} = $tr->{$mod};
    }
  }
}

unless ( eval { ExtUtils::MakeMaker->VERSION(6.56) } ) {
  my $br = delete $WriteMakefileArgs{BUILD_REQUIRES};
  my $pp = $WriteMakefileArgs{PREREQ_PM};
  for my $mod ( keys %$br ) {
    if ( exists $pp->{$mod} ) {
      $pp->{$mod} = $br->{$mod} if $br->{$mod} > $pp->{$mod};
    }
    else {
      $pp->{$mod} = $br->{$mod};
    }
  }
}

delete $WriteMakefileArgs{CONFIGURE_REQUIRES}
  unless eval { ExtUtils::MakeMaker->VERSION(6.52) };

WriteMakefile(%WriteMakefileArgs);



