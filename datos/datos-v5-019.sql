-- ============================================================
-- datos-v5-019: el ancho proporcional de la figura (SC-76)
-- ------------------------------------------------------------
-- Modifica:
--   figure: como_sale suma un párrafo sobre ancho=NN, el porcentaje
--   del ancho de la columna. Solo de libros. Lote 2 de las imágenes
--   (fenced-divs-to-elements-db.lua, las tres hojas de salida y la
--   regla gbp-ancho del validador).
-- Después: reexportar el catálogo (SC-34).
-- Esquema: 5
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- --- 1. PRECONDICIONES: LA FILA, SIN EL PÁRRAFO, CON EL TEXTO DE ANCLA UNA VEZ ---
INSERT INTO _verif SELECT 'figure existe', COUNT(*) = 1 FROM shortcodes WHERE nombre = 'figure';
INSERT INTO _verif SELECT 'sin ancho todavía', instr(como_sale, 'ancho=') = 0 FROM shortcodes WHERE nombre = 'figure';
INSERT INTO _verif SELECT 'ancla una vez', (length(como_sale) - length(replace(como_sale, 'Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.', ''))) = length('Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.') FROM shortcodes WHERE nombre = 'figure';

-- --- 2. CAMBIO ---
UPDATE shortcodes
   SET como_sale = replace(como_sale, 'Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.', 'Con `alt="..."` en la apertura, ese texto describe la imagen en el EPUB; si falta, se usa el pie.

En un libro, `ancho=60` en la apertura (`::: {.fig #fig-mapa ancho=60}`) compone la figura al 60 % del ancho de la columna en el PDF. En el EPUB y el HTML es un tope: la imagen sale a su tamaño, y nunca más ancha que ese porcentaje. Va un número entero de 1 a 100, sin el signo; otro valor detiene la conversión. Sin `ancho`, el ancho de la columna. Por ahora es solo de libros.'),
       fecha_modificacion = datetime('now','localtime')
 WHERE nombre = 'figure';

INSERT INTO _verif SELECT 'párrafo agregado', instr(como_sale, 'ancho=60') > 0 FROM shortcodes WHERE nombre = 'figure';

DROP TABLE _verif;

COMMIT;
