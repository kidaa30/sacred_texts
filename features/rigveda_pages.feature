Feature: Rigveda pages

	Scenario: Rigveda main page
		When I visit "/rigveda"
		Then I should see "Rigveda API" within "h1"
