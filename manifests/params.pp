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
 
  # This hack is used instead of the domainname fact, as this is often from on boxes with more than 2 dots in the fqdn
  $domain = inline_template('<%= fqdn.split(".")[-2,2].join(".") %>')
  $from = "$::fqdn@$domain"
  $defaultalias = "hostmaster@$domain"

  $aliases = $::osfamily ? {
    default => '/etc/aliases',
  }

  ### Application related parameters

  $package = $::osfamily ? {
    'Debian' => 'msmtp-mta',
    default => 'msmtp',
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
