<?php

if ( ! class_exists( 'FP_CLI' ) ) {
	return;
}

$fpcli_shell_autoloader = __DIR__ . '/vendor/autoload.php';
if ( file_exists( $fpcli_shell_autoloader ) ) {
	require_once $fpcli_shell_autoloader;
}

FP_CLI::add_command( 'shell', 'Shell_Command' );
