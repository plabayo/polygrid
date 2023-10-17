use std::path::PathBuf;

use axum::{routing::get, Router};
use tower::ServiceBuilder;
use tower_http::{
    compression::CompressionLayer, normalize_path::NormalizePathLayer, services::ServeDir,
    trace::TraceLayer,
};

mod pages {
    use askama::Template;

    #[derive(Template)]
    #[template(path = "../templates/index.html")]
    pub struct IndexTemplate;

    pub async fn index() -> IndexTemplate {
        IndexTemplate
    }

    #[derive(Template)]
    #[template(path = "../templates/editor.html")]
    pub struct EditorTemplate;

    pub async fn editor() -> EditorTemplate {
        EditorTemplate
    }

    #[derive(Template)]
    #[template(path = "../templates/404.html")]
    pub struct NotFoundTemplate;

    pub async fn not_found() -> NotFoundTemplate {
        NotFoundTemplate
    }
}

#[shuttle_runtime::main]
async fn axum() -> shuttle_axum::ShuttleAxum {
    let router = Router::new()
        .route("/", get(pages::index))
        .route("/editor", get(pages::editor))
        .nest_service("/static", ServeDir::new(PathBuf::from("polygrid-website/static")))
        .fallback(pages::not_found)
        .layer(
            ServiceBuilder::new()
                .layer(TraceLayer::new_for_http())
                .layer(CompressionLayer::new())
                .layer(NormalizePathLayer::trim_trailing_slash()),
        );

    Ok(router.into())
}
