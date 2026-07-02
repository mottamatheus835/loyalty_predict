# %%
import pandas as pd
import sqlalchemy
# %%
#Defini uma função para ler a query do arquivo sql e depois colocar em uma variável
def import_query(path):
    with open(path) as open_file:
        query = open_file.read()
    return query

query = import_query("life_cycle.sql")
#print(query)
# %%
#Criei as engines para interagir com os bancos de dados, o original e o analítico
engine_read = sqlalchemy.create_engine("sqlite:///../../data/loyalty_system/database.db")

engine_save_db = sqlalchemy.create_engine("sqlite:///../../data/analytics/database.db")
# %%
#Criei uma atualização em lista das datas até o último dia

dates = [
    '2025-01-01', '2025-02-01', '2025-03-01', '2025-04-01', '2025-05-01', '2025-06-01', 
    '2025-07-01', '2025-08-01', '2025-09-01', '2025-10-01', '2025-11-01', '2025-12-01',
     '2026-01-01',  '2026-02-01', '2026-03-01', '2026-04-01',  '2026-05-01',  '2026-06-01',
]


# %%

for i in dates:
    with engine_save_db.connect() as con:
        try:
            con.execute(sqlalchemy.text(f'DELETE FROM life_cycle WHERE dtRef = date("{i}", "-1 day")'))
            con.commit()
        except Exception as error:
            print(error)
    query_format = (query.format(date=i))
    
    df = pd.read_sql(query_format,engine_read)

    df.to_sql("life_cycle", engine_save_db, index=False, if_exists="append")
# %%
