%dw 2.0
output application/xml writeDeclaration = false

// Consulta paginada dos preços negociados vigentes (StkRft), para a carga inicial ArtSoft -> Salesforce.
// Filtro do enunciado: StkRft|EmprCli|Codigo=01000:AA999999|NrCli=0:99999999|? IsGreatEq(DtFim, hoje)

var requestedNext = (vars.requestedNext default "") as String
var limit = (vars.runState.limit default 1000) as Number

var next =
	if (isEmpty(requestedNext))
		""
	else
		"|#" ++ requestedNext

// TESTE: intervalo de Codigo ampliado (00000:ZZZZZZZZ) para incluir artigos como ART002.
// Original do enunciado: Codigo=01000:AA999999. Voltar a ele se o teste não for mais necessário.
// A query enviada ao ARTSOFT é sempre esta (filtro base: DtFim >= hoje). Filtros mais seletivos no ARTSOFT
// obrigam uma varredura da tabela e estouram o timeout. Por isso dtFimFrom, dtFim, dtIniFrom e dtIni
// são aplicados no flow, depois de ler cada página.
var query =
	"StkRft|EmprCli|Codigo=00000:ZZZZZZZZ|NrCli=0:99999999|? \$IsGreatEq(%StkRft.Negoc.DtFim,\$date(TODAY,AAAAMMDD))" ++
	next

---
"TBL" @(
	"type": "list",
	"name": "NegociacoesFuturas",
	"end": limit,
	"query": query
): {
	"defcol": {
		"ClientAndBranchNumber" @(form: "(%StkRft.Ter.Cli).(%StkRft.Ter.NrFilial)"): {},
		"Cli" @(form: "%StkRft.Ter.Cli"): {},
		"Filial" @(form: "%StkRft.Ter.NrFilial"): {},
		"ProductCode" @(form: "%StkRft.Cod.Codigo"): {},
		"BeginDate" @(form: "%StkRft.Negoc.DtIni"): {},
		"EndDate" @(form: "%StkRft.Negoc.DtFim"): {},
		"Value" @(form: "%StkRft.Negoc.Preco"): {}
	}
}
