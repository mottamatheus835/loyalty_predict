WITH tb_usuario_eps AS (
    SELECT idUsuario,
        descSlugCurso,
        COUNT(descSlugCursoEpisodio) qtdeEps

    FROM cursos_episodios_completos  

    GROUP BY idUsuario, descSlugCurso) ,

tb_curso AS (
    SELECT descSlugCurso,
    COUNT(nrEp) totalEps 
 
    FROM cursos_episodios 
 
     GROUP BY descSlugCurso),


tb_percent_curso AS (
 SELECT idUsuario,
        T1.descSlugCurso,
        T1.qtdeEps,
        T2.totalEps,
        (1. * T1.qtdeEps) / T2.totalEps AS percentCursoCompleto
 
 FROM tb_usuario_eps AS T1
 LEFT JOIN tb_curso AS T2 ON T1.descSlugCurso = T2.descSlugCurso
 GROUP BY T1.idUsuario, T1.descSlugCurso)

 SELECT 
    idUsuario, 

    SUM(CASE WHEN descSlugCurso = 'carreira' THEN percentCursoCompleto ELSE 0 END) AS carreira,
    SUM(CASE WHEN descSlugCurso = 'coleta-dados-2024' THEN percentCursoCompleto ELSE 0 END) AS coletaDados2024,
    SUM(CASE WHEN descSlugCurso = 'ds-databricks-2024' THEN percentCursoCompleto ELSE 0 END) AS dsDatabricks2024,
    SUM(CASE WHEN descSlugCurso = 'ds-pontos-2024' THEN percentCursoCompleto ELSE 0 END) AS dsPontos2024,
    SUM(CASE WHEN descSlugCurso = 'estatistica-2024' THEN percentCursoCompleto ELSE 0 END) AS estatistica2024,
    SUM(CASE WHEN descSlugCurso = 'estatistica-2025' THEN percentCursoCompleto ELSE 0 END) AS estatistica2025,
    SUM(CASE WHEN descSlugCurso = 'f1-lake' THEN percentCursoCompleto ELSE 0 END) AS f1Lake,
    SUM(CASE WHEN descSlugCurso = 'github-2024' THEN percentCursoCompleto ELSE 0 END) AS github2024,
    SUM(CASE WHEN descSlugCurso = 'github-2025' THEN percentCursoCompleto ELSE 0 END) AS github2025,
    SUM(CASE WHEN descSlugCurso = 'go-2026' THEN percentCursoCompleto ELSE 0 END) AS go2026,
    SUM(CASE WHEN descSlugCurso = 'ia-canal-2025' THEN percentCursoCompleto ELSE 0 END) AS iaCanal2025,
    SUM(CASE WHEN descSlugCurso = 'lago-mago-2024' THEN percentCursoCompleto ELSE 0 END) AS lagoMago2024,
    SUM(CASE WHEN descSlugCurso = 'loyalty-predict-2025' THEN percentCursoCompleto ELSE 0 END) AS loyaltyPredict2025,
    SUM(CASE WHEN descSlugCurso = 'machine-learning-2025' THEN percentCursoCompleto ELSE 0 END) AS machineLearning2025,
    SUM(CASE WHEN descSlugCurso = 'matchmaking-trampar-de-casa-2024' THEN percentCursoCompleto ELSE 0 END) AS matchmakingTrampardecasa2024,
    SUM(CASE WHEN descSlugCurso = 'ml-2024' THEN percentCursoCompleto ELSE 0 END) AS ml2024,
    SUM(CASE WHEN descSlugCurso = 'mlflow-2025' THEN percentCursoCompleto ELSE 0 END) AS mlflow2025,
    SUM(CASE WHEN descSlugCurso = 'nekt-2025' THEN percentCursoCompleto ELSE 0 END) AS nekt2025,
    SUM(CASE WHEN descSlugCurso = 'pandas-2024' THEN percentCursoCompleto ELSE 0 END) AS pandas2024,
    SUM(CASE WHEN descSlugCurso = 'pandas-2025' THEN percentCursoCompleto ELSE 0 END) AS pandas2025,
    SUM(CASE WHEN descSlugCurso = 'plataforma-ml-2026' THEN percentCursoCompleto ELSE 0 END) AS plataformaMl2026,
    SUM(CASE WHEN descSlugCurso = 'python-2024' THEN percentCursoCompleto ELSE 0 END) AS python2024,
    SUM(CASE WHEN descSlugCurso = 'python-2025' THEN percentCursoCompleto ELSE 0 END) AS python2025,
    SUM(CASE WHEN descSlugCurso = 'ragia' THEN percentCursoCompleto ELSE 0 END) AS ragia,
    SUM(CASE WHEN descSlugCurso = 'speed-f1' THEN percentCursoCompleto ELSE 0 END) AS SpeedF1,
    SUM(CASE WHEN descSlugCurso = 'sql-2020' THEN percentCursoCompleto ELSE 0 END) AS sql2020,
    SUM(CASE WHEN descSlugCurso = 'sql-2025' THEN percentCursoCompleto ELSE 0 END) AS sql2025,
    SUM(CASE WHEN descSlugCurso = 'streamlit-2025' THEN percentCursoCompleto ELSE 0 END) AS streamlit2025,
    SUM(CASE WHEN descSlugCurso = 'trampar-lakehouse-2024' THEN percentCursoCompleto ELSE 0 END) AS tramparLakehouse2024,
    SUM(CASE WHEN descSlugCurso = 'tse-analytics-2024' THEN percentCursoCompleto ELSE  0 END) AS tseAnalytics2024

from tb_percent_curso

GROUP BY idUsuario