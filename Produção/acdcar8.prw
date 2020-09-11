#include "protheus.ch"
#include "apvt100.ch"
#include "topconn.ch"

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ACDCAR8   ºAutor  ³gilvan         º Data ³  05/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ AP                                                        º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/



User Function acdcar8()

_Oper:=__cUserID
Private _romaneio :=SPACE(11)
Private _vol :=SPACE(11)
Private _estrut :=SPACE(11)
Private _qtd:=0
Private _ok:=space(1)

VTKeyBoard(chr(20))

VTClear

_OPER:=alltrim(cusername)
Do while .t.
	_produto:=SPACE(15)
	
	aSave0 := VTSAVE()
	
	@ 0,0 VTSay "  PRODUTO X ENDEREÇO"
	@ 1,0 VTSay "Produto"
	@ 2,0 VtGet _produto  Pict "@!" F3 "SB1"
	aSave := VTSAVE()
	
	VTREAD
	If	VTLastKey() == 27
		VTAlert("Sair!","aviso",.t.,3000)
		exit
	EndIf
	_CODPB:=_PRODUTO
	_PNe:=.F.
	dbselectarea("SB1")
	Dbsetorder(5)// codigo de barra
	SB1->(Dbseek(xfilial("SB1")+_Produto) )
	If eof()
		dbsetorder(1)// codigo do produto
		SB1->(Dbseek(xfilial("SB1")+_Produto) )
		if !eof()
			_desc  :=SB1->B1_DESC
			_codbar:=alltrim(SB1->B1_CODBAR)
			_CODANT:=SB1->B1_XCODANT
			_PRODUTO  :=SB1->B1_COD
		ELSE
			_codbar:=_PRODuto
			_lCad  :=.t. //nao encontrado
			_pne   :=.t.
		Endif
	Else
		// encontrou pelo codigo de barra.
		_desc     :=SB1->B1_DESC
		_codbar   :=SB1->B1_CODBAR
		_PRODUTO  :=SB1->B1_COD
	Endif
	
	
	If _pne
		VTbeep(2)
		VTAlert(_PRODUTO+" Produto nao encontrado!","aviso",.t.,3000)
		VtRestore(,,,,aSave0)
		loop
	EndIf
	_sn:="S"
	@ 3,0 VTSay SUBSTR(_desc,1,19)
	@ 4,0 VTSay SUBSTR(_desc,20,39)
	@ 5,0 VTSay "Consultar?"
	@ 6,0 VtGet _SN  Pict "@!"
	VTREAD
	If	_SN<> "S"
		VtRestore(,,,,aSave0)
		LOOP
	EndIf
	
	aSave := VTSAVE()
	
	
	If	VTLastKey() == 27
		//	VTAlert("Abortado pelo Usuário.","aviso",.t.,3000)
		exit
	EndIf
	
	
	CONSEND1()
	
	//		VtRestore(,,,,aSave0)
	
	If	VTLastKey() == 27
		//	VTAlert("Abortado pelo Usuário.","aviso",.t.,3000)
		VtRestore(,,,,aSave0)
		LOOP
	EndIf
	
enddo

Return


static function CONSEND1

Local aCampos := {}

IF VAZIO(_PRODUTO)
	RETURN
ENDIF

AADD(aCampos,{"CODBAR"        ,"C",15,0})
AADD(aCampos,{"CODPRO"    ,"C",15,0})
AADD(aCampos,{"LOCALE"    ,"C",02,0})
AADD(aCampos,{"CENDER"    ,"C",15,0})
AADD(aCampos,{"DESCRIC"    ,"C",30,0})
AADD(aCampos,{"QTD"   ,"N",12,2})

cFileTRB := CriaTrab(aCampos)
DBCreate(cFileTRB,aCampos)
DBUseArea(.T.,,cFileTRB,"TRBACD5",.F.,.F.) // Exclusivo
IndRegua("TRBACD5",cFileTRB,"CENDER",,,OemToAnsi("Organizando Arquivo.."))
DBClearIndex()
DBSetIndex(cFileTRB+OrdBagExt())


