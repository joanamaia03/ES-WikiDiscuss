Feature: Login
  As a user, I want to log in to the app

  Scenario: Successful Login
    Given I am in the login page
    And I fill in "EmailTextField" with "mansur@mail.ru"
    And I fill in "PasswordTextField" with "qwerty"
    When I tap the "Sign In" button
    Then I should see the home page

  Scenario: Failed Login
    Given I am in the login page
    And I fill in "EmailTextField" with "not_registed@mail.ru"
    And I fill in "PasswordTextField" with "qwerty"
    When I tap the "Sign In" button
    Then I should see "Email or Password is incorrect"

  Scenario: Failed Password
    Given I am in the login page
    And I fill in "EmailTextField" with "mansur@mail.ru"
    And I fill in "PasswordTextField" with "wrong_password"
    When I tap the "Sign In" button
    Then I should see "Email or Password is incorrect"

  Scenario: Empty Email
    Given I am in the login page
    And I fill in "PasswordTextField" with "qwerty"
    When I tap the "Sign In" button
    Then I should see "Email or Password is incorrect"

  Scenario: Empty Password
    Given I am in the login page
    And I fill in "EmailTextField" with "mansur@mail.ru"
    When I tap the "Sign In" button
    Then I should see "Email or Password is incorrect"

  Scenario: Navigate to Sign Up
    Given I am in the login page
    When I tap the "Sign Up" button
    Then I should see the register page

  Scenario: Successful Logout
    Given I am in the login page
    And I fill in "EmailTextField" with "mansur@mail.ru"
    And I fill in "PasswordTextField" with "qwerty"
    And I tap the "Sign In" button
    And I tap the 'menu' icon button
    And I tap the "Profile" button
    And I tap the "Logout" button
    Then I should see the login page
