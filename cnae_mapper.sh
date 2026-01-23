#!/bin/bash

# ==============================================================================
# SCRIPT DE NORMALIZACIÓN DE IMÁGENES CNAE (NIVEL 2)
# ==============================================================================
# Uso: ./cnae_mapper.sh <ruta_carpeta_entrada>
# ==============================================================================

# 1. VALIDACIÓN DE ARGUMENTOS
if [ -z "$1" ]; then
    echo "ERROR: Debes indicar la carpeta de entrada."
    echo "Uso: $0 <ruta_al_directorio_imagenes>"
    exit 1
fi

INPUT_DIR="${1%/}" # Eliminar slash final si existe
OUTPUT_DIR="./out"

if [ ! -d "$INPUT_DIR" ]; then
    echo "ERROR: El directorio de entrada '$INPUT_DIR' no existe."
    exit 1
fi

# 2. PREPARACIÓN DEL ENTORNO
echo "--- Iniciando proceso ---"
echo "Entrada: $INPUT_DIR"
echo "Salida:  $OUTPUT_DIR"

# Crear carpeta de salida (limpia si ya existe para evitar mezclas, opcional)
if [ ! -d "$OUTPUT_DIR" ]; then
    mkdir -p "$OUTPUT_DIR"
fi

# Contadores para el reporte final
count_success=0
count_skipped=0

# ==============================================================================
# 3. LÓGICA DE MAPEO MANUAL (CORE)
# ==============================================================================
# Esta función recibe el NOMBRE del archivo (sin extensión) y devuelve el CÓDIGO CNAE.
# Se basa estrictamente en los nombres de archivo vistos en el comando 'tree'.
# ==============================================================================

