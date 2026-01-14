import pandas as pd
from sqlalchemy import create_engine
import click

@click.command()
@click.option('--pg-user', default='postgres', help='PostgreSQL username')
@click.option('--pg-pass', default='postgres', help='PostgreSQL password')
@click.option('--pg-host', default='localhost', help='PostgreSQL host')
@click.option('--pg-port', default='5433', help='PostgreSQL port')
@click.option('--pg-db', default='ny_taxi', help='PostgreSQL database name')
def main(pg_user, pg_pass, pg_host, pg_port, pg_db): 

    df_trip = pd.read_parquet('https://d37ci6vzurychx.cloudfront.net/trip-data/green_tripdata_2025-11.parquet')
    df_zone = pd.read_csv('https://github.com/DataTalksClub/nyc-tlc-data/releases/download/misc/taxi_zone_lookup.csv')

    engine = create_engine(f'postgresql://{pg_user}:{pg_pass}@{pg_host}:{pg_port}/{pg_db}')

    df_trip.to_sql(name = "green_tripdata", con = engine, if_exists = "replace")
    df_zone.to_sql(name = "zones", con = engine, if_exists = "replace")

if __name__ == '__main__':
    main()


