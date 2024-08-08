Feature: Help Screen
  As a user, I want to see the help screen so that I can read FAQ and contact support

  Scenario: Open help screen
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I tap the 'menu' icon button
    And I tap the 'Help' button
    Then I should see the help screen

  Scenario: Open question
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I tap the 'menu' icon button
    And I tap the 'Help' button
    And I tap the 'How to contact team services' button
    Then I should see "To contact support team, please write email up202102355@fe.up.pt"

  Scenario: Open question
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I tap the 'menu' icon button
    And I tap the 'Help' button
    And I tap the 'How to reset my password?' button
    Then I should see "You can logout and then click on "Reset Password" button. You will receive an email with a link to reset your password."

  Scenario: Open question
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I tap the 'menu' icon button
    And I tap the 'Help' button
    And I tap the 'How to contact team services' button
    And I tap the 'How to contact team services' button
    Then I shouldn't see "To contact support team, please write email up202102355@fe.up.pt"

  Scenario: Navigation test
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I tap the 'menu' icon button
    And I tap the 'Help' button
    And I tap the "back" icon button
    Then I should see the home page
    And I shouldn't see "Frequently Asked Questions"