cQry	:= "SELECT B1_COD,BF_QUANT,BE_LOCAL,F_GET_ENDERECO_FRMT2(BE_LOCALIZ,BE_FILIAL) BE_LOCALIZ,F_GET_END_TITULO_FRMT2(BE_LOCALIZ,BE_FILIAL) BE_DESCRIC,B1_CODBAR " 
cQry	+= "  FROM  "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBE")+" SBE, "+RetSqlName("SBF")+" SBF " 
cQry	+= " WHERE BE_FILIAL  = '"+XFILIAL('SBE')+"' "
cQry	+= "    AND BF_FILIAL = '"+XFILIAL('SBF')+"' "
cQry	+= "    AND BE_LOCAL = BF_LOCAL AND BE_LOCALIZ = BF_LOCALIZ  "
cQry	+= "    AND B1_COD  = BF_PRODUTO "
cQry	+= "    AND B1_COD  = '"+_produto+"'  "
cQry	+= "    AND SB1.D_E_L_E_T_ = ' ' "
cQry	+= "    AND SBE.D_E_L_E_T_ = ' ' "
cQry	+= "    AND SBF.D_E_L_E_T_ = ' ' "
cQry	+= " UNION "     
cQry	+= " SELECT B1_COD,0 BF_QUANT,BE_LOCAL,F_GET_ENDERECO_FRMT2(BE_LOCALIZ,BE_FILIAL) BE_LOCALIZ,F_GET_END_TITULO_FRMT2(BE_LOCALIZ,BE_FILIAL) BE_DESCRIC,B1_CODBAR " 
cQry	+= "  FROM  "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBE")+" SBE " 
cQry	+= "  WHERE BE_FILIAL = '"+XFILIAL('SBE')+"' "
cQry	+= "    AND B1_COD    = BE_CODPRO "
cQry	+= "    AND B1_COD    = '"+_produto+"'  "
cQry	+= "    AND SB1.D_E_L_E_T_ = ' ' "
cQry	+= "    AND SBE.D_E_L_E_T_ = ' ' "  
cQry	+= "    ORDER BY  BE_LOCAL DESC,BE_LOCALIZ"
    
//cQry	:= "SELECT B1_COD,BF_QUANT,BE_LOCAL,BE_LOCALIZ,BE_DESCRIC,B1_CODBAR "
//cQry	+= " FROM  "+RetSqlName("SB1")+" SB1, "+RetSqlName("SBE")+" SBE, "+RetSqlName("SBF")+" SBF "
//cQry	+= " WHERE BE_FILIAL = '"+XFILIAL('SBE')+"' "
//cQry	+= "   AND BF_FILIAL =  '"+XFILIAL('SBF')+"' "
//cQry	+= "   AND BE_LOCAL = BF_LOCAL AND BE_LOCALIZ = BF_LOCALIZ  "
//cQry	+= "   AND B1_COD  = BF_PRODUTO "
//cQry	+= "   AND B1_COD  = '"+_produto+"'  "
//cQry	+= "   AND SB1.D_E_L_E_T_ <> '*' "
//cQry	+= "   AND SBE.D_E_L_E_T_ <> '*' "
//cQry	+= "   AND SBF.D_E_L_E_T_ <> '*' "

/*If Select("TRBCAR8") > 0
	dbSelectArea("TRBCAR8")
	dbCloseArea()
EndIf
TCQUERY cQry NEW ALIAS "TRBCAR8"
*/

	cTRB_2 := GetNextAlias()
	if Select('cTRB_2') <> 0
		DbSelectArea('cTRB_2')
		(cTRB_2)->(DbCloseArea())
	endIf   
	
	//Executando consulta e setando o total da régua 
	TCQuery cQry New Alias cTRB_2 
	//Enquanto houver dados
	cTRB_2->(DbGoTop())	

dbgotop()

DO WHILE !EOF()
	DBSELECTAREA("TRBACD5")
	RECLOCK("TRBACD5",.T.)
	REPLACE CODBAR WITH cTRB_2->B1_CODBAR
	REPLACE CODPRO WITH cTRB_2->B1_COD
	REPLACE LOCALE WITH cTRB_2->BE_LOCAL
	REPLACE CENDER  WITH cTRB_2->BE_LOCALIZ
	REPLACE DESCRIC   WITH cTRB_2->BE_DESCRIC
	REPLACE QTD    WITH cTRB_2->BF_QUANT
	msunlock()
	DBSELECTAREA("cTRB_2")
	DBSKIP()
ENDDO

aFields := {"LOCALE","CENDER","DESCRIC","QTD"}
aHeader := {"LOCAL","ENDERECO","DESCRICAO","QTD"}
aSize   := {02,15,30,15}
ctop:=""
cBottom:=""

aSave := VTSAVE()
VTClear()
_AREA:=GETAREA()


DBSELECTAREA("TRBACD5")

nRecno := VTDBBrowse(1,0,VTMaxRow(),VTMaxCol(),"TRBACD5",aHeader,aFields,aSize,,cTop,cBottom)

//vtsetkey(09,bkey09)

DBSELECTAREA("cTRB_2")
dbCloseArea()

dbSelectArea("TRBACD5")
dbCloseArea()

RESTAREA(_AREA)

VtRestore(,,,,aSave)

RETURN



