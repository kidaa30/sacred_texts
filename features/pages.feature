Feature: static pages

	Scenario: Index
		When I am on the home page
		Then I should see "Sacred Texts" within "h1"
