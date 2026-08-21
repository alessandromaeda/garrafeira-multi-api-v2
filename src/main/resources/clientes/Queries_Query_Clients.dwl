%dw 2.0
output application/xml writeDeclaration = false
var nif = (vars.requestedNif default "") as String
var queryFilter =
    if (isEmpty(nif))
        "TerFch|AutoInc=1:999999"
    else
        "TerFch|NrIdFisc=" ++ nif
---
{
    "TBL" @(
        "type": "list",
        "name": "CLI",
        "end": "100",
        "query": queryFilter
    ): {
        "defcol": {
            "ClientNumber" @(
                "form": "%TerFch.Cli.Numero"
            ): {},
            "TaxNumber" @(
                "form": "%TerFch.Ter.NrIdFisc"
            ): {},
            "ClientName" @(
                "form": "%TerFch.Ter.Nome"
            ): {}
        }
    }
}
