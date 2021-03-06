SOURCE_DIRECTORY := src
SOURCE_EXTENSION := .md
SOURCE_TYPE := markdown

OUTPUT_DIRECTORY := site
OUTPUT_EXTENSION := .html
OUTPUT_TYPE := html5

TEMPLATE_FILE := templates/layout.html

ASSETS_DIRECTORY := assets

SOURCE_FILES = $(shell find $(SOURCE_DIRECTORY) -type f -name '*$(SOURCE_EXTENSION)')
OUTPUT_FILES = $(patsubst $(SOURCE_DIRECTORY)/%$(SOURCE_EXTENSION),$(OUTPUT_DIRECTORY)/%$(OUTPUT_EXTENSION), $(SOURCE_FILES))

GENERATOR := pandoc
GENERATOR_FLAGS = --standalone --from $(SOURCE_TYPE) --to $(OUTPUT_TYPE) --template=$(TEMPLATE_FILE)

DEPLOY_SERVER := 192.168.1.51
DEPLOY_PATH := /var/www/nabile.duckdns.org/DotN64

$(OUTPUT_DIRECTORY)/%$(OUTPUT_EXTENSION): $(SOURCE_DIRECTORY)/%$(SOURCE_EXTENSION)
	mkdir -p $(OUTPUT_DIRECTORY)
	$(GENERATOR) $(GENERATOR_FLAGS) $< -o $@

all: $(OUTPUT_FILES)
	cp -r $(ASSETS_DIRECTORY)/. $(OUTPUT_DIRECTORY)

deploy: all
	rsync -rz --info=progress2 $(OUTPUT_DIRECTORY)/ $(DEPLOY_SERVER):$(DEPLOY_PATH)

clean:
	rm -r $(OUTPUT_DIRECTORY)

.PHONY: all deploy clean
