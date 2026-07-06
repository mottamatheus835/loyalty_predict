WITH tb_life_cycle_atual AS
    (SELECT 
        IdCliente,
        descLifeCycle

    FROM life_cycle

    WHERE dtRef = DATE('2026-05-01', '-1 DAY'))

SELECT 
        IdCliente,
        descLifeCycle

FROM life_cycle

WHERE dtRef = DATE('2026-05-01', '-1 DAY')