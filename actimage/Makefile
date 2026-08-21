TYPST = typst compile
ASSETS = assets

.PHONY: rapport assets

rapport.pdf: rapport.typ
	$(TYPST) rapport.typ

assets:
	dot -Tsvg $(ASSETS)/onacvg-migration.dot -o $(ASSETS)/onacvg-migration.svg
