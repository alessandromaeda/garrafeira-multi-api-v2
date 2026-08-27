%dw 2.0 
output application/xml writeDeclaration = false

var next =
	if (isEmpty(vars.requestedNext default ""))
		""
	else
		"|#" ++ (vars.requestedNext as String)

var query =
	"StkFch|DtUltAct|Data=" ++ vars.runState.lastUpdate ++
	"|? \$inRange(%StkFch.Cod.Codigo,01000,AA999999)" ++
	next

---
"TBL" @(
	"type": "list",
	"name": "Stk",
	"end": p("productsSfSync.page.limit") as Number,
	"query": query
): {
	"defcol": {
		"StkFch.Cod.Editado" @(form: "%StkFch.Cod.Editado"): {},
		"StkFch.Cod.Codigo" @(form: "%StkFch.Cod.Codigo"): {},
		"StkFch.Div.NrReg" @(form: "%StkFch.Div.NrReg"): {},
		"StkFch.Cod.Familia1" @(form: "%StkFch.Cod.Familia1"): {},
		"StkFch.Cod.Familia2" @(form: "%StkFch.Cod.Familia2"): {},
		"StkFch.Div.DtCriac" @(form: "%StkFch.Div.DtCriac"): {},
		"StkFch.Adic.Txt.MARCA" @(form: "%StkFch.Adic.Txt.MARCA"): {},
		"StkFch.Logis.NmGrupo1" @(form: "%StkFch.Logis.NmGrupo1"): {},
		"StkFch.Logis.NmGrupo2" @(form: "%StkFch.Logis.NmGrupo2"): {},
		"StkFch.Adic.Txt.CAPAC" @(form: "%StkFch.Adic.Txt.CAPAC"): {},
		"StkFch.IVA.Taxa" @(form: "%StkFch.IVA.Taxa"): {},
		"TotalStock" @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,0)"): {},
		"StkFch.Logis.FornPr" @(form: "%StkFch.Logis.FornPr"): {},
		"StkFch.Logis.FornPrID" @(form: "%StkFch.Logis.FornPrID"): {},
		"StkFch.Logis.Uni" @(form: "%StkFch.Logis.Uni"): {},
		"StkFch.Nome.0" @(form: "%StkFch.Nome.0"): {},
		"StkFch.Cod.NomeFam2" @(form: "%StkFch.Cod.NomeFam2"): {},
		"StkFch.Logis.QtdEmb" @(form: "%StkFch.Logis.QtdEmb"): {},
		"ProductImage" @(form: "\$GetImage(%StkFch.Div.FichImgRed)"): {},
		"StkFch.Flag.Abater" @(form: "%StkFch.Flag.Abater"): {},
		"DoNotOrder" @(form: "\$LogicAnd(%StkFch.Flag.App,30,H)"): {},
		"Logistics" @(
			"type": "list",
			"name": "UL",
			"end": "1",
			"supressEmpty": "s",
			"supressRoot": "s",
			"query": "StkUnl|AI_Art={%StkFch.Div.NrReg}"
		): {
			"defcol": {
				"CodUnl" @(form: "%StkUnl.CodUnl"): {}
			}
		},
		"StkFch.Prc.Preco.0" @(form: "%StkFch.Prc.Preco.0"): {},
		"StkFch.Prc.Preco.1" @(form: "%StkFch.Prc.Preco.1"): {},
		"StkFch.Prc.Preco.2" @(form: "%StkFch.Prc.Preco.2"): {},
		"StkFch.Prc.Preco.3" @(form: "%StkFch.Prc.Preco.3"): {},
		"StkFch.Prc.Preco.4" @(form: "%StkFch.Prc.Preco.4"): {},
		"StkFch.Prc.Preco.5" @(form: "%StkFch.Prc.Preco.5"): {},
		"StkFch.Prc.Preco.6" @(form: "%StkFch.Prc.Preco.6"): {},
		"StkFch.Prc.Preco.7" @(form: "%StkFch.Prc.Preco.7"): {},
		"StkFch.Prc.Preco.8" @(form: "%StkFch.Prc.Preco.8"): {},
		"StkFch.Prc.Preco.9" @(form: "%StkFch.Prc.Preco.9"): {},
		"StkFch.Prc.Preco.X" @(form: "%StkFch.Prc.Preco.X"): {},
		"StkFch.Prc.Preco.Y" @(form: "%StkFch.Prc.Preco.Y"): {},
		"StkFch.Prc.PrecoEx.10" @(form: "%StkFch.Prc.PrecoEx.10"): {},
		"StkFch.Prc.PrecoEx.11" @(form: "%StkFch.Prc.PrecoEx.11"): {},
		"StkFch.Prc.PrecoEx.12" @(form: "%StkFch.Prc.PrecoEx.12"): {},
		"StkFch.Prc.PrecoEx.13" @(form: "%StkFch.Prc.PrecoEx.13"): {},
		"StkFch.Prc.PrecoEx.14" @(form: "%StkFch.Prc.PrecoEx.14"): {},
		"StkFch.Adic.Txt.DESCRITIVO" @(form: "%StkFch.Adic.Txt.DESCRITIVO"): {},
		"StkFch.Adic.Txt.DESCRITIVO2" @(form: "%StkFch.Adic.Txt.DESCRITIVO2"): {},
		"StkFch.Adic.Txt.DESCRITIVOFR" @(form: "%StkFch.Adic.Txt.DESCRITIVOFR"): {},
		"StkFch.Adic.Txt.CONTPT" @(form: "%StkFch.Adic.Txt.CONTPT"): {},
		"StkFch.Adic.Txt.CONTEN" @(form: "%StkFch.Adic.Txt.CONTEN"): {},
		"StkFch.Adic.Txt.CONTFR" @(form: "%StkFch.Adic.Txt.CONTFR"): {},
		"StkFch.Adic.Txt.ENOLOGO" @(form: "%StkFch.Adic.Txt.ENOLOGO"): {},
		"StkFch.Adic.Txt.FICHAEN" @(form: "%StkFch.Adic.Txt.FICHAEN"): {},
		"StkFch.Adic.Txt.FICHAPT" @(form: "%StkFch.Adic.Txt.FICHAPT"): {}
	}
}
