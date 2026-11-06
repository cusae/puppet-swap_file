# frozen_string_literal: true

# Managed by modulesync - DO NOT EDIT
# https://voxpupuli.org/docs/updating-files-managed-with-modulesync/

require 'voxpupuli/acceptance/spec_helper_acceptance'

# Ubuntu cloud images ship systemd-resolved with DNSSEC=yes but without the
# dns-root-data package. /usr/share/dns/root.key is then missing and every
# lookup fails with "DNSSEC validation failed: missing-key", which breaks the
# package installation done by configure_beaker. Disable DNSSEC validation in
# the test VMs before that happens.
if ENV['BEAKER_HYPERVISOR'] == 'vagrant_libvirt'
  hosts.each do |host|
    next unless host['platform'].include?('ubuntu')

    host.exec!(
      'sed -i "s/^#*DNSSEC=.*/DNSSEC=no/" /etc/systemd/resolved.conf && systemctl restart systemd-resolved',
      'disable DNSSEC validation in test VM'
    )
  end
end

configure_beaker(modules: :metadata)

Dir['./spec/support/acceptance/**/*.rb'].sort.each { |f| require f }
