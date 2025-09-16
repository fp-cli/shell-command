Feature: FinPress REPL

  Scenario: Blank session
    Given a FIN install

    When I run `fin shell < /dev/null`
    And I run `fin shell --basic < /dev/null`
    Then STDOUT should be empty

  Scenario: Persistent environment
    Given a FIN install
    And a session file:
      """
      function is_empty_string( $str ) { return strlen( $str ) == 0; }
      $a = get_option('home');
      is_empty_string( $a );
      """

    When I run `fin shell --basic < session`
    Then STDOUT should contain:
      """
      bool(false)
      """

  Scenario: Multiline support (basic)
    Given a FIN install
    And a session file:
      """
      function is_empty_string( $str ) { \
          return strlen( $str ) == 0; \
      }

      function_exists( 'is_empty_string' );
      """

    When I run `fin shell --basic < session`
    Then STDOUT should contain:
      """
      bool(true)
      """

  Scenario: Use custom shell path
    Given a FIN install

    And a session file:
      """
      return true;
      """

    When I try `FIN_CLI_CUSTOM_SHELL=/nonsense/path fin shell --basic < session`
    Then STDOUT should be empty
    And STDERR should contain:
      """
      Error: The shell binary '/nonsense/path' is not valid.
      """

    When I try `FIN_CLI_CUSTOM_SHELL=/bin/bash fin shell --basic < session`
    Then STDOUT should contain:
      """
      bool(true)
      """
    And STDERR should be empty
