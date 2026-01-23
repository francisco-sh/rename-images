# Herramienta de Mapeo de Imágenes CNAE

Esta herramienta es un script de Bash diseñado para recorrer una estructura de directorios de imágenes clasificadas, seleccionar únicamente las versiones de alta calidad ("FULL SIZE") y renombrarlas según el código CNAE-2009 de Nivel 2 (2 dígitos).

## Requisitos

- Sistema operativo: Linux (o entorno compatible con Bash/Unix).
- Dependencias: `bash`, `find`, `cp` (comandos estándar).
- Permisos: Lectura en la carpeta de origen, Escritura en la carpeta donde se ejecute el script.

## Qué hace este script

1. **Busca** recursivamente en el directorio indicado.
2. **Filtra** únicamente los archivos que residen dentro de carpetas llamadas exactamente `FULL SIZE`.
3. **Identifica** el archivo basándose en su nombre original (ignorando mayúsculas/minúsculas y extensión).
4. **Asigna** manualmente el código CNAE (ej. `10`, `45`, `84`) correspondiente según una tabla interna.
5. **Copia** el archivo a la carpeta `out/`, renombrándolo como `CODIGO.extensión` (ej. `10.jpg`, `29.png`).

## Estructura de Salida

Se creará automáticamente una carpeta `out/` en el mismo lugar donde ejecutes el script.
El resultado será una lista plana de archivos:

- `out/01.jpg`
- `out/02.webp`
- `out/29.png`
- ...

## Instrucciones de Uso

1. Guarda el código del script en un archivo, por ejemplo: `cnae_mapper.sh`.
2. Dale permisos de ejecución:
   ```bash
   chmod +x cnae_mapper.sh
   ```
3. Ejecútalo indicando la ruta de la carpeta principal de imágenes:
   ```bash
   ./cnae_mapper.sh "/ruta_carpeta_imagenes"
   ```

## Notas sobre el Mapeo
Si una imagen original no tiene correspondencia en la tabla interna del script, se omitirá y se mostrará un mensaje de WARNING en la consola. El script no modifica los archivos originales.