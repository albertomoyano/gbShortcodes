-- ============================================================
-- datos-v5-009: conversación liberada (SC-43)
-- ------------------------------------------------------------
-- Modifica:
--   conversacion, pregunta, respuesta y acotacion pasan a liberado
--   para libros y revistas, sin pendiente. Probados en Mint (2026-10):
--   PDF, HTML y EPUB en libros y revistas. Falta probar el ODT y el
--   XML JATS (validación, sabores y packtools): por decisión de
--   Alberto se liberan igual, y lo que falta queda anotado en el
--   pendiente de SC-43 del corpus. La fila no puede llevarlo: el
--   esquema no admite liberado con pendiente (SC-34), como en el
--   código (datos-v5-006, SC-42).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES ---
-- LOS CUATRO EN BORRADOR, CON LOS TRES TEXTOS DE LA AYUDA Y CON LOS
-- AJUSTES DE datos-v5-008 YA APLICADOS
INSERT INTO _verif SELECT 'conversación en borrador', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
    AND estado_libro = 'borrador' AND estado_revista = 'borrador';
INSERT INTO _verif SELECT 'ayuda completa', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
    AND que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL;
INSERT INTO _verif SELECT 'datos-v5-008 aplicado', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'conversacion' AND instr(como_sale, 'corrida a la izquierda como una cita') > 0;

-- --- 2. LIBERACIÓN ---
UPDATE shortcodes SET
  estado_libro = 'liberado',
  estado_revista = 'liberado',
  pendiente = NULL,
  fecha_modificacion = datetime('now','localtime')
WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion');

-- --- 3. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'conversación liberada', COUNT(*) = 4 FROM shortcodes
  WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion')
    AND estado_libro = 'liberado' AND estado_revista = 'liberado'
    AND pendiente IS NULL;

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista FROM shortcodes
WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion') ORDER BY orden;
