-- ============================================================
-- datos-v5-017: cifras liberadas (SC-65)
-- ------------------------------------------------------------
-- Modifica:
--   num, si y si-rango pasan a liberado para libros y revistas, sin
--   pendiente. Probado por Alberto en Mint (2026-10-22): PDF, HTML y
--   EPUB con cifras en un título, un párrafo, una nota y una celda; el
--   marcador del PDF; la inserción desde el panel; el aviso de un
--   porcentaje suelto y un caso que frena (\SI{88}{\per}). Lo que
--   falta (el capítulo en otro idioma en el PDF del libro) queda en el
--   pendiente de SC-65 (gbcorpus-act-59.sql), no en la fila (SC-34).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
INSERT INTO _verif SELECT 'tres en borrador', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('num', 'si', 'si-rango')
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('num', 'si', 'si-rango')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre IN ('num', 'si', 'si-rango');

INSERT INTO _verif SELECT 'tres liberadas', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('num', 'si', 'si-rango')
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
 WHERE nombre IN ('num', 'si', 'si-rango') ORDER BY orden;
