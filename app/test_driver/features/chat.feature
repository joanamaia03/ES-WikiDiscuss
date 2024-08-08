Feature: Chat
  As a user, I want to be able to chat with other users

  Scenario: Open Chat page
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    And I am on some page
    When I tap the "chat" icon button
    Then I should see chat page

  Scenario: Send message
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    And I am on some page
    And I tap the "chat" icon button
    And And I fill in "SendTextField" with "test message Mansur"
    When I tap the "send" icon button
    Then I should see "test message Mansur"
    And I should see "Just now"
    And I shouldn't see "not test message"

  Scenario: Send message another user
    Given I am register user with email "mansur@gmail.com" and password "qwerty" on main page
    And I am on some page
    And I tap the "chat" icon button
    And And I fill in "SendTextField" with "test message Mansur2.0"
    When I tap the "send" icon button
    Then I should see "test message Mansur2.0"
    And I should see "Just now"
    And I should see "mansur: Just now"
    And I should see "test message Mansur"
    And I shouldn't see "not test message"

  Scenario: Navigation
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    And I am on some page
    And I tap the "chat" icon button
    When I tap the "back" icon button
    Then I see "Portugal" page