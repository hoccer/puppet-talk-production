class talk-production ($talkserver_fqdn, $talkserver_port, $talkserver_cert, $talkserver_key,
		$legacy_talkserver_fqdn, $legacy_talkserver_port, $legacy_talkserver_cert, $legacy_talkserver_key,
		$filecache_fqdn, $filecache_port, $filecache_cert, $filecache_key,
		$legacy_filecache_fqdn, $legacy_filecache_port, $legacy_filecache_cert, $legacy_filecache_key) {
  include talk-production::install, talk-production::config
}
