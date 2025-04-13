#!/bin/bash

ARCHIVO="/workspaces/ProyectoFinal./ventas_compania_actualizado.csv"
REPORTE="/workspaces/ProyectoFinal./reporte.txt"

#Verificar si el archivo existe
function verificar_archivo {
    if [[ ! -f "/workspaces/ProyectoFinal./ventas_compania_actualizado.csv" ]]; then
        echo " Archivo no encontrado: /workspaces/ProyectoFinal./ventas_compania_actualizado.csv"
        exit 1
    fi
}

verificar_archivo

# Función: Total de ingresos por categoría
function ingresos_por_categoria {
    echo -e "\n Total de ingresos por categoría:" >> "/workspaces/ProyectoFinal./reporte.txt"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$4] += $7 } END { for (cat in ingresos) printf "• %s: $%.2f\n", cat, ingresos[cat] }' >> "/workspaces/ProyectoFinal./reporte.txt"
}

# Función: Total de ingresos por mes
function ingresos_por_mes {
    echo -e "\n Total de ingresos por mes:" >> "/workspaces/ProyectoFinal./reporte.txt"
    tail -n +2 "$ARCHIVO" | awk -F';' '{
        split($1, fecha, "-");
        mes = fecha[1] "-" fecha[2];
        ingresos[mes] += $7
    } END {
        for (m in ingresos) printf "• %s: $%.2f\n", m, ingresos[m]
    }' >> "/workspaces/ProyectoFinal./reporte.txt"
}

# Función: Total de ingresos por cliente
function ingresos_por_cliente {
    echo -e "\n Total de ingresos por cliente:" >> "/workspaces/ProyectoFinal./reporte.txt"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$2] += $7 } END { for (c in ingresos) printf "• %s: $%.2f\n", c, ingresos[c] }' >> "/workspaces/ProyectoFinal./reporte.txt"
}

# Función: Total de ingresos por departamento
function ingresos_por_departamento {
    echo -e "\n Total de ingresos por departamento:" >> "/workspaces/ProyectoFinal./reporte.txt"
    tail -n +2 "$ARCHIVO" | awk -F';' '{ ingresos[$3] += $7 } END { for (d in ingresos) printf "• %s: $%.2f\n", d, ingresos[d] }' >> "/workspaces/ProyectoFinal./reporte.txt"
}

# Función: Top 10 productos más vendidos
function top_10_productos {
    echo -e "\n Top 10 productos más vendidos (por cantidad):" >> "/workspaces/ProyectoFinal./reporte.txt"
    tail -n +2 "$ARCHIVO" | awk -F';' '{
        gsub(/^ +| +$/, "", $5);
        productos[$5] += $6
    } END {
        for (p in productos) print productos[p], p
    }' | sort -rn | head -10 | awk '{ printf "• %s unidades - %s\n", $1, $2 }' >> "/workspaces/ProyectoFinal./reporte.txt"
}

# Función: Generar reporte completo
function generar_reporte {
    echo "Generando reporte en /workspaces/ProyectoFinal./reporte.txt ..."
    echo "========== REPORTE DIARIO ==========" >> "/workspaces/ProyectoFinal./reporte.txt"
    ingresos_por_categoria
    ingresos_por_mes
    ingresos_por_cliente
    ingresos_por_departamento
    top_10_productos
    echo "Reporte generado exitosamente en /workspaces/ProyectoFinal./reporte.txt"
}

generar_reporte >> "/workspaces/ProyectoFinal./reporte.txt"
