Feature: Rigveda mandala resource

	Scenario: Default content type for mandala collection
		When I visit "/api/v1/rigveda/mandalas"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup the collection of mandalas
		When I visit "/api/v1/rigveda/mandalas"
		Then the JSON should have "mandalas"
		And the JSON at "mandalas" should be an array
		And the JSON at "total_count" should be 10
