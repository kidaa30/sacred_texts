Feature: quran/suwar resource

	Scenario: Default content type for suwar collection
		When I visit "/api/v1/quran/suwar"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup the collection of suwar
		When I visit "/api/v1/quran/suwar"
		Then the JSON should have "suwar"
		And  the JSON at "suwar" should be an array
		And the JSON at "total_count" should be 114
