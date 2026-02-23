import marimo

__generated_with = "0.20.2"
app = marimo.App(width="medium")


@app.cell
def _():
    import marimo as mo
    import duckdb
    import pandas as pd

    return duckdb, mo


@app.cell
def _(duckdb):
    conn = duckdb.connect("taxi_pipeline.duckdb")
    df = conn.sql("SELECT * FROM taxi_data.rides").df()
    return (conn,)


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Question 1
    """)
    return


@app.cell
def _(conn, mo):
    q1 = mo.sql(
        f"""
        SELECT MIN(trip_pickup_date_time)::DATE start_date, MAX(trip_pickup_date_time)::DATE end_date
        FROM taxi_data.rides
        """,
        engine=conn
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Question 2
    """)
    return


@app.cell
def _(conn, mo):
    q2 = mo.sql(
        f"""
        SELECT SUM(CASE WHEN payment_type = 'Credit' THEN 1 ELSE 0 END) * 100 / COUNT(*) credit_proportion
        FROM taxi_data.rides 
        LIMIT 10
        """,
        engine=conn
    )
    return


@app.cell(hide_code=True)
def _(mo):
    mo.md(r"""
    ## Question 3
    """)
    return


@app.cell
def _(conn, mo):
    q3 = mo.sql(
        f"""
        SELECT SUM(tip_amt) total_tip_amt
        FROM taxi_data.rides
        """,
        engine=conn
    )
    return


@app.cell
def _():
    return


if __name__ == "__main__":
    app.run()
