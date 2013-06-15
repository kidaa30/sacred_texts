Feature: static pages

	Scenario: Index
		When I visit "/"
		Then I should see "Sacred Texts" within "h1"

	Scenario: Design
		When I visit "/apidesign"
		Then I should see "API Design decisions" within "h1" 
