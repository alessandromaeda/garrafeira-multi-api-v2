%dw 2.0
output application/xml writeDeclaration = false
---
{
    "TBL" @(
        "type": "list",
        "name": "SKU",
        "end": "100",
        "query": "StkFch|DtUltAct|Data=20250411:20991231 |? \u0024IsGreat(%StkFch.Cod.Codigo,01000) ^ \u0024IsLessEq(%StkFch.Cod.Codigo,AA999999) ^ \u0024IsEqual(%StkFch.Div.NivFam,0)"
    ): {
        "defcol": {
            "ProductCode" @(
                "form": "%StkFch.Cod.Codigo"
            ): {},
            "ProductInternalRecord" @(
                "form": "%StkFch.Div.NrReg"
            ): {},
            "ProductUnit" @(
                "form": "%StkFch.Logis.Uni"
            ): {},
            "ProductName" @(
                "form": "%StkFch.Nome.0"
            ): {},
            "ProductBrand" @(
                "form": "%StkFch.Adic.Txt.MARCA"
            ): {},
            "ProductFamily" @(
                "form": "%StkFch.Logis.NmGrupo1"
            ): {},
            "ProductSubFamily" @(
                "form": "%StkFch.Logis.NmGrupo2"
            ): {},
            "ProductVolume" @(
                "form": "%StkFch.Adic.Txt.CAPAC"
            ): {},
            "ProductVatRate" @(
                "form": "%StkFch.IVA.Taxa"
            ): {},
            "ProductAllStock" @(
                "form": "\u0024SkuValue(%StkFch.Cod.Codigo,Avail,0)"
            ): {},
            "ProductSupplierNumber" @(
                "form": "%StkFch.Logis.FornPr"
            ): {},
            "ProductQuantityPack" @(
                "form": "%StkFch.Logis.QtdEmb"
            ): {},
            "ProductImage" @(
                "form": "\u0024GetImage(%StkFch.Div.FichImgRed)"
            ): {},
            "DoNotOrder" @(
                "form": "\u0024LogicAnd(%StkFch.Flag.App,30,H)"
            ): {},
            "DoNotSale" @(
                "form": "\u0024LogicAnd(%StkFch.Flag.App,3,H)"
            ): {},
            "Logistics" @(
                "type": "list",
                "name": "UL",
                "end": "20",
                //"supressEmpty": "s",
               // "supressroot": "s",
                "query": "StkUnl|AI_Art={%StkFch.Div.NrReg}"
            ): {
                "defcol": {
                    "CodUnl" @(
                        "form": "%StkUnl.CodUnl"
                    ): {}
                }
            }
        }
    }
}