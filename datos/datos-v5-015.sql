-- ============================================================
-- datos-v5-015: letra volada liberada (SC-62)
-- ------------------------------------------------------------
-- Modifica:
--   sptext pasa a liberado para libros y revistas, sin pendiente.
--   Probado por Alberto en Mint (2026-10-21) con un libro y una
--   revista: PDF, HTML y EPUB, la inserción desde el panel, el
--   resaltado y los casos que frenan (punto antes, mayúscula). El ODT
--   queda en el pendiente de SC-62 (gbcorpus-act-54.sql), no en la
--   fila (SC-34).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
INSERT INTO _verif SELECT 'sptext en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'sptext' AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'sptext' AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'sptext';

INSERT INTO _verif SELECT 'sptext liberado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'sptext' AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'sptext';
