-- ============================================================
-- datos-v5-011: verso liberado (SC-49)
-- ------------------------------------------------------------
-- Modifica:
--   verse pasa a liberado para libros y revistas, sin pendiente.
--   Probado en Mint (2026-10) con prueba-verso.md: PDF, HTML y EPUB
--   en libros y revistas. Lo que falta (ODT, inserción desde el
--   panel, casos que frenan, epubcheck) queda en el pendiente de
--   SC-49 del corpus; el XML JATS y sus sabores se prueban en la
--   fase de JATS, con todos los shortcodes desarrollados (decisión
--   de Alberto). La fila no puede llevar pendiente: el esquema no
--   admite liberado con pendiente (SC-34).
-- Requiere datos-v5-010 aplicado.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- EN BORRADOR, CON LOS TRES TEXTOS DE LA AYUDA Y LOS DE datos-v5-010
INSERT INTO _verif SELECT 'verse en borrador', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse'
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse'
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;
INSERT INTO _verif SELECT 'datos-v5-010 aplicado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse' AND instr(ejemplo, 'patron="01"') > 0;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'verse';

-- --- 3. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'verse liberado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'verse'
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes WHERE nombre = 'verse';
