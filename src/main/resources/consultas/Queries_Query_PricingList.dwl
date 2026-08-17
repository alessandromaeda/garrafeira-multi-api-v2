%dw 2.0
output application/xml writeDeclaration = false
---
{
    "TBL" @(
        "type": "list",
        "name": "SKU",
        "end": "100",
       // "query": "StkFch|DtUltAct|Data=20250102:20261231 |? \u0024IsGreat(%StkFch.Cod.Codigo,01000) ^ \u0024IsLessEq(%StkFch.Cod.Codigo,AA999999)"
   		"query": "StkFch|Principal|Codigo=2005030:2005030"
    ): {
        "defcol": {
            "ProductCode" @(
                "form": "%StkFch.Cod.Codigo"
            ): {},
            "Price00" @(
                "form": "%StkFch.Prc.Preco.0"
            ): {},
            "Price01" @(
                "form": "%StkFch.Prc.Preco.1"
            ): {},
            "Price02" @(
                "form": "%StkFch.Prc.Preco.2"
            ): {},
            "Price03" @(
                "form": "%StkFch.Prc.Preco.3"
            ): {},
            "Price04" @(
                "form": "%StkFch.Prc.Preco.4"
            ): {},
            "Price05" @(
                "form": "%StkFch.Prc.Preco.5"
            ): {},
            "Price06" @(
                "form": "%StkFch.Prc.Preco.6"
            ): {},
            "Price07" @(
                "form": "%StkFch.Prc.Preco.7"
            ): {},
            "Price12" @(
                "form": "%StkFch.Prc.PrecoEx.12"
            ): {},
            "Price13" @(
                "form": "%StkFch.Prc.PrecoEx.13"
            ): {},
            "Price14" @(
                "form": "%StkFch.Prc.PrecoEx.14"
            ): {}
        }
    }
}