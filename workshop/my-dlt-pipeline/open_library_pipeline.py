"""A dlt pipeline to ingest book data from the Open Library Books API."""

import dlt
from dlt.sources.rest_api import rest_api_resources
from dlt.sources.rest_api.typing import RESTAPIConfig


@dlt.source
def open_library_rest_api_source():
    """Define dlt resources from the Open Library REST API."""
    config: RESTAPIConfig = {
        "client": {
            "base_url": "https://openlibrary.org",
        },
        "resources": [
            {
                "name": "books",
                "endpoint": {
                    "path": "api/books",
                    "params": {
                        "bibkeys": "ISBN:0451526538,ISBN:9780980200447",
                        "format": "json",
                        "jscmd": "data",
                    },
                    "data_selector": "$.*",
                    "paginator": {
                        "type": "single_page",
                    },
                },
                "write_disposition": "replace",
            },
        ],
    }

    yield from rest_api_resources(config)


pipeline = dlt.pipeline(
    pipeline_name='open_library_pipeline',
    destination='duckdb',
    refresh="drop_sources",
    progress="log",
)


if __name__ == "__main__":
    load_info = pipeline.run(open_library_rest_api_source())
    print(load_info)  # noqa: T201
