Feature: Rigveda mandala/sukta/rc resource

	Scenario: Default content type is JSON
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas/1"
		Then the content_type should be json

	Scenario: Lookup a valid rc
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas/1"
		Then the http response status code should be 200
		And the JSON should be:
		"""
		{
		"mandala":1,
		"rc":1,
		"sukta":1,
		"text":"I Laud Agni, the chosen Priest, God, minister of sacrifice, The hotar, lavishest of wealth."
		}
		"""

	Scenario: Lookup a valid rc using lower case mandala
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas/1"
		Then the http response status code should be 200
		And the JSON should be:
		"""
		{
		"mandala":1,
		"rc":1,
		"sukta":1,
		"text":"I Laud Agni, the chosen Priest, God, minister of sacrifice, The hotar, lavishest of wealth."
		}
		"""

	Scenario: Lookup a rc with an invalid mandala
		When I visit "/api/v1/rigveda/mandalas/999/suktas/1/rcas/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid sukta
		When I visit "/api/v1/rigveda/mandalas/1/suktas/99/rcas/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid rc
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas/100"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Default content type for mandala/sukta/rc collection
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of rcas for valid mandala and sukta
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should be an array
		And the JSON at "total_count" should be 9

	Scenario: Lookup a collection of rcas for valid mandala and invalid sukta
		When I visit "/api/v1/rigveda/mandalas/1/suktas/99/rcas"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of rcas for invalid mandala, valid sukta
		When I visit "/api/v1/rigveda/mandalas/999/suktas/1/rcas"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of mandala/sukta/rcas should return 10 results by default
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 10 entries

	Scenario: Lookup a collection of mandala/sukta/rcas, specifying the page size 
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1/rcas?num=4"
		Then the JSON should have "rcas"
		And the JSON at "rcas" should have 4 entries

	Scenario: Lookup a collection of mandala/sukta/rcas, specifying the start page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=2"
		Then the JSON should have "rcas"
		And the JSON at "rcas/0/rc" should be 11

	Scenario: next_page element is not present when there are not enough mandala/sukta/rcas to overflow to another page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=2"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough mandala/sukta/rcas to overflow to another page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=1"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next mandala/sukta/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=1"
		Then the JSON at "next_page" should include "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=2"

	Scenario: prev_page element is not present when on the firt mandala/sukta/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on mandala/sukta/rcas page greater than 1
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=2"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous mandala/sukta/rcas page
		When I visit "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=2"
		Then the JSON at "previous_page" should include "/api/v1/rigveda/mandalas/1/suktas/3/rcas?page=1"
