Feature: Quran search

	Scenario: full search, single keyword, multiple results
		When I visit "/api/v1/quran/ayat?q=Abraham"
		Then the content_type should be json
		And the JSON at "ayat" should be an array
		And the JSON at "total_count" should be 71

	Scenario: Suwar scoped search, single keyword, multiple results
		When I visit "/api/v1/quran/suwar/4/ayat?q=Abraham"
		Then the content_type should be json
		And the JSON at "ayat" should be an array
		And the JSON at "total_count" should be 3
