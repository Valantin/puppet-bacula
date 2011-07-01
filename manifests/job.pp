define bacula::job (
    $files    = '',
    $excludes = '',
    $fileset  = true #should we generate a fileset for this job
  ) {

  if ! defined(Class["bacula"]) {
    err("need class bacula for this to be useful")
  }
  $director = $bacula::bacula_director

  # so if the fileset is not defined, we fall back to one called Common
  if $fileset == true {
    if $files == '' { err("you tell me to create a fileset, but not files given") }
    $fileset_real = "$name"
    bacula::fileset {
      "$name":
        files    => $files,
        excludes => $excludes
      }
  } else {
    $fileset_real = "Common"
  }

  @@concat::fragment {
    "bacula-job-$name":
      target  => '/etc/bacula/conf.d/job.conf',
      content => template("bacula/job.conf.erb"),
      tag     => "bacula-$director";
  }

#  if $bacula::monitor == true {
#    @@nagios_service { "check_bacula_${name}":
#      use                 => 'generic-service',
#      host_name           => "$fqdn",
#      check_command       => 'check_bacula',
#      service_description => "check_bacula_${name}",
#      target              => '/etc/nagios3/conf.d/nagios_service.cfg',
#      notify              => Service[$nagios::params::nagios_service],
#    }
#  }

}

