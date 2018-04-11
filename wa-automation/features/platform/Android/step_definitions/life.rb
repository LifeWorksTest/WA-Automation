Given(/^I am on the Employee Assistance screen$/) do
    @life_page = page(AndroidLifePage).await
  end
  
  Then(/^I validate that all the categories have sub\-categories$/) do
    @life_page.validate_catogries
  end

  Then(/^I open one of the articles by following the links$/) do
    @life_page.open_an_article
  end