Feature: Bible search

	Scenario: full search, single keyword, multiple results
		When I visit "/api/v1/bible/verses?q=Ulai"
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":2,
		"verses":[
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
		When I visit "/api/v1/bible/verses?q=ulai+Gabriel"
		Then the content_type should be json
		Then the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
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
		When I visit "/api/v1/bible/verses?q=blarg"
		Then the http response status code should be 404
		And the JSON should be:
		"""
    {
    "error" : "No results found."
		}
		"""

	Scenario: Chapter search
		When I visit "/api/v1/bible/books/Genesis/chapters/3/verses?q=Adam"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":2,
		"verses":[
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

	Scenario: Chapter search, multiple keywords
		When I visit "/api/v1/bible/books/Daniel/chapters/8/verses?q=ulai+Gabriel"
		Then the content_type should be json
		Then the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
		{
		"bookname":"Daniel",
		"chapter":8,
		"text":"And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.",
		"verse":16
		}
		]
		}
		"""

	Scenario: Book search
		When I visit "/api/v1/bible/books/Genesis/verses?q=wounding"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
		{
		"bookname":"Genesis",
		"chapter":4,
		"text":"And Lamech said unto his wives: Adah and Zillah, hear my voice; Ye wives of Lamech, hearken unto my speech: For I have slain a man for wounding me, And a young man for bruising me:",
		"verse":23
		}
		]
		}
		"""

	Scenario: Book search, multiple keywords
		When I visit "/api/v1/bible/books/Daniel/verses?q=ulai+Gabriel"
		Then the content_type should be json
		Then the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
		{
		"bookname":"Daniel",
		"chapter":8,
		"text":"And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.",
		"verse":16
		}
		]
		}
		"""

	Scenario: Full search, type json
		When I visit "/api/v1/bible/verses?q=ulai+Gabriel&type=json"
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
		{
		"bookname":"Daniel",
		"chapter":8,
		"text":"And I heard a man`s voice between [the banks of] the Ulai, which called, and said, Gabriel, make this man to understand the vision.",
		"verse":16
		}
		]
		}
		"""

	Scenario: Whole word search mode, per book
		When I visit "/api/v1/bible/books/Genesis/verses?q=Eve+Cain&mode=whole"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
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
		When I visit "/api/v1/bible/books/Genesis/verses?q=Eve+Cain"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":4,
		"verses":[
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

	Scenario: Whole word search mode, per chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/4/verses?q=Eve+Cain&mode=whole"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":1,
		"verses":[
		{
		"bookname":"Genesis",
		"chapter":4,
		"text":"And the man knew Eve his wife; and she conceived, and bare Cain, and said, I have gotten a man with [the help of] Jehovah.",
		"verse":1
		}
		]
		}
		"""

	Scenario: Regular search mode, per chapter
		When I visit "/api/v1/bible/books/Genesis/chapters/4/verses?q=Eve+Cain"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON should be:
		"""
		{
		"total_count":4,
		"verses":[
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

	Scenario: Large result sets should return 10 results by default for global searches
		When I visit "/api/v1/bible/verses?q=God"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 10 entries

	Scenario: Large result sets should return 10 results by default for book scoped searches
		When I visit "/api/v1/bible/books/Genesis/verses?q=God"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 10 entries

	Scenario: Large result sets should return 10 results by default for chapter scoped searches
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?q=God"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 10 entries

	Scenario: Specify result size for global searches
		When I visit "/api/v1/bible/verses?q=God&num=4"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 4 entries

	Scenario: Specify result size for book scoped searches
		When I visit "/api/v1/bible/books/Genesis/verses?q=God&num=4"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 4 entries

	Scenario: Specify result size for chapter scoped searches
		When I visit "/api/v1/bible/books/Genesis/chapters/1/verses?q=God&num=4"
		Then the http response status code should be 200
		Then the content_type should be json
		And the JSON at "verses" should have 4 entries

	Scenario: Specify page for global searches
		When I visit "/api/v1/bible/verses?q=God&page=2"
		Then the http response status code should be 200
		Then the content_type should be json
	    And the JSON at "verses/0" should be:
	    """
	    {
	    "bookname":"Genesis",
	    "chapter":1,
	    "text":"And God said, Let the earth put forth grass, herbs yielding seed, [and] fruit-trees bearing fruit after their kind, wherein is the seed thereof, upon the earth: and it was so.",
	    "verse":11
	    }
	    """

	Scenario: Specify page for book scoped searches
		When I visit "/api/v1/bible/books/Mark/verses?q=God&page=2"
		Then the http response status code should be 200
		Then the content_type should be json
	    And the JSON at "verses/0" should be:
	    """
	    {
	    "bookname":"Mark",
	    "chapter":4,
	    "text":"And he said, So is the kingdom of God, as if a man should cast seed upon the earth;",
	    "verse":26
	    }
	    """

	Scenario: Specify page for chapter scoped searches
		When I visit "/api/v1/bible/books/Genesis/chapters/2/verses?q=God&page=2"
		Then the http response status code should be 200
		Then the content_type should be json
	    And the JSON at "verses/0" should be:
	    """
	    {
	    "bookname":"Genesis",
	    "chapter":2,
	    "text":"And out of the ground Jehovah God formed every beast of the field, and every bird of the heavens; and brought them unto the man to see what he would call them: and whatsoever the man called every living creature, that was the name thereof.",
	    "verse":19
	    }
	    """

	Scenario: next_page element is not present when remaining global search results are less than a page
		When I visit "/api/v1/bible/verses?q=Jesus&page=89"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining global search results exceed a page
		When I visit "/api/v1/bible/verses?q=Jesus"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for global search results
		When I visit "/api/v1/bible/verses?q=Jesus&page=3"
		Then the JSON at "next_page" should include "/api/v1/bible/verses?q=Jesus&page=4"

	Scenario: next_page element is not present when remaining book scoped search results are less than a page
		When I visit "/api/v1/bible/books/Daniel/verses?q=Ulai"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining book scoped search results exceed a page
		When I visit "/api/v1/bible/books/Matthew/verses?q=Jesus"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for book scoped search results
		When I visit "/api/v1/bible/books/Matthew/verses?q=Jesus&page=3"
		Then the JSON at "next_page" should include "/api/v1/bible/books/Matthew/verses?q=Jesus&page=4"

	Scenario: next_page element is not present when remaining chapter scoped search results are less than a page
		When I visit "/api/v1/bible/books/Daniel/chapters/1/verses?q=Ulai"
		Then the JSON should not have "next_page"

	Scenario: next_page element is present when remaining chapter scoped search results exceed a page
		When I visit "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus"
		Then the JSON should have "next_page"

	Scenario: next_page element references the next page for chapter scoped search results
		When I visit "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus&page=1"
		Then the JSON at "next_page" should include "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus&page=2"

	Scenario: previous_page element is not present when global search results are on the first page
		When I visit "/api/v1/bible/verses?q=Jesus"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when global search results are on a page greater than 1 
		When I visit "/api/v1/bible/verses?q=Jesus&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for global search results
		When I visit "/api/v1/bible/verses?q=Jesus&page=3"
		Then the JSON at "previous_page" should include "/api/v1/bible/verses?q=Jesus&page=2"

	Scenario: previous_page element is not present when book scoped search results are on the first page
		When I visit "/api/v1/bible/books/Daniel/verses?q=Ulai"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when remaining book scoped search results are on a page greater than 1 
		When I visit "/api/v1/bible/books/Matthew/verses?q=Jesus&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for book scoped search results
		When I visit "/api/v1/bible/books/Matthew/verses?q=Jesus&page=3"
		Then the JSON at "previous_page" should include "/api/v1/bible/books/Matthew/verses?q=Jesus&page=2"

	Scenario: previous_page element is not present when chapter scoped search results are on the first page 
		When I visit "/api/v1/bible/books/Daniel/chapters/1/verses?q=Ulai"
		Then the JSON should not have "previous_page"

	Scenario: previous_page element is present when chapter scoped search results are on a page greater than 1 
		When I visit "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus&page=2"
		Then the JSON should have "previous_page"

	Scenario: previous_page element references the previous page for chapter scoped search results
		When I visit "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus&page=2"
		Then the JSON at "previous_page" should include "/api/v1/bible/books/Matthew/chapters/9/verses?q=Jesus&page=1"
