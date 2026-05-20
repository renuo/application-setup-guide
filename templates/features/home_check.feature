Feature:
  As a monitoring service
  I want to have a simple page
  So I can assure the app is alive

  Scenario:
    When I visit "/up"
    Then the response status is 200
