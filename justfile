check:
    cargo check --workspace --all-targets

check-wasm32:
    cargo check --workspace --all-features --lib --target wasm32-unknown-unknown

check-fmt:
    cargo fmt --all -- --check

clippy:
    cargo clippy --workspace --all-targets --all-features --  -D warnings -W clippy::all

test:
    cargo test --workspace --all-targets --all-features

test-docs:
    cargo test --workspace --doc

trunk-build:
    cd polygrid-app && trunk build --release

trunk-watch:
    cd polygrid-app && trunk watch

qa: check check-wasm32 check-fmt clippy test test-docs trunk-build
    scripts/prepare_dist_sw_js.py

fmt:
    cargo fmt --all

clippy-fix:
    cargo clippy --fix --workspace --all-targets --all-features --allow-dirty

fix: fmt clippy-fix

git-push: qa
    git push

shuttle-deploy name="polygrid-website": qa
    cargo shuttle deploy --name {{name}} --no-test

shuttle-deploy-test:
    just shuttle-deploy "polygrid-website-test"

shuttle-watch name="polygrid-website":
    cargo watch -x 'shuttle run --name {{name}}' -i 'polygrid-website-app,Cargo.lock'
