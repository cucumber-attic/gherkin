requires "Cpanel::JSON::XS";
requires "Class::XSAccessor";
requires "IO::Scalar";

on 'test' => sub {
    requires "Path::Class";
    requires "Test::Differences";
    requires "Test::Exception";
    requires "Test::More";
};

on 'develop' => sub {
    requires "Config::INI::Reader";
    requires "CPAN::Changes";
    requires "Dist::Zilla";
    requires "Dist::Zilla::Plugin::Git::GatherDir";
    requires "Dist::Zilla::Plugin::Prereqs::FromCPANfile";
    requires "Dist::Zilla::Plugin::Test::UseAllModules";
};