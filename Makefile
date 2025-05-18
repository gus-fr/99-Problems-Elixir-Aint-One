# Makefile

FORMAT_FILES := $(shell find ./src -type f \( -name "*.ex" -o -name "*.exs" \))

.PHONY: format
format:
	@echo $(FORMAT_FILES)
	@echo "Formatting Elixir files..."
	@mix format $(FORMAT_FILES)
