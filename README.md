# Herramienta de Renombrado CNAE

Script para extraer y renombrar imágenes de la estructura de carpetas CNAE, mapeando los nombres descriptivos a sus códigos numéricos (CNAE-2009).

## Características

* **Entrada Dinámica:** Permite especificar cualquier carpeta de origen al ejecutarlo.
* **Salida Localizada:** Genera la carpeta `IMAGENES_CNAES_FINAL` siempre en el mismo directorio donde guardes este script.
* **Multi-formato:** Procesa `.jpg`, `.png`, `.avif`, etc., manteniendo la extensión original.
* **Solo FULL SIZE:** Solo extrae imágenes que estén dentro de carpetas llamadas `FULL SIZE`.

## Instrucciones de Uso

### 1. Preparación
Asegúrate de que el script tenga permisos de ejecución. Abre tu terminal y ejecuta:

```bash
chmod +x renombrar_cnae.sh
