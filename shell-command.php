<?php

if ( ! class_exists( 'FIN_CLI' ) ) {
	return;
}

$fincli_shell_autoloader = __DIR__ . '/vendor/autoload.php';
if ( file_exists( $fincli_shell_autoloader ) ) {
	require_once $fincli_shell_autoloader;
}

FIN_CLI::add_command( 'shell', 'Shell_Command' );
