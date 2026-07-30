%dw 2.0
output text/xml writeDeclaration = false
---
"TBL" @(
    "type": "list",
    "name": "SKU",
    "end": "10",
    "query": "StkFch|DtUltAct|Data=20250411:20991231 |? \$IsGreat(%StkFch.Cod.Codigo,01000) ^ \$IsLessEq(%StkFch.Cod.Codigo,AA999999) |#74293"
//    "query": "StkFch|DtUltAct|Data=20250411:20991231 |? \$IsGreat(%StkFch.Cod.Codigo,01000) ^ \$IsLessEq(%StkFch.Cod.Codigo,AA999999)"
): {
    "defcol": {
        "ProductCode" @(form: "%StkFch.Cod.Codigo"): {},
        "ProductInternalRecord" @(form: "%StkFch.Div.NrReg"): {},
        "ProductUnit" @(form: "%StkFch.Logis.Uni"): {},
        "PRodutcName" @(form: "%StkFch.Nome.0"): {},
        "ProductBrand" @(form: "%StkFch.Adic.Txt.MARCA"): {},
        "ProductFamily" @(form: "%StkFch.Logis.NmGrupo1"): {},
        "ProductSubFamily" @(form: "%StkFch.Logis.NmGrupo2"): {},
        "ProductVolume" @(form: "%StkFch.Adic.Txt.CAPAC"): {},
        "ProductVatRate" @(form: "%StkFch.IVA.Taxa"): {},
        "ProductAllStock" @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,0)"): {},
        "ProductSupplierNumber" @(form: "%StkFch.Logis.FornPr"): {},
        "ProductQuantityPack" @(form: "%StkFch.Logis.QtdEmb"): {},
        "ProductImage" @(form: "\$GetImage(%StkFch.Div.FichImgRed)"): {},
        "DoNotOrder" @(form: "\$LogicAnd(%StkFch.Flag.App,30,H)"): {},
        "DoNotSale" @(form: "\$LogicAnd(%StkFch.Flag.App,3,H)"): {},
        "Logistics" @(
            "type": "list",
            "name": "UL",
            "end": "1",
            "supressEmpty": "s",
            "supressroot": "s",
            "query": "StkUnl|AI_Art={%StkFch.Div.NrReg} "
        ): {
            "defcol": {
                "CodUnl" @(form: "%StkUnl.CodUnl"): {}   // EAN
            }
        }
    }
}
