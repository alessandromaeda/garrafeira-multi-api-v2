%dw 2.0
output application/xml writeDeclaration = false
---
{
    TBL @(
        "type": "list",
        "name": "Clientes",
        "end": "100",
        "query": "TerFch|Cliente|NrCli=1:100"
    ): {
        defcol: {
            Codigo @(form: "%TerFch.Cli.Numero", "type": "text"): {},
            Nome @(form: "%TerFch.Ter.Nome", "type": "text"): {},
            Grupo_Empresas_Txt @(form: "%TerFch.Adic.Txt.GE", "type": "text"): {},
            Grupo_Empresas_Val @(form: "%TerFch.Adic.Val.GE", "type": "num"): {},
            Dimensao_Txt @(form: "%TerFch.Adic.Txt.CLI_DIMENS", "type": "text"): {},
            Dimensao_Val @(form: "%TerFch.Adic.Val.CLI_DIMENS", "type": "num"): {},
            Crescimento_Val @(form: "%TerFch.Adic.Val.CLI_CRESC", "type": "num"): {},
            Potencial_Val @(form: "%TerFch.Adic.Val.POTCLI", "type": "num"): {},
            Plafond_Val @(form: "%TerFch.Adic.Val.PI", "type": "num"): {},
            Area_Geo_Txt @(form: "%TerFch.Adic.Txt.AREAGEO", "type": "text"): {},
            Area_Geo_Val @(form: "%TerFch.Adic.Val.AREAGEO", "type": "num"): {},
            Zona_Geo_Txt @(form: "%TerFch.Adic.Txt.ZONAGEO", "type": "text"): {},
            Zona_Geo_Val @(form: "%TerFch.Adic.Val.ZONAGEO", "type": "num"): {},
            Obj_Vendas_Txt @(form: "%TerFch.Adic.Txt.OV", "type": "text"): {},
            Motivo_Txt @(form: "%TerFch.Adic.Txt.MOT", "type": "text"): {}
        }
    }
}