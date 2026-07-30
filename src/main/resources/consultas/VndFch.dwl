%dw 2.0
output text/xml writeDeclaration = false
---
"TBL" @(
    "type": "list",
    "name": "Vnd",
    "end": "100",
    "query": "VndFch|NrVend=1:9999 |#891"
    //"query": "VndFch|Hierarq=1:9999"
): {
    "defcol": {
	    "VndFch.NrVended" @(form: "%VndFch.NrVended"): {},
	    "VndFch.RespHier" @(form: "%VndFch.RespHier"): {},
	    "VndFch.NmeRespH" @(form: "%VndFch.NmeRespH"): {},
	    "VndFch.NivComCd" @(form: "%VndFch.NivComCd"): {},
	    "VndFch.NivComDs" @(form: "%VndFch.NivComDs"): {},
	    "VndFch.CCustoHb" @(form: "%VndFch.CCustoHb"): {},
	    "VndFch.Flags" @(form: "%VndFch.Flags"): {},
	    "VndFch.RecCtrlU" @(form: "%VndFch.RecCtrlU"): {},
	    "VndFch.RecCtrlD" @(form: "%VndFch.RecCtrlD"): {},
	    "VndFch.ComFixa" @(form: "%VndFch.ComFixa"): {},
	    "VndFch.ObsVend" @(form: "%VndFch.ObsVend"): {},
	    "VndFch.DescFuncao" @(form: "%VndFch.DescFuncao"): {},
	    "VndFch.Perfil" @(form: "%VndFch.Perfil"): {},
	    "VndFch.CodPais" @(form: "%VndFch.CodPais"): {},
	    "VndFch.Nome" @(form: "%VndFch.Nome"): {},
	    "VndFch.NomeRed" @(form: "%VndFch.NomeRed"): {},
	    "VndFch.Morada" @(form: "%VndFch.Morada"): {},
	    "VndFch.Localid" @(form: "%VndFch.Localid"): {},
	    "VndFch.CPAlfa" @(form: "%VndFch.CPAlfa"): {},
	    "VndFch.Obs" @(form: "%VndFch.Obs"): {},
	    "VndFch.NrIdFisc" @(form: "%VndFch.NrIdFisc"): {},
	    "VndFch.DataNasc" @(form: "%VndFch.DataNasc"): {},
	    "VndFch.NrTelef" @(form: "%VndFch.NrTelef"): {},
	    "VndFch.NrFax" @(form: "%VndFch.NrFax"): {},
	    "VndFch.TlmBip" @(form: "%VndFch.TlmBip"): {},
	    "VndFch.EMail" @(form: "%VndFch.EMail"): {},
	    "VndFch.URL" @(form: "%VndFch.URL"): {},
	    "VndFch.NIB" @(form: "%VndFch.NIB"): {},
	    "VndFch.Titulo" @(form: "%VndFch.Titulo"): {},
	    "VndFch.FichImg" @(form: "%VndFch.FichImg"): {},
	    "VndFch.Imagem" @(form: "%VndFch.Imagem"): {},
	    "VndFch.EMailP" @(form: "%VndFch.EMailP"): {}
	}
}