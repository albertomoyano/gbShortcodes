-- ============================================================
-- datos-v5-013: alineación liberada (SC-61)
-- ------------------------------------------------------------
-- Modifica:
--   alinear-izq, alinear-centro y alinear-der pasan a liberado
--   para libros y revistas, sin pendiente. Probados en Mint
--   (2026-10-21) con un libro y una revista: PDF, HTML y EPUB.
--   Lo que falta (ODT, panel, conteo, mensaje de un caso que frena)
--   queda en el pendiente de SC-61 (gbcorpus-act-50.sql), no en las
--   filas (SC-34).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS TRES EN BORRADOR Y CON LA AYUDA COMPLETA
INSERT INTO _verif SELECT 'tres en borrador', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('alinear-izq', 'alinear-centro', 'alinear-der')
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('alinear-izq', 'alinear-centro', 'alinear-der')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre IN ('alinear-izq', 'alinear-centro', 'alinear-der');

INSERT INTO _verif SELECT 'tres liberados', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('alinear-izq', 'alinear-centro', 'alinear-der')
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
 WHERE grupo = 'composicion' ORDER BY orden;
