Feature: Bible verse resource

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

	Scenario: Lookup a valid verse, json content type
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses/1.json"
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

	Scenario: Lookup a valid verse, xml content type
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses/1.xml"
		Then the http response status code should be 200
		And the XML should be:
		"""
		<?xml version="1.0" encoding="UTF-8"?>
		<bible>
		<bookname>Genesis</bookname>
		<chapter type="integer">1</chapter>
		<verse type="integer">1</verse>
		<text>In the beginning God created the heavens and the earth.</text>
		</bible>
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

	Scenario: Default content type for verse collection
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of verses for valid book and chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses"
		And the JSON should have "verses"
		And the JSON at "verses" should be an array
		And the JSON at "verses" should have 10 entries
		And the JSON at "total_count" should be 31
		And the JSON should have "next_page"

	Scenario: Lookup a collection of verses for valid book and invalid chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/99/verses"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of verses for invalid book
		When I visit "/api/v1/bible/books/blarg/chapters/1/verses"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""
