WITH tb_transacao AS(
    SELECT *,
    SUBSTR(DtCriacao, 0,11) AS dtDia,
    CAST(SUBSTR(DtCriacao, 12,2) AS INT) AS dtHora

    FROM transacoes
    WHERE dtCriacao < '{date}'),

tb_agg_transacao AS  (
    SELECT IdCliente,
        MAX(JULIANDAY(DATE('{date}', '-1 DAY' )) - JULIANDAY(DtCriacao)) AS idadeDias,

        COUNT(DISTINCT dtDia) AS qtdeAtivacaoVida,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-7 day') THEN dtDia END) AS qtdeAtivacaoD7,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-14 day') THEN dtDia END) AS qtdeAtivacaoD14,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-28 day') THEN dtDia END) AS qtdeAtivacaoD28,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-56 day') THEN dtDia END) AS qtdeAtivacaoD56,

        COUNT(DISTINCT IdTransacao) AS qtdeTransacaoVida,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-7 day') THEN IdTransacao END) AS qtdeTransacaoD7,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-14 day') THEN IdTransacao END) AS qtdeTransacaoD14,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-28 day') THEN IdTransacao END) AS qtdeTransacaoD28,
        COUNT(DISTINCT CASE WHEN dtDia >= date('{date}', '-56 day') THEN IdTransacao END) AS qtdeTransacaoD56,

        SUM(qtdePontos) as saldoVida,
        SUM(CASE WHEN dtDia >= date('{date}', '-7 day') THEN  qtdePontos ELSE 0 END) AS   saldoD7,
        SUM(CASE WHEN dtDia >= date('{date}', '-14 day') THEN qtdePontos ELSE 0  END) AS    saldoD14,
        SUM(CASE WHEN dtDia >= date('{date}', '-28 day') THEN qtdePontos ELSE 0  END) AS   saldoD28,
        SUM(CASE WHEN dtDia >= date('{date}', '-56 day') THEN qtdePontos ELSE 0  END) AS    saldoD56,
        
        SUM(CASE WHEN qtdePontos> 0 THEN qtdePontos ELSE 0 END) as qtdePontosPosVida,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-7 day')  AND qtdePontos > 0 THEN  qtdePontos ELSE 0 END) AS   qtdePontosPosD7,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-14 day') AND qtdePontos > 0  THEN qtdePontos ELSE 0  END) AS    qtdePontosPosD14,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-28 day') AND qtdePontos > 0  THEN qtdePontos ELSE 0  END) AS   qtdePontosPosD28,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-56 day') AND qtdePontos > 0  THEN qtdePontos ELSE 0  END) AS    qtdePontosPosD56,

        SUM(CASE WHEN qtdePontos < 0 THEN qtdePontos ELSE 0 END) as qtdePontosNegVida,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-7 day')  AND qtdePontos < 0 THEN  qtdePontos ELSE 0 END) AS   qtdePontoNegD7,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-14 day') AND qtdePontos < 0  THEN qtdePontos ELSE 0  END) AS  qtdePontosNegD14,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-28 day') AND qtdePontos < 0  THEN qtdePontos ELSE 0  END) AS  qtdePontosNegD28,
        SUM(DISTINCT CASE WHEN dtDia >= date('{date}', '-56 day') AND qtdePontos < 0  THEN qtdePontos ELSE 0  END) AS  qtdePontoNegD56,

        1.* COUNT(CASE WHEN dtHora BETWEEN 10 AND 14 THEN IdTransacao END) / COUNT(IdTransacao) AS pctTransacaoManha,
        1.* COUNT(CASE WHEN dtHora BETWEEN 15 AND 21 THEN IdTransacao END) / COUNT(IdTransacao) AS pctTransacaoTarde,
        1.* COUNT(CASE WHEN dtHora > 21 OR dtHora < 10 THEN IdTransacao END) / COUNT(IdTransacao) AS pctTransacaoNoite


    FROM tb_transacao
    GROUP BY IdCliente
),

tb_agg_calc AS (
    SELECT *,
            COALESCE( 1. * qtdeTransacaoVida / qtdeAtivacaoVida, 0) AS qtdeTransacao_Dia_Vida,
            COALESCE( 1. * qtdeTransacaoD7 / qtdeAtivacaoD7, 0) AS qtdeTransacao_Dia_D7,
            COALESCE( 1. * qtdeTransacaoD14 / qtdeAtivacaoD14, 0) AS qtdeTransacao_Dia_D14,
            COALESCE( 1. * qtdeTransacaoD28 / qtdeAtivacaoD28, 0) AS qtdeTransacao_Dia_D28,
            COALESCE( 1. * qtdeTransacaoD56 / qtdeAtivacaoD56, 0) AS qtdeTransacao_Dia_D56,
            COALESCE(1. * qtdeAtivacaoD28 / 28, 0) AS pctAtivacaoMAU

    FROM tb_agg_transacao),
    

