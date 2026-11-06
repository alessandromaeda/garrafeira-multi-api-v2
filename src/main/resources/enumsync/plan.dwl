%dw 2.0
output application/java
var testValues = [
	{ code: "9901", name: "TESTE MULE 1" },
	{ code: "9902", name: "TESTE MULE 2" }
]
var revertCodes = vars.revertCodes default (testValues map ((t) -> t.code))
var current = vars.sfRead.values
var currentCodes = current map ((v) -> trim(v.fullName default ""))
var desired = (vars.desired default []) ++ (if (vars.injectTest) testValues else [])
var missing = desired filter ((d) -> !(currentCodes contains d.code)) distinctBy ((d) -> d.code)
var toAdd = missing filter ((d, i) -> i < vars.maxNew)
var pending = missing filter ((d, i) -> i >= vars.maxNew)
var isRevert = vars.action == "revert"
var isReplace = vars.action == "replace"
var keepCodes = vars.keepCodes default []
var toRemove = if (isRevert) (current filter ((v) -> revertCodes contains trim(v.fullName default ""))) else []
var kept = current filter ((v) -> !(toRemove contains v))
var labelFormat = vars.mapping.salesforce.labelFormat default "{name}"
fun labelOf(d: Object): String = labelFormat replace "{code}" with d.code replace "{name}" with (d.name default "")
var added = (if (isRevert) [] else toAdd) map ((d) -> { fullName: d.code, "default": "false", label: labelOf(d) })
var desiredCodes = desired map ((d) -> d.code)
var inactiveDesired = current filter ((v) -> v.isActive == "false" and (desiredCodes contains trim(v.fullName default ""))) map ((v) -> v.fullName)
// --- modo replace: a lista final passa a ser a do ArtSoft (+ codigos mantidos por keepCodes)
var desiredList = (vars.desired default []) distinctBy ((d) -> d.code)
var desiredListCodes = desiredList map ((d) -> d.code)
fun codeOf(v: Object): String = trim((v.fullName default "") as String)
fun currentOf(c: String) = (current filter ((v) -> codeOf(v) == c))[0]
var rpNew = desiredList filter ((d) -> !(currentCodes contains d.code))
var rpRelabel = desiredList filter ((d) -> (currentCodes contains d.code) and trim((currentOf(d.code).label default "") as String) != labelOf(d))
var rpKeep = current filter ((v) -> (keepCodes contains codeOf(v)) and !(desiredListCodes contains codeOf(v)))
var rpRemove = current filter ((v) -> !(desiredListCodes contains codeOf(v)) and !(keepCodes contains codeOf(v)))
var rpFinal = (desiredList map ((d) -> do {
	var ex = currentOf(d.code)
	---
	if (ex != null and trim((ex.label default "") as String) == labelOf(d)) ex else { fullName: d.code, "default": "false", label: labelOf(d) }
})) ++ rpKeep
---
if (isReplace) {
	toAdd: rpNew map ((d) -> d.code),
	toRelabel: rpRelabel map ((d) -> d.code),
	pending: [],
	toRemove: rpRemove map ((v) -> codeOf(v)),
	kept: rpKeep map ((v) -> codeOf(v)),
	inactiveInSalesforce: [],
	changes: sizeOf(rpNew) + sizeOf(rpRelabel) + sizeOf(rpRemove),
	finalValues: rpFinal,
	finalCodes: rpFinal map ((v) -> v.fullName)
} else {
	toRelabel: [],
	kept: [],
	toAdd: if (isRevert) [] else (toAdd map ((d) -> d.code)),
	pending: if (isRevert) [] else (pending map ((d) -> d.code)),
	toRemove: toRemove map ((v) -> v.fullName),
	inactiveInSalesforce: inactiveDesired,
	changes: sizeOf(added) + sizeOf(toRemove),
	finalValues: kept ++ added,
	finalCodes: (kept ++ added) map ((v) -> v.fullName)
}
