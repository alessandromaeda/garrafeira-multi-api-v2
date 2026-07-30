%dw 2.0
output application/xml writeDeclaration = false
---
{
    TBL @(
    	"type": "list",
		"name": "SKU",
		"end": "100",
		"query": "StkRft|EmprCli|Codigo=01000:AA999999|NrCli=0:99999999|? \$IsGreatEq(%StkRft.Negoc.DtFim,\$date(TODAY,AAAAMMDD))"
    ): { 
        defcol: {
			ClientAndBranchNumber @(form: "(%StkRft.Ter.Cli).(%StkRft.Ter.NrFilial)"): {},
			ProductCode @(form: "%StkRft.Ter.CodArt"): {},
			BeginDate @(form: "%StkRft.Negoc.DtIni"): {},
			EndDate @(form: "%StkRft.Negoc.DtFim"): {},
			Value @(form: "%StkRft.Negoc.Preco"): {}
		}
    }
}