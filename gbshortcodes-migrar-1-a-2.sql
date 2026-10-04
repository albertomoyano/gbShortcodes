-- ============================================================
-- Migración del esquema de gbShortcodes de la versión 1 a la 2
-- ------------------------------------------------------------
-- Agrega la columna clase: la clase de Pandoc que escribe el .md,
-- clave con que gbpublisher valida y empareja los cierres (RF-11).
-- Modifica: la tabla shortcodes (se rehace con la columna nueva en su
-- lugar, para que quede igual a una base creada en v2) y el ejemplo de
-- los bloques, que pasa a llevar el cierre nombrado (SC-33). Solo se
-- cambia un ejemplo que sigue igual al de la carga inicial: uno editado
-- se conserva y se lista al final.
-- Se corre desde una terminal: la aplicación no abre una base v1.
-- Migración: 1 a 2
-- Esquema: 1
-- ============================================================

BEGIN TRANSACTION;

CREATE TEMP TABLE _verif (paso TEXT, ok INTEGER CHECK (ok = 1));

-- LA CLASE Y EL EJEMPLO DE CADA SHORTCODE DE LA CARGA INICIAL
CREATE TEMP TABLE _clases (nombre TEXT PRIMARY KEY, clase TEXT NOT NULL,
                           ejemplo_v1 TEXT, ejemplo_v2 TEXT);

