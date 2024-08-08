Feature: Register
  As a new user, I want to register in the app

  Scenario: Register with valid data
    Given I am in the register page
    When I fill in "NameTextField" with "test_user"
    And I fill in "EmailTextField" with "mansur_test8@mail.ru"
    And I fill in "PasswordTextField" with "123456"
    And I fill in "ConfPasswordTextField" with "123456"
    And I tap the "Register" button
    Then I should see the home page

  Scenario: Passwords do not match
    Given I am in the register page
    When I fill in "NameTextField" with "test_user"
    And I fill in "EmailTextField" with "mansur_test2@mail.ru"
    And I fill in "PasswordTextField" with "123456"
    And I fill in "ConfPasswordTextField" with "123457"
    And I tap the "Register" button
    Then I should see "Email or Password is incorrect"

  Scenario: Incorrect email format
    Given I am in the register page
    When I fill in "NameTextField" with "test_user"
    And I fill in "EmailTextField" with "mansur_test2mail.ru"
    And I fill in "PasswordTextField" with "123456"
    And I fill in "ConfPasswordTextField" with "123456"
    And I tap the "Register" button
    Then I should see "Email or Password is incorrect"

  Scenario: Already registered email
    Given I am in the register page
    When I fill in "NameTextField" with "test_user"
    And I fill in "EmailTextField" with "mansur@mail.ru"
    And I fill in "PasswordTextField" with "123456"
    And I fill in "ConfPasswordTextField" with "123456"
    And I tap the "Register" button
    Then I should see "Email or Password is incorrect"

  Scenario: Navigate to login page
    Given I am in the register page
    When I tap the "Back" button
    Then I should see the login page