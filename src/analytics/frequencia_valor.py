# %%
import pandas as pd
import sqlalchemy
import matplotlib.pyplot as plt
import seaborn as sns
from sklearn import cluster
from sklearn import preprocessing
# %%
engine = sqlalchemy.create_engine("sqlite:///../../data/loyalty_system/database.db")

# %%
def import_query(path):
    with open(path) as open_file:
        query = open_file.read()
    return query

query = import_query("frequencia_valor.sql")
# %%
df = pd.read_sql(query, engine)
df.head()
df = df[df['IdCliente'] != '163022e8-12b8-486f-8604-57d8fa0ed7e1']

# %%
plt.plot(df['qtdeFrequencia'], df['qtdePontosPos'], 'o')
plt.grid()
plt.xlabel('Frequência')
plt.ylabel('Valor')
plt.show()
# %%
minmax = preprocessing.MinMaxScaler()
x = minmax.fit_transform(df[['qtdeFrequencia','qtdePontosPos']])

# %%

kmean = cluster.KMeans(n_clusters = 5, random_state = 42, max_iter= 1000)
kmean.fit(x)

df['cluster_calc'] = kmean.labels_

# %%
df.groupby(by='cluster')['IdCliente'].count()
df.groupby(by='cluster_calc')['IdCliente'].count()

# %%
sns.scatterplot(data=df, x='qtdeFrequencia', y='qtdePontosPos', hue = 'cluster_calc', palette = 'deep')
plt.hlines(y=2000,  xmin=0, xmax=12, color='black')
plt.vlines(x=5, ymin=0, ymax=2000, color='black')
plt.vlines(x=12,ymin=0,ymax=df['qtdePontosPos'].max()+200, color='black')
plt.vlines(x=21, ymin=0, ymax=df['qtdePontosPos'].max()+200,color='black')
plt.hlines(y=2700, xmin=12, xmax=21, color='black')
plt.hlines(y=4000, xmin=12, xmax=21 , color='black')
plt.grid()
# %%
df.sort_values('qtdePontosPos', ascending=False)
# %%
sns.scatterplot(data=df, x='qtdeFrequencia', y='qtdePontosPos', hue = 'cluster', palette = 'deep')
plt.hlines(y=2000,  xmin=0, xmax=12, color='black')
plt.vlines(x=5, ymin=0, ymax=2000, color='black')
plt.vlines(x=12,ymin=0,ymax=df['qtdePontosPos'].max()+200, color='black')
plt.vlines(x=21, ymin=0, ymax=df['qtdePontosPos'].max()+200,color='black')
plt.hlines(y=2700, xmin=12, xmax=21, color='black')
plt.hlines(y=4000, xmin=12, xmax=21 , color='black')
plt.grid()


# %%
#1 - laranjas
#0> a <5 dias e com pontos de zero a 2000
#
#2 - azuis
#5>= dias e <12 dias e com pontos de zero a 2000
#
#3 - vermelhos
#0> a < 12 dias e com pontos 2700> e <max
#
#4 - roxos 
#12>= dias e <21 dias e com pontos de 0 a 2700
#
#5 - verde 1
#15>= dias e <21 dias e com pontos 2700>= e <4000
#
#6 - verde 2 
#21>= dias e <30 dias e com pontos 2000>= e <max
#
#7 - verde 3 outlier
#15>= dias e <21 dias e com pontos 4000>= e <6000
#%%
