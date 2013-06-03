Feature: Quran Aya resource 

  Scenario: Default content type for Ayat collection
    When I visit "/api/v1/quran/ayat"
    Then the http response status code should be 200
    And the content_type should be json

  Scenario: Lookup the collection of Ayat
    When I visit "/api/v1/quran/ayat"
    Then the JSON should have "ayat"
    And the JSON at "ayat" should be an array
    And the JSON at "total_count" should be 6236

	Scenario: Lookup the collection of Ayat should return 10 results by default
		When I visit "/api/v1/quran/ayat"
		Then the JSON should have "ayat"
		And the JSON at "ayat" should have 10 entries

	Scenario: Lookup the collection of Ayat, specifying the page size 
		When I visit "/api/v1/quran/ayat?num=4"
		Then the JSON should have "ayat"
		And the JSON at "ayat" should have 4 entries

	Scenario: Lookup the collection of Ayat, specifying the start page
		When I visit "/api/v1/quran/ayat?page=2"
		Then the JSON should have "ayat"
    And the JSON at "ayat/0/aya" should be 4
    And the JSON at "ayat/0/sura" should be 2

	Scenario: next_page element is not present when there are not enough Ayat to overflow to another page
		When I visit "/api/v1/quran/ayat?page=624"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when there are enough Ayat to overflow to another page
		When I visit "/api/v1/quran/ayat?page=3"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next Ayat page
		When I visit "/api/v1/quran/ayat?page=3"
		Then the JSON at "next_page" should include "/api/v1/quran/ayat?page=4"

	Scenario: prev_page element is not present when on the first Ayat page
		When I visit "/api/v1/quran/ayat?page=1"
		Then the JSON should not have "previous_page"

	Scenario: prev_page element is present when on Ayat page greater than 1
		When I visit "/api/v1/quran/ayat?page=3"
		Then the JSON should have "previous_page"

	Scenario: prev_page element references the previous book/Ayat page
		When I visit "/api/v1/quran/ayat?page=3"
		Then the JSON at "previous_page" should include "/api/v1/quran/ayat?page=2"
