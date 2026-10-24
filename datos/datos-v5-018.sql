-- ============================================================
-- datos-v5-018: se retiran las filas viejas de las tablas (SC-67)
-- ------------------------------------------------------------
-- Borra:
--   table-wrap, table-fullwidth y table-landscape. Abrían el viejo
--   bloque ::: {.table #tbl-id}, que cuadro-leer.lua frena desde la
--   entrega 1 de los cuadros (SC-66): el cuadro vive en su archivo,
--   cuadros/tbl-….md, y lo crea, lo edita y lo inserta el formulario
--   de los cuadros (FTabla, SC-67). Las tres estaban en borrador: solo
--   se veían desde el IDE. Pendiente anotado en SC-66 (act-63).
-- Después: reexportar el catálogo (SC-34).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES: LAS TRES, SIN LIBERAR, CON EL BLOQUE VIEJO ---
INSERT INTO _verif SELECT 'tres filas de la clase table', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('table-wrap', 'table-fullwidth', 'table-landscape')
    AND clase = 'table';
INSERT INTO _verif SELECT 'ninguna liberada', COUNT(*) = 0 FROM shortcodes
  WHERE nombre IN ('table-wrap', 'table-fullwidth', 'table-landscape')
    AND (estado_libro = 'liberado' OR estado_revista = 'liberado');
INSERT INTO _verif SELECT 'las tres abren ::: {.table', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('table-wrap', 'table-fullwidth', 'table-landscape')
    AND apertura LIKE '::: {.table %';

-- --- 2. BAJA ---
DELETE FROM shortcodes
 WHERE nombre IN ('table-wrap', 'table-fullwidth', 'table-landscape');

INSERT INTO _verif SELECT 'ninguna de la clase table', COUNT(*) = 0 FROM shortcodes
  WHERE clase = 'table';

DROP TABLE _verif;

COMMIT;

SELECT COUNT(*) AS shortcodes_que_quedan FROM shortcodes;
