Feature: Search pages
  As a user, I want to search pages, so that I can find the page I need

  Scenario: Search page
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    Then I should see ""Hello, World!" program"
    And I should see "Portugal"
    And I shouldn't see "logitech"

  Scenario: Search page
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I fill in "SearchTextField" with "Portugal"
    Then I should see "Portugal"
    And I should see "Portuguese language"
    And I should see "Portuguese Empire"
    And I shouldn't see "Russia"

  Scenario: Failed search page
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I fill in "SearchTextField" with "Engeneria de software"
    Then I should see "No results found"
    And I shouldn't see "Software engineering"
    And I shouldn't see "Portugal"

  Scenario: Open page
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I fill in "SearchTextField" with "Hello world"
    And I tap the ""Hello, World!" program" button
    Then I see ""Hello, World!" program" page
    And I not see "Portugal" page

  Scenario: Open page and go back
    Given I am register user with email "mansur@mail.ru" and password "qwerty" on main page
    When I fill in "SearchTextField" with "Hello world"
    And I tap the ""Hello, World!" program" button
    And I tap the "Wiki Discuss" button
    Then I should see the home page
