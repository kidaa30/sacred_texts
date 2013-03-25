Feature: Bible API

	Scenario: Lookup a valid text
		When I visit "/api/v1/bible/Genesis/1/1"
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

	Scenario: Lookup a valid text, json content type
		When I visit "/api/v1/bible/Genesis/1/1.json"
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

	Scenario: Lookup a valid text, xml content type
		When I visit "/api/v1/bible/Genesis/1/1.xml"
		Then the http response status code should be 200
		And the XML should be:
		"""
    <?xml version="1.0" encoding="UTF-8"?>
    <bookname>Genesis</bookname>
    <chapter>1</chapter>
    <verse>1</verse>
    <text>In the beginning God created the heavens and the earth.</text>
    """

	Scenario: Lookup with an invalid bookname
		When I visit "/api/v1/bible/blarg/1/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid chapter
		When I visit "/api/v1/bible/Genesis/99/1"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

	Scenario: Lookup with an invalid verse
		When I visit "/api/v1/bible/Genesis/1/100"
		Then the http response status code should be 404
		And the JSON should be:
		"""
		{
		"error":"No results found."
		}
		"""

  Scenario: complex lookup can have passage param
    When I visit "/api/v1/bible/?passage=Genesis 1:1"
    Then the http response status code should be 200

  Scenario: complex lookup can have search param
    When I visit "/api/v1/bible/?search=Job"
    Then the http response status code should be 200

  Scenario: Complex lookuo cannot have both passage and search params at the same time
    When I visit "/api/v1/bible/?passage=Genesis 1:1&search=Job"
    Then the http response status code should be 400
    And the JSON should be:
    """
    {
    "error":"Only one of the parameters 'passage' and 'search' can be specified."
    }
    """

  Scenario: full search, single keyword, multiple results
    When I visit "/api/v1/bible/?search=Ulai"
    Then the JSON should be:
    """
    {
    "results":[
                {
                  "bookname":"Daniel",
                  "chapter":8,
                  "text":"And I saw in the vision; now it was so, that when I saw, I was in Shushan the palace, which is in the province of Elam; and I saw in the vision, and I was by the river Ulai.",
                  "verse":2
                },
                {
                  "bookname":"Daniel",
                  "chapter":8,
                  "text":"And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.",
                  "verse":16
                }
              ]
    }
    """

  Scenario: full search, multiple keywords
    When I visit "/api/v1/bible/?search=ulai+Gabriel"
    Then the JSON should be:
    """
    {
    "results":[
                {
                  "bookname":"Daniel",
                  "chapter":8,
                  "text":"And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.",
                  "verse":16
                }
              ]
    }
    """

  Scenario: full search, no results
    When I visit "/api/v1/bible/?search=blarg"
    Then the JSON should be:
    """
    {
      "results":[]
    }
    """

  Scenario: scoped search, per chapter
    When I visit "/api/v1/bible/Genesis/3/?search=Adam"
		Then the http response status code should be 200
    And the JSON should be:
    """
    {
    "results":[
                {
                  "bookname":"Genesis",
                  "chapter":3,
                  "text":"And unto Adam he said, Because thou hast hearkened unto the voice of thy wife, and hast eaten of the tree, of which I commanded thee, saying, Thou shalt not eat of it: cursed is the ground for thy sake; in toil shalt thou eat of it all the days of thy life;",
                  "verse":17
                },
                {
                  "bookname":"Genesis",
                  "chapter":3,
                  "text":"And Jehovah God made for Adam and for his wife coats of skins, and clothed them.",
                  "verse":21
                }
              ]
    }
    """
