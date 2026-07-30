%dw 2.0
output text/xml writeDeclaration = false
---
"TBL" @(
    "type": "list",
    "name": "Ter",
    "end": "100",
    "query": "TerCon|DataAniv=19500101:20091231 |#0"
    //"query": "TerCon|Contact|AITerc=1:99999"
): {
    "defcol": {
        "NrCli" @(form: "%TerCon.NrCli"): {},
        "NrFor" @(form: "%TerCon.NrFor"): {},
        "Filial" @(form: "%TerCon.Filial"): {},
        "TpContacto" @(form: "%TerCon.TpContacto"): {},
        "NrContacto" @(form: "%TerCon.NrContacto"): {},
        "DataNasc" @(form: "%TerCon.DataNasc"): {},
        "Titulo" @(form: "%TerCon.Titulo"): {},
        "Nome" @(form: "%TerCon.Nome"): {},
        "Telemovel" @(form: "%TerCon.Telemovel"): {},
        "Telefone" @(form: "%TerCon.Telefone"): {},
        "Fax" @(form: "%TerCon.Fax"): {},
        "Email1" @(form: "%TerCon.Email1"): {},
        "Email2" @(form: "%TerCon.Email2"): {},
        "URL" @(form: "%TerCon.URL"): {},
        "Obs" @(form: "%TerCon.Obs"): {},
        "Password" @(form: "%TerCon.Password"): {},
        "AcessosGer" @(form: "%TerCon.AcessosGer"): {},
        "AcessosEsp" @(form: "%TerCon.AcessosEsp"): {},
        "AcessoCtasC" @(form: "%TerCon.AcessoCtasC"): {},
        "AcessoCtasF" @(form: "%TerCon.AcessoCtasF"): {},
        "TipoSaida" @(form: "%TerCon.TipoSaida"): {},
        "SocialMedia01" @(form: "%TerCon.SocialMedia01"): {},
        "SocialMedia_Comp01" @(form: "%TerCon.SocialMedia_Comp01"): {}
    }
}
