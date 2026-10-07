-- ============================================================
-- datos-v5-004: recuadros comunes liberados (SC-41)
-- ------------------------------------------------------------
-- Modifica:
--   recuadro y recuadrob pasan a liberado para libros y revistas,
--   sin pendiente. Probados en Mint (gbpublisher 3.22.2, 2026-10)
--   en libros: PDF, HTML y EPUB. Falta la prueba en artículo de
--   revista; queda registrada en SC-41. La regla de SC-34 no
--   admite liberado en un producto y borrador en el otro.
--   recuadro-ancho y recuadrob-ancho, solo de revistas, siguen en
--   borrador hasta probarlos.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS DOS EN BORRADOR Y CON LOS TRES TEXTOS DE LA AYUDA
INSERT INTO _verif SELECT 'recuadros comunes en borrador', COUNT(*) = 2 FROM shortcodes
  WHERE nombre IN ('recuadro', 'recuadrob')
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 2 FROM shortcodes
  WHERE nombre IN ('recuadro', 'recuadrob')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre IN ('recuadro', 'recuadrob');

-- --- 3. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'recuadros comunes liberados', COUNT(*) = 2 FROM shortcodes
  WHERE nombre IN ('recuadro', 'recuadrob')
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;
-- LAS VARIANTES DE ANCHO NO SE TOCAN
INSERT INTO _verif SELECT 'variantes de ancho en borrador', COUNT(*) = 2 FROM shortcodes
  WHERE nombre IN ('recuadro-ancho', 'recuadrob-ancho')
    AND estado_libro = 'no_aplica' AND estado_revista = 'borrador';

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
WHERE clase IN ('recuadro', 'recuadrob') ORDER BY orden;
