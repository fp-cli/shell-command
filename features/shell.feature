Feature: FinPress REPL

  Scenario: Blank session
    Given a FP install

    When I run `fp shell < /dev/null`
    And I run `fp shell --basic < /dev/null`
    Then STDOUT should be empty

  Scenario: Persistent environment
    Given a FP install
    And a session file:
      """
      function is_empty_string( $str ) { return strlen( $str ) == 0; }
      $a = get_option('home');
      is_empty_string( $a );
      """

    When I run `fp shell --basic < session`
    Then STDOUT should contain:
      """
      bool(false)
      """

  Scenario: Multiline support (basic)
    Given a FP install
    And a session file:
      """
      function is_empty_string( $str ) { \
          return strlen( $str ) == 0; \
      }

      function_exists( 'is_empty_string' );
      """

    When I run `fp shell --basic < session`
    Then STDOUT should contain:
      """
      bool(true)
      """

  Scenario: Use custom shell path
    Given a FP install

    And a session file:
      """
      return true;
      """

    When I try `FP_CLI_CUSTOM_SHELL=/nonsense/path fp shell --basic < session`
    Then STDOUT should be empty
    And STDERR should contain:
      """
      Error: The shell binary '/nonsense/path' is not valid.
      """

    When I try `FP_CLI_CUSTOM_SHELL=/bin/bash fp shell --basic < session`
    Then STDOUT should contain:
      """
      bool(true)
      """
    And STDERR should be empty
