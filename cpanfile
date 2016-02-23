requires "Cpanel::JSON::XS";
requires "Class::XSAccessor";
requires "IO::Scalar";

on 'test' => sub {
    requires "Test::More";
    requires "Test::Differences";
    requires "Test::Exception";
};

on 'develop' => sub {
    requires "Dist::Zilla";
    requires "Dist::Zilla::Plugin::Prereqs::FromCPANfile";
    requires "Dist::Zilla::Plugin::Test::UseAllModules";
};