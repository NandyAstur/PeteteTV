# Petete TV — Flujo de desarrollo y preparación multiplataforma

## 1. Ruta local oficial

La carpeta de trabajo local en Windows será:

`T:\AT WORK\SCRIPTS\PeteteTV`

Debe considerarse la ubicación estándar para scripts, compilaciones locales, pruebas y utilidades del proyecto.

## 2. Fuente de verdad y sincronización

El repositorio principal es:

`NandyAstur/PeteteTV`

Rama principal:

`main`

El proyecto debe disponer de una herramienta de actualización local de un clic, inspirada en Petete Radio, que:

1. compruebe que Git está disponible;
2. compruebe/prepare la carpeta `T:\AT WORK\SCRIPTS\PeteteTV`;
3. valide que corresponde al repositorio correcto;
4. obtenga el estado remoto;
5. actualice desde `main` de manera segura;
6. detecte cambios locales antes de sobrescribirlos;
7. no destruya trabajo local sin confirmación explícita;
8. deje log persistente junto a la utilidad o en una carpeta `.info/logs`;
9. muestre claramente versión/commit descargado y resultado final.

## 3. Herramientas Windows previstas

Siguiendo la experiencia real de Petete Radio, Petete TV tendrá herramientas equivalentes a las existentes allí (`ACTUALIZAR_LOCAL.bat`, actualizador GitHub→local, `PROBAR_APP.bat`, creador de EXE/instalador/publicación e instalador Inno Setup).

Nombres de trabajo previstos:

- `ACTUALIZAR_LOCAL.bat`
- `PETETE_TV_ACTUALIZAR_GITHUB_A_LOCAL.bat`
- `PROBAR_APP.bat`
- `CREAR_EXE_E_INSTALADOR_Y_PUBLICAR_SI_CORRECTO.bat`
- `PETETE_TV_INSTALADOR.iss`

Podrán apoyarse en PowerShell cuando sea conveniente, dejando el `.bat` como lanzador cómodo para el usuario.

### Reglas

- Cada herramienta importante debe generar log.
- Una ventana que falla no debe desaparecer sin dejar diagnóstico.
- Las herramientas deben detectar dependencias ausentes y explicarlas.
- Compilar y publicar serán acciones separables, aunque exista una herramienta que encadene ambas cuando todo sea correcto.
- No se publicará automáticamente una candidata que no haya superado las comprobaciones definidas.
- Los scripts deberán funcionar desde la ruta oficial y evitar depender del directorio actual del terminal.

## 4. PC primero

La primera implementación funcional será Windows/PC.

Orden aproximado:

1. identidad y logo;
2. splash/bienvenida SuperPetete adaptada;
3. shell de la ventana principal;
4. lista izquierda de canales;
5. visor 16:9;
6. controles del reproductor;
7. modelo de canal y fuente;
8. reproducción real;
9. EPG/metadatos;
10. búsqueda y clasificación de documentales;
11. favoritos e historial;
12. diagnóstico y logs;
13. actualización;
14. instalador;
15. pulido y estabilización.

## 5. Android previsto desde el principio

La versión Android no se implementará ahora, pero condicionará la arquitectura desde el primer día.

### Debe poder compartirse o trasladarse con mínimo coste

- `Channel`: identidad lógica del canal.
- `Source`: una o varias fuentes físicas por canal.
- `Programme/Content`: programas, documentales, videopodcasts y metadatos.
- categorías y etiquetas;
- favoritos e historial;
- búsquedas guardadas;
- preferencias no específicas de UI;
- EPG y normalización de metadatos;
- validación lógica de fuentes;
- reglas de clasificación/recomendación;
- formatos de importación/exportación;
- almacenamiento/sincronización futura.

### Debe quedar aislado por plataforma

- controles de ventana de Windows;
- integración con bandeja/sistema de Windows;
- motor físico de vídeo cuando dependa de APIs del SO;
- permisos Android;
- ciclo de vida Android;
- notificaciones Android;
- Picture-in-Picture específico de plataforma;
- casting y dispositivos externos específicos.

## 6. Arquitectura orientativa

La estructura final dependerá del stack elegido, pero conceptualmente debe respetar esta separación:

```text
PeteteTV/
├── src/
│   ├── Core/               # Modelos y reglas independientes de UI
│   ├── Catalog/            # Canales, contenidos, clasificación
│   ├── Sources/            # Fuentes, importadores y validadores
│   ├── Epg/                # Programación y metadatos
│   ├── Playback.Abstractions/ # Contratos comunes del reproductor
│   └── Windows/            # Aplicación PC y adaptadores Windows
├── Android/                # Se incorporará cuando PC esté pulido
├── assets/
├── docs/
├── tools/
└── .info/
    └── logs/
```

No es una estructura de carpetas obligatoria todavía; es la regla arquitectónica que debe conservarse al elegir tecnología y crear la solución real.

## 7. Versionado y últimas buenas conocidas

Desde que exista la primera compilación ejecutable se mantendrá:

- versión visible;
- número de candidata/build;
- commit Git asociado;
- registro de última buena conocida;
- changelog;
- capacidad de volver a una candidata conocida si una modificación rompe el arranque o la reproducción.

El esquema exacto de versión se fijará antes de la primera candidata distribuible y no se improvisará después.

## 8. Publicación y actualizaciones

Cuando la versión PC esté madura, se preparará un flujo equivalente al aprendido con Petete Radio:

- build Release reproducible;
- EXE/app autocontenida cuando sea conveniente;
- instalador Inno Setup;
- manifiesto de actualización separado de la aplicación;
- checksum del instalador;
- descarga y actualización con mensajes claros;
- posibilidad de actualización normal y, solo si se decide, forzada;
- logs de actualización e instalación.

## 9. Principio rector

**No construir Petete TV para Windows de una forma que obligue a rehacer toda la lógica al crear Petete TV para Android.**

La interfaz podrá ser específica de cada plataforma; los datos, reglas y servicios principales deberán diseñarse como piezas desacopladas y reutilizables siempre que sea razonable.
