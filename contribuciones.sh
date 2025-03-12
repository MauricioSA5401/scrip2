#!/bin/bash

# Configuración
START_DATE="2025-01-08"
END_DATE=$(date +%Y-%m-%d)  # Fecha actual
DAYS_WITHOUT_CONTRIB=$(shuf -i 1-$(($(date -d "$END_DATE" "+%j") - $(date -d "$START_DATE" "+%j"))) -n 4)

# Configurar el usuario de Git (reemplaza con tu usuario y email de GitHub)
git config user.name "MauricioSA5401"
git config user.email "tuemail@example.com"

# Iterar sobre cada día desde START_DATE hasta END_DATE
current_date="$START_DATE"
while [[ "$current_date" < "$END_DATE" ]] || [[ "$current_date" == "$END_DATE" ]]; do
    # Si el día está en la lista de días sin contribuciones, lo omitimos
    day_of_year=$(date -d "$current_date" "+%j")
    if [[ " ${DAYS_WITHOUT_CONTRIB[*]} " =~ " $day_of_year " ]]; then
        echo "Omitiendo contribuciones el día $current_date"
    else
        echo "Añadiendo contribuciones para el $current_date"
        echo "$current_date - Contribución automática" >> contrib.txt
        git add contrib.txt
        GIT_COMMITTER_DATE="$current_date 12:00:00" GIT_AUTHOR_DATE="$current_date 12:00:00" git commit -m "Contribución automática en $current_date"
    fi
    # Sumar un día a la fecha actual
    current_date=$(date -I -d "$current_date + 1 day")
done

# Subir los cambios al repositorio
git push origin main
