# Sincronização horária de produtos com o Salesforce

O serviço está isolado em `products-salesforce-sync.xml` e não altera os
fluxos de teste existentes.

## Execução

- Schedule: cinco minutos depois de cada hora, em `Europe/Lisbon`.
- Endpoint manual: `POST /internal/products/salesforce/sync`.
- Janela: sempre de ontem até hoje, no formato `yyyyMMdd:yyyyMMdd`.
- Paginação: sequencial pelo atributo `next`, mantendo a mesma janela.
- Filtro de código: `$inRange(%StkFch.Cod.Codigo,01000,AA999999)`.
- Erros: encerram a execução; nenhum checkpoint é persistido.
- Página vazia: não é enviada ao Data Cloud.

O endpoint manual aceita uma data de referência no formato `yyyyMMdd`:

```http
POST /internal/products/salesforce/sync?date=20260820
```

Nesse exemplo, a janela será `20260819:20260820`. Sem `date`, o fluxo usa
a data corrente em `Europe/Lisbon`. O scheduler sempre usa a data corrente.

Também é possível informar diretamente as duas datas:

```http
POST /internal/products/salesforce/sync?date=20260112:20260815
```

Nesse caso, a consulta usa exatamente `20260112:20260815`, sem recalcular
nenhuma das extremidades.

A consulta exclusiva do sync é montada por
`consultas/Queries_Query_Products_Salesforce.dwl`. A primeira página segue:

```text
StkFch|DtUltAct|Data=<ontem>:<hoje>|? $inRange(%StkFch.Cod.Codigo,01000,AA999999)
```

Nas páginas seguintes, o cursor retornado é anexado como `|#<next>`.

O limite de registros por página e o limite defensivo de páginas são
propriedades externas com valores locais padrão no XML.

## Responsabilidades

O Mule envia cada página exatamente no envelope:

```json
{
  "data": []
}
```

O Mule não consulta a existência do produto, não escolhe entre insert e
update e não remove repetições. Essas responsabilidades pertencem ao
Salesforce/Data Cloud.

## Configuração necessária

As propriedades do Data Cloud ficam em
`properties/products-sf-secure.yaml`. Neste ambiente de teste elas estão em
texto puro e não dependem de `encrypt.key`. Esse arquivo contém credenciais e
não deve ser publicado, compartilhado ou versionado em um repositório remoto.

Por segurança, o valor local de
`productsSfSync.scheduler.cronExpression` aponta para 2099. Depois de
configurar o Salesforce no ambiente desejado, alterar externamente para
`0 5 * * * ?`.

Pré-condição ainda não comprovada no código: confirmar com o Salesforce/Data
Cloud qual campo é a chave primária/única do objeto de ingestão de produtos.
Uma resposta `accepted: true` confirma a aceitação do lote pela API, mas não
comprova o processamento final individual de cada registro.
