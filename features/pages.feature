Feature: static pages

	Scenario: Index
		When I visit "/"
		Then I should see "Sacred Texts" within "h1"

	Scenario: Design
		When I visit "/apidesign"
		Then I should see "API Design decisions" within "h1" 

	Scenario: Bible
		When I visit "/bible"
		Then I should see "Bible API" within "h1"

	Scenario: Quran
		When I visit "/quran"
		Then I should see "Quran API" within "h1"
