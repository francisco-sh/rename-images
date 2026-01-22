#!/bin/bash

# ==========================================
# SCRIPT DE RENOMBRADO CNAE (V2 - Dinámico)
# ==========================================

# 1. VALIDACIÓN DE ARGUMENTOS
# Verificamos si el usuario pasó una ruta
if [ -z "$1" ]; then
    echo "❌ ERROR: Falta la ruta de origen."
    echo "USO: $0 \"/ruta/a/la/carpeta/imagenes\""
    exit 1
fi

# 2. CONFIGURACIÓN DE RUTAS
# Ruta de origen: el primer argumento que pasas al script
DIR_ORIGEN="$1"

# Detectamos dónde está guardado ESTE script físicamente
DIR_SCRIPT="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Definimos la carpeta de destino en el mismo lugar que el script
DIR_DESTINO="$DIR_SCRIPT/IMAGENES_CNAES_FINAL"

# Verificamos que la carpeta de origen exista
if [ ! -d "$DIR_ORIGEN" ]; then
    echo "❌ ERROR: La carpeta de origen no existe o no es accesible:"
    echo "   $DIR_ORIGEN"
    exit 1
fi

# Creamos la carpeta de destino
mkdir -p "$DIR_DESTINO"

echo "========================================"
echo " 🚀 INICIANDO PROCESO"
echo " 📂 Origen : $DIR_ORIGEN"
echo " 💾 Destino: $DIR_DESTINO"
echo "========================================"

# --- DICCIONARIO DE MAPEO (Nombre exacto -> Código CNAE) ---
declare -A cnae_map

# SECCION A
cnae_map["Agricultura, ganadería, caza y servicios relacionados con las mismas"]="01"
cnae_map["Silvicultura y explotación forestal"]="02"
cnae_map["Pesca y acuicultura"]="03"

# SECCION B
cnae_map["Extracción de antracita, hulla, y lignito"]="05"
cnae_map["Extracción de crudo de petróleo y gas natural"]="06"
cnae_map["Extracción de minerales metálicos"]="07"
cnae_map["Otras industrias extractivas"]="08"
cnae_map["Actividades de apoyo a las industrias extractivas"]="09"

# SECCION C
cnae_map["Industria alimentaria"]="10"
cnae_map["Fabricación de bebidas"]="11"
cnae_map["Industria del tabaco"]="12"
cnae_map["Industria textil"]="13"
cnae_map["Confección de prendas de vestir"]="14"
cnae_map["Industria del cuero y productos relacionados de otros materiales"]="15"
cnae_map["Industria de la madera y del corcho, excepto muebles_ cestería y espartería"]="16"
cnae_map["Industria del papel"]="17"
cnae_map["Artes gráficas y reproducción de soportes grabados"]="18"
cnae_map["Coquerías y refino de petróleo"]="19"
cnae_map["Industria química"]="20"
cnae_map["Productos farmacéuticos"]="21"
cnae_map["Productos de caucho y plásticos"]="22"
cnae_map["Otros productos minerales no metálicos"]="23"
cnae_map["Metalurgia"]="24"
cnae_map["Productos metálicos, excepto maquinaria y equipo"]="25"
cnae_map["Productos informáticos, electrónicos y ópticos"]="26"
cnae_map["Material y equipo eléctrico"]="27"
cnae_map["Maquinaria y equipo n.c.o.p."]="28"
cnae_map["Vehículos de motor, remolques y semirremolques"]="29"
cnae_map["Otro material de transporte"]="30"
cnae_map["Fabricación de muebles"]="31"
cnae_map["Otras industrias manufactureras"]="32"
cnae_map["Reparación, mantenimiento e instalación de maquinaria y equipos"]="33"

# SECCION D & E
cnae_map["Energía eléctrica, gas, vapor y aire acondicionado"]="35"
cnae_map["Captación, depuración y distribución de agua"]="36"
cnae_map["Recogida y tratamiento de aguas residuales"]="37"
cnae_map["Actividades de recogida, tratamiento y eliminación de residuos"]="38"
cnae_map["Actividades de descontaminación y otros servicios de gestión de residuos"]="39"

# SECCION F
cnae_map["Construcción de edificios"]="41"
cnae_map["Ingeniería civil"]="42"
cnae_map["Actividades de construcción especializada"]="43"

# SECCION G
cnae_map["Comercio al por mayor"]="46"
cnae_map["Comercio al por menor"]="47"

# SECCION H
cnae_map["Transporte terrestre y por tubería"]="49"
cnae_map["Transporte marítimo y por vías navegables interiores"]="50"
cnae_map["Transporte aéreo"]="51"
cnae_map["Depósito, almacenamiento y actividades auxiliares del transporte"]="52"
cnae_map["Actividades postales y de mensajería"]="53"
cnae_map["Actividades postales y de mensajería "]="53"
cnae_map["Actividades postales y de mensajería_"]="53"

