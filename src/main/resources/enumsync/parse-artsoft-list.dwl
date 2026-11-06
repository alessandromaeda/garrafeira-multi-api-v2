%dw 2.0
output application/java
var doc = read(payload as String {encoding: (vars.mapping.artsoft.encoding default "windows-1252")}, "application/xml")

// Localiza as "linhas" da tabela: o primeiro grupo de elementos irmãos repetidos.
fun rowsOf(n: Any): Array<Any> =
	if (!(n is Object)) []
	else do {
		var groups = (n pluck ((v, k) -> { key: k as String, attrs: (k.@ default {}), value: v })) groupBy ((e) -> e.key)
		var repeated = (groups pluck ((g) -> g)) filter ((g) -> sizeOf(g) > 1)
		---
		if (!isEmpty(repeated)) (repeated[0] map ((e) -> { attrs: e.attrs, value: e.value }))
		else flatten((n pluck ((v) -> rowsOf(v))))
	}

fun fieldsOf(row: Any): Object = do {
	var attrs = (row.attrs default {}) as Object
	var content = row.value
	---
	attrs ++ (
		if (content is Object) (content mapObject ((v, k) -> { (k as String): v }))
		else if (content is String and !isEmpty(trim(content))) { "_text": content }
		else {}
	)
}

fun firstMatch(fields: Object, pattern: Regex, fallbackIndex: Number): String =
	do {
		var keys = fields pluck ((v, k) -> k as String)
		var hit = (keys filter ((k) -> k matches pattern))[0]
		var chosen = if (hit != null) hit else keys[fallbackIndex]
		---
		if (chosen == null) "" else trim((fields[chosen] default "") as String)
	}

var mapping = vars.mapping.artsoft
---
rowsOf(doc) map ((row) -> do {
	var f = fieldsOf(row)
	var code = if (mapping.codeField != null) trim((f[mapping.codeField] default "") as String)
		else firstMatch(f, /(?i)^(cod|codigo|id|nr|num|numero)/, 0)
	var name = if (mapping.nameField != null) trim((f[mapping.nameField] default "") as String)
		else if (f."_text" != null) trim(f."_text" as String)
		else firstMatch(f, /(?i)(nome|desc|nm|name|texto|abrv)/, 1)
	---
	{ code: code, name: name }
}) filter ((r) -> !isEmpty(r.code) and !isEmpty(r.name))
