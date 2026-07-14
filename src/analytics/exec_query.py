# %%
import pandas as pd
import sqlalchemy 
import datetime
from tqdm import tqdm
import argparse
# %%
### FUNÇÕES ###
def import_query(path):
    with open(path) as open_file:
        query = open_file.read()
    return query


def date_range(start,stop):
    dates = []
    while start <= stop:
        dates.append(start)
        dt_start = datetime.datetime.strptime(start, "%Y-%m-%d") + datetime.timedelta(days=1)
        start = datetime.datetime.strftime(dt_start,'%Y-%m-%d')
    return dates


def exec_query(table, db_origin, db_target, dt_start, dt_stop):
    query = import_query(f'{table}.sql')

    engine_application = sqlalchemy.create_engine(f'sqlite:///../../data/{db_origin}/database.db')
    engine_analytical = sqlalchemy.create_engine(f'sqlite:///../../data/{db_target}/database.db')

    dates = date_range(dt_start, dt_stop)


    for i in tqdm(dates, desc="Progresso: "):
        with engine_analytical.connect() as conn:
            try:
                query_delete = f"DELETE FROM {table} WHERE dtRef = date('{i}', '-1 day')"
                conn.execute(sqlalchemy.text(query_delete))
                conn.commit()
            except Exception as Erro:
                
                if Erro == f"(sqlite3.OperationalError) no such table: {table}":
                    print(f"Uma nova tabela chamada {table} será criada, pois ela não existe")
                else:
                    print(Erro)
        query_format = query.format(date=i)
        
        df = pd.read_sql(query_format, engine_application)
        df.to_sql(table, engine_analytical, index=False, if_exists='append')

# %%
def main():

    parser = argparse.ArgumentParser()
    parser.add_argument('--db_origin', choices=['loyalty_system', 'education_platform'],
                        default= 'loyalty_system')
    parser.add_argument('--db_target', choices=['analytics'], default='analytics')

    parser.add_argument('--table', type=str, help='Tabela que será processada com o mesmo nome do arquivo sql')
    
    parser.add_argument('--dt_start', type=str, default='2024-01-01')

    stop = datetime.datetime.now().strftime('%Y-%m-%d')
    parser.add_argument('--dt_stop', type=str, default=stop)

    args = parser.parse_args()

    exec_query(args.table, args.db_origin, args.db_target, args.dt_start, args.dt_stop)

#%%
if __name__ ==  "__main__":
    main()





# %%
