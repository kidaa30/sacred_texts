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

	Scenario: Default cotent type for mandala
		When I visit "/api/v1/rigveda/mandalas/1"
		Then the http response status code should be 200
		And the content_type should be json

	Scenario: Lookup a mandala
		When I visit "/api/v1/rigveda/mandalas/1"
		Then the JSON at "mandala" should be 1
		And the JSON at "suktas" should be an array
		And the JSON at "suktas/0/sukta" should be 1
		And the JSON at "suktas/0/link" should include "api/v1/rigveda/mandalas/1/suktas/1"
		And the JSON at "total_count" should be 191
