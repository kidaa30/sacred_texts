Feature: Bible book/chapter/verse resource

	Scenario: Default content type is JSON
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses/1"
		Then the content_type should be json

	Scenario: Lookup a valid verse
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses/1"
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

	Scenario: Lookup a valid verse using lower case book
		When I visit "/api/v1/bible/books/genesis/chapters/1/verses/1"
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

	Scenario: Lookup a verse with an invalid bookname
		When I visit "/api/v1/bible/books/blarg/chapters/1/verses/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/99/verses/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid verse
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses/100"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Default content type for book/chapter/verse collection
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of verses for valid book and chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses"
		Then the JSON should have "verses"
		And the JSON at "verses" should be an array
		And the JSON at "total_count" should be 31

	Scenario: Lookup a collection of verses for valid book and invalid chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/99/verses"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of verses for invalid book, valid chapter
		When I visit "/api/v1/bible/books/blarg/chapters/1/verses"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of book/chapter/verses should return 10 results by default
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses"
		Then the JSON should have "verses"
		And the JSON at "verses" should have 10 entries

	Scenario: Lookup a collection of book/chapter/verses, specifying the page size 
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?num=4"
		Then the JSON should have "verses"
		And the JSON at "verses" should have 4 entries

	Scenario: Lookup a collection of book/chapter/verses, specifying the start page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=2"
		Then the JSON should have "verses"
		And the JSON at "verses/0/verse" should be 11

	Scenario: next_page element is not present when there are not enough book/chapter/verses to overflow to another page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=4"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough book/chapter/verses to overflow to another page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next book/chapter/verses page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=3"
		Then the JSON at "next_page" should include "/api/v1/bible/books/Genesis/chapters/1/verses?page=4"

	Scenario: prev_page element is not present when on the firt book/chapter/verses page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on book/chapter/verses page greater than 1
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous book/chapter/verses page
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?page=3"
		Then the JSON at "previous_page" should include "/api/v1/bible/books/Genesis/chapters/1/verses?page=2"
