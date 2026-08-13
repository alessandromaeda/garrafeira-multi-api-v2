%dw 2.0
output application/xml writeDeclaration = false
---
{
    "TBL" @(
        "type": "list",
        "name": "SKU",
        "end": "10",
        "query": "StkFch|Principal|Codigo=AA50005:AA50005"
    ): {
        defcol: {
            ProductCode @(form: "%StkFch.Cod.Codigo"): {},
            ProductName @(form: "%StkFch.Nome.0"): {}
        }
    }
}