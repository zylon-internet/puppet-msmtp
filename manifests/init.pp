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
# [*port*]
#   The port that the SMTP server listens on.  The default port  will  be
#   acquired  from your  operating  system's  service database: for SMTP,
#   the service is "smtp" (default port 25), unless TLS without STARTTLS is
#   used, in which case it is "smtps" (465). For LMTP, it is "lmtp".
#
# [*timeout*]
#   Set or unset a network timeout, in seconds. The argument off means that
#   no timeout will be set, which means that the operating system default
#   will be used.
#
# [*protocol*]
#   Set the protocol to use. Currently only SMTP and LMTP are supported.
#   Default: smtp
#
# [*auth*]
#   (on|off|method)]
#   This command enables or disables SMTP authentication.
#   You should not need to set the method yourself; with the argument on,
#   msmtp will choose the best one  available  for you.
#
# [*user*]
#   Set your user name for SMTP authentication.
#
# [*password*]
#   Set your password for SMTP authentication.
#
# [*tls*]
#   Enable or disable TLS/SSL encryption.
#
# [*tls_trust_file*]
#   This command activates strict server certificate verification.
#   Recommended if [*tls*] is on.
#
# [*tls_starttls*]
#   By default, TLS encryption is activated using the STARTTLS SMTP command.
#   Set to "no" if you want to force tls (SSL).
#
# [*domain*]
#   Argument of the SMTP EHLO (or LMTP LHLO) command.
#   Default: $::domain fact.
#
# [*maildomain*]
#   Set the domain part for generated envelope-from addresses.
#   It is only used when auto_from is on.
#
# [*from*]
#   Envelope-From to enforce on all outgoing mail.
#   Defaults to "$::fqdn@$domain"
#
# [*auto_from*]
#   Enable or disable automatic envelope-fromaddresses.
#   The default is off.
#
# [*log_facility*]
#   Enable or disable syslog logging.
#   The facility can be one of LOG_USER, LOG_MAIL, LOG_LOCAL0, ..., LOG_LOCAL7.
#   Default: LOG_MAIL
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
  $port                = params_lookup( 'port' ),
  $timeout             = params_lookup( 'timeout' ),
  $protocol            = params_lookup( 'protocol' ),
  $auth                = params_lookup( 'auth' ),
  $user                = params_lookup( 'user' ),
  $password            = params_lookup( 'password' ),
  $tls                 = params_lookup( 'tls' ),
  $tls_trust_file      = params_lookup( 'tls_trust_file' ),
  $tls_starttls        = params_lookup( 'tls_starttls' ),
  $domain              = params_lookup( 'domain' ),
  $maildomain          = params_lookup( 'maildomain' ),
  $auto_from           = params_lookup( 'auto_from' ),
  $log_facility        = params_lookup( 'log_facility' ),
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

  ### Include custom class if $my_class is set
  if $msmtp::my_class {
    include $msmtp::my_class
  }
}
