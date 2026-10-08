-- ============================================================
-- datos-v5-006: código liberado (SC-42)
-- ------------------------------------------------------------
-- Modifica:
--   codigo, listado y codigo-linea pasan a liberado para libros y
--   revistas, sin pendiente. Probados en Mint (2026-10): PDF (también
--   el de imprenta), HTML, EPUB y ODT en libros y revistas; inserción
--   desde el panel; los casos que frenan. Los sabores JATS de revista
--   (SciELO, Redalyc) quedan para la fase de revistas: no son del
--   shortcode, son de los sabores. La regla de SC-34 no admite
--   liberado en un producto y borrador en el otro.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS TRES EN BORRADOR Y CON LOS TRES TEXTOS DE LA AYUDA
INSERT INTO _verif SELECT 'código en borrador', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea')
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre IN ('codigo', 'listado', 'codigo-linea');

-- --- 3. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'código liberado', COUNT(*) = 3 FROM shortcodes
  WHERE nombre IN ('codigo', 'listado', 'codigo-linea')
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
WHERE modo = 'codigo' ORDER BY tipo, orden;
