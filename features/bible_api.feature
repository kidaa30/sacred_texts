Feature: Bible API

	Scenario: Lookup a valid text
		When I visit "/api/v1/bible/Genesis/1/1"
		Then the http response status code should be 200
		And the JSON should be:
		"""
		{
		"bookname":"Genesis",
		"chapter":1,
		"verse":1,
		"text":	"In the beginning God created the heavens and the earth."
		}
		"""

	Scenario: Lookup with an invalid bookname
		When I visit "/api/v1/bible/blarg/1/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid chapter
		When I visit "/api/v1/bible/Genesis/99/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid verse
		When I visit "/api/v1/bible/Genesis/1/100"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

  Scenario: complex lookup can have passage param
    When I visit "/api/v1/bible/?passage=Genesis 1:1"
    Then the http response status code should be 200

  Scenario: complex lookup can have search param
    When I visit "/api/v1/bible/?search=Job"
    Then the http response status code should be 200

  Scenario: Complex lookuo cannot have both passage and search params at the same time
    When I visit "/api/v1/bible/?passage=Genesis 1:1&search=Job"
    Then the http response status code should be 400
    And the JSON should be:
    """
    {
    "error":"Only one of the parameters 'passage' and 'search' can be specified."
    }
    """
