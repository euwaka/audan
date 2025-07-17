CC := gcc

VENDOR_LIB_DIR := build/vendor/

# raylib
RAYLIB_SRC_FILES  := $(wildcard vendor/raylib/src/*.c)
RAYLIB_INCLUDE    := vendor/raylib/src

# audan constants 
INCLUDE   := -Isrc/ -I$(RAYLIB_INCLUDE) 
SRC_FILES := $(wildcard src/*.c)
TARGET    := build/audan

CFLAGS := -Wall -Wpedantic -Wextra -std=c17 -ggdb
CLIBS  := -L$(VENDOR_LIB_DIR) -lm -lraylib 

.PHONY: all run build clean vendor build_docs

build_docs:
	@echo "Building docs.pdf in build/docs/..."
	@mkdir -p build/docs/
	@pdflatex -output-directory="build/docs/" docs/main.tex

vendor: raylib 
	@echo "Vendor is built..."

raylib:
	@echo "Building raylib..."
	@mkdir -p $(VENDOR_LIB_DIR)
	@$(MAKE) -C vendor/raylib/src/ clean
	@$(MAKE) -C vendor/raylib/src/ PLATFORM=PLATFORM_DESKTOP 
	@mv vendor/raylib/src/libraylib.a $(VENDOR_LIB_DIR)

all: build

build: $(SRC_FILES)
	@echo "Building audan..."
	@mkdir -p build/
	@$(CC) $(CFLAGS) $(INCLUDE) $(SRC_FILES) -o $(TARGET) $(CLIBS) 

run: 
	@./$(TARGET)

clean:
	@echo "Cleanning junk..."
	@rm -rf build/
