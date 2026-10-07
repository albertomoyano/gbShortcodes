-- ============================================================
-- datos-v5-002: espaciov liberado
-- ------------------------------------------------------------
-- Modifica:
--   espaciov pasa a liberado para libros y revistas, sin pendiente.
--   Probado en Mint (gbpublisher 3.22.2, 2026-10): inserción desde el
--   panel con el modo separador-valor, PDF con el espacio, HTML y EPUB
--   sin rastro. La regla de SC-34 no admite liberado en un producto y
--   borrador en el otro.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- EL SHORTCODE EXISTE, EN BORRADOR, Y TIENE LOS TRES TEXTOS DE LA AYUDA
INSERT INTO _verif SELECT 'espaciov en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'espaciov' AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'espaciov' AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;

UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'espaciov';

INSERT INTO _verif SELECT 'espaciov liberado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'espaciov' AND estado_libro = 'liberado' AND estado_revista = 'liberado'
  AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'espaciov';