# SECCION I
cnae_map["Servicios de alojamiento"]="55"
cnae_map["Servicios de comidas y bebidas"]="56"

# SECCION J
cnae_map["Edición"]="58"
cnae_map["Producción cinematográfica, de vídeo y de programas de televisión, grabación de sonido y edición musical"]="59"
cnae_map["Actividades de programación, radiodifusión, agencias de noticias y otras actividades de distribución de contenidos"]="60"
cnae_map["Telecomunicaciones"]="61"
cnae_map["Programación, consultoría y otras actividades relacionadas con la informática"]="62"
cnae_map["Infraestructura informática, tratamiento de datos, hosting y otras actividades de servicios de información"]="63"

# SECCION K & L
cnae_map["Servicios financieros, excepto seguros y fondos de pensiones"]="64"
cnae_map["Seguros, reaseguros y planes de pensiones, excepto seguridad social obligatoria"]="65"
cnae_map["Actividades auxiliares a los servicios financieros y a los seguros"]="66"
cnae_map["Actividades inmobiliarias"]="68"

# SECCION M
cnae_map["Actividades jurídicas y de contabilidad"]="69"
cnae_map["Actividades de las sedes centrales y consultoría de gestión empresarial"]="70"
cnae_map["Servicios técnicos de arquitectura e ingeniería_ ensayos y análisis técnicos"]="71"
cnae_map["Investigación y desarrollo"]="72"
cnae_map["Actividades de publicidad, estudios de mercado, relaciones públicas y comunicación"]="73"
cnae_map["Otras actividades profesionales, científicas y técnicas"]="74"
cnae_map["Actividades veterinarias"]="75"

# SECCION N
cnae_map["Actividades de alquiler"]="77"
cnae_map["Actividades relacionadas con el empleo"]="78"
cnae_map["Actividades de agencias de viajes, operadores turísticos, servicios de reservas y actividades relacionadas"]="79"
cnae_map["Servicios de investigación y seguridad"]="80"
cnae_map["Servicios a edificios y actividades de jardinería"]="81"
cnae_map["Actividades administrativas de oficina y otras actividades auxiliares a las empresas"]="82"

# SECCION O, P, Q
cnae_map["Administración pública y defensa_ seguridad social obligatoria"]="84"
cnae_map["Educación"]="85"
cnae_map["Actividades sanitarias"]="86"
cnae_map["Asistencia en establecimientos residenciales"]="87"
cnae_map["Actividades de servicios sociales sin alojamiento"]="88"

# SECCION R, S, T, U, V
cnae_map["Actividades de creación artística y artes escénicas"]="90"
cnae_map["Actividades de bibliotecas, archivos, museos y otras actividades culturales"]="91"
cnae_map["Actividades de juegos de azar y apuestas"]="92"
cnae_map["Actividades deportivas, recreativas y de entretenimiento"]="93"
cnae_map["Actividades asociativas"]="94"
cnae_map["Reparación y mantenimiento de ordenadores, artículos personales y enseres domésticos y vehículos de motor y motocicletas"]="95"
cnae_map["Servicios personales"]="96"
cnae_map["Actividades de los hogares como empleadores de personal doméstico"]="97"
cnae_map["Actividades de los hogares como productores de bienes y servicios para uso propio"]="98"
cnae_map["Actividades de organizaciones y organismos extraterritoriales"]="99"


# --- LÓGICA PRINCIPAL ---

find "$DIR_ORIGEN" -type d -name "FULL SIZE" | while read -r full_size_dir; do
    
    # Buscar cualquier archivo dentro de FULL SIZE (sin entrar en subdirectorios)
    find "$full_size_dir" -maxdepth 1 -type f | while read -r filepath; do
        
        filename=$(basename "$filepath")
        extension="${filename##*.}"
        name_no_ext="${filename%.*}"
        
        # Buscar código
        codigo="${cnae_map[$name_no_ext]}"
        
        if [ -n "$codigo" ]; then
            destino_final="$DIR_DESTINO/$codigo.$extension"
            cp "$filepath" "$destino_final"
            echo "✅ $filename -> $codigo.$extension"
        else
            if [[ "$filename" != .* ]]; then
                echo "⚠️  [NO ENCONTRADO] '$name_no_ext' en $filepath"
            fi
        fi
    done
done

echo "========================================"
echo " FIN DEL PROCESO"
echo " Los archivos están en:"
echo " $DIR_DESTINO"
echo "========================================"
