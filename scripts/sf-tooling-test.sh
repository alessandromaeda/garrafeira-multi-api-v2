#!/usr/bin/env bash
# Obtém token (client credentials) e consulta a Tooling API do Salesforce.
# Lê as credenciais de src/main/resources/properties/products-sf-secure.yaml
# sem imprimi-las. Uso: ./scripts/sf-tooling-test.sh [Objeto] [Campo]
set -euo pipefail
cd "$(dirname "$0")/.."

YAML=src/main/resources/properties/products-sf-secure.yaml
val() { sed -nE "s/^[[:space:]]*$1:[[:space:]]*\"?([^\"]*)\"?[[:space:]]*$/\1/p" "$YAML" | head -1; }

KEY=$(val consumerKey)
SECRET=$(val consumerSecret)
HOST=$(val tokenEndpoint)
OBJ=${1:-Account}
FIELD=${2:-Type}

RESP=$(curl -sS -X POST "$HOST/services/oauth2/token" \
  -d "grant_type=client_credentials" \
  --data-urlencode "client_id=$KEY" \
  --data-urlencode "client_secret=$SECRET")

TOKEN=$(printf '%s' "$RESP" | sed -nE 's/.*"access_token"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')
INSTANCE=$(printf '%s' "$RESP" | sed -nE 's/.*"instance_url"[[:space:]]*:[[:space:]]*"([^"]+)".*/\1/p')
if [ -z "$TOKEN" ]; then echo "Falha ao obter token: $RESP" >&2; exit 1; fi

curl -sS -G "${INSTANCE:-$HOST}/services/data/v67.0/tooling/query/" \
  -H "Authorization: Bearer $TOKEN" \
  --data-urlencode "q=SELECT Id, FullName, Metadata FROM CustomField WHERE TableEnumOrId='$OBJ' AND DeveloperName='$FIELD'"
echo