tb_horas_dia AS (
    SELECT 
        IdCliente,
        dtDia,
        24 * (MAX(JULIANDAY(DtCriacao)) - MIN(JULIANDAY(DtCriacao))) AS duracao
        

    FROM tb_transacao

    GROUP BY IdCliente, dtDia
),

tb_hora_cliente AS (    
    SELECT 
        IdCliente,
        SUM(duracao) AS qtdeHorasVida,
        SUM(CASE WHEN dtDia >= DATE('{date}', '-7 day') THEN duracao END) AS qtdeHorasD7,
        SUM(CASE WHEN dtDia >= DATE('{date}', '-14 day') THEN duracao END) AS qtdeHorasD14,
        SUM(CASE WHEN dtDia >= DATE('{date}', '-28 day') THEN duracao END) AS qtdeHorasD28,
        SUM(CASE WHEN dtDia >= DATE('{date}', '-56 day') THEN duracao END) AS qtdeHorasD56
    FROM tb_horas_dia

    GROUP BY IdCliente ),

tb_lag_dia AS (    
    SELECT
        IdCliente,
        dtDia,
        LAG(dtDia) OVER (PARTITION BY IdCliente ORDER BY dtDia) AS lagDia

    FROM tb_transacao
),

tb_intervalo_dias AS (
    SELECT 
        IdCliente,
        AVG(JULIANDAY(dtDia) - JULIANDAY(lagDia)) AS avgIntervaloDiasVida,
        AVG(CASE WHEN dtDia >= DATE('{date}', '-28 DAY') THEN JULIANDAY(dtDia) - JULIANDAY(lagDia) END) AS avgIntervaloDiasD28

    FROM tb_lag_dia

    GROUP BY IdCliente) ,

tb_share_produtos AS (SELECT 
                IdCliente,
                1. * COUNT(CASE WHEN DescNomeProduto = 'ChatMessage' THEN T1.IdTransacao END)  / COUNT(T1.IdTransacao) AS qtdeChatMessage,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Airflow Lover' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeAirflowLover,
                1. * COUNT(CASE WHEN DescNomeProduto = 'R Lover' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeRLover,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Resgatar Ponei' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeResgatarPonei,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Lista de presença' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeListadepresenca,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Presença Streak' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdePresencaStreak,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Troca de Pontos StreamElements' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeTrocadePontosStreamElements,
                1. * COUNT(CASE WHEN DescNomeProduto = 'Reembolso: Troca de Pontos StreamElements' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeReembolsoTrocadePontosStreamElements,
                1. * COUNT(CASE WHEN DescCategoriaProduto = 'rpg' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeRPG,
                1. * COUNT(CASE WHEN DescCategoriaProduto = 'churn_model' THEN T1.IdTransacao END) / COUNT(T1.IdTransacao) AS qtdeChurnModel


        FROM tb_transacao AS T1

        LEFT JOIN transacao_produto AS T2
        ON T1.IdTransacao = T2.IdTransacao

        LEFT JOIN produtos AS T3
        ON T2.IdProduto = T3.IdProduto

        GROUP BY IdCliente),
            
tb_join AS (SELECT 
    T1.*,
    T2.qtdeHorasVida,
    T2.qtdeHorasD7,
    T2.qtdeHorasD14,
    T2.qtdeHorasD28,
    T2.qtdeHorasD56,
    T3.avgIntervaloDiasVida,
    T3.avgIntervaloDiasD28,
    T4.qtdeChatMessage,
    T4.qtdeAirflowLover,
    T4.qtdeRLover,
    T4.qtdeResgatarPonei,
    T4.qtdeListadepresenca,
    T4.qtdePresencaStreak,
    T4.qtdeTrocadePontosStreamElements,
    T4.qtdeReembolsoTrocadePontosStreamElements,
    T4.qtdeRPG,
    T4.qtdeChurnModel

    FROM tb_agg_calc AS T1

    LEFT JOIN tb_hora_cliente AS T2 ON T1.IdCliente = T2.IdCliente
    LEFT JOIN tb_intervalo_dias AS T3 ON T1.IdCliente = T3.IdCliente    
    LEFT JOIN tb_share_produtos AS T4 ON T1.IdCliente = T4.IdCliente)

SELECT 
    DATE('{date}', '-1 DAY') AS dtRef,
    *

FROM tb_join