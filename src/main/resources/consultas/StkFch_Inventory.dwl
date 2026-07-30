%dw 2.0
output text/xml writeDeclaration = false
---
"TBL" @(
    "type": "list",
    "name": "SKU",
    "end": "100",
    "query": "StkFch|Principal|Codigo=01000:AA999999"
): {
    defcol: {
        Codigo @(form: "%StkFch.Cod.Codigo"): {},
        StockArm001 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,1)"): {},
        StockArm002 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,2)"): {},
        StockArm003 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,3)"): {},
        StockArm099 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,99)"): {},
        StockArm100 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,100)"): {},
        StockArm101 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,101)"): {},
        StockArm102 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,102)"): {},
        StockArm103 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,103)"): {},
        StockArm104 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,104)"): {},
        StockArm105 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,105)"): {},
        StockArm106 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,106)"): {},
        StockArm107 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,107)"): {},
        StockArm108 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,108)"): {},
        StockArm109 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,109)"): {},
        StockArm110 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,110)"): {},
        StockArm111 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,111)"): {},
        StockArm112 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,112)"): {},
        StockArm113 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,113)"): {},
        StockArm114 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,114)"): {},
        StockArm115 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,115)"): {},
        StockArm116 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,116)"): {},
        StockArm117 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,117)"): {},
        StockArm118 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,118)"): {},
        StockArm119 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,119)"): {},
        StockArm120 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,120)"): {},
        StockArm121 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,121)"): {},
        StockArm122 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,122)"): {},
        StockArm123 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,123)"): {},
        StockArm124 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,124)"): {},
        StockArm125 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,125)"): {},
        StockArm126 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,126)"): {},
        StockArm127 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,127)"): {},
        StockArm128 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,128)"): {},
        StockArm129 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,129)"): {},
        StockArm130 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,130)"): {},
        StockArm140 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,140)"): {},
        StockArm201 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,201)"): {},
        StockArm990 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,990)"): {},
        StockArm999 @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,999)"): {},
        StockTotal @(form: "\$SkuValue(%StkFch.Cod.Codigo,Avail,0)"): {}
    }
}