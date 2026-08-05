# %%
import pandas as pd
import sqlalchemy

# %%
con = sqlalchemy.create_engine('sqlite:///../../data/analytics/database.db')
# %%
df = pd.read_sql('abt_fiel', con)
df.head()
# %%
colunas_int = pd.Series([
 'qtdeAtivacaoVida',
 'qtdeAtivacaoD7',
 'qtdeAtivacaoD14',
 'qtdeAtivacaoD28',
 'qtdeAtivacaoD56',
 'qtdeTransacaoVida',
 'qtdeTransacaoD7',
 'qtdeTransacaoD14',
 'qtdeTransacaoD28',
 'qtdeTransacaoD56',
 'saldoVida',
 'saldoD7',
 'saldoD14',
 'saldoD28',
 'saldoD56',
 'qtdePontosPosVida',
 'qtdePontosPosD7',
 'qtdePontosPosD14',
 'qtdePontosPosD28',
 'qtdePontosPosD56',
 'qtdePontosNegVida',
 'qtdePontoNegD7',
 'qtdePontosNegD14',
 'qtdePontosNegD28',
 'qtdePontoNegD56',
 'qtdeTransacao_Dia_Vida',
 'qtdeTransacao_Dia_D7',
 'qtdeTransacao_Dia_D14',
 'qtdeTransacao_Dia_D28',
 'qtdeTransacao_Dia_D56',
 'qtdeChatMessage',
 'qtdeAirflowLover',
 'qtdeRLover',
 'qtdeResgatarPonei',
 'qtdeListadepresenca',
 'qtdePresencaStreak',
 'qtdeTrocadePontosStreamElements',
 'qtdeReembolsoTrocadePontosStreamElements',
 'qtdeRPG',
 'qtdeChurnModel',
 'qtdeFrequencia',
 'qtdeCursosCompletos',
 'qtdeCursosIncompletos',
 'qtdeDiasUltimaAtividade'])

colunas_float = pd.Series([
 'idadeDias',
 'pctTransacaoManha',
 'pctTransacaoTarde',
 'pctTransacaoNoite',
 'qtdeHorasVida',
  'qtdeHorasD7',
  'qtdeHorasD14',
  'qtdeHorasD28',
  'qtdeHorasD56',
 'pctAtivacaoMAU',
 'avgIntervaloDiasVida',
 'avgIntervaloDiasD28',
 'curiosoShare',
 'fielShare',
 'reconquistadoShare',
 'turistaShare',
 'desencantadoShare',
 'zumbiShare',
 'rebornShare',
 'mediaFrequenciaGrupo',
 'proporcaoFreqGrupo'])

# %%
df[colunas_int].astype('int')
# %%
df.to_csv('df.csv',sep=';')
############################
# %%
#DataFrame Out of Time - Para usar como forma de validar o modelo
df_oot = df[df['dtRef']==df['dtRef'].max()].reset_index(drop=True)
df_oot.head()
# %%
target = 'flFiel'

features = df.columns.tolist()[3:]

df_train_test = df[df['dtRef']<df['dtRef'].max()].reset_index(drop=True)

x = df_train_test[features]
y = df_train_test[target]
# %%
from sklearn import model_selection

x_train, x_test, y_train, y_test = model_selection.train_test_split(
    x, y, test_size= 0.2 ,random_state=42, stratify=y)

# %%
print(f"Base Treino: {y_train.shape[0]} Uni | Tx Target {100*y_train.mean():.2f}%")
print(f"Base Teste: {y_test.shape[0]} Uni | Tx Target {100*y_test.mean():.2f}%")
# %%
s_na = x_train.isna().mean()
s_na[s_na > 0]
# %%
features_cat = x_train.dtypes[x_train.dtypes == 'object'].index.tolist()
features_cat
# %%
x_train.dtypes.index.tolist()

#df_train = x_train.copy()
#df_train[target] = y_train.copy()

#df_train.groupby(target)
# %%
df[~df['carreira'].isna()]['carreira']
# %%
# %%
