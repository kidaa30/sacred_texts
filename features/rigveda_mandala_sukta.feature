Feature: Rigveda mandala/sukta resource

	Scenario: Test redirect of /api/v1/rigveda/mandala/{mandala_id}/suktas{sukta_id}
		When I visit "/api/v1/rigveda/mandalas/1/suktas/1"
		Then I should be on "the mandalas/1/suktas/1/rcas page"

	Scenario: Test redirect of /api/v1/rigveda/mandala/{mandala_id}/suktas
		When I visit "/api/v1/rigveda/mandalas/1/suktas"
		Then I should be on "the mandalas/1 page"
