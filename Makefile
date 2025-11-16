magic:
	@echo "Magic command executed"
	cargo fmt
	cargo clippy -- -D warnings
	cargo doc