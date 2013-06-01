Feature: Bible book/verse resource

	Scenario: Default content type for book/verse collection
		When I visit "/api/v1/bible/books/Genesis/verses"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of book/verses for valid book and chapter
		When I visit "/api/v1/bible/books/Genesis/verses"
		Then the JSON should have "verses"
		And the JSON at "verses" should be an array
		And the JSON at "total_count" should be 1533

	Scenario: Lookup a collection of book/verses for invalid book
		When I visit "/api/v1/bible/books/blarg/verses"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of book/verses should return 10 results by default
		When I visit "/api/v1/bible/books/Genesis/verses"
		Then the JSON should have "verses"
		And the JSON at "verses" should have 10 entries

	Scenario: Lookup a collection of book/verses, specifying the page size 
		When I visit "/api/v1/bible/books/Genesis/verses?num=4"
		Then the JSON should have "verses"
		And the JSON at "verses" should have 4 entries

	Scenario: Lookup a collection of book/verses, specifying the start page
		When I visit "/api/v1/bible/books/Genesis/verses?page=2"
		Then the JSON should have "verses"
		And the JSON at "verses/0/verse" should be 11

	Scenario: next_page element is not present when there are not enough book/verses to overflow to another page
		When I visit "/api/v1/bible/books/Genesis/verses?page=4"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough book/verses to overflow to another page
		When I visit "/api/v1/bible/books/Genesis/verses?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next book/verses page
		When I visit "/api/v1/bible/books/Genesis/verses?page=3"
		Then the JSON at "next_page" should include "/api/v1/bible/books/Genesis/verses?page=4"

	Scenario: prev_page element is not present when on the firt book/verses page
		When I visit "/api/v1/bible/books/Genesis/verses?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on book/verses page greater than 1
		When I visit "/api/v1/bible/books/Genesis/verses?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous book/verses page
		When I visit "/api/v1/bible/books/Genesis/verses?page=3"
		Then the JSON at "previous_page" should include "/api/v1/bible/books/Genesis/verses?page=2"
