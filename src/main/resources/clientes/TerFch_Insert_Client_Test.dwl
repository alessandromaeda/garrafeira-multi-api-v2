%dw 2.0
output application/xml writeDeclaration = false
var client = payload
---
{
    "Entity" @(
        "createCli": "2",
        "trans": "S",
        "RetID": "S",
        "status": "S"
    ): {
        "BaseAddr": {
            "Ter.NrIdFisc": client.nif,
            "Ter.Nome": client.nome,
            "Ter.Morada": client.morada,
            "Ter.CPPais": client.codigoPostal,
            "Pais.Cod": client.paisCod default 0,
            "Moed.Abrv": client.moeda default "EUR",
            "Cli.PrefT": client.preferenciaTerceiro default 1,
            "Ter.EMail": client.email,
            ("Div.UserMod": client.utilizadorModificacao) if (!isEmpty(client.utilizadorModificacao))
        }
    }
}
