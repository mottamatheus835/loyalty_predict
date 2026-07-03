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

 SELECT idUsuario, 


SUM(CASE desSlugCurso = 'carreira' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'coleta-dados-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'ds-databricks-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'ds-pontos-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'estatistica-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'estatistica-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'f1-lake' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'github-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'github-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'go-2026' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'ia-canal-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'lago-mago-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'loyalty-predict-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'machine-learning-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'matchmaking-trampar-de-casa-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'ml-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'mlflow-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'nekt-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'pandas-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'pandas-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'plataforma-ml-2026' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'python-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'python-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'ragia' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'speed-f1' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'sql-2020' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'sql-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'streamlit-2025' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'trampar-lakehouse-2024' THEN percentCursoCompleto ELSE 0) AS 
SUM(CASE desSlugCurso = 'tse-analytics-2024' THEN percentCursoCompleto ELSE 0) AS 

from tb_percent_curso

GROUP BY idUsuario