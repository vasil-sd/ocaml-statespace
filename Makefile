PROJECT=statespace
GITHUB_URL=https://github.com/vasil-sd/ocaml-$(PROJECT)

.PHONY: all build clean release test

release:
	git push --tags
	@ TAG=$$(git tag | tail -n 1); \
	mkdir -p release/$(PROJECT).$$TAG; \
	cp $(PROJECT).descr release/$(PROJECT).$$TAG/descr; \
	cp $(PROJECT).opam release/$(PROJECT).$$TAG/opam; \
	ARCHIVE=$(GITHUB_URL)/archive/$$TAG.tar.gz; \
	MD5SUM=$$(wget -O - $$ARCHIVE 2> /dev/null | md5sum | awk '{print $$1}'); \
	echo "archive: \"$$ARCHIVE\"" > release/$(PROJECT).$$TAG/url; \
	echo "checksum: \"$$MD5SUM\"" >> release/$(PROJECT).$$TAG/url

build:
	dune build @install

test:
	dune runtest

all: build

install:
	dune install

uninstall:
	dune uninstall

clean:
	rm -rf _build *.install