get_cnae_code() {
    local filename="$1"
    
    # Convertimos a minúsculas para evitar problemas de case-sensitivity
    # aunque el case de abajo intentará coincidir con el texto exacto del tree
    # por seguridad usamos patrones flexibles o exactos según el tree proporcionado.
    
    case "$filename" in
        # --- A: Agricultura ---
        "Agricultura, ganadería, caza y servicios relacionados con las mismas") echo "01" ;;
        "Silvicultura y explotación forestal") echo "02" ;;
        "Pesca y acuicultura") echo "03" ;;

        # --- B: Extractivas ---
        "Extracción de antracita, hulla, y lignito") echo "05" ;;
        "Extracción de crudo de petróleo y gas natural") echo "06" ;;
        "Extracción de minerales metálicos") echo "07" ;;
        "Otras industrias extractivas") echo "08" ;;
        "Actividades de apoyo a las industrias extractivas") echo "09" ;;

        # --- C: Manufactura ---
        "Industria alimentaria") echo "10" ;;
        "Fabricación de bebidas") echo "11" ;;
        "Industria del tabaco") echo "12" ;;
        "Industria textil") echo "13" ;;
        "Confección de prendas de vestir") echo "14" ;;
        "Industria del cuero y productos relacionados de otros materiales") echo "15" ;;
        "Industria de la madera y del corcho, excepto muebles_ cestería y espartería") echo "16" ;; # Nota el guion bajo del tree
        "Industria del papel") echo "17" ;;
        "Artes gráficas y reproducción de soportes grabados") echo "18" ;;
        "Coquerías y refino de petróleo") echo "19" ;;
        "Industria química") echo "20" ;;
        "Productos farmacéuticos") echo "21" ;;
        "Productos de caucho y plásticos") echo "22" ;;
        "Otros productos minerales no metálicos") echo "23" ;;
        "Metalurgia") echo "24" ;;
        "Productos metálicos, excepto maquinaria y equipo") echo "25" ;;
        "Productos informáticos, electrónicos y ópticos") echo "26" ;;
        "Material y equipo eléctrico") echo "27" ;;
        "Maquinaria y equipo n.c.o.p.") echo "28" ;;
        "Vehículos de motor, remolques y semirremolques") echo "29" ;;
        "Otro material de transporte") echo "30" ;;
        "Fabricación de muebles") echo "31" ;;
        "Otras industrias manufactureras") echo "32" ;;
        "Reparación, mantenimiento e instalación de maquinaria y equipos") echo "33" ;;

        # --- D: Energía ---
        "Energía eléctrica, gas, vapor y aire acondicionado") echo "35" ;;

        # --- E: Agua y Residuos ---
        "Captación, depuración y distribución de agua") echo "36" ;;
        "Recogida y tratamiento de aguas residuales") echo "37" ;;
        "Actividades de recogida, tratamiento y eliminación de residuos") echo "38" ;;
        "Actividades de descontaminación y otros servicios de gestión de residuos") echo "39" ;;

        # --- F: Construcción ---
        "Construcción de edificios") echo "41" ;; # Mapeo directo aunque CNAE 41 sea Promoción
        "Ingeniería civil") echo "42" ;;
        "Actividades de construcción especializada") echo "43" ;;

        # --- G: Comercio ---
        # Nota: El código 45 (Vehículos) no tiene imagen explícita en tu tree bajo G, 
        # pero si existe un archivo con nombre similar, agrégalo aquí.
        "Comercio al por mayor") echo "46" ;;
        "Comercio al por menor") echo "47" ;;
        
        # --- H: Transporte ---
        "Transporte terrestre y por tubería") echo "49" ;;
        "Transporte marítimo y por vías navegables interiores") echo "50" ;;
        "Transporte aéreo") echo "51" ;;
        "Depósito, almacenamiento y actividades auxiliares del transporte") echo "52" ;;
        "Actividades postales y de mensajería "*) echo "53" ;; # Wildcard por el espacio extraño en el tree (.png)

        # --- I: Hostelería ---
        "Servicios de alojamiento") echo "55" ;;
        "Servicios de comidas y bebidas") echo "56" ;;

        # --- J: Información ---
        "Edición") echo "58" ;;
        "Producción cinematográfica, de vídeo y de programas de televisión, grabación de sonido y edición musical") echo "59" ;;
        "Actividades de programación, radiodifusión, agencias de noticias y otras actividades de distribución de contenidos") echo "60" ;;
        "Telecomunicaciones") echo "61" ;;
        "Programación, consultoría y otras actividades relacionadas con la informática") echo "62" ;;
        "Infraestructura informática, tratamiento de datos, hosting y otras actividades de servicios de información") echo "63" ;;

        # --- K/L: Financiero (El tree mezcla letras vs CNAE standard, usamos el nombre del archivo) ---
        "Servicios financieros, excepto seguros y fondos de pensiones") echo "64" ;;
        "Seguros, reaseguros y planes de pensiones, excepto seguridad social obligatoria") echo "65" ;;
        "Actividades auxiliares a los servicios financieros y a los seguros") echo "66" ;;

        # --- M: Inmobiliarias ---
        "Actividades inmobiliarias") echo "68" ;;

        # --- N: Profesionales ---
        "Actividades jurídicas y de contabilidad") echo "69" ;;
        "Actividades de las sedes centrales y consultoría de gestión empresarial") echo "70" ;;
        "Servicios técnicos de arquitectura e ingeniería_ ensayos y análisis técnicos") echo "71" ;;
        "Investigación y desarrollo") echo "72" ;;
        "Actividades de publicidad, estudios de mercado, relaciones públicas y comunicación") echo "73" ;;
        "Otras actividades profesionales, científicas y técnicas") echo "74" ;;
        "Actividades veterinarias") echo "75" ;;

        # --- O/N: Administrativas (Tree vs CNAE) ---
        "Actividades de alquiler") echo "77" ;;
        "Actividades relacionadas con el empleo") echo "78" ;;
        "Actividades de agencias de viajes, operadores turísticos, servicios de reservas y actividades relacionadas") echo "79" ;;
        "Servicios de investigación y seguridad") echo "80" ;;
        "Servicios a edificios y actividades de jardinería") echo "81" ;;
        "Actividades administrativas de oficina y otras actividades auxiliares a las empresas") echo "82" ;;

        # --- P: Administración Pública ---
        "Administración pública y defensa_ seguridad social obligatoria") echo "84" ;;

        # --- Q/P: Educación ---
        "Educación") echo "85" ;;

        # --- R/Q: Sanidad ---
        "Actividades sanitarias") echo "86" ;;
        "Asistencia en establecimientos residenciales") echo "87" ;;
        "Actividades de servicios sociales sin alojamiento") echo "88" ;;

        # --- S/R: Artísticas ---
        "Actividades de creación artística y artes escénicas") echo "90" ;;
        "Actividades de bibliotecas, archivos, museos y otras actividades culturales") echo "91" ;;
        "Actividades de juegos de azar y apuestas") echo "92" ;;
        "Actividades deportivas, recreativas y de entretenimiento") echo "93" ;;

        # --- T/S: Otros Servicios ---
        "Actividades asociativas") echo "94" ;;
        "Reparación y mantenimiento de ordenadores, artículos personales y enseres domésticos y vehículos de motor y motocicletas") echo "95" ;;
        "Servicios personales") echo "96" ;;

        # --- U/T: Hogares ---
        "Actividades de los hogares como empleadores de personal doméstico") echo "97" ;;
        "Actividades de los hogares como productores de bienes y servicios para uso propio") echo "98" ;;

        # --- V/U: Extraterritoriales ---
        "Actividades de organizaciones y organismos extraterritoriales") echo "99" ;;

        # DEFAULT: No encontrado
        *) echo "" ;;
    esac
}

# ==============================================================================
# 4. EJECUCIÓN: BÚSQUEDA Y COPIADO
# ==============================================================================

# Usamos find para buscar archivos dentro de carpetas llamadas exactamente "FULL SIZE"
# -path "*/FULL SIZE/*" asegura que el archivo esté dentro de esa carpeta.
# -type f asegura que es un archivo.
# Buscamos extensiones comunes de imágenes.

find "$INPUT_DIR" -type f -path "*/FULL SIZE/*" \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" -o -iname "*.avif" \) | while read -r filepath; do
    
    # Extraer nombre base y extensión
    full_filename=$(basename "$filepath")
    extension="${full_filename##*.}"
    filename_no_ext="${full_filename%.*}"

    # Obtener el código mapeado
    cnae_code=$(get_cnae_code "$filename_no_ext")

    if [ -n "$cnae_code" ]; then
        # Definir ruta destino: out/CODIGO.ext
        dest_path="$OUTPUT_DIR/${cnae_code}.${extension}"
        
        # Copiar
        cp "$filepath" "$dest_path"
        
        echo "[OK] $cnae_code <- $full_filename"
        ((count_success++))
    else
        echo "[WARNING] OMITIDO (Sin mapeo): $full_filename"
        ((count_skipped++))
    fi

done

echo "------------------------------------------------"
echo "Proceso finalizado."
echo "Imágenes procesadas correctamente en 'out/': $count_success"
echo "Imágenes omitidas (sin mapeo): $count_skipped"
echo "------------------------------------------------"
