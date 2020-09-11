#include "protheus.ch"
#include "apvt100.ch"
#include "topconn.ch"
 
/*/{Protheus.doc} zacdca14
Rotina de Coleta de Inventario - Sob Medida Deposito
@author Chico
@since 18/01/2017
@version 1.0
@return ${return}, ${return_description}
@example
(examples)
@see (links_or_references)
/*/
User Function zacdca14()
_cPictqtde := PesqPict("SB2","B2_QATU")
_Oper:=__cUserID
public odesc,onqe,oprod
public odlg1
dbselectarea("SB1")
dbsetorder(1)

VTKeyBoard(chr(20))

//aSave := VTSAVE()
VTClear
//09 ctrl+i
//24 ctrl+x
//16 ctrl+p

bkey09 := VTSetKey(09,{|| cinvcar1()},"Informacoes")

VTAlert("Usuario: "+alltrim(cusername),"aviso",.t.,2000)
 
Do while .t.
	_Prod := Space(15)
	_Desc := Space(60)
	_Cod  := Space(15)
	_QtdUlt := 0
	_nQE  := 0
	_lCad := .f.
	_nb   := 0         
	_pne  := .f. // PRODUTO NAO ENCONTRADO
	
	_cLocal   :=Space(2)
	_cLocaliz :=Space(15)
  
     
    *'************************************'*
	*'************ PASSO 1 ***************'*
	*' RECOLHE INFORMACOES DA LOCALIZAÇÃO '*	
	*'************************************'* 
	VTCLEAR() 
	DLVTCabec("Invent. [SobMedida]",.F.,.F.,.T.)	
	@ 01,00 VTSay "Local (Armazem)"
	@ 02,00 VtGet _cLocal  Pict "@!"	 
	@ 03,00 VTSay "Endereco "
	@ 04,00 VtGet _cLocaliz  Pict "@!" F3 "SBE"
	aSave := VTSAVE()
	VTRead  
	if CheckEsc() 
	  Exit
	endif  	
	
	if alltrim(_cLocaliz) = '00LOJA' 
	  VTbeep(2)
	  VTAlert(_cLocaliz+" 00LOJA não pode ser utilizado via SOBMEDIDA!","Erro",.t.,3000)
	  VtRestore(,,,,aSave)
	  loop
	endif  
	
	dbselectarea("SBE")
	SBE->(Dbsetorder(1))// LOCAL+LOCALIZ	
	conout("Dbseek(xfilial(SBE)+_cLocal+_cLocaliz "+xfilial("SBE")+_cLocal+PADR(_cLocaliz,15," ") )
	IF !SBE->(Dbseek(xfilial("SBE")+_cLocal+PADR(_cLocaliz,15," ")))	  
	  VTbeep(2)
	  VTAlert(_cLocaliz+" Endereco nao encontrado!","aviso",.t.,3000)
	  VtRestore(,,,,aSave)
	  loop
	endif 
	 
	
     
     
	*'************************************'*
	*'************ PASSO 2 ***************'*
	*' RECOLHE INFORMACOES DA LOCALIZAÇÃO '*	
	*'************************************'*
	VTCLEAR() 
	DLVTCabec("Invent.[SobMedida]",.F.,.F.,.T.)	
	@ 01,00 VTSay "Local (Armazem) "+_cLocal	 
	@ 02,00 VTSay "Endereco "+_cLocaliz
	@ 03,00 VTSay Replicate("-",VTMaxCol())	
	@ 04,00 VTSay "Produto"
	@ 05,00 VtGet _prod  Pict "@!" F3 "SB1"	 
	aSave := VTSAVE()
	VTREAD
	
	
	
	 
	
	dbselectarea("SB1")
	Dbsetorder(5)// codigo de barra	
	IF !SB1->(Dbseek(xfilial("SB1")+PADR(_Prod,15," ") ))
	  dbCloseArea()
	  dbselectarea("SB1")
	  Dbsetorder(1)// codigo interno
	  ConOut("Buscando pelo interno '"+_Prod+"'  LEN "+str(LEN(_Prod)))	   
	  IF !SB1->(Dbseek(xfilial("SB1")+PADR(_Prod,15," ") ))
	    VTbeep(2)
	    VTAlert(_prod+" Produto nao encontrado!","aviso",.t.,3000)
	    VtRestore(,,,,aSave)
	    loop   	  
	  endif
	endif
	
	_desc   := SB1->B1_DESC
	_codbar := alltrim(SB1->B1_CODBAR)
	_CODANT := SB1->B1_XCODANT
	_cod    := SB1->B1_COD
	checkinv()// --> checa se houve bipe do mesmo produto para o mesmo endereco
		
	@ 06,00 VtSay "Ult.Coleta "+cValToChar(_QtdUlt)
	@ 07,00 VtGet _nQE pict "@e 99999.99" valid _nQE > 0
	VTREAD
	
	
	
	*'************************************'*
	*'************ PASSO 3 ***************'*
	*' CONFIRMA A OPERACAO '*	
	*'************************************'* 
	VTCLEAR() 
	
	/*IF !VTYesNo(_cLocal+"-"+_cLocaliz+ "Qtd."+cValToChar(_nQE)+CRLF+Replicate("-",VTMaxCol())+;
				AllTrim(_codbar)+" - "+Alltrim(_desc)+;
				Replicate("-",VTMaxCol()),"CONFIRMAR COLETA ?",.T.)*/
        
    if DLVTAviso(' CONFIRMAR COLETA ?',_cLocal+"-"+_cLocaliz+ "Qtd."+cValToChar(_nQE)+CRLF+Replicate("-",VTMaxCol())+;
				AllTrim(_codbar)+" - "+Alltrim(_desc)+CRLF+;
				Replicate("-",VTMaxCol()), {"Sim","Nao"}) ==2  
        VTRestore(,,,,aSave)
	    loop
	endif	
	   
	 
	if CheckEsc() 
	  Exit
	endif  	
	  
	 
	Reclock("ZZ9",.T.) 
    ConOut(' ZZ9 -> passou  ')	 
	Replace ZZ9_FILIAL With Xfilial("ZZ9")
	Replace ZZ9_COD    With _cod
	Replace ZZ9_CODBAR With _Codbar
	Replace ZZ9_DESC   With _Desc
	Replace ZZ9_QTD1   With  _nQE
	Replace ZZ9_OPER1  With _oper
	Replace ZZ9_OPER2  With SUBSTR(alltrim(cusername),1,6)
	Replace ZZ9_ENDER  With _cLocaliz
	REPLACE ZZ9_FLAG   WITH "-1"
	ConOut(' ZZ9 -> passou3 ')	
	Msunlock()
	VTbeep(3)
	VTAlert("Batida confirmada","aviso",.t.,3000)
	 
	_nQE := 0
	_NB  := 0	
	
	VtRestore(,,,,aSave)
	ConOut(' ZZ9 -> passou4  ')	
