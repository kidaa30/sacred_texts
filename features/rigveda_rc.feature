Feature: Rigveda rc resource

	Scenario: Default content type for rc collection
		When I visit "/api/v1/rigveda/rcas"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup the collection of rcas
		When I visit "/api/v1/rigveda/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should be an array
		And the JSON at "total_count" should be 9535

	Scenario: Lookup the collection of rcas should return 10 results by default
		When I visit "/api/v1/rigveda/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 10 entries

	Scenario: Lookup the collection of rcas, specifying the page size 
		When I visit "/api/v1/rigveda/rcas?num=4"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 4 entries

	Scenario: Lookup the collection of rcas, specifying the start page
		When I visit "/api/v1/rigveda/rcas?page=2"
		Then the JSON should have "rcas"
		And the JSON at "rcas/0/rc" should be 2
		And the JSON at "rcas/0/sukta" should be 2
		And the JSON at "rcas/0/mandala" should be 1

	Scenario: next_page element is not present when there are not enough rcas to overflow to another page
		When I visit "/api/v1/rigveda/rcas?page=954"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough rcas to overflow to another page
		When I visit "/api/v1/rigveda/rcas?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next rcas page
		When I visit "/api/v1/rigveda/rcas?page=3"
		Then the JSON at "next_page" should include "/api/v1/rigveda/rcas?page=4"

	Scenario: prev_page element is not present when on the first rcas page
		When I visit "/api/v1/rigveda/rcas?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on rcas page greater than 1
		When I visit "/api/v1/rigveda/rcas?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous book/rcas page
		When I visit "/api/v1/rigveda/rcas?page=3"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/rcas?page=2"
