%dw 2.0
output application/xml writeDeclaration = false

var nextValue = (vars.nextValue default "") as String
var lastUpdateTimeValue = (vars.lastUpdateTimeValue default "") as String
var next = if (!isEmpty(nextValue)) " |#" ++ nextValue else ""
var lastUpdateTime = if (!isEmpty(lastUpdateTimeValue)) " |HrUltAct=" ++ lastUpdateTimeValue else ""
var validClientNumberFilter = " |? \$IsGreatEq(%TerFch.Cli.Numero,1) ^ \$IsLessEq(%TerFch.Cli.Numero,99999)"
var query =
    "TerFch|DtUltAct=20250402:20991231" ++
    lastUpdateTime ++
    validClientNumberFilter ++
    next
---
{
    "TBL" @(
        "type": "list",
        "name": "CLI",
        "end": "100",
        "query": query
    ): {
        "defcol": {
            "ClientNumber" @(
                "form": "%TerFch.Cli.Numero"
            ): {}
        }
    }
}
