WITH tb_life_cycle_atual AS
    (SELECT 
        IdCliente,
        descLifeCycle AS descLifeCycleAtual

    FROM life_cycle

    WHERE dtRef = DATE('2026-05-01', '-1 DAY')),

tb_life_cycle_D28 AS (
    SELECT 
        IdCliente,
        descLifeCycle AS descLifeCycleD28

    FROM life_cycle

    WHERE dtRef = DATE('2026-05-01', '-28 DAY')), 

tb_share_ciclos AS (
    SELECT IdCliente,

    1. * SUM(CASE WHEN descLifeCycle = "01-CURIOSO" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS curiosoShare,
    1. * SUM(CASE WHEN descLifeCycle = "02-FIEL" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS fielShare,
    1. * SUM(CASE WHEN descLifeCycle = "02-RECONQUISTADO" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS reconquistadoShare,
    1. * SUM(CASE WHEN descLifeCycle = "03-TURISTA" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS turistaShare,
    1. * SUM(CASE WHEN descLifeCycle = "04-DESENCANTADO" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS desencantadoShare,
    1. * SUM(CASE WHEN descLifeCycle = "05-ZUMBI" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS zumbiShare,
    1. * SUM(CASE WHEN descLifeCycle = "06-REBORN" THEN 1 ELSE 0 END) / COUNT(descLifeCycle) AS rebornShare

    FROM life_cycle

    WHERE dtRef < '2026-05-01'

    GROUP BY IdCliente),

tb_join AS (
    SELECT 
        T1.*,
        T2.descLifeCycleD28,
        curiosoShare,
        T3.fielShare,
        T3.reconquistadoShare,
        T3.turistaShare,
        T3.desencantadoShare,
        T3.zumbiShare,
        T3.rebornShare
    
    FROM tb_life_cycle_atual AS T1

    LEFT JOIN tb_life_cycle_D28 AS T2 ON T1.IdCliente = T2.IdCliente
    LEFT JOIN tb_ciclos_share AS T3 ON T1.IdCliente = T3.IdCliente
)
;