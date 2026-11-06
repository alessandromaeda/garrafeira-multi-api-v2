%dw 2.0
output application/java
var doc = read(payload as String {encoding: "UTF-8"}, "application/xml")
var body = doc.Envelope.Body
var record = body.readMetadataResponse.result.records
var kind = vars.mapping.salesforce.kind
var isStandard = kind == "StandardValueSet"
var isGlobalSet = kind == "GlobalValueSet"
var rawValues =
	if (isStandard) (record.*standardValue default [])
	else if (isGlobalSet) (record.*customValue default [])
	else (record.valueSet.valueSetDefinition.*value default [])

fun asMap(v: Any): Object = if (v is Object) (v mapObject ((x, k) -> { (k as String): (x as String) })) else {}
---
{
	fault: if (body.Fault != null) (body.Fault.faultstring as String default "SOAP Fault") else null,
	found: record != null,
	global: kind == "CustomField" and record.valueSet.valueSetName != null,
	globalName: if (kind == "CustomField") (record.valueSet.valueSetName as String default null) else null,
	values: rawValues map ((v) -> asMap(v)),
	// Definição do campo sem a lista de valores, para reenviar completa no update (CustomField).
	skeleton:
		if (isStandard or record == null) {}
		else if (isGlobalSet) (record filterObject ((v, k) -> k as String != "customValue"))
		else (record mapObject ((v, k) ->
			if (k as String == "valueSet")
				{ (k as String): (v mapObject ((v2, k2) ->
					if (k2 as String == "valueSetDefinition")
						{ (k2 as String): (v2 filterObject ((v3, k3) -> k3 as String != "value")) }
					else { (k2 as String): v2 })) }
			else { (k as String): v }))
}
