Feature: Bible API

	Scenario: Lookup a valid text
		When I visit "/api/v1/bible/Genesis/1/1"
		Then the JSON should be:
			"""
			{
				"bookname":"Genesis",
				"chapter":1,
				"verse":1,
				"text":	"In the beginning God created the heavens and the earth."
			}
			"""
