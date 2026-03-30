# dbt-test-1

dbt project for testing against a Trino backend (Chameleon).

## Prerequisites

- [uv](https://docs.astral.sh/uv/) installed
- Access to the Trino instance at `chameleon.local:443`

## Setup

1. Create a `.env` file with your Trino credentials:

   ```
   TRINO_USER=<your-username>
   TRINO_PASSWORD=<your-password>
   ```

2. Install dependencies:

   ```sh
   uv sync
   ```

## Running dbt

All dbt commands are run via `uv run` with `--env-file .env` to inject the Trino credentials:

```sh
# Load seeds
uv run --env-file .env dbt seed

# Run models
uv run --env-file .env dbt run

# Run tests
uv run --env-file .env dbt test

# Full pipeline (seed + run + test)
uv run --env-file .env dbt build
```
