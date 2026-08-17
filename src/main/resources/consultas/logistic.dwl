%dw 2.0
output application/xml writeDeclaration = false
---
{
    // Teste isolado pro NrReg=319 (ProductCode "15" / LICORES).
    // Se vier <TBL/> vazio, confirma que esse registro nao tem
    // logistica mesmo - reforcando a hipotese de que e um registro
    // de familia/grupo, nao um produto vendavel de verdade.
    "TBL" @(
        "type": "list",
        "name": "UL",
        "end": "20",
        "query": "StkUnl|AI_Art=319"
    ): {
        defcol: {
            CodUnl @("form": "%StkUnl.CodUnl"): {},
            Codigo @("form": "%StkUnl.Codigo"): {}
        }
    }
}