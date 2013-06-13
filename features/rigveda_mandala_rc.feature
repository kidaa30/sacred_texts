Feature: Rigveda mandala/rc resource

	Scenario: Default content type for mandala/rc collection
		When I visit "/api/v1/rigveda/mandalas/1/rcas"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of mandala/rcas for valid book and chapter
		When I visit "/api/v1/rigveda/mandalas/1/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should be an array
		And the JSON at "total_count" should be 1842

	Scenario: Lookup a collection of mandala/rcas for invalid book
		When I visit "/api/v1/rigveda/mandalas/999/rcas"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of mandala/rcas should return 10 results by default
		When I visit "/api/v1/rigveda/mandalas/1/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 10 entries

	Scenario: Lookup a collection of mandala/rcas, specifying the page size 
		When I visit "/api/v1/rigveda/mandalas/1/rcas?num=4"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 4 entries

	Scenario: Lookup a collection of mandala/rcas, specifying the start page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=2"
		Then the JSON should have "rcas"
		And the JSON at "rcas/0/rc" should be 2
		And the JSON at "rcas/0/sukta" should be 2

	Scenario: next_page element is not present when there are not enough mandala/rcas to overflow to another page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=185"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough mandala/rcas to overflow to another page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next mandala/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=3"
		Then the JSON at "next_page" should include "/api/v1/rigveda/mandalas/1/rcas?page=4"

	Scenario: prev_page element is not present when on the firt mandala/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on mandala/rcas page greater than 1
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous mandala/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?page=3"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/mandalas/1/rcas?page=2"
