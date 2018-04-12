Given(/^I am on the Assessments screen$/) do
    @life_page = page(AndroidLifePage).await
end

Then(/^I retake Health Risk Assessment$/) do
    # pending # Write code here that turns the phrase above into concrete actions
    @life_page.retake_assessment
end