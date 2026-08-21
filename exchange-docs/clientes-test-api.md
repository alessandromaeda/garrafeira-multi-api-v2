# API REST de teste — clientes ARTSOFT

Esta API fica separada dos flows agendados de `garrafeira-testes.xml` e escuta somente na interface local (`127.0.0.1`), porta `8082`.

## 1. Consultar uma lista de clientes

```http
GET http://localhost:8082/test/clientes
```

A consulta pede ao ARTSOFT no máximo 100 registos e devolve número do cliente, NIF e nome.

## 2. Consultar um NIF específico

```bash
curl --request GET \
  --url 'http://127.0.0.1:8082/test/clientes?nif=505128985' \
  --header 'Accept: application/xml'
```

O NIF deve conter exatamente nove algarismos. Esta operação é somente de leitura e deve ser executada antes da tentativa de inserção.

## 3. Inserir um cliente e obter o número atribuído

```bash
curl --request POST \
  --url 'http://127.0.0.1:8082/test/clientes/insert' \
  --header 'Content-Type: application/json' \
  --header 'Accept: application/json' \
  --data '{
    "nif": "505128985",
    "nome": "Noesis Portugal - Consultadoria em Sistemas Informáticos, S.A.",
    "morada": "Torres de Lisboa - Rua Tomás da Fonseca, Torre E, 14º piso",
    "codigoPostal": "1600-209",
    "email": "geral@noesis.pt",
    "paisCod": 0,
    "moeda": "EUR",
    "preferenciaTerceiro": 1
  }'
```

Os campos obrigatórios são `nif`, `nome`, `morada`, `codigoPostal` e `email`. Os restantes assumem os valores mostrados no exemplo. `Div.UserMod` só é enviado ao ARTSOFT quando `utilizadorModificacao` possuir um valor.

Depois de `/TerFch/Update` devolver `rc="0"` e o `ID`, o flow executa `/Queries/Query` com `TerFch|AutoInc=<ID>` e devolve o número comercial do cliente.

> Atenção: este endpoint escreve dados reais no ARTSOFT configurado. O nome `/TerFch/Update` não comprova comportamento de upsert. Até existir documentação ou teste conclusivo, a operação com `createCli="2"` deve ser tratada como inserção.
