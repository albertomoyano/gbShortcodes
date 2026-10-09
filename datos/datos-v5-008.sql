-- ============================================================
-- datos-v5-008: conversación (SC-43), ajustes de diseño
-- ------------------------------------------------------------
-- Modifica la ayuda (como_sale) de conversacion y respuesta:
--   HTML: la etiqueta de quien responde también va en azul.
--   PDF: el bloque va corrido 14 pt a la izquierda, como la cita;
--   sin sangría de primera línea.
-- Siguen en borrador: falta probar el ODT y el XML JATS.
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES: LOS TEXTOS QUE SE REEMPLAZAN ESTÁN ---
INSERT INTO _verif SELECT 'conversacion con el texto viejo', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'conversacion'
    AND instr(como_sale, 'en sans y en cuerpo chico, sin sangría,') > 0
    AND instr(como_sale, 'las etiquetas en negrita, y la de la pregunta además en azul.') > 0;
INSERT INTO _verif SELECT 'respuesta con el texto viejo', COUNT(*) = 1 FROM shortcodes
  WHERE nombre = 'respuesta'
    AND instr(como_sale, 'En el HTML, el EPUB y el ODT, en negrita; en el PDF, en peso normal.') > 0;

-- --- 2. AYUDA ---
UPDATE shortcodes SET
  como_sale = replace(replace(como_sale,
    'en sans y en cuerpo chico, sin sangría,',
    'en sans y en cuerpo chico, corrida a la izquierda como una cita, sin sangría de primera línea,'),
    'las etiquetas en negrita, y la de la pregunta además en azul.',
    'las etiquetas en negrita y en azul, la de quien pregunta y la de quien responde.'),
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'conversacion';

UPDATE shortcodes SET
  como_sale = replace(como_sale,
    'En el HTML, el EPUB y el ODT, en negrita; en el PDF, en peso normal.',
    'En el HTML, en negrita y azul; en el EPUB y el ODT, en negrita; en el PDF, en peso normal.'),
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'respuesta';

-- --- 3. PENDIENTE: LO QUE FALTA PROBAR ---
UPDATE shortcodes SET
  pendiente = 'Probado en Mint (2026-10): PDF, HTML y EPUB en libros y revistas. Falta probar el ODT y el XML JATS.',
  fecha_modificacion = datetime('now','localtime')
WHERE nombre = 'conversacion';

-- --- 4. VERIFICACIÓN ---
INSERT INTO _verif SELECT 'textos nuevos', COUNT(*) = 2 FROM shortcodes
  WHERE (nombre = 'conversacion' AND instr(como_sale, 'corrida a la izquierda como una cita') > 0
         AND instr(como_sale, 'la de quien pregunta y la de quien responde.') > 0)
     OR (nombre = 'respuesta' AND instr(como_sale, 'En el HTML, en negrita y azul;') > 0);

DROP TABLE _verif;

COMMIT;

SELECT nombre, estado_libro, estado_revista, pendiente FROM shortcodes
WHERE nombre IN ('conversacion', 'pregunta', 'respuesta', 'acotacion') ORDER BY orden;
