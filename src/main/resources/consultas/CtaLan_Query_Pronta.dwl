%dw 2.0
output text/xml encoding="Windows-1252"
---
{
    "terminal" @(
        "type": "list",
        "end": "100",
        "name": "docum",
        "query": "CtaLan|TipoDoc|TpDoc=A1:B999|NrDoc=1:999999999"
    ): {
        "defcol": {
            "entry" @(
                "type": "table"
            ): {
                "defcol": {
                    "Cta.Conta" @(form: "%CtaLan.Cta.Conta"): {},
                    "Doc.TipoID" @(form: "%CtaLan.Doc.TipoID"): {},
                    "descricao" @(form: "%CtaLan.Doc.Desc"): {},
                    "C_C.TpDocOrg" @(form: "%CtaLan.C_C.TpDocOrg"): {},
                    "Doc.Numero" @(form: "%CtaLan.Doc.Numero"): {},
                    "Data.Lanc" @(form: "%CtaLan.Data.Lanc"): {},
                    "Data.Venc" @(form: "%CtaLan.Data.Venc"): {},
                    "Val.Valor" @(form: "%CtaLan.Val.Valor"): {},
                    "C_C.NrVend" @(form: "%CtaLan.C_C.NrVend"): {},
                    "Lan.Obs" @(form: "%CtaLan.Lan.Obs", supressEmpty: "s"): {}
                }
            },
            "onAcc" @(
                "type": "list",
                "name": "docRef",
                "supressEmpty": "s",
                "query": "CtaDoc|DocOrg|TpDoc={%CtaLan.Doc.TipoID}|NrDoc={%CtaLan.Doc.Numero}"
            ): {
                "defcol": {},
                "defAttr": {
                    "docID" @(form: "%CtaDoc.DocRegID/%CtaDoc.NrDocReg", "type": "text"): {},
                    "remitt" @(form: "%CtaDoc.ValorReg"): {}
                }
            }
        },
        "defAttr": {
            "docID" @(form: "%CtaLan.Doc.TipoID/%CtaLan.Doc.Numero"): {},
            "cpart" @(form: "%CtaLan.Lan.Contrap"): {},
            "retID" @(form: "s"): {},
            "status" @(form: "s"): {},
            "trans" @(form: "s"): {}
        }
    }
}
