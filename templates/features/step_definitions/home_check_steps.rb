When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^the response status is (\d+)$/) do |status|
  expect(page).to have_http_status(status.to_i)
end
