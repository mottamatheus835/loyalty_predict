WITH tb_freq_valor AS (
    SELECT IdCliente,
        count(DISTINCT substr(DtCriacao, 0, 11)) AS qtdeFrequencia,
        sum(CASE WHEN QtdePontos > 0 THEN qtdePontos ELSE 0 END) AS qtdePontosPos,
        sum(abs(QtdePontos)) AS qtdePontosAbs

    FROM transacoes 

    WHERE DtCriacao < '2026-06-01'

    AND DtCriacao >= date('2026-06-01', '-28 DAY')

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

SELECT *
FROM tb_cluster 
    ;

--1 - laranjas   
--0> a <5 dias e com pontos de zero a 2000   
--
--2 - azuis  
--5>= dias e <12 dias e com pontos de zero a 2000
--
--3 - vermelhos  
--0> a < 12 dias e com pontos 2000> e <max   
--
--4 - roxos  
--12>= dias e <21 dias e com pontos de 0 a 2700  
--
--5 - verde 1
--15>= dias e <21 dias e com pontos 2700>= e <4000   
--
--6 - verde 2    
--21>= dias e <30 dias e com pontos 2000>= e <max
--
--7 - verde 3 outlier
--15>= dias e <21 dias e com pontos 4000>= e <max