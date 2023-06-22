#!/bin/bash

# Función para contar líneas en un archivo
count_file_lines() {
    local file="$1"
    local lines=$(awk 'END {print NR}' "$file")    
    echo "File: $(basename "$file") , Lines: $lines"
}

# Variables para los parametros
owner=""
month=""

# Obtener el directorio donde se encuentra el script
script_directory=$(dirname "$(readlink -f "$0")")

# Valida los parametros de línea de comandos
while getopts "o:m:" opt; do
    case $opt in
        o)
            owner=$OPTARG
            echo "Looking for files where the owner is: $owner"
            ;;
        m)
            month=$OPTARG
            echo "Looking for files where the month is: $month"
            ;;        
    esac
done

#Ciclo para recorrer los archivos encontrados en el directorio raiz
for file in "$script_directory"/*.txt; do
    if [ -f "$file" ]; then
        # Verifica si el archivo cumple con el owner
        if [ -n "$owner" ]; then
            file_owner=$(stat -c %U "$file")
            if [ "$file_owner" != "$owner" ]; then
                continue
            fi           
        fi
       # Verifica si el archivo cumple con el mes
        if [ -n "$month" ]; then
            file_month=$(stat -c %y "$file" | awk '{print $1}')
            file_month=$(date -d "$file_month" +%b)            
            if [ "$file_month" != "$month" ]; then
                continue
            fi          
        fi        
        count_file_lines "$file"
    fi
done