%dw 2.0
output application/xml writeDeclaration = false
---
{
    TBL @(
        "type": "list",
        "end": "100",
        "name": "Doc",
        "query": "DocFch|DocData|TpDoc=V001:V999|Data=20260101:20261231|? \$IsGreat(%DocFch.Cta.TpDocCC,1) ^ \$IsEqual(%DocFch.Doc.TbMotDel,0)"
    ): {
        defcol: {
		    DocumentSeries      @(form: "%DocFch.Doc.Serie"): {},
		    DocumentNumber      @(form: "%DocFch.Doc.NrDoc"): {},
		    DocumentDate        @(form: "%DocFch.Data.Docum"): {},
		    ClientNumber        @(form: "%DocFch.Ter.NrTerc"): {},
		    SalesRepNumber      @(form: "%DocFch.Doc.NrVended"): {},
		    DocumentWarehouse   @(form: "%DocFch.Doc.NrArm"): {},
		    DocumentVoid        @(form: "%DocFch.Doc.MotDelDoc"): {},
		    DocumentChanged     @(form: "%DocFch.Inf.DataMod"): {},
		
		    Lan @(
		        "type": "list",
		        "name": "Lan",
		        "query": "DocLan|Document|TpDoc={%DocFch.Doc.Serie}|NrDoc={%DocFch.Doc.NrDoc}"
		    ): {
		        defcol: {
		            DocumentWarehouse     @(form: "%DocLan.Div.NrArm"): {},
		            DocumentLineNumber    @(form: "%DocLan.Doc.NrLan"): {},
		            ProductNumber         @(form: "%DocLan.Cod.Codigo"): {},
		            ProductQuantity       @(form: "%DocLan.Qtd.Real"): {},
		            ProductQtdFree        @(form: "%DocLan.Qtd.Bonus"): {},
		            ProductQtdTotal       @(form: "%DocLan.Qtd.Movim"): {},
		            ProductUnityNetValue  @(form: "%DocLan.Val.UnLiq"): {},
		            DiscountPercentage    @(form: "%DocLan.Desc.Tot"): {},
		            DiscountValue         @(form: "%DocLan.Val.TtDscReal"): {},
		            VatValue              @(form: "%DocLan.IVA.Total"): {},
		            CreditNote            @(form: "%DocLan.Div.NCredOrg"): {},
		            CreditNoteDate        @(form: "%DocLan.Div.NCredOrgDt"): {}
		        }
		    }
		}
    }
}