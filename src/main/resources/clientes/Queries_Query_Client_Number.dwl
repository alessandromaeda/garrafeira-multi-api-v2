%dw 2.0
output application/xml writeDeclaration = false
---
{
    "TBL" @(
        "type": "list",
        "name": "CLI",
        "end": "100",
        "query": "TerFch|AutoInc=" ++ (vars.clientAutoInc as String)
    ): {
        "defcol": {
            "ClientNumber" @(
                "form": "%TerFch.Cli.Numero"
            ): {}
        }
    }
}