INSERT INTO _clases VALUES ('epigraph', 'epigraph', '::: epigraph
El conocimiento es poder.
— Francis Bacon
:::', '::: epigraph
El conocimiento es poder.
— Francis Bacon

[/epigraph]: # ()
:::');
INSERT INTO _clases VALUES ('figure', 'fig', '::: {.fig #fig-mapa}
![Pie de la figura, con *formato* y citas [@clave]](media/fig-mapa.png)
:::', '::: {.fig #fig-mapa}
![Pie de la figura, con *formato* y citas [@clave]](media/fig-mapa.png)

[/fig]: # ()
:::');
INSERT INTO _clases VALUES ('table-wrap', 'table', '::: {.table #tbl-datos}
| Variable | Grupo A | Grupo B |
|----------|---------|----------|
| Media    | 45.2    | 52.1     |

Tabla 1. Comparación de medias entre grupos.
:::', '::: {.table #tbl-datos}
| Variable | Grupo A | Grupo B |
|----------|---------|----------|
| Media    | 45.2    | 52.1     |

Tabla 1. Comparación de medias entre grupos.

[/table]: # ()
:::');
INSERT INTO _clases VALUES ('boxed-text', 'box', '::: {.box type="warning"}
**Advertencia**: Los resultados pueden variar según las condiciones ambientales.
:::', '::: {.box type="warning"}
**Advertencia**: Los resultados pueden variar según las condiciones ambientales.

[/box]: # ()
:::');
INSERT INTO _clases VALUES ('verse', 'verse', '::: verse
Caminante, son tus huellas
el camino y nada más;
caminante, no hay camino,
se hace camino al andar.
:::', '::: verse
Caminante, son tus huellas
el camino y nada más;
caminante, no hay camino,
se hace camino al andar.

[/verse]: # ()
:::');
INSERT INTO _clases VALUES ('code', 'code', '::: {.code language="python"}
~~~
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n-1)
~~~
:::', '::: {.code language="python"}
~~~
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n-1)
~~~

[/code]: # ()
:::');
INSERT INTO _clases VALUES ('chem-struct', 'chem-struct', '::: chem-struct
H₂SO₄
:::', '::: chem-struct
H₂SO₄
:::');
INSERT INTO _clases VALUES ('disp-formula', 'formula', '::: {.formula #eq-einstein}
$$E = mc^2$$
:::', '::: {.formula #eq-einstein}
$$E = mc^2$$

[/formula]: # ()
:::');
INSERT INTO _clases VALUES ('supplementary', 'supplementary', '::: {.supplementary #supp-datos}
Dataset completo disponible en: datos_experimento.xlsx
:::', '::: {.supplementary #supp-datos}
Dataset completo disponible en: datos_experimento.xlsx

[/supplementary]: # ()
:::');
INSERT INTO _clases VALUES ('clinical-trial', 'clinical-trial', '::: clinical-trial
Registro: ClinicalTrials.gov
Número: NCT01234567
:::', '::: clinical-trial
Registro: ClinicalTrials.gov
Número: NCT01234567

[/clinical-trial]: # ()
:::');
INSERT INTO _clases VALUES ('source-quote', 'source', '::: {.source archivo="AGN, Sala IX, Legajo 23-5-6"}
En el día de la fecha se procedió a la lectura del acta...
:::', '::: {.source archivo="AGN, Sala IX, Legajo 23-5-6"}
En el día de la fecha se procedió a la lectura del acta...

[/source]: # ()
:::');
INSERT INTO _clases VALUES ('glossary', 'glossary', '::: {.glossary term="Hermenéutica"}
Método de interpretación de textos que busca comprender el significado
a partir del contexto histórico y cultural del autor.
:::', '::: {.glossary term="Hermenéutica"}
Método de interpretación de textos que busca comprender el significado
a partir del contexto histórico y cultural del autor.

[/glossary]: # ()
:::');
INSERT INTO _clases VALUES ('speech', 'speech', '::: {.speech speaker="Entrevistado A"}
Yo creo que la situación cambió radicalmente a partir de 1990...
:::', '::: {.speech speaker="Entrevistado A"}
Yo creo que la situación cambió radicalmente a partir de 1990...

[/speech]: # ()
:::');
INSERT INTO _clases VALUES ('field-note', 'fieldnote', '::: {.fieldnote date="2024-03-15"}
Llegué al mercado a las 7am. Los vendedores ya estaban
organizando sus puestos...
:::', '::: {.fieldnote date="2024-03-15"}
Llegué al mercado a las 7am. Los vendedores ya estaban
organizando sus puestos...

[/fieldnote]: # ()
:::');
INSERT INTO _clases VALUES ('case-study', 'case', '::: {.case id="Empresa-Alpha"}
**Contexto**: Empresa mediana del sector manufacturero...
**Problema**: Caída de productividad del 15%...
:::', '::: {.case id="Empresa-Alpha"}
**Contexto**: Empresa mediana del sector manufacturero...
**Problema**: Caída de productividad del 15%...

[/case]: # ()
:::');
INSERT INTO _clases VALUES ('chem-equation', 'chem-equation', '::: chem-equation
2H₂ + O₂ → 2H₂O
:::', '::: chem-equation
2H₂ + O₂ → 2H₂O

[/chem-equation]: # ()
:::');
INSERT INTO _clases VALUES ('reaction-scheme', 'reaction-scheme', '::: reaction-scheme
[Esquema con pasos de síntesis]
:::', '::: reaction-scheme
[Esquema con pasos de síntesis]

[/reaction-scheme]: # ()
:::');
INSERT INTO _clases VALUES ('reaction-mechanism', 'reaction-mechanism', '::: reaction-mechanism
Paso 1: Ataque nucleofílico...
Paso 2: Eliminación...
:::', '::: reaction-mechanism
Paso 1: Ataque nucleofílico...
Paso 2: Eliminación...

[/reaction-mechanism]: # ()
:::');
INSERT INTO _clases VALUES ('spectral-data', 'spectral-data', '::: spectral-data {tipo="RMN-1H"}
¹H NMR (400 MHz, CDCl₃): δ 7.26 (s, 1H)...
:::', '::: spectral-data {tipo="RMN-1H"}
¹H NMR (400 MHz, CDCl₃): δ 7.26 (s, 1H)...

[/spectral-data]: # ()
:::');
INSERT INTO _clases VALUES ('experimental-procedure', 'experimental-procedure', '::: experimental-procedure
En un matraz de 250 mL se añadieron...
:::', '::: experimental-procedure
En un matraz de 250 mL se añadieron...

[/experimental-procedure]: # ()
:::');
INSERT INTO _clases VALUES ('crystal-data', 'crystal-data', '::: crystal-data
Sistema cristalino: monoclínico
Grupo espacial: P2₁/c
:::', '::: crystal-data
Sistema cristalino: monoclínico
Grupo espacial: P2₁/c

[/crystal-data]: # ()
:::');
INSERT INTO _clases VALUES ('theorem', 'theorem', '::: theorem {nombre="Pitágoras"}
En un triángulo rectángulo, el cuadrado de la hipotenusa...
:::', '::: theorem {nombre="Pitágoras"}
En un triángulo rectángulo, el cuadrado de la hipotenusa...

[/theorem]: # ()
:::');
INSERT INTO _clases VALUES ('proof', 'proof', '::: proof
Sea a, b, c los lados del triángulo...
:::', '::: proof
Sea a, b, c los lados del triángulo...

[/proof]: # ()
:::');
INSERT INTO _clases VALUES ('definition', 'definition', '::: definition {nombre="Límite"}
Sea f una función definida en un intervalo abierto...
:::', '::: definition {nombre="Límite"}
Sea f una función definida en un intervalo abierto...

[/definition]: # ()
:::');
INSERT INTO _clases VALUES ('lemma', 'lemma', '::: lemma
Si n es par, entonces n² es par.
:::', '::: lemma
Si n es par, entonces n² es par.

[/lemma]: # ()
:::');
INSERT INTO _clases VALUES ('corollary', 'corollary', '::: corollary
Todo número primo mayor que 2 es impar.
:::', '::: corollary
Todo número primo mayor que 2 es impar.

[/corollary]: # ()
:::');
INSERT INTO _clases VALUES ('proposition', 'proposition', '::: proposition
La suma de los ángulos internos de un triángulo es 180°.
:::', '::: proposition
La suma de los ángulos internos de un triángulo es 180°.

[/proposition]: # ()
:::');
INSERT INTO _clases VALUES ('axiom', 'axiom', '::: axiom
Por dos puntos distintos pasa una única recta.
:::', '::: axiom
Por dos puntos distintos pasa una única recta.

[/axiom]: # ()
:::');
INSERT INTO _clases VALUES ('math-example', 'math-example', '::: math-example
Calcular el límite de f(x) = (x²-1)/(x-1) cuando x→1...
:::', '::: math-example
Calcular el límite de f(x) = (x²-1)/(x-1) cuando x→1...

[/math-example]: # ()
:::');
INSERT INTO _clases VALUES ('numbered-equation', 'numbered-equation', '::: numbered-equation {id="eq-euler"}
e^{iπ} + 1 = 0
:::', '::: numbered-equation {id="eq-euler"}
e^{iπ} + 1 = 0

[/numbered-equation]: # ()
:::');
INSERT INTO _clases VALUES ('notation', 'notation', '::: notation
- ∀: para todo
- ∃: existe
- ∈: pertenece a
:::', '::: notation
- ∀: para todo
- ∃: existe
- ∈: pertenece a

[/notation]: # ()
:::');
INSERT INTO _clases VALUES ('problem', 'problem', '::: problem
Un proyectil se lanza con velocidad inicial v₀...
:::', '::: problem
Un proyectil se lanza con velocidad inicial v₀...

[/problem]: # ()
:::');
INSERT INTO _clases VALUES ('solution', 'solution', '::: solution
Aplicando las ecuaciones de movimiento...
:::', '::: solution
Aplicando las ecuaciones de movimiento...

[/solution]: # ()
:::');
INSERT INTO _clases VALUES ('primary-source', 'primary-source', '::: primary-source {fuente="BNE Ms. 1234, f. 23r"}
En aquel tiempo moraua en Toledo...
:::', '::: primary-source {fuente="BNE Ms. 1234, f. 23r"}
En aquel tiempo moraua en Toledo...

[/primary-source]: # ()
:::');
INSERT INTO _clases VALUES ('apparatus', 'apparatus', '::: apparatus
¹ moraua] moraba B, morava C
² Toledo] Toleto A
:::', '::: apparatus
¹ moraua] moraba B, morava C
² Toledo] Toleto A

[/apparatus]: # ()
:::');
INSERT INTO _clases VALUES ('variant', 'variant', '::: variant {testigos="A B"}
moraua
::: variant {testigos="C D"}
moraba
:::', '::: variant {testigos="A B"}
moraua
::: variant {testigos="C D"}
moraba
:::');
INSERT INTO _clases VALUES ('gloss', 'gloss', '::: gloss {lema="fazaña"}
Hecho notable, hazaña. Del lat. *facianea.
:::', '::: gloss {lema="fazaña"}
Hecho notable, hazaña. Del lat. *facianea.
:::');
INSERT INTO _clases VALUES ('ling-example', 'ling-example', '::: ling-example
(1) a. *El niño parece dormir.
    b. El niño parece estar dormido.
:::', '::: ling-example
(1) a. *El niño parece dormir.
    b. El niño parece estar dormido.

[/ling-example]: # ()
:::');
INSERT INTO _clases VALUES ('interlinear', 'interlinear', '::: interlinear {lengua="lat"}
Puer        libr-um      leg-it
niño.NOM    libro-AC     leer-3SG.PRES
''El niño lee el libro''
:::', '::: interlinear {lengua="lat"}
Puer        libr-um      leg-it
niño.NOM    libro-AC     leer-3SG.PRES
''El niño lee el libro''

[/interlinear]: # ()
:::');
INSERT INTO _clases VALUES ('paleographic', 'paleographic', '::: paleographic {tipo="diplomática"}
en aq<ue>l t<iem>po moraua en toledo | vn cauall<er>o...
:::', '::: paleographic {tipo="diplomática"}
en aq<ue>l t<iem>po moraua en toledo | vn cauall<er>o...

[/paleographic]: # ()
:::');
INSERT INTO _clases VALUES ('stemma', 'stemma', '::: stemma
[Diagrama de relaciones entre manuscritos]
:::', '::: stemma
[Diagrama de relaciones entre manuscritos]

[/stemma]: # ()
:::');
INSERT INTO _clases VALUES ('etymology', 'etymology', '::: etymology {voz="palabra"}
Del lat. PARABOLA, y este del gr. παραβολή ''comparación''.
:::', '::: etymology {voz="palabra"}
Del lat. PARABOLA, y este del gr. παραβολή ''comparación''.
:::');
INSERT INTO _clases VALUES ('reconstructed', 'reconstructed', '::: reconstructed
*FACIANEA > fazaña
:::', '::: reconstructed
*FACIANEA > fazaña
:::');
INSERT INTO _clases VALUES ('siglum', 'siglum', '::: siglum {codigo="A", nombre="BNE Ms. 1234"}
:::', '::: siglum {codigo="A", nombre="BNE Ms. 1234"}

[/siglum]: # ()
:::');
INSERT INTO _clases VALUES ('dosage', 'dosage', '::: dosage
Fármaco: enalapril
Cantidad: 10
Unidad: mg
Frecuencia: diaria
:::', '::: dosage
Fármaco: enalapril
Cantidad: 10
Unidad: mg
Frecuencia: diaria

[/dosage]: # ()
:::');
INSERT INTO _clases VALUES ('patient-data', 'patient-data', '::: patient-data
Edad: 45
Sexo: masculino
:::', '::: patient-data
Edad: 45
Sexo: masculino

[/patient-data]: # ()
:::');
INSERT INTO _clases VALUES ('diagnosis', 'diagnosis', '::: diagnosis
Hipertensión arterial esencial (ICD-10: I10)
:::', '::: diagnosis
Hipertensión arterial esencial (ICD-10: I10)
:::');
INSERT INTO _clases VALUES ('lab-result', 'lab-result', '::: lab-result
Test: Glucosa
Valor: 110
Unidad: mg/dL
Rango: 70-100
:::', '::: lab-result
Test: Glucosa
Valor: 110
Unidad: mg/dL
Rango: 70-100

[/lab-result]: # ()
:::');
INSERT INTO _clases VALUES ('surgical-procedure', 'surgical-procedure', '::: surgical-procedure
Se realizó apendicectomía laparoscópica bajo anestesia general.
Tiempo quirúrgico: 45 minutos. Sin complicaciones.
:::', '::: surgical-procedure
Se realizó apendicectomía laparoscópica bajo anestesia general.
Tiempo quirúrgico: 45 minutos. Sin complicaciones.

[/surgical-procedure]: # ()
:::');
INSERT INTO _clases VALUES ('adverse-event', 'adverse-event', '::: adverse-event
Paciente presentó rash cutáneo leve a las 48h de iniciado tratamiento.
Se suspendió medicación y síntomas remitieron en 72h.
:::', '::: adverse-event
Paciente presentó rash cutáneo leve a las 48h de iniciado tratamiento.
Se suspendió medicación y síntomas remitieron en 72h.

[/adverse-event]: # ()
:::');
INSERT INTO _clases VALUES ('consent-statement', 'consent-statement', '::: consent-statement
Todos los pacientes firmaron consentimiento informado aprobado
por el Comité de Ética institucional (protocolo #2024-045).
:::', '::: consent-statement
Todos los pacientes firmaron consentimiento informado aprobado
por el Comité de Ética institucional (protocolo #2024-045).

[/consent-statement]: # ()
:::');
INSERT INTO _clases VALUES ('ethics-approval', 'ethics-approval', '::: ethics-approval
Estudio aprobado por Comité de Ética del Hospital Italiano
(CEPI #2024-1234) en conformidad con Declaración de Helsinki.
:::', '::: ethics-approval
Estudio aprobado por Comité de Ética del Hospital Italiano
(CEPI #2024-1234) en conformidad con Declaración de Helsinki.

[/ethics-approval]: # ()
:::');
INSERT INTO _clases VALUES ('synthesis-scheme', 'synthesis-scheme', '::: {.synthesis-scheme #sch-01}
![Síntesis de compuesto 3](esquema-01.png)
Reactivos: (i) NaBH₄, MeOH, 0°C; (ii) TsCl, piridina, TA
:::', '::: {.synthesis-scheme #sch-01}
![Síntesis de compuesto 3](esquema-01.png)
Reactivos: (i) NaBH₄, MeOH, 0°C; (ii) TsCl, piridina, TA

[/synthesis-scheme]: # ()
:::');
INSERT INTO _clases VALUES ('measurement', 'measurement', '::: measurement
Magnitud: velocidad
Valor: 299792458
Incertidumbre: 1.2
Unidad: m/s
:::', '::: measurement
Magnitud: velocidad
Valor: 299792458
Incertidumbre: 1.2
Unidad: m/s
:::');
INSERT INTO _clases VALUES ('apparatus-physics', 'apparatus-physics', '::: apparatus-physics
Espectrómetro Raman Horiba LabRAM HR Evolution.
Láser: 532 nm, potencia 5 mW.
Detector: CCD enfriado a -70°C.
:::', '::: apparatus-physics
Espectrómetro Raman Horiba LabRAM HR Evolution.
Láser: 532 nm, potencia 5 mW.
Detector: CCD enfriado a -70°C.

[/apparatus-physics]: # ()
:::');
INSERT INTO _clases VALUES ('sec-intro', 'intro', '::: {.intro}
Texto de introducción.
:::', '::: {.intro}
Texto de introducción.

[/intro]: # ()
:::');
INSERT INTO _clases VALUES ('sec-methods', 'methods', '::: {.methods}
Descripción del método.
:::', '::: {.methods}
Descripción del método.

[/methods]: # ()
:::');
INSERT INTO _clases VALUES ('sec-results', 'results', '::: {.results}
Principal hallazgo.
:::', '::: {.results}
Principal hallazgo.

[/results]: # ()
:::');
INSERT INTO _clases VALUES ('sec-discussion', 'discussion', '::: {.discussion}
Interpretación de resultados.
:::', '::: {.discussion}
Interpretación de resultados.

[/discussion]: # ()
:::');
INSERT INTO _clases VALUES ('sec-conclusions', 'conclusions', '::: {.conclusions}
Conclusión principal.
:::', '::: {.conclusions}
Conclusión principal.

[/conclusions]: # ()
:::');
INSERT INTO _clases VALUES ('sec-case-report', 'case-report', '::: {.case-report}
Descripción del caso.
:::', '::: {.case-report}
Descripción del caso.

[/case-report]: # ()
:::');
INSERT INTO _clases VALUES ('sec-review-article', 'review-article', '::: {.review-article}
Texto de revisión.
:::', '::: {.review-article}
Texto de revisión.

[/review-article]: # ()
:::');
INSERT INTO _clases VALUES ('sec-abstract', 'abstract', '::: {.abstract}
Objetivo: ...
:::', '::: {.abstract}
Objetivo: ...

[/abstract]: # ()
:::');
INSERT INTO _clases VALUES ('sec-acknowledgments', 'acknowledgments', '::: {.acknowledgments}
Los autores agradecen...
:::', '::: {.acknowledgments}
Los autores agradecen...

[/acknowledgments]: # ()
:::');
INSERT INTO _clases VALUES ('sec-appendix', 'appendix', '::: {.appendix}
Datos complementarios.
:::', '::: {.appendix}
Datos complementarios.

[/appendix]: # ()
:::');
INSERT INTO _clases VALUES ('sec-conflict-of-interest', 'conflict-of-interest', '::: {.conflict-of-interest}
Los autores declaran...
:::', '::: {.conflict-of-interest}
Los autores declaran...

[/conflict-of-interest]: # ()
:::');
INSERT INTO _clases VALUES ('sec-editorial', 'editorial', '::: {.editorial}
Texto editorial.
:::', '::: {.editorial}
Texto editorial.

[/editorial]: # ()
:::');
INSERT INTO _clases VALUES ('sec-correspondence', 'correspondence', '::: {.correspondence}
Estimado editor...
:::', '::: {.correspondence}
Estimado editor...

[/correspondence]: # ()
:::');
INSERT INTO _clases VALUES ('sec-book-review', 'book-review', '::: {.book-review}
El libro analizado...
:::', '::: {.book-review}
El libro analizado...

[/book-review]: # ()
:::');
INSERT INTO _clases VALUES ('sec-obituary', 'obituary', '::: {.obituary}
El Dr. X falleció...
:::', '::: {.obituary}
El Dr. X falleció...

[/obituary]: # ()
:::');
INSERT INTO _clases VALUES ('sec-oration', 'oration', '::: {.oration}
Texto de la ponencia.
:::', '::: {.oration}
Texto de la ponencia.

[/oration]: # ()
:::');
INSERT INTO _clases VALUES ('sec-retraction', 'retraction', '::: {.retraction}
Los autores retractan...
:::', '::: {.retraction}
Los autores retractan...

[/retraction]: # ()
:::');
INSERT INTO _clases VALUES ('sec-correction', 'correction', '::: {.correction}
En la versión publicada...
:::', '::: {.correction}
En la versión publicada...

[/correction]: # ()
:::');
INSERT INTO _clases VALUES ('fig-fullwidth', 'fig', '::: {.fig #fig-mapa .fullwidth}
![Pie de la figura](media/fig-mapa.png)
:::', '::: {.fig #fig-mapa .fullwidth}
![Pie de la figura](media/fig-mapa.png)

[/fig]: # ()
:::');
INSERT INTO _clases VALUES ('table-fullwidth', 'table', '::: {.table #tbl-datos .fullwidth}
: Título de la tabla

| Col1 | Col2 |
|------|------|
| dato | dato |
:::', '::: {.table #tbl-datos .fullwidth}
: Título de la tabla

| Col1 | Col2 |
|------|------|
| dato | dato |

[/table]: # ()
:::');
INSERT INTO _clases VALUES ('table-landscape', 'table', '::: {.table #tbl-grande .landscape}
: Título de la tabla

| Col1 | Col2 | Col3 |
|------|------|------|
| dato | dato | dato |
:::', '::: {.table #tbl-grande .landscape}
: Título de la tabla

| Col1 | Col2 | Col3 |
|------|------|------|
| dato | dato | dato |

[/table]: # ()
:::');
INSERT INTO _clases VALUES ('spectral-mention', 'spectral-mention', 'La señal a [δ 7.26 (s, 1H)]{.spectral-mention} confirma la presencia del aromático.', 'La señal a [δ 7.26 (s, 1H)]{.spectral-mention} confirma la presencia del aromático.');

-- TODO SHORTCODE DE LA BASE TIENE SU CLASE: SI NO, NO SE MIGRA NADA
INSERT INTO _verif SELECT 'clase de cada shortcode', COUNT(*) = 0
  FROM shortcodes WHERE nombre NOT IN (SELECT nombre FROM _clases);

-- TABLA NUEVA, CON EL DDL DE LA VERSIÓN 2
CREATE TABLE shortcodes_v2 (
  id_shortcode       INTEGER PRIMARY KEY,
  nombre             TEXT    NOT NULL UNIQUE
                     CHECK (nombre <> '' AND nombre NOT GLOB '*[^a-z0-9-]*'),
  clase              TEXT    NOT NULL
                     CHECK (clase <> '' AND clase NOT GLOB '*[^a-z0-9-]*'),
  etiqueta           TEXT    NOT NULL CHECK (etiqueta <> ''),
  tipo               TEXT    NOT NULL CHECK (tipo IN ('bloque','linea')),
  grupo              TEXT    NOT NULL CHECK (grupo IN ('comun','estructura','disciplinar')),
  perfil             TEXT    CHECK (perfil <> '' AND perfil NOT GLOB '*[^a-z_]*'),
  orden              INTEGER NOT NULL,
  estado_libro       TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_libro IN ('no_aplica','borrador','liberado')),
  estado_revista     TEXT    NOT NULL DEFAULT 'no_aplica'
                     CHECK (estado_revista IN ('no_aplica','borrador','liberado')),
  modo               TEXT    NOT NULL DEFAULT 'envolver'
                     CHECK (modo IN ('envolver','plantilla','figura')),
  apertura           TEXT    NOT NULL CHECK (apertura <> ''),
  cierre             TEXT    NOT NULL CHECK (cierre <> ''),
  que_es             TEXT    CHECK (que_es <> ''),
  ejemplo            TEXT    CHECK (ejemplo <> ''),
  como_sale          TEXT    CHECK (como_sale <> ''),
  mapeo_docbook      TEXT,
  mapeo_jats         TEXT,
  notas              TEXT,
  pendiente          TEXT,
  fecha_alta         TEXT    NOT NULL,
  fecha_modificacion TEXT    NOT NULL,
  CHECK ((grupo = 'disciplinar') = (perfil IS NOT NULL)),
  CHECK (estado_libro <> 'no_aplica' OR estado_revista <> 'no_aplica'),
  CHECK (modo <> 'figura' OR tipo = 'bloque'),
  CHECK ((estado_libro <> 'liberado' AND estado_revista <> 'liberado')
         OR (que_es IS NOT NULL AND ejemplo IS NOT NULL AND como_sale IS NOT NULL))
);

INSERT INTO shortcodes_v2 (id_shortcode, nombre, etiqueta, tipo, grupo, perfil, orden, estado_libro, estado_revista, modo, apertura, cierre, que_es, como_sale, mapeo_docbook, mapeo_jats, notas, pendiente, fecha_alta, clase, ejemplo, fecha_modificacion)
SELECT s.id_shortcode, s.nombre, s.etiqueta, s.tipo, s.grupo, s.perfil, s.orden, s.estado_libro, s.estado_revista, s.modo, s.apertura, s.cierre, s.que_es, s.como_sale, s.mapeo_docbook, s.mapeo_jats, s.notas, s.pendiente, s.fecha_alta, c.clase,
       CASE WHEN s.ejemplo IS c.ejemplo_v1 THEN c.ejemplo_v2 ELSE s.ejemplo END,
       CASE WHEN s.ejemplo IS c.ejemplo_v1 AND c.ejemplo_v1 IS NOT c.ejemplo_v2
            THEN datetime('now','localtime') ELSE s.fecha_modificacion END
  FROM shortcodes s JOIN _clases c ON c.nombre = s.nombre;

INSERT INTO _verif SELECT 'filas copiadas',
  (SELECT COUNT(*) FROM shortcodes_v2) = (SELECT COUNT(*) FROM shortcodes);

DROP TABLE shortcodes;
ALTER TABLE shortcodes_v2 RENAME TO shortcodes;
CREATE INDEX ix_shortcodes_orden ON shortcodes (grupo, perfil, orden);
CREATE INDEX ix_shortcodes_clase ON shortcodes (clase);

INSERT INTO esquema_version (version, fecha) VALUES (2, date('now'));

DROP TABLE _verif;
DROP TABLE _clases;

COMMIT;

-- BLOQUES CUYO EJEMPLO NO TIENE EL CIERRE NOMBRADO (EDITADOS A MANO)
SELECT 'Sin cierre nombrado en el ejemplo: ' || nombre FROM shortcodes
 WHERE tipo = 'bloque' AND instr(IFNULL(ejemplo, ''), '[/' || clase || ']: # ()') = 0
 ORDER BY nombre;
