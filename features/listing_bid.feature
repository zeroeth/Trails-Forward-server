Feature: Bid on a listing
  Players should be able to bid on listings

  Background: The player is logged in to a world
    Given I have a world
      And There are two users
      And I have a listing
      And They have listing

  Scenario: Bid on a listing
     When I bid on their listing
     Then I should have a bid on that listing

  Scenario: Accept a bid on a listing
     When I accept a bid on my listing
     Then The bid should be accepted

