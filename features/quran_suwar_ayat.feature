Feature: Quran suwar/aya resource

	Scenario: Default content type for suwar/ayat collection
		When I visit "/api/v1/quran/suwar/1/ayat"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a collection of suwar/ayat for valid sura
		When I visit "/api/v1/quran/suwar/1/ayat"
		Then the JSON should have "ayat"
		And the JSON at "ayat" should be an array
		And the JSON at "total_count" should be 7

	Scenario: Lookup a collection of suwar/ayat for invalid sura
		When I visit "/api/v1/quran/suwar/444/ayat"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup a collection of suwar/ayat should return 10 results by default
		When I visit "/api/v1/quran/suwar/2/ayat"
		Then the JSON should have "ayat"
		And the JSON at "ayat" should have 10 entries

	Scenario: Lookup a collection of suwar/ayat, specifying the page size 
		When I visit "/api/v1/quran/suwar/1/ayat?num=4"
		Then the JSON should have "ayat"
		And the JSON at "ayat" should have 4 entries

	Scenario: Lookup a collection of suwar/ayat, specifying the start page
		When I visit "/api/v1/quran/suwar/2/ayat?page=2"
		Then the JSON should have "ayat"
		And the JSON at "ayat/0/aya" should be 11

	Scenario: next_page element is not present when there are not enough suwar/ayat to overflow to another page
		When I visit "/api/v1/quran/suwar/2/ayat?page=29"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough suwar/ayat to overflow to another page
		When I visit "/api/v1/quran/suwar/2/ayat?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next suwar/ayat page
		When I visit "/api/v1/quran/suwar/2/ayat?page=3"
		Then the JSON at "next_page" should include "/api/v1/quran/suwar/2/ayat?page=4"

	Scenario: prev_page element is not present when on the firt suwar/ayat page
		When I visit "/api/v1/quran/suwar/1/ayat?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on suwar/ayat page greater than 1
		When I visit "/api/v1/quran/suwar/2/ayat?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous suwar/ayat page
		When I visit "/api/v1/quran/suwar/2/ayat?page=3"
		Then the JSON at "previous_page" should include "/api/v1/quran/suwar/2/ayat?page=2"
