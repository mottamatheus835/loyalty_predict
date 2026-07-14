# %%
import pandas as pd
import sqlalchemy 
import datetime
from tqdm import tqdm

# %%
def import_query(path):
    with open(path) as open_file:
        query = open_file.read()
    return query
# %%
query = import_query('life_cycle.sql')
#print(query)
# %%
engine_application = sqlalchemy.create_engine('sqlite:///../../data/loyalty_system/database.db')
engine_analytical = sqlalchemy.create_engine('sqlite:///../../data/analytics/database.db')
# %%
def date_range(start,stop):
    dates = []
    while start <= stop:
        dates.append(start)
        dt_start = datetime.datetime.strptime(start, "%Y-%m-%d") + datetime.timedelta(days=1)
        start = datetime.datetime.strftime(dt_start,'%Y-%m-%d')
    return dates

dates = date_range('2024-01-01',  '2026-12-01')
#print(dates)
# %%

for i in tqdm(dates, desc="Progresso: "):
    with engine_analytical.connect() as conn:
        try:
            query_delete = f"DELETE FROM life_cycle WHERE dtRef = date('{i}', - '1 day')"
            conn.execute(sqlalchemy.text(query_delete))
            conn.commit()
        except:
            continue
    
    #print(i)
    query_format = query.format(date=i)
    
    df = pd.read_sql(query_format, engine_application)
    df.to_sql('life_cycle', engine_analytical, index=False, if_exists='append')

# %%
df.head()
# %%
#df[df['dtRef'] == None].value_counts()
# %%
