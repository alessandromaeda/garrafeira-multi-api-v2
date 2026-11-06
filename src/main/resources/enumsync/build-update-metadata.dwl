%dw 2.0
output text/plain
fun esc(s: Any): String =
	((s default "") as String) replace "&" with "&amp;" replace "<" with "&lt;" replace ">" with "&gt;"

fun el(k: String, v: Any): String =
	if (v is Object)
		"<met:$(k)>" ++ (((v pluck ((vv, kk) -> el(kk as String, vv))) joinBy "")) ++ "</met:$(k)>"
	else
		"<met:$(k)>" ++ esc(v) ++ "</met:$(k)>"

fun valueEl(tag: String, v: Object): String = el(tag, v)

var kind = vars.mapping.salesforce.kind
var fullName = vars.mapping.salesforce.fullName
var finalValues = vars.plan.finalValues
var metadata =
	if (kind == "StandardValueSet")
		"<met:metadata xsi:type=\"met:StandardValueSet\">"
			++ "<met:fullName>" ++ esc(fullName) ++ "</met:fullName>"
			++ (finalValues map ((v) -> valueEl("standardValue", v)) joinBy "")
			++ "</met:metadata>"
	else if (kind == "GlobalValueSet") do {
		var sk = vars.sfRead.skeleton
		var others = (sk filterObject ((v, k) -> k as String != "fullName")) pluck ((vv, kk) -> el(kk as String, vv)) joinBy ""
		// Na gravacao o Salesforce exige que o nome da lista global termine em __gvs.
		var gvsName = if (fullName endsWith "__gvs") fullName else (fullName ++ "__gvs")
		---
		"<met:metadata xsi:type=\"met:GlobalValueSet\"><met:fullName>" ++ esc(gvsName) ++ "</met:fullName>"
			++ (finalValues map ((v) -> valueEl("customValue", v)) joinBy "")
			++ others ++ "</met:metadata>"
	}
	else do {
		var sk = vars.sfRead.skeleton
		var defn = sk.valueSet.valueSetDefinition default {}
		var defnXml = "<met:valueSetDefinition>"
			++ ((defn pluck ((vv, kk) -> el(kk as String, vv))) joinBy "")
			++ (finalValues map ((v) -> valueEl("value", v)) joinBy "")
			++ "</met:valueSetDefinition>"
		var valueSetXml = "<met:valueSet>"
			++ (((sk.valueSet default {}) filterObject ((v, k) -> k as String != "valueSetDefinition")) pluck ((vv, kk) -> el(kk as String, vv)) joinBy "")
			++ defnXml ++ "</met:valueSet>"
		var others = (sk filterObject ((v, k) -> k as String != "valueSet" and k as String != "fullName")) pluck ((vv, kk) -> el(kk as String, vv)) joinBy ""
		---
		"<met:metadata xsi:type=\"met:CustomField\"><met:fullName>" ++ esc(fullName) ++ "</met:fullName>" ++ others ++ valueSetXml ++ "</met:metadata>"
	}
---
"<env:Envelope xmlns:env=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:met=\"http://soap.sforce.com/2006/04/metadata\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\">"
	++ "<env:Header><met:SessionHeader><met:sessionId>" ++ esc(vars.sfToken) ++ "</met:sessionId></met:SessionHeader></env:Header>"
	++ "<env:Body><met:updateMetadata>" ++ metadata ++ "</met:updateMetadata></env:Body></env:Envelope>"