enddo
Return


static function cinvcar1
Local aFields := {"ZZ9_COD","ZZ9_DESC","ZZ9_QTD1","ZZ9_QTD2"}
Local aHeader := {"CODIGO","DESCRICAO","QTD1","QTD2"}
Local aSize   := {10,30,10,10}
ctop    := "xfilial('ZZ9')+ZZ9->ZZ9_COD"
cBottom := "xfilial('ZZ9')+ZZ9->ZZ9_COD"

 aSave := VTSAVE()
VTClear()
_AREA:=GETAREA()
DBSELECTAREA("ZZ9")
SET FILTER TO ZZ9_OPER1 = _OPER .OR. ZZ9_OPER2 = _OPER .OR. ZZ9_OPER3 = _OPER
nRecno := VTDBBrowse(1,0,VTMaxRow(),VTMaxCol(),"ZZ9",aHeader,aFields,aSize,,cTop,cBottom)
vtsetkey(09,bkey09)
DBSELECTAREA("ZZ9")
SET FILTER TO
RESTAREA(_AREA)

VtRestore(,,,,aSave)
RETURN

//***********************************************//
//****** Checa Solicitação de saida (ESC) *******//
//***********************************************//
Static Function CheckEsc 
  If	VTLastKey() == 27
	VTAlert("Inventario finalizado.","aviso",.t.,3000)
	Return .T.
  EndIf   
