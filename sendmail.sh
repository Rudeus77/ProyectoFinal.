#!/bin/bash

export API_KEY='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'
DESTINATARIO="wmarenco@ugb.edu.sv"
REMITENTE="brayan05012@gmail.com"
ASUNTO="Reporte de ventas diarias"
MENSAJE="HOLA JEFE! Le adjunto el reporte de ventas de este dia"

REPORTE_BASE64=$(base64 -w 0 reporte.txt)

curl --request POST \
--url https://api.sendgrid.com/v3/mail/send \
--header "Authorization: Bearer $API_KEY" \
--header "Content-Type: application/json" \
--data '{
"personalizations": [{
"to": [{"email": "'"$DESTINATARIO"'"}]
}],
"from": {"email": "'"$REMITENTE"'"},
"subject": "'"$ASUNTO"'",
"content": [{
"type": "text/plain",
"value": "'"$MENSAJE"'"
}],
"attachments": [{
"content": "'"$REPORTE_BASE64"'",
"type": "text/txt",
"filename": "reporte.txt",
"disposition": "attachment"
}]
}'