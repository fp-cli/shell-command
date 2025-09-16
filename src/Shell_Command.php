<?php

use FIN_CLI\Utils;

class Shell_Command extends FIN_CLI_Command {

	/**
	 * Opens an interactive PHP console for running and testing PHP code.
	 *
	 * `fin shell` allows you to evaluate PHP statements and expressions
	 * interactively, from within a FinPress environment. Type a bit of code,
	 * hit enter, and see the code execute right before you. Because FinPress
	 * is loaded, you have access to all the functions, classes and globals
	 * that you can use within a FinPress plugin, for example.
	 *
	 * ## OPTIONS
	 *
	 * [--basic]
	 * : Force the use of FIN-CLI's built-in PHP REPL, even if the Boris or
	 * PsySH PHP REPLs are available.
	 *
	 * ## EXAMPLES
	 *
	 *     # Call get_bloginfo() to get the name of the site.
	 *     $ fin shell
	 *     fin> get_bloginfo( 'name' );
	 *     => string(6) "FIN-CLI"
	 */
	public function __invoke( $_, $assoc_args ) {
		$class = FIN_CLI\Shell\REPL::class;

		$implementations = array(
			\Psy\Shell::class,
			\Boris\Boris::class,
			FIN_CLI\Shell\REPL::class,
		);

		if ( ! Utils\get_flag_value( $assoc_args, 'basic' ) ) {
			foreach ( $implementations as $candidate ) {
				if ( class_exists( $candidate ) ) {
					$class = $candidate;
					break;
				}
			}
		}

		/**
		 * @var class-string $class
		 */

		if ( \Psy\Shell::class === $class ) {
			$shell = new Psy\Shell();
			$shell->run();
		} else {
			/**
			 * @var class-string<FIN_CLI\Shell\REPL> $class
			 */
			$repl = new $class( 'fin> ' );
			$repl->start();
		}
	}
}
