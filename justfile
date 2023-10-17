run:
    cd polygrid-website && cargo shuttle run

watch:
    cd polygrid-website && cargo watch -x "shuttle run" -i Cargo.lock

deploy:
    cargo shuttle deploy

wasm-pack:
    wasm-pack build --target web --release ./polygrid-editor