Return.F.


Static Function CriaBF(cQuant)

begin Transaction
  cQry	:= "	update SBF010  "
  cQry	+= "       set d_E_L_E_T_ = '*'  "
  cQry	+= "     where bf_local   = '01' "
  cQry	+= "       and bf_localiz = '00LOJA' "
  cQry	+= "       and BF_FILIAL  = '"+xfilial("SBF")+"'"
  cQry	+= "       and BF_PRODUTO = '"+SBF->BF_PRODUTO+"'"
  ConOut("entrou para aplicar update") 
  
  
  if (TCSQLExec(cQry) < 0)
  	cErrUpd := TCSQLError()
	VTAlert("Erro delete bf","aviso",.t.,3000)
	ConOut("ERRO PARA ATUALIZAR A TABELA - iteent_rom_separacao@DBL_carajas")
	TCSQLExec("ROLLBACK")
	VtRestore(,,,,aSave1)
	Return		
  End
  
  
  cQry	:= "	insert into SBF010  "
  cQry	+= "       set d_E_L_E_T_ = '*'  "
  cQry	+= "     where bf_local   = '01' "
  cQry	+= "       and bf_localiz = '00LOJA' "
  cQry	+= "       and BF_FILIAL  = '"+xfilial("SBF")+"'"
  cQry	+= "       and BF_PRODUTO = '"+SBF->BF_PRODUTO+"'"
  ConOut("entrou para aplicar update") 
  
  
  if (TCSQLExec(cQry) < 0)
  	cErrUpd := TCSQLError()
	VTAlert("Erro delete bf","aviso",.t.,3000)
	ConOut("ERRO PARA ATUALIZAR A TABELA - iteent_rom_separacao@DBL_carajas")
	TCSQLExec("ROLLBACK")
	VtRestore(,,,,aSave1)
	Return		
  End
   
  TCSQLExec("COMMIT")
End Transaction	
Return nil
 
*'  Valida se o ja existe inventario  '*
////////////////////////////////////////////////////////////////////
static function checkinv()
////////////////////////////////////////////////////////////////////
	aSave2  := VTSAVE()
	VTClear
	cQry	:= "SELECT NVL(ZZ9_QTD1,0) ZZ9_QTD1,R_E_C_N_O_ "
	cQry	+= "  FROM "+RetSqlName("ZZ9")+" ZZ9"
	cQry	+= " WHERE SUBSTR(ZZ9_DT,1,10)  = TO_CHAR(SYSDATE,'DD/MM/YYYY')"
	cQry	+= "   AND ZZ9_COD   = '"+ALLTRIM(_cod)+"'"
	cQry	+= "   AND trim(ZZ9_ENDER) = '"+ALLTRIM(_cLocaliz)+"'"
	cQry	+= "   AND trim(ZZ9_FLAG)       = '-1'"
	cQry	+= "  ORDER BY R_E_C_N_O_ DESC" 
	
	
	cQry := ChangeQuery(cQry)
	 
	If Select("TRBCAR3") > 0
	  dbSelectArea("TRBCAR3")
	  dbCloseArea()
    EndIf
	TCQUERY cQry NEW ALIAS "TRBCAR3"
	  
	IF !TRBCAR3->(EOF())
	  _QtdUlt := TRBCAR3->ZZ9_QTD1
	  VTAlert("Ultima contagem foi de "+cvaltochar(TRBCAR3->ZZ9_QTD1),"Produto já coletado",.t.,5000,3)   
	  	  
	end
	VtRestore(,,,,aSave2)
	
Return (.T.)
