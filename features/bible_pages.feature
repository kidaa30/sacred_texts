Feature: Bible pages

	Scenario: Bible
		When I visit "/bible"
		Then I should see "Bible API" within "h1"
