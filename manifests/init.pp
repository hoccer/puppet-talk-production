class talk-production ($talkserver_fqdn, $talkserver_cert, $talkserver_key,
                       $filecache_fqdn, $filecache_cert, $filecache_key) {
  include talk-production::install, talk-production::config
}
