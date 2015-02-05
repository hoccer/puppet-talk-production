class talk-production ($primary_talkserver_fqdn, $primary_talkserver_port,
        $primary_talkserver_cert, $primary_talkserver_key,
        $primary_talkserver_backend, $secondary_talkserver_fqdn,
        $secondary_talkserver_port, $secondary_talkserver_cert,
        $secondary_talkserver_key, $secondary_talkserver_backend,
        $filecache_fqdn, $filecache_port, $filecache_cert, $filecache_key,
        $invitation_servers) {
  include talk-production::install, talk-production::config
}
