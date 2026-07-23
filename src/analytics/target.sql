CREATE TABLE abt_fiel AS 

WITH tb_join AS(
SELECT 
    T1.dtRef,
    T1.IdCliente,
    T1.descLifeCycle,
    T2.descLifeCycle,
    CASE WHEN T2.descLifeCycle = '02-FIEL' THEN 1 ELSE 0 END AS flFiel,
    ROW_NUMBER() OVER (PARTITION BY T1.IdCliente ORDER BY RANDOM()) AS RandomCol

FROM life_cycle AS T1

LEFT JOIN life_cycle AS T2
ON T1.IdCliente = T2.IdCliente 
AND DATE(T1.dtRef, '+28 DAY') =  DATE(T2.dtRef)

WHERE ((T1.dtRef >= '2024-01-01' AND T1.dtRef <= '2026-05-01') 
        OR T1.dtRef = '2026-06-01')
AND T1.descLifeCycle <> '05-ZUMBI'

),
   tb_cohort AS (
    SELECT 
        T1.dtRef,
        T1.IdCliente,
        T1.flFiel

    FROM tb_join as T1

    WHERE RandomCol <= 2

    ORDER BY IdCliente, dtRef
)

SELECT 
        --target
        T1.*,
        --fs_transacional
        T2.idadeDias,
        T2.qtdeAtivacaoVida,
        T2.qtdeAtivacaoD7,
        T2.qtdeAtivacaoD14,
        T2.qtdeAtivacaoD28,
        T2.qtdeAtivacaoD56,
        T2.qtdeTransacaoVida,
        T2.qtdeTransacaoD7,
        T2.qtdeTransacaoD14,
        T2.qtdeTransacaoD28,
        T2.qtdeTransacaoD56,
        T2.saldoVida,
        T2.saldoD7,
        T2.saldoD14,
        T2.saldoD28,
        T2.saldoD56,
        T2.qtdePontosPosVida,
        T2.qtdePontosPosD7,
        T2.qtdePontosPosD14,
        T2.qtdePontosPosD28,
        T2.qtdePontosPosD56,
        T2.qtdePontosNegVida,
        T2.qtdePontoNegD7,
        T2.qtdePontosNegD14,
        T2.qtdePontosNegD28,
        T2.qtdePontoNegD56,
        T2.pctTransacaoManha,
        T2.pctTransacaoTarde,
        T2.pctTransacaoNoite,
        T2.qtdeTransacao_Dia_Vida,
        T2.qtdeTransacao_Dia_D7,
        T2.qtdeTransacao_Dia_D14,
        T2.qtdeTransacao_Dia_D28,
        T2.qtdeTransacao_Dia_D56,
        T2.pctAtivacaoMAU,
        T2.qtdeHorasVida,
        T2.qtdeHorasD7,
        T2.qtdeHorasD14,
        T2.qtdeHorasD28,
        T2.qtdeHorasD56,
        T2.avgIntervaloDiasVida,
        T2.avgIntervaloDiasD28,
        T2.qtdeChatMessage,
        T2.qtdeAirflowLover,
        T2.qtdeRLover,
        T2.qtdeResgatarPonei,
        T2.qtdeListadepresenca,
        T2.qtdePresencaStreak,
        T2.qtdeTrocadePontosStreamElements,
        T2.qtdeReembolsoTrocadePontosStreamElements,
        T2.qtdeRPG,
        T2.qtdeChurnModel,
        --fs_life_cycle
        T3.qtdeFrequencia,
        T3.descLifeCycleAtual,
        T3.descLifeCycleD28,
        T3.curiosoShare,
        T3.fielShare,
        T3.reconquistadoShare,
        T3.turistaShare,
        T3.desencantadoShare,
        T3.zumbiShare,
        T3.rebornShare,
        T3.mediaFrequenciaGrupo,
        --fs_education
        T3.proporcaoFreqGrupo,
        T4.qtdeCursosCompletos, 
        T4.qtdeCursosIncompletos, 
        T4.carreira, 
        T4.coletaDados2024, 
        T4.dsDatabricks2024, 
        T4.dsPontos2024, 
        T4.estatistica2024, 
        T4.estatistica2025, 
        T4.f1Lake, 
        T4.github2024, 
        T4.github2025, 
        T4.go2026, 
        T4.iaCanal2025, 
        T4.lagoMago2024, 
        T4.loyaltyPredict2025, 
        T4.machineLearning2025, 
        T4.matchmakingTrampardecasa2024, 
        T4.ml2024, 
        T4.mlflow2025, 
        T4.nekt2025, 
        T4.pandas2024, 
        T4.pandas2025, 
        T4.plataformaMl2026, 
        T4.python2024, 
        T4.python2025, 
        T4.ragia, 
        T4.SpeedF1, 
        T4.sql2020, 
        T4.sql2025, 
        T4.streamlit2025, 
        T4.tramparLakehouse2024, 
        T4.tseAnalytics2024, 
        T4.qtdeDiasUltimaAtividade

FROM tb_cohort AS T1

LEFT JOIN fs_transacional AS T2 ON T1.IdCliente = T2.IdCliente
AND T1.dtRef = T2.dtRef

LEFT JOIN fs_life_cycle AS T3 ON T1.IdCliente = T3.IdCliente
AND T1.dtRef = T3.dtRef

LEFT JOIN fs_education AS T4 ON T1.IdCliente = T4.IdCliente
AND T1.dtRef = T4.dtRef

;   