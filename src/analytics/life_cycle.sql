-- curioso - > idade < 7
-- fiel - > recencia < 7 e recencia anterior < 15
-- turista -> recencia >= 7 e <= 14
-- desencantado -> 14 < recencia <= 28
-- zumbi -> recencia > 28
-- reconquistado -> recencia < 7 e 14 <= recencia anterior <= 28
-- reborn -> recencia < 7 e recencia anterior > 28

WITH tb_daily AS (
-- lista com clientes de cada dia
    SELECT 
    DISTINCT IdCliente,
    substr(DtCriacao, 0, 11) dtDia

    FROM transacoes
    WHERE DtCriacao < '{date}'
),

 tb_idade AS(
    SELECT 
    IdCliente,
    --MIN(dtDia) AS dtPrimTransacao,
    CAST(MAX( JULIANDAY('{date}') - JULIANDAY(dtDia)) AS INT) AS qtdeDiasPrimTransacao,
    --MAX(dtDia) AS dtUltimaTransacao,
    CAST(MIN(JULIANDAY('{date}') - JULIANDAY(dtDia)) AS INT) AS qtdeDiasUltTransacao

    FROM tb_daily

    GROUP BY idCliente
    ),

 tb_rownumber AS(
    SELECT *,
    ROW_NUMBER() OVER (PARTITION BY IdCliente ORDER BY dtDia DESC) AS rnDia
    
    FROM tb_daily
),
tb_penultima AS(
    SELECT *,
    CAST(JULIANDAY('{date}') - JULIANDAY(dtDia) AS INT) AS qtdeDiasPenultimaTransacao
    FROM tb_rownumber
    WHERE rnDia = 2
),
tb_life_cycle as (
    SELECT t1.*,
        t2.qtdeDiasPenultimaTransacao,
        CASE 
            WHEN qtdeDiasPrimTransacao <= 7 THEN "01-CURIOSO"
            WHEN qtdeDiasUltTransacao <= 7 AND (qtdeDiasPenultimaTransacao - qtdeDiasUltTransacao) <= 14 THEN "02-FIEL"
            WHEN qtdeDiasUltTransacao BETWEEN 8 AND 14 THEN "03-TURISTA"
            WHEN qtdeDiasUltTransacao BETWEEN 15 AND 28 THEN "04-DESENCANTADO"
            WHEN qtdeDiasUltTransacao >28 THEN "05-ZUMBI"
            WHEN qtdeDiasUltTransacao <= 7 AND (qtdeDiasPenultimaTransacao - qtdeDiasUltTransacao) BETWEEN 15 AND 28 THEN "02-RECONQUISTADO"
            WHEN qtdeDiasUltTransacao <= 7 AND (qtdeDiasPenultimaTransacao - qtdeDiasUltTransacao) > 28 THEN "06-REBORN"
            END AS descLifeCycle
    FROM tb_idade as t1
    LEFT JOIN tb_penultima as t2
    ON t1.idCliente = t2.idCliente

),

 tb_freq_valor AS (
    SELECT IdCliente,
        count(DISTINCT substr(DtCriacao, 0, 11)) AS qtdeFrequencia,
        sum(CASE WHEN QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS qtdePontosPos,
        sum(abs(QtdePontos)) AS qtdePontosAbs

    FROM transacoes 

    WHERE DtCriacao < '{date}'

    AND DtCriacao >= date('{date}', '-28 DAY')

    GROUP BY 1

    ORDER BY Dtcriacao DESC
),

tb_cluster AS
(    SELECT *, 
    CASE 
        WHEN qtdeFrequencia BETWEEN 15 AND 20 AND qtdePontosPos >4000  THEN '24-OUTLIER'
        WHEN qtdeFrequencia BETWEEN 21 AND 29 AND qtdePontosPos >=2000 THEN '23-EFICIENTES'
        WHEN qtdeFrequencia BETWEEN 15 AND 20 AND qtdePontosPos BETWEEN 2700 AND 4000 THEN '22-DEDICADOS'
        WHEN qtdeFrequencia BETWEEN 12 AND 20 AND qtdePontosPos < 2700  THEN '21-ESTUDANTES'
        WHEN qtdeFrequencia <12 AND qtdePontosPos > 2000 THEN '10-ACUMULADORES'
        WHEN qtdeFrequencia BETWEEN 5 AND 11 AND qtdePontosPos < 2000 THEN '01-INDECISOS'
        WHEN qtdeFrequencia <5 AND qtdePontosPos < 2000 THEN '00-CASUAIS'  
    END AS cluster
    FROM tb_freq_valor)

SELECT date('{date}', '-1 day') AS dtRef,
       t1.*,
       t2.qtdeFrequencia,
       t2.qtdePontosPos,
       t2.cluster

FROM tb_life_cycle AS t1 
LEFT JOIN tb_cluster AS t2 ON t1.IdCliente = t2.IdCliente
    ;
