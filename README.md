# gbShortcodes

Aplicación de escritorio que mantiene el catálogo de shortcodes de
[gbpublisher](https://github.com/albertomoyano/gbpublisher): qué
shortcodes existen, cómo se escriben, qué ayuda muestra cada uno y en
qué estado está para libros y para revistas. Gambas 3 y SQLite, con el
mismo modelo que [gbCorpus](https://github.com/albertomoyano/gbCorpus).

---

## Por qué existe

El catálogo vivía en una tabla de MySQL dentro de la base de cada
instalación. Eso tenía dos problemas: un shortcode nuevo o corregido
solo llegaba a las instalaciones con un script de esquema, y nada
distinguía un shortcode probado de uno que nunca había pasado por las
tres salidas.

gbShortcodes saca el catálogo de la base de gbpublisher. Se mantiene acá
y se exporta a una carpeta del proyecto, que viaja en el `.deb`. Cada
shortcode tiene un estado para libros y otro para revistas: `no_aplica`,
`borrador` o `liberado`. gbpublisher instalado muestra solo lo liberado.

---

## Qué hace

**Consulta.** Un combo filtra por estado (libros o revistas, liberados o
borradores), por pendientes o por grupo. La lista marca con ★ lo
liberado.

**Pulido de la ayuda.** Cada shortcode tiene tres textos en Markdown:
*Qué es*, el *Ejemplo* tal como se escribe en el `.md`, y *Cómo sale*. La
pestaña *Vista previa* muestra la página de ayuda tal como se exporta,
con lo que está escrito en pantalla, guardado o no.

**Tres salidas.**

| Salida | Contenido | Para qué |
|---|---|---|
| Paquete | `_catalogo.tsv`, y por shortcode `<nombre>.html` y `<nombre>.md` | La carpeta `.hidden/shortcodes/` de gbpublisher |
| Documento de prueba | Un `.md` con el ejemplo de cada shortcode de libros, o de revistas | Componerlo en PDF, EPUB y HTML antes de liberar |
| Volcado SQL | INSERT restaurables | Respaldo en texto, que diffea en git |

La salida es determinista: dos exportaciones del mismo contenido dan
archivos idénticos.

---

## Lo que deliberadamente no hace

**No da de alta ni elimina shortcodes, y no cambia su comportamiento**:
nombre, tipo, grupo, orden, estados, modo, apertura y cierre. Eso se
decide después de probarlo y se aplica por script SQL con
*Catálogo → Importar UPDATE SQL*, que ejecuta `engine/importar_shortcodes.sh`
con respaldo previo, transacción y verificaciones posteriores.

---

## Modelo de datos

Una tabla, `shortcodes`, y `esquema_version`. El esquema está en
`.src/shortcodes_esquema.sql` y descrito en la entrada RF-11 del corpus
de gbpublisher, junto con el contrato de exportación.

---

## Instalación

Requiere Gambas 3.21 o superior, `sqlite3` y `pandoc`, sobre Linux.
Desarrollado para Linux Mint Cinnamon con X11. Componentes:

- `gb.db2`, `gb.db2.sqlite3`
- `gb.desktop`, `gb.image`, `gb.settings`, `gb.term`
- `gb.form`, `gb.form.dialog`, `gb.form.terminal`
- `gb.qt5`, `gb.qt5.ext`

Abrir el proyecto en el IDE, **Proyecto → Limpiar**, luego
**Proyecto → Compilar**. En el primer arranque se crea
`~/.gbshortcodes/shortcodes.sqlite` vacía. El catálogo se carga
importando `shortcodes-carga-inicial.sql`.

---

## Estructura del proyecto

```
FMain        vista maestro-detalle; handlers delgados
m_Base       conexión SQLite, creación de la base, versión de esquema
m_Catalogo   estado de sesión y todo el acceso a la tabla
m_Exportar   paquete, documento de prueba, volcado y vista previa
CShortcode   un shortcode, fuera del objeto Result
engine/      importar_shortcodes.sh
```

---

## Licencia

GPL v3.
