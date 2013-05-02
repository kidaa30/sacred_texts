Feature: Bible API

	Scenario: Lookup a valid text
		When I visit "/api/v1/bible/Genesis/1/1"
		Then the http response status code should be 200
		And the content_type should be json
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
		And the content_type should be json
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
		<bible>
		<bookname>Genesis</bookname>
		<chapter type="integer">1</chapter>
		<verse type="integer">1</verse>
		<text>In the beginning God created the heavens and the earth.</text>
		</bible>
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
		When I visit "/api/v1/bible?passage=Genesis 1:1"
		Then the http response status code should be 200

	Scenario: complex lookup can have search param
		When I visit "/api/v1/bible?search=Job"
		Then the http response status code should be 200

	Scenario: Complex lookuo cannot have both passage and search params at the same time
		When I visit "/api/v1/bible?passage=Genesis 1:1&search=Job"
		Then the http response status code should be 400
		And the JSON should be:
		"""
		{
		"error":"Only one of the parameters 'passage' and 'search' can be specified."
		}
		"""

	Scenario: full search, single keyword, multiple results
		When I visit "/api/v1/bible?search=Ulai"
		Then the content_type should be json
		And the JSON should be:
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
		When I visit "/api/v1/bible?search=ulai+Gabriel"
		Then the content_type should be json
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
		When I visit "/api/v1/bible?search=blarg"
		Then the JSON should be:
		"""
		{
		"results":[]
		}
		"""

	Scenario: Chapter search
		When I visit "/api/v1/bible/Genesis/3?search=Adam"
		Then the http response status code should be 200
		Then the content_type should be json
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

	Scenario: Book search
		When I visit "/api/v1/bible/Genesis?search=wounding"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
    {
    "results":[
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"And Lamech said unto his wives: Adah and Zillah, hear my voice; Ye wives of Lamech, hearken unto my speech: For I have slain a man for wounding me, And a young man for bruising me:",
    "verse":23
    }
    ]
    }
		"""

	Scenario: Full search, type json
		When I visit "/api/v1/bible?search=ulai+Gabriel&type=json"
		Then the content_type should be json
		And the JSON should be:
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

	Scenario: Full search, type xml
		When I visit "/api/v1/bible?search=ulai+Gabriel&type=xml"
		Then the XML should be:
		"""
		<?xml version="1.0" encoding="UTF-8"?>
		<hash>
		<results type="array">
		<result>
		<bookname>Daniel</bookname>
		<chapter type="integer">8</chapter>
		<text>And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.</text>
		<verse type="integer">16</verse>
		</result>
		</results>
		</hash>
		"""

	Scenario: Exact search mode, per book
    When I visit "/api/v1/bible/Genesis?search=Eve+Cain&mode=exact"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
    {
    "results":[
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"And the man knew Eve his wife; and she conceived, and bare Cain, and said, I have gotten a man with [the help of] Jehovah.",
    "verse":1
    }
    ]
    }
		"""

	Scenario: Regular search mode, per book
    When I visit "/api/v1/bible/Genesis?search=Eve+Cain"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
    {
    "results":[
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"And the man knew Eve his wife; and she conceived, and bare Cain, and said, I have gotten a man with [the help of] Jehovah.",
    "verse":1
    },
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"And Jehovah said unto him, Therefore whosoever slayeth Cain, vengeance shall be taken on him sevenfold. And Jehovah appointed a sign for Cain, lest any finding him should smite him.",
    "verse":15
    },
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"And Zillah, she also bare Tubal-cain, the forger of every cutting instrument of brass and iron: and the sister of Tubal-cain was Naamah.",
    "verse":22
    },
    {
    "bookname":"Genesis",
    "chapter":4,
    "text":"If Cain shall be avenged sevenfold, Truly Lamech seventy and sevenfold.","verse":24
    }
    ]
    }
		"""
