# = Class: msmtp
#
# This is the main msmtp class
#
#
# == Parameters
#
# Standard class parameters
# Define the general class behaviour and customizations
#
# [*smarthost*]
#   Hostname of the SMTP smarthost to be used.
#   Defaults to 'mail'.
#
# [*from*]
#   Envelope-From to enforce on all outgoing mail.
#   Defaults to "$::fqdn@$domain"
#
# [*defaultalias*]
#   E-mail adres to receive all local mail. For cron messages, etc.
#   Defaults to "hostmaster@$domain"
#
# [*aliases*]
#   Path to aliases-file. 
#   Defaults to '/etc/aliases'
#
# [*my_class*]
#   Name of a custom class to autoload to manage module's customizations
#   If defined, msmtp class will automatically "include $my_class"
#   Can be defined also by the (top scope) variable $msmtp_myclass
#
# [*source*]
#   Sets the content of source parameter for main configuration file
#   If defined, msmtp main config file will have the param: source => $source
#   Can be defined also by the (top scope) variable $msmtp_source
#
# [*template*]
#   Sets the path to the template to use as content for main configuration file
#   If defined, msmtp main config file has: content => content("$template")
#   Note source and template parameters are mutually exclusive: don't use both
#   Can be defined also by the (top scope) variable $msmtp_template
#
# [*options*]
#   An hash of custom options to be used in templates for arbitrary settings.
#   Can be defined also by the (top scope) variable $msmtp_options
#
# [*version*]
#   The package version, used in the ensure parameter of package type.
#   Default: present. Can be 'latest' or a specific version number.
#   Note that if the argument absent (see below) is set to true, the
#   package is removed, whatever the value of version parameter.
#
# [*absent*]
#   Set to 'true' to remove package(s) installed by module
#   Can be defined also by the (top scope) variable $msmtp_absent
#
# [*audit_only*]
#   Set to 'true' if you don't intend to override existing configuration files
#   and want to audit the difference between existing files and the ones
#   managed by Puppet.
#   Can be defined also by the (top scope) variables $msmtp_audit_only
#   and $audit_only
#
# [*noops*]
#   Set noop metaparameter to true for all the resources managed by the module.
#   Basically you can run a dryrun for this specific module if you set
#   this to true. Default: false
#
# Default class params - As defined in msmtp::params.
# Note that these variables are mostly defined and used in the module itself,
# overriding the default values might not affected all the involved components.
# Set and override them only if you know what you're doing.
# Note also that you can't override/set them via top scope variables.
#
# [*package*]
#   The name of msmtp package
#
# [*config_file*]
#   Main configuration file path
#
# == Examples
#
# You can use this class in 2 ways:
# - Set variables (at top scope level on in a ENC) and "include msmtp"
# - Call msmtp as a parametrized class
#
# See README for details.
#
#
class msmtp (
  $smarthost           = params_lookup( 'smarthost' ),
  $from                = params_lookup( 'from' ),
  $defaultalias        = params_lookup( 'defaultalias' ),
  $aliases             = params_lookup( 'aliases' ),
  $my_class            = params_lookup( 'my_class' ),
  $source              = params_lookup( 'source' ),
  $template            = params_lookup( 'template' ),
  $options             = params_lookup( 'options' ),
  $version             = params_lookup( 'version' ),
  $absent              = params_lookup( 'absent' ),
  $audit_only          = params_lookup( 'audit_only' , 'global' ),
  $noops               = params_lookup( 'noops' ),
  $package             = params_lookup( 'package' ),
  $config_file         = params_lookup( 'config_file' )
  ) inherits msmtp::params {

  $config_file_mode=$msmtp::params::config_file_mode
  $config_file_owner=$msmtp::params::config_file_owner
  $config_file_group=$msmtp::params::config_file_group

  $bool_source_dir_purge=any2bool($source_dir_purge)
  $bool_absent=any2bool($absent)
  $bool_audit_only=any2bool($audit_only)
  $bool_noops=any2bool($noops)

  if $defaultalias {
    mailalias { 'default':
      recipient => $defaultalias,
      target    => $aliases,
      notify    => Exec['msmtp-newaliases'] 
    }

    exec { 'msmtp-newaliases':
     command     => '/usr/bin/newaliases',
     refreshonly => true
    }
  }
  
  ### Definition of some variables used in the module
  $manage_package = $msmtp::bool_absent ? {
    true  => 'absent',
    false => $msmtp::version,
  }

  $manage_file = $msmtp::bool_absent ? {
    true    => 'absent',
    default => 'present',
  }

  $manage_audit = $msmtp::bool_audit_only ? {
    true  => 'all',
    false => undef,
  }

  $manage_file_replace = $msmtp::bool_audit_only ? {
    true  => false,
    false => true,
  }

  $manage_file_source = $msmtp::source ? {
    ''        => undef,
    default   => $msmtp::source,
  }

  $manage_file_content = $msmtp::template ? {
    ''        => undef,
    default   => template($msmtp::template),
  }

  ### Managed resources
  package { $msmtp::package:
    ensure  => $msmtp::manage_package,
    noop    => $msmtp::bool_noops,
  }

  file { 'msmtp.conf':
    ensure  => $msmtp::manage_file,
    path    => $msmtp::config_file,
    mode    => $msmtp::config_file_mode,
    owner   => $msmtp::config_file_owner,
    group   => $msmtp::config_file_group,
    require => Package[$msmtp::package],
    source  => $msmtp::manage_file_source,
    content => $msmtp::manage_file_content,
    replace => $msmtp::manage_file_replace,
    audit   => $msmtp::manage_audit,
    noop    => $msmtp::bool_noops,
  }

  # The whole msmtp configuration directory can be recursively overriden
  if $msmtp::source_dir {
    file { 'msmtp.dir':
      ensure  => directory,
      path    => $msmtp::config_dir,
      require => Package[$msmtp::package],
      notify  => $msmtp::manage_service_autorestart,
      source  => $msmtp::source_dir,
      recurse => true,
      purge   => $msmtp::bool_source_dir_purge,
      force   => $msmtp::bool_source_dir_purge,
      replace => $msmtp::manage_file_replace,
      audit   => $msmtp::manage_audit,
      noop    => $msmtp::bool_noops,
    }
  }


  ### Include custom class if $my_class is set
  if $msmtp::my_class {
    include $msmtp::my_class
  }

}
