Feature: rigveda search

	Scenario: full search, single keyword, multiple results
		When I visit "/api/v1/rigveda/rcas?q=rama"
		Then the content_type should be json
		And the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 3
		And the JSON at "rcas/0/sukta" should be 53
		And the JSON at "rcas/0/rc" should be 14
		And the JSON at "total_count" should be 11

	Scenario: full search, multiple keywords
		When I visit "/api/v1/rigveda/rcas?q=Maghavan+Indra+Warrior"
		Then the content_type should be json
		And the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 173
		And the JSON at "rcas/0/rc" should be 5
		And the JSON at "total_count" should be 2

	Scenario: full search, no results
		When I visit "/api/v1/rigveda/rcas?q=blarg"
		Then the http response status code should be 404
		And the JSON should be:
		"""
	    {
    "error" : "No results found."
		}
		"""

	Scenario: Sukta search
		When I visit "/api/v1/rigveda/mandalas/1/suktas/32/rcas?q=Maghavan"
		Then the content_type should be json
		And the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 32
		And the JSON at "rcas/0/rc" should be 3
		And the JSON at "total_count" should be 2

	Scenario: Sukta search, multiple keywords
		When I visit "/api/v1/rigveda/mandalas/1/suktas/33/rcas?q=Maghavan+Indra"
		Then the content_type should be json
		And the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 33
		And the JSON at "rcas/0/rc" should be 12
		And the JSON at "total_count" should be 1

	Scenario: mandala search
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=Maghavan"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 32
		And the JSON at "rcas/0/rc" should be 3
		And the JSON at "total_count" should be 24

	Scenario: mandala search, multiple keywords
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=Maghavan+Indra"
		Then the content_type should be json
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 32
		And the JSON at "rcas/0/rc" should be 13
		And the JSON at "total_count" should be 12

	Scenario: Whole word search mode, per mandala
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=war&mode=whole"
		Then the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 27
		And the JSON at "rcas/0/rc" should be 9
		And the JSON at "total_count" should be 19

	Scenario: Regular search mode, per mandala
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=war"
		Then the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 1
		And the JSON at "rcas/0/rc" should be 2
		And the JSON at "total_count" should be 113

	Scenario: Whole word search mode, per sukta
		When I visit "/api/v1/rigveda/mandalas/1/suktas/27/rcas?q=war&mode=whole"
		Then the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 27
		And the JSON at "rcas/0/rc" should be 9
		And the JSON at "total_count" should be 1

	Scenario: Regular search mode, per sukta
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas?q=war"
		Then the http response status code should be 200
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 1
		And the JSON at "rcas/0/rc" should be 2
		And the JSON at "total_count" should be 1

	Scenario: Large result sets should return 10 results by default for global searches
		When I visit "/api/v1/rigveda/rcas?q=Maghavan"
		Then the JSON at "rcas" should have 10 entries

	Scenario: Large result sets should return 10 results by default for mandala scoped searches
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=Maghavan"
		Then the JSON at "rcas" should have 10 entries

	Scenario: Large result sets should return 10 results by default for sukta scoped searches
		When I visit "/api/v1/rigveda/mandalas/1/suktas/32/rcas?q=Indra"
		Then the JSON at "rcas" should have 10 entries

	Scenario: Specify result size for global searches
    When I visit "/api/v1/rigveda/rcas?q=Indra&num=4"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas" should have 4 entries

	Scenario: Specify result size for mandala scoped searches
    When I visit "/api/v1/rigveda/mandalas/1/rcas?q=Indra&num=4"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas" should have 4 entries

	Scenario: Specify result size for sukta scoped searches
    When I visit "/api/v1/rigveda/mandalas/1/suktas/32/rcas?q=Indra&num=4"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas" should have 4 entries

	Scenario: Specify page for global searches
		When I visit "/api/v1/rigveda/rcas?q=God&page=2"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas/0/mandala" should be 1
		And the JSON at "rcas/0/sukta" should be 12
		And the JSON at "rcas/0/rc" should be 7

	Scenario: Specify page for mandala scoped searches
		When I visit "/api/v1/rigveda/mandalas/2/rcas?q=God&page=2"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas/0/mandala" should be 2
		And the JSON at "rcas/0/sukta" should be 3
		And the JSON at "rcas/0/rc" should be 2

	Scenario: Specify page for sukta scoped searches
		When I visit "/api/v1/rigveda/mandalas/3/suktas/1/rcas?q=Agni&page=2"
		Then the http response status code should be 200
		And the content_type should be json
		And the JSON at "rcas/0/mandala" should be 3
		And the JSON at "rcas/0/sukta" should be 1
		And the JSON at "rcas/0/rc" should be 22

	Scenario: next_page element is not present when remaining global search results are less than a page
		When I visit "/api/v1/rigveda/rcas?q=Agni&page=147"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining global search results exceed a page
		When I visit "/api/v1/rigveda/rcas?q=Agni"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for global search results
		When I visit "/api/v1/rigveda/rcas?q=Agni&page=3"
		Then the JSON at "next_page" should include "/api/v1/rigveda/rcas?q=Agni&page=4"

	Scenario: next_page element is not present when remaining mandala scoped search results are less than a page
    When I visit "/api/v1/rigveda/mandalas/1/rcas?q=agni&page=30"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining mandala scoped search results exceed a page
    When I visit "/api/v1/rigveda/mandalas/1/rcas?q=agni&page=29"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for mandala scoped search results
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=agni&page=3"
		Then the JSON at "next_page" should include "/api/v1/rigveda/mandalas/1/rcas?q=agni&page=4"

	Scenario: next_page element is not present when remaining sukta scoped search results are less than a page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas?q=Ulai"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining sukta scoped search results exceed a page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/22/rcas?q=the"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for sukta scoped search results
		When I visit "/api/v1/rigveda/mandalas/1/suktas/22/rcas?q=the&page=1"
		Then the JSON at "next_page" should include "/api/v1/rigveda/mandalas/1/suktas/22/rcas?q=the&page=2"

	Scenario: previous_page element is not present when global search results are on the first page
		When I visit "/api/v1/rigveda/rcas?q=priest"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when global search results are on a page greater than 1 
		When I visit "/api/v1/rigveda/rcas?q=priest&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for global search results
		When I visit "/api/v1/rigveda/rcas?q=priest&page=3"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/rcas?q=priest&page=2"

	Scenario: previous_page element is not present when mandala scoped search results are on the first page
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=priest"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when remaining mandala scoped search results are on a page greater than 1 
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=priest&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for mandala scoped search results
		When I visit "/api/v1/rigveda/mandalas/1/rcas?q=priest&page=3"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/mandalas/1/rcas?q=priest&page=2"

	Scenario: previous_page element is not present when sukta scoped search results are on the first page 
		When I visit "/api/v1/rigveda/mandalas/2/suktas/1/rcas?q=agni"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when sukta scoped search results are on a page greater than 1 
    When I visit "/api/v1/rigveda/mandalas/2/suktas/1/rcas?q=agni&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for sukta scoped search results
    When I visit "/api/v1/rigveda/mandalas/2/suktas/1/rcas?q=agni&page=2"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/mandalas/2/suktas/1/rcas?q=agni&page=1"
