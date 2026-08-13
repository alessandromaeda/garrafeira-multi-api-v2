%dw 2.0
output application/xml writeDeclaration = false
---
{
    "TBL" @(
        "type": "list",
        "name": "SKU",
        "end": "100",
        "query": "StkFch|DtUltAct|Data=20250411:20991231|? \$IsEqual(%StkFch.Cod.Codigo,'AA50005')"
    ): {
        defcol: {
            ProductCode @(
                form: "%StkFch.Cod.Codigo"
            ): {},
            ProductInternalRecord @(
                form: "%StkFch.Div.NrReg"
            ): {},
            ProductUnit @(
                form: "%StkFch.Logis.Uni"
            ): {},
            ProductName @(
                form: "%StkFch.Nome.0"
            ): {},
            ProductBrand @(
                form: "%StkFch.Adic.Txt.MARCA"
            ): {},
            ProductFamily @(
                form: "%StkFch.Logis.NmGrupo1"
            ): {},
            ProductSubFamily @(
                form: "%StkFch.Logis.NmGrupo2"
            ): {},
            ProductVolume @(
                form: "%StkFch.Adic.Txt.CAPAC"
            ): {},
            ProductVatRate @(
                form: "%StkFch.IVA.Taxa"
            ): {},
            ProductSupplierNumber @(
                form: "%StkFch.Logis.FornPr"
            ): {},
            ProductQuantityPack @(
                form: "%StkFch.Logis.QtdEmb"
            ): {},
            Logistics @(
                "type": "list",
                "name": "UL",
                "end": "20",
                "supressEmpty": "s",
                "supressroot": "s",
                "query": "StkUnl|AI_Art={%StkFch.Div.NrReg}"
            ): {
                defcol: {
                    CodUnl @(
                        form: "%StkUnl.CodUnl"
                    ): {},
                    Codigo @(
                        form: "%StkUnl.Codigo"
                    ): {},
                    Quant @(
                        form: "%StkUnl.Quant"
                    ): {},
                    Descricao @(
                        form: "%StkUnl.Descricao"
                    ): {}
                }
            }
        }
    }
}