# Class: msmtp::params
#
# This class defines default parameters used by the main module class msmtp
# Operating Systems differences in names and paths are addressed here
#
# == Variables
#
# Refer to msmtp class for the variables defined here.
#
# == Usage
#
# This class is not intended to be used directly.
# It may be imported or inherited by other classes
#
class msmtp::params {

  $smarthost = 'mail'
  $port = ''
  $timeout = ''
  $protocol = ''
  $auth = ''
  $user = ''
  $password = ''
  $tls = ''
  $tls_trust_file = ''
  $tls_starttls = ''

  $domain = $::domain
  $maildomain = $::domain

  $auto_from = ''

  $from = "$::fqdn@${::domain}"
  $defaultalias = "hostmaster@${::domain}"


  $aliases = $::osfamily ? {
    default => '/etc/aliases',
  }

  $log_facility = 'LOG_MAIL'

  ### Application related parameters

  $package = $::osfamily ? {
    'Debian' => 'msmtp-mta',
    default  => 'msmtp',
  }

  $config_file = $::osfamily ? {
    default => '/etc/msmtprc',
  }

  $config_file_mode = $::osfamily ? {
    default => '0644',
  }

  $config_file_owner = $::osfamily ? {
    default => 'root',
  }

  $config_file_group = $::osfamily ? {
    default => 'root',
  }

  # General Settings
  $my_class = ''
  $source = ''
  $template = 'msmtp/msmtprc.erb'
  $options = ''
  $version = 'present'
  $absent = false
  $audit_only = false
  $noops = false
}
