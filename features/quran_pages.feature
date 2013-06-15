Feature: Quran pages

	Scenario: Quran
		When I visit "/quran"
		Then I should see "Quran API" within "h1"
