Feature:
  As a monitoring service
  I want to have a simple page
  So I can assure the app is alive

  Scenario:
    When I visit "/home/check"
    Then I see the text "1+2=3"
