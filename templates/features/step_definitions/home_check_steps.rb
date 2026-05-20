When(/^I visit "([^"]*)"$/) do |path|
  visit path
end

Then(/^I see the text "([^"]*)"$/) do |text|
  expect(page).to have_content(text)
end
