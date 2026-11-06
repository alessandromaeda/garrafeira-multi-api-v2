%dw 2.0
output application/java
---
// Uma linha por enum a sincronizar. Para incluir um novo, basta acrescentar um item.
// salesforce.kind: StandardValueSet | GlobalValueSet | CustomField (lista propria do campo).
// salesforce.labelFormat: como montar o rotulo de um valor NOVO ({code} e {name}).
// artsoft.encoding: charset com que o ArtSoft devolve ESSA tabela (padrao windows-1252).
// Opcionais em "artsoft": codeField / nameField, para forçar quais campos da linha do
// CfgTables são o código e o nome (por padrão são detectados pelo nome do campo).
[
	{
		id: "tipo",
		label: "Tipo de cliente (TerFch.Cli.CodTipo / Cli.Tipo)",
		enabled: true,
		artsoft: { table: "TblTpTerc", attrs: { idTable: "0" }, encoding: "UTF-8" },
		salesforce: { kind: "StandardValueSet", fullName: "AccountType", labelFormat: "{name}" }
	},
	{
		id: "zona",
		label: "Zona (TerFch.Cli.CodZona / Cli.Zona)",
		enabled: true,
		artsoft: { table: "TblZonas", attrs: {}, encoding: "windows-1252" },
		salesforce: { kind: "GlobalValueSet", fullName: "GASO_LogisticsGeoZone", labelFormat: "{code} - {name}" }
	}
]
