# == Class: openssl::packages
#
# Sets up packages for openssl
class openssl::packages {
  assert_private()

  if $openssl::package_name {
    package { 'openssl':
      ensure => $openssl::package_ensure,
      name   => $openssl::package_name,
    }
  }

  if $facts['os']['family'] == 'Debian' or (
  $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['full'], '6.0') >= 0) {
    ensure_packages(['ca-certificates'], {
        ensure => $openssl::ca_certificates_ensure,
    })

    if $facts['os']['family'] == 'Debian' {
      exec { 'update-ca-certificates':
        path        => $::path,
        refreshonly => true,
        require     => Package['ca-certificates'],
      }
    }
  }
}
