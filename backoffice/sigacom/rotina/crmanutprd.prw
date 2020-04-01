#Include "Protheus.Ch"
#Include "Totvs.Ch"
#include 'TopConn.ch'

/*/{Protheus.doc} CRMANUTPRD
Descrição: Função de manutenção no cadastro de Produto.
@author Carajas
@since 28/09/2017
@version undefined
@type function
/*/
User Function CRMANUTPRD()

	Local cDescFil	:= Space(41)
	Local nTamFil	:= TamSx3("B1_FILIAL")[1]
	Local nTamFor	:= TamSx3("A2_COD")[1]
	Local nTamLoj	:= TamSx3("A2_LOJA")[1]
	Local nTamPro	:= TamSx3("B1_COD")[1]
	Local nTamLin	:= TamSx3("AY0_CODIGO")[1]
	Local nTamDep	:= TamSx3("AY0_CODIGO")[1]
	Local oGroup	:= Nil
	Local oChk1		:= Nil
	Local oChk2		:= Nil
	Local oChk3		:= Nil
	Local oChk4		:= Nil
	Local oChk5		:= Nil
	Local oChk6		:= Nil
	Local oChk7		:= Nil
	Local oChk8		:= Nil
	Local oChk9		:= Nil
	Local oChk10	:= Nil
	Local oChk11	:= Nil
	Local oChk12	:= Nil
	Local oChk13	:= Nil
	Local oChk14	:= Nil
	Local oChk15	:= Nil
	Local oFil		:= Nil
	Local oProd		:= Nil
	Local oLjSA2	:= Nil
	Local oDep		:= Nil
	Local oDescLin	:= Nil
	Local oDlg		:= Nil
	Local cUserLib := GetMv('CA_CADMANU')
	
	Private cFilSBZ		:= Space(nTamFil)
	Private cForSA2		:= Space(nTamFor)
	Private cLojSA2		:= Space(nTamLoj)
	Private cDescFor	:= Space(TamSx3("A2_NOME")[1])
	Private cDeptB1		:= Space(nTamDep)
	Private cProdSB1	:= Space(nTamPro)
	Private cLinhZA		:= Space(nTamLin)
	Private cDescDep	:= Space(TamSx3("AY1_DESCSU")[1])
	Private cDescPro	:= Space(TamSx3("B1_DESC")[1])
	Private cDescLin	:= Space(TamSx3("AY1_DESCSU")[1])
	Private cTotProd	:= ''
	Private lCheck1		:= .F.
	Private lCheck2		:= .F.
	Private lCheck3		:= .F.
	Private lCheck4		:= .F.
	Private lCheck5		:= .F.
	Private lCheck6		:= .F.
	Private lCheck7		:= .F.
	Private lCheck8		:= .F.
	Private lCheck9		:= .F.
	Private lCheck10	:= .F.
	Private lCheck11	:= .F.
	Private lCheck12	:= .F.
	Private lCheck13	:= .F.	
	Private lCheck14	:= .F.
	Private lCheck15	:= .F.	
	Private aProdAlt	:= {}
	Private oTotal		:= Nil
	Private oDesc		:= Nil
	Private oList		:= Nil
	

	if ( At( RetCodUsr(),cUserLib) != 0)
		AAdd(aProdAlt,{Space(TamSx3("B1_COD")[1]),Space(TamSx3("B1_DESC")[1]),Space(TamSx3("B1_UM")[1]),Space(15),Space(15)})
	
		DEFINE FONT oBold2   NAME "Arial" SIZE 0, -12 BOLD
		DEFINE MSDIALOG oDlg FROM 000,000 TO 555,820 TITLE "Manutenção de Produtos" PIXEL
	
		@008,010 SAY "Filial " SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@016,010 MSGET cFilSBZ   SIZE 030,010 OF oDlg PIXEL F3 'SM0' Valid(Iif(!Empty(cFilSBZ),cDescFil := FWFilialName(,cFilSBZ,1),Space(nTamFil)),oFil:Refresh())
		@016,042 GET oFil Var cDescFil  SIZE 100,010 OF oDlg PIXEL WHEN .F.
	
		@008,146 SAY "Produto " SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@016,146 MSGET cProdSB1	SIZE 065,010 OF oDlg PIXEL F3 'SB1' Valid(fPesqReg(cProdSB1,"SB1",'cProdSB1')) // ,oProd:Refresh())
		@016,212 GET oProd Var cDescPro	SIZE 193,010 OF oDlg PIXEL WHEN .F.
	
		@030,010 SAY "Fornecedor " SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@038,010 MSGET cForSA2	   SIZE 037,010 OF oDlg PIXEL F3 'SA2' Valid(Iif(!Empty(cForSA2),cLojSA2 := SA2->A2_LOJA,Space(nTamFor)),oLjSA2:Refresh())
		@038,069 GET oDesc Var cDescFor	   SIZE 336,010 OF oDlg PIXEL WHEN .F.
	
		@030,048 SAY "Loja"	 SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@038,048 GET oLjSA2 Var cLojSA2 SIZE 020,010 OF oDlg PIXEL Valid(Iif(!Empty(cForSA2),VldFor(),Space(nTamLoj)))
	
		@052,010 SAY "Departamento" SIZE 045,013 OF oDlg PIXEL FONT oBold2
		@060,010 MSGET cDeptB1		SIZE 050,010 OF oDlg PIXEL F3 'AY02' Valid(fPesqReg(cDeptB1,"AY0",'cDeptB1'))  //,oDep:Refresh())
		@060,062 GET oDep Var cDescDep	SIZE 145,010 OF oDlg PIXEL WHEN .F.
	
		@052,210 SAY "Linha"	SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@060,210 MSGET cLinhZA	SIZE 040,010 OF oDlg PIXEL F3 'AY05' Valid(fPesqReg(cLinhZA,"AY0",'cLinhZA'))   // ,oDescLin:Refresh())
		@060,252 GET oDescLin Var cDescLin	SIZE 153,010 OF oDlg PIXEL WHEN .F.
	
		@076,361 BUTTON "Pesquisar" SIZE 043,015 PIXEL OF oDlg ACTION (MsgRun("Pesquisando... Aguarde...","Caraj�s",{|| PesqProd(oList) }))
		@093,361 BUTTON "Importar" SIZE 043,015 PIXEL OF oDlg ACTION (MsgRun("Importando Produtos... Aguarde...","Caraj�s",{|| U_CRIMPPROD(cForSA2,cLojSA2,cDeptB1,cLinhZA,cFilSBZ,cProdSB1) }))
	
		oGroup := TGroup():New(075,010,105,355,"Status",oDlg,,,.T.)
		oChk1  := TCheckBox():New(085,015,'Ativo'     	 ,	{|| lCheck1 } ,oDlg,100,210,,{|| lCheck1 := !lCheck1,oChk1:Refresh()   },,,,,,.T.,,,)
		oChk2  := TCheckBox():New(095,015,'Inativo'   	 ,	{|| lCheck2 } ,oDlg,100,210,,{|| lCheck2 := !lCheck2,oChk2:Refresh()   },,,,,,.T.,,,)
	
		oChk3  := TCheckBox():New(085,050,'Temporário'   ,	{|| lCheck3 } ,oDlg,100,210,,{|| lCheck3 := !lCheck3,oChk3:Refresh()   },,,,,,.T.,,,)
		oChk4  := TCheckBox():New(095,050,'Serviço'      ,	{|| lCheck4 } ,oDlg,100,210,,{|| lCheck4 := !lCheck4,oChk4:Refresh()   },,,,,,.T.,,,)
	
		oChk5  := TCheckBox():New(085,95,'Encomenda'    ,	{|| lCheck5 } ,oDlg,100,210,,{|| lCheck5 := !lCheck5,oChk5:Refresh()   },,,,,,.T.,,,)
		oChk6  := TCheckBox():New(095,95,'Uso e Consumo',	{|| lCheck6 } ,oDlg,100,210,,{|| lCheck6 := !lCheck6,oChk6:Refresh()   },,,,,,.T.,,,)
	
		oChk7  := TCheckBox():New(085,150,'Insumo'       ,	{|| lCheck7 } ,oDlg,100,210,,{|| lCheck7 := !lCheck7,oChk7:Refresh()   },,,,,,.T.,,,)
		oChk8  := TCheckBox():New(095,150,'Bloqueado'    ,	{|| lCheck8 } ,oDlg,100,210,,{|| lCheck8 := !lCheck8,oChk8:Refresh()   },,,,,,.T.,,,)
	
		oChk9  := TCheckBox():New(085,190,'Recente'      ,	{|| lCheck9 } ,oDlg,100,210,,{|| lCheck9 := !lCheck9,oChk9:Refresh()   },,,,,,.T.,,,)
		oChk10 := TCheckBox():New(095,190,'Local'        ,	{|| lCheck10} ,oDlg,100,210,,{|| lCheck10:= !lCheck10,oChk10:Refresh() },,,,,,.T.,,,)
		
		oChk11 := TCheckBox():New(085,235,'Sazonal'      ,	{|| lCheck11} ,oDlg,100,210,,{|| lCheck11:= !lCheck11,oChk11:Refresh() },,,,,,.T.,,,)
		oChk12 := TCheckBox():New(095,235,'Oportunidade' ,	{|| lCheck12} ,oDlg,100,210,,{|| lCheck12:= !lCheck12,oChk12:Refresh() },,,,,,.T.,,,)

		oChk13 := TCheckBox():New(085,280,'Fora de Linha',	{|| lCheck13} ,oDlg,100,210,,{|| lCheck13:= !lCheck13,oChk13:Refresh() },,,,,,.T.,,,)
		oChk14 := TCheckBox():New(095,280,'Excluído'     ,	{|| lCheck14} ,oDlg,100,210,,{|| lCheck14:= !lCheck14,oChk14:Refresh() },,,,,,.T.,,,)

		oChk15 := TCheckBox():New(085,330,'Nulo',			{|| lCheck15} ,oDlg,100,210,,{|| lCheck15:= !lCheck15,oChk15:Refresh()},,,,,,.T.,,,)
	
		oList := TWBrowse():New(111,010,394,144,,{'Código','Descrição','Unidade','Status','Novo Status'},,oDlg,,,,,,,,,,,,,,.T.,,,,,)
	
		oList:SetArray(aProdAlt)
	
		oList:bLine := { ||{aProdAlt[oList:nAT,1],;
							aProdAlt[oList:nAT,2],;
							aProdAlt[oList:nAT,3],;
							aProdAlt[oList:nAT,4],;
							aProdAlt[oList:nAT,5]} }
	
		oList:bRClicked	:= {|| Iif(oList:ColPos == 5,U_StatNew(oList,aProdAlt,oList:nAT),Nil)}					  
	
		@263,010 SAY "Total de Itens: "	SIZE 040,013 OF oDlg PIXEL FONT oBold2
		@263,053 SAY oTotal Var cTotProd SIZE 040,013 OF oDlg PIXEL FONT oBold2 COLOR CLR_RED			  
	
		@259,139 BUTTON "Relatório dos Produtos do GRID" SIZE 090,015 PIXEL OF oDlg ACTION (U_RelGRID(oList))
		@259,232 BUTTON "Confirmar"	SIZE 043,015 PIXEL OF oDlg ACTION (MsgRun("Aplicando os Novos Status... Aguarde...","Caraj�s",{|| ConfStat() }),oDlg:End())
		@259,278 BUTTON "Aplicar Novo Status a Todos" SIZE 080,015 PIXEL OF oDlg ACTION (AplicAll(oList))
		@259,361 BUTTON "Cancelar"	SIZE 043,015 PIXEL OF oDlg ACTION (oDlg:End())
	
		ACTIVATE MSDIALOG oDlg CENTERED
	else
		Alert("Usuário não autorizado!")
	endif
Return

/*/{Protheus.doc} ConfStat
Descrição: Função de gravação dos novos status na SBZ.
@author Carajas
@since 28/09/2017
@version undefined
@type function
/*/
Static Function ConfStat()
	Local B 		:= 0
	Local C 		:= 0
	Local aNwStatus	:= {}
    Local lRet:=.f.
       
    if !MsgYesNo("Confirma alteração no cadastro conforme seleção do(s) status?")
       Return 
    else
       for C := 1 To Len(aProdAlt)
		   //Caso uns dos itens n�o tenha sido alterado o status, mantem o anterior.
		   if !Empty(aProdAlt[C,5])
		      lRet:=.t.
		   endIf
       next
       if !lRet
	      Aviso("Carajás","Não foi selecionado nenhum registros para ser alterado!",{"Ok"})
	      Return
       endif
    endif

	DbSelectArea("SBZ")
	
	For B := 1 To Len(aProdAlt)      
	
		//Caso uns dos itens n�o tenha sido alterado o status, mantem o anterior.
		If Empty(aProdAlt[B,5])
		   Loop
		EndIf

		//Transforma o Status novo para a letra correspondente de grava��o no banco.
		aNwStatus := U_GetStatus(2,aProdAlt[B,5])
		
		//Atualiza o Status na SBZ.
		SBZ->(DbGoTo(aProdAlt[B,6]))
		RecLock("SBZ",.F.)
		SBZ->BZ_XSTATUS := aNwStatus[2]
		SBZ->(MsUnLock())
		
		//Altera Status no IMR
		//Novo status, c�digo antigo
		//U_zStIMR(aNwStatus[2], aProdAlt[B,1])

	Next 

	Aviso("Carajás","Status aplicados com sucesso!",{"Ok"})
Return


/*/{Protheus.doc} zStIMR
Descrição: Função de alteração do Status Totvs para Status IMR.
@author Wylianne Costa
@since 11/09/2018
@version undefined
@param cStatusTotvs, characters, descricao
@param cCodFilial, characters, descricao
@param cCodProd, characters, descricao
@type function0101
/*/
User Function zStIMR(cStatusTotvs, cCodProd)

	Local cStatusIMR := ""
	Local cCodFilial := M->cFilSBZ
	Local codAntProd := U_zCodAn(cCodProd)
	Local nArrayBanco := 0
			
	
	aDadosBanco :={;
						{"0101",	"PRODUTO@DBL_CARAJAS_MCZ",         "Matriz"},;
						{"0104",	"PRODUTO@DBL_10_JOAOPESSOA",       "Joao Pessoa"},;
						{"0103",	"PRODUTO@DBL_07_ARAPIRACA",        "Arapiraca"};
					}
			
			
	DO CASE
		CASE cCodFilial = "0101"
			nArrayBanco := 1
		CASE cCodFilial = "0104" 
			nArrayBanco := 2
		CASE cCodFilial = "0103"
			nArrayBanco := 3
	ENDCASE
		
	DO CASE
		CASE cStatusTotvs = "A"
			cStatusIMR := "A"
		CASE cStatusTotvs = "N"
			cStatusIMR := "I"
		CASE cStatusTotvs = "T"
			cStatusIMR := "A"
		CASE cStatusTotvs = "S"
			cStatusIMR := "I"
		CASE cStatusTotvs = "E"
			cStatusIMR := "I"
		CASE cStatusTotvs = "C"
			cStatusIMR := "X"
		CASE cStatusTotvs = "I"
			cStatusIMR := "X"
		CASE cStatusTotvs = "B"
			cStatusIMR := "B"
	ENDCASE
		
	if (nArrayBanco != 0)
		cQuery := "UPDATE "+ aDadosBanco[nArrayBanco][2] +" SET STATUS = '"+cStatusIMR+"' WHERE CODIGO = "+codAntProd
		If (TCSQLExec(cQuery) < 0)
			cErrUpd := TCSQLError()
			TCSQLExec("ROLLBACK")
			//AAdd(aLog, "Problema na atualização do Status da Loja "+ aDadosBanco[nArrayBanco][3] +". DbLink: "+ aDadosBanco[nArrayBanco][2] )
		Else
			TCSQLExec("COMMIT")
			//AAdd(aLog, "Atualização do Status da Loja "+ aDadosBanco[nArrayBanco][3] +" com Sucesso.")
		EndIf	
	endif
Return

/*/{Protheus.doc} zCodAn
Descrição: Função de alteração do Status Totvs para Status IMR.
@author Wylianne Costa
@since 11/09/2018
@version undefined
@param cCodTotvs, characters, descricao
/*/
User function zCodAn(cCodTotvs)
	Local aArea := GetArea()
	Local cCodAntigo := ""
	Local cQuery := ""
		
	cQuery := " SELECT B1_XCODANT AS COD_ANTIGO "
	cQuery += " FROM " + RetSqlName("SB1")
	cQuery += " WHERE B1_COD = '"+ cCodTotvs +"' AND D_E_L_E_T_ =' '"
	
	//Execuando a consulta acima
	TCQuery cQuery New Alias "TMP"

	cCodAntigo := TMP->COD_ANTIGO

	TMP->(DbCloseArea())
	RestArea(aArea)
	
Return cCodAntigo	

/*/{Protheus.doc} VldFor
Descrição: Função de validação do fornecedor.
@author Carjas
@since 28/09/2017
@version undefined
@type function
/*/
Static Function VldFor()
	Local lRet := .T.

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1)) //A2_FILIAL+A2_COD+A2_LOJA

	If SA2->(DbSeek(xFilial("SA2")+cForSA2+cLojSA2))
		cDescFor	:= AllTrim(SA2->A2_NOME)
	Else
		MsgAlert("Fornecedor não cadastrado","Carajás - [VldFor]")
		lRet := .F.
	EndIf

	oDesc:Refresh()
Return(lRet)

/*/{Protheus.doc} StatNew
Descrição: Objeto de seleção do novo Status. Disparado ao clicar com o botão direito na coluna 5.
@author Carajas
@since 28/09/2017
@version undefined
@param oObjt, object, descricao
@param aPos, array, descricao
@param nPos, numeric, descricao
@type function
/*/
User Function StatNew(oObjt,aPos,nPos)
	Local nList	:= 16
	Local aList	:= {'Ativo','Inativo','Temporario','Servico','Encomenda','Uso e Consumo','Insumo','Bloqueado','Recente','Local','Sazonal','Oportunidade','Fora de Linha','Excluido','Nulo',''}
	Local oList	:= Nil
	Local oDlg	:= Nil

	DEFINE MSDIALOG oDlg FROM 000,000 TO 199,162 TITLE "Novos Status" PIXEL

	oList:= TListBox():New(000,001,{|u|if(Pcount()>0,nList := u, nList)},aList,080,100,{|| aPos[nPos,5] := aList[nList],oObjt:Refresh()},oDlg,,,,.T.,,{|| oDlg:End()})

	ACTIVATE MSDIALOG oDlg CENTERED
Return

/*/{Protheus.doc} AplicAll
Descrição: Função para replicar o status para todos os produtos da grid.
@author Carajas
@since 28/09/2017
@version undefined
@param oObjt, object, descricao
@type function
/*/
Static Function AplicAll(oObjt)
	Local cNewStat	:= ''
	Local Al 		:= 0
    
    if !MsgYesNo("Confirma aplicação do novo status em todos os produtos selecionados?")
       Return 
    endif
	
	For Al := 1 To Len(aProdAlt)
		If Al == 1
			cNewStat := aProdAlt[Al,5]
			Loop
		EndIf
		aProdAlt[Al,5] := cNewStat
	Next Al

	oObjt:Refresh()
Return

/*/{Protheus.doc} PesqProd
Descrição: Ação do Botão Pesquisar. Efetua o Filtro dos produtos conforme parametros.
@author Carajas
@since 28/09/2017
@version undefined
@param oObjt, object, descricao
@type function
/*/
Static Function PesqProd(oObjt)
	Local cStatus := U_GetStatus(1) //Fun��o para Gerenciar os Status.
	Local cAliBZ  := ''

	//Efetua a consulta dos produtos.
	cAliBZ := U_ConsBZ(cForSA2,cLojSA2,cDeptB1,cLinhZA,cFilSBZ,cProdSB1,cStatus,.F.)

	//Limpa o Array.
	aStatus := {}
	aSize(aProdAlt,0)

	//Somente efetua a listagem de produtos caso um dos status sejam selecionados.
	If !Empty(cStatus) .Or. lCheck9
		DbSelectArea(cAliBZ)
		Count To cTotProd
		(cAliBZ)->(DbGoTop())

		While !(cAliBZ)->(EOF())

			If (cAliBZ)->RECBZ > 0
				//Função para Gerenciar os Status.
				aStatus := U_GetStatus(2,(cAliBZ)->BZ_XSTATUS)

				AAdd(aProdAlt,{(cAliBZ)->B1_COD,(cAliBZ)->B1_DESC,(cAliBZ)->B1_UM,aStatus[1],Space(15),(cAliBZ)->RECBZ})
			Else
				MsgAlert("Produto não localizado na SBZ.","Manutenção de Produto")
			EndIf

			(cAliBZ)->(DbSkip())
		EndDo
	Else
	   MsgAlert("Nenhum Status selecionado para selecao dos registros ou Filial nao informada.","Manutenção de Produto")		
	EndIf

	oObjt:Refresh()
	oTotal:Refresh()
	(cAliBZ)->(DbCloseArea())
Return

/*/{Protheus.doc} GetStatus
Descrição: Função para gerenciar os Status da BZ_XSTATUS.
@author Carajas
@since 28/09/2017
@version undefined
@param nOpc, numeric, descricao
@param cStatus, characters, descricao
@type function
/*/
User Function GetStatus(nOpc,cStatus)

	Local xRetorno := ''

	Default cStatus := 'Nulo'

	//Opção para retornar o Where da pesquisa.
	If nOpc == 1
		If lCheck1
			xRetorno += 'A;' 	// Ativo 
		EndIf
		If lCheck2
			xRetorno += 'N;'	// Inativo
		EndIf
		If lCheck3
			xRetorno += 'T;'	// Temporario
		EndIf
		If lCheck4
			xRetorno += 'S;'	// Serviço
		EndIf
		If lCheck5
			xRetorno += 'E;'	// Encomenda
		EndIf
		If lCheck6
			xRetorno += 'C;'	// Uso e Consumo
		EndIf
		If lCheck7
			xRetorno += 'I;'	// Insumo
		EndIf
		If lCheck8
			xRetorno += 'B;'	// Bloqueado
		EndIf
		If lCheck9
			xRetorno += 'R;'	// Recente
		EndIf		
		If lCheck10
			xRetorno += 'L;'	// Local
		EndIf
		If lCheck11
			xRetorno += 'Z;'	// Sazonal
		EndIf		
		If lCheck12
			xRetorno += 'O;'	// Oportunidade
		EndIf
		If lCheck13
			xRetorno += 'F;'	// Fora de Linha
		EndIf
		If lCheck14
			xRetorno += 'X;'	// Excluído
		EndIf
		If lCheck15
			xRetorno += ''		// Nulo
		EndIf	

		//Limpa o ultimo ";" criado.
		xRetorno := Left(xRetorno,Len(xRetorno)-1)

	Else //Gerencia os Status para Gravação e Apresentação na tela.
		If     (cStatus == 'A' .Or. Upper(cStatus) == 'ATIVO')
			xRetorno := {'Ativo','A'}
		ElseIf (cStatus == 'N' .Or. Upper(cStatus) == 'INATIVO')
			xRetorno := {'Inativo','N'}
		ElseIf (cStatus == 'T' .Or. Upper(cStatus) == 'TEMPORARIO')
			xRetorno := {'Temporario','T'}
		ElseIf (cStatus == 'S' .Or. Upper(cStatus) == 'SERVICO')
			xRetorno := {'Servico','S'}
		ElseIf (cStatus == 'E' .Or. Upper(cStatus) == 'ENCOMENDA')
			xRetorno := {'Encomenda','E'}
		ElseIf (cStatus == 'C' .Or. Upper(cStatus) == 'USO E CONSUMO')
			xRetorno := {'Uso e Consumo','C'}
		ElseIf (cStatus == 'I' .Or. Upper(cStatus) == 'INSUMO')
			xRetorno := {'Servico','I'}
		ElseIf (cStatus == 'B' .Or. Upper(cStatus) == 'BLOQUEADO')
			xRetorno := {'Bloquado','B'}
		ElseIf (cStatus == 'R' .Or. Upper(cStatus) == 'RECENTE')
			xRetorno := {'Recente','R'}
		ElseIf (cStatus == 'L' .Or. Upper(cStatus) == 'LOCAL')
			xRetorno := {'Local','L'}
		ElseIf (cStatus == 'Z' .Or. Upper(cStatus) == 'SAZONAL')
			xRetorno := {'Sazonal','Z'}
		ElseIf (cStatus == 'O' .Or. Upper(cStatus) == 'OPORTUNIDADE')
			xRetorno := {'Oporunidade','O'}
		ElseIf (cStatus == 'F' .Or. Upper(cStatus) == 'FORA DE LINHA')
			xRetorno := {'Fora de Linha','F'}
		ElseIf (cStatus == 'X' .Or. Upper(cStatus) == 'EXCLUIDO')
			xRetorno := {'Excluido','X'}							
		ElseIf (Empty(cStatus) .Or. Upper(cStatus) == 'NULO')
			xRetorno := {'Nulo',''}	
		EndIf
	EndIf
Return(xRetorno)

/*/{Protheus.doc} ConsBZ
Descrição: Função de Consulta dos Produtos para apresentação no Objeto Principal.
@author Carajas
@since 28/09/2017
@version undefined
@param cFornec, characters, descricao
@param cLoja, characters, descricao
@param cDepto, characters, descricao
@param cLinha, characters, descricao
@param cFilB, characters, descricao
@param cProduto, characters, descricao
@param cFiltro, characters, descricao
@param lViaImp, logical, descricao
@type function
/*/
User Function ConsBZ(cFornec,cLoja,cDepto,cLinha,cFilB,cProduto,cFiltro,lViaImp)
	Local cQuery   := ''
	Local cAliGer  := GetNextAlias()

	Default cFornec  := ''
	Default cLoja	 := ''
	Default cDepto	 := ''
	Default cLinha	 := ''
	Default cFilB	 := ''
	Default cProduto := ''
	Default cFiltro	 := ''
	Default lViaImp	 := .F.

	If Select(cAliGer) > 0
		(cAliGer)->(DbCloseArea())
	EndIf

	cQuery := "SELECT B1_COD,B1_DESC,B1_UM,BZ_XSTATUS,BZ.R_E_C_N_O_ AS RECBZ "
	cQuery += "FROM "+RetSqlName("SB1")+" B1 "
	cQuery += "INNER JOIN "+RetSqlName("SBZ")+" BZ ON BZ.D_E_L_E_T_=' ' AND " 
	cQuery += "B1.B1_COD = BZ.BZ_COD AND BZ.BZ_FILIAL ='"+ cFilB +"' " 
	cQuery += "LEFT OUTER JOIN "+RetSqlName("AY0")+" DEP ON DEP.D_E_L_E_T_=' ' AND DEP.AY0_CODIGO = B1.B1_01CAT2 "
	cQuery += "LEFT OUTER JOIN "+RetSqlName("AY0")+" LIN ON LIN.D_E_L_E_T_=' ' AND LIN.AY0_CODIGO = B1.B1_01CAT5 "
	cQuery += "WHERE "
	cQuery += "B1.D_E_L_E_T_ =' ' "
	cQuery += "AND B1.B1_FILIAL = '"+ xFilial('SB1') +"' "
	If !Empty(cProduto)
		cQuery += "AND B1.B1_COD = '"+ cProduto +"' "
	EndIf
	If !Empty(cFornec)
		cQuery += "AND B1.B1_PROC = '"+ cFornec +"' " 
		cQuery += "AND B1.B1_LOJPROC = '"+ cLoja +"' "
	EndIf
	If !Empty(cDepto)
		cQuery += "AND DEP.AY0_CODIGO ='"+ cDepto +"' "
	EndIf 
	If !Empty(cLinha)
		cQuery += "AND LIN.AY0_CODIGO = '"+ cLinha +"' "
	EndIf
	/*
	If !lViaImp //Valida se � via importa��o.
		cQuery += "AND (Trim(BZ.BZ_XSTATUS) IN "+ FormatIn(cFiltro,";") + ;
		          Iif(lCheck9," OR ( Trim(BZ.BZ_XSTATUS) Is null) OR TRIM(BZ.BZ_XSTATUS)='N')", ") ") 		          
	EndIf 
	*/
	If !lViaImp //Valida se � via importa��o.
		cQuery += "AND (Trim(BZ.BZ_XSTATUS) IN "+ FormatIn(cFiltro,";")+Iif(lCheck9," OR Trim(BZ.BZ_XSTATUS) Is null) ", ") ") 		          
	EndIf
	
	cQuery := ChangeQuery(cQuery)
	dbUseArea( .T.,"TOPCONN",TCGENQRY(,,cQuery),cAliGer,.F.,.T.)
    
Return(cAliGer)

/*/
���Programa  � fPesqReg  � Autor � Awdry Marcio      � Data �     02/2018 ���
���Descricao � Pesquisa registro na tabela                                ���
/*/
Static Function fPesqReg(cConteudo,xcAlias,xcVar)

Local aArea:=GetArea()
Local lRet:=.t.
   
dbSelectArea(xcAlias)
dbSetOrder(1)
if !empty(cConteudo).and.!dbSeek(xFilial(xcAlias)+cConteudo)
   //Aviso("Atencao","Conteudo informado nao localizado no cadastro!",{"Ok"})
   MsgAlert("Conteudo informado n�o localizado no cadastro!. Favor Verificar.","Manuten��o de Produto")
   lRet:=.F.  
else
   if !empty(cConteudo)
      if xcVar=='cProdSB1'
         M->cDescPro := SB1->B1_DESC //Posicione("SB1",1,xFilial("SB1")+xcCampo,"B1_DESC"),Space(nTamPro))  
      elseif xcVar=='cDeptB1'
         M->cDescDep := AY0->AY0_DESC
      elseif xcVar=='cLinhZA'
         M->cDescLin := AY0->AY0_DESC    
      endif
   else
      if xcVar=='cProdSB1'
         M->cDescPro :=" " 
      elseif xcVar=='cDeptB1'
         M->cDescDep := " "
      elseif xcVar=='cLinhZA'
         M->cDescLin := " "    
      endif   
   endif  
endif

RestArea(aArea)
Return lRet


User Function RelGRID()

	Local oReport := NIL  
	
	oReport := RptDef(aProdAlt)
	oReport:PrintDialog()
Return

//Impressão de Produtos da GRID
Static Function RptDef(aProduto)

	Local oReport := Nil
	Local oSection1:= Nil
	Local cNome := 'Wizard de Produtos-' //+ Dtoc(date())
	 
	Local oBreak
	Local oFunction
	
	oReport := TReport():New(cNome,"Relação de Produtos Encontrados no Wizard de Produtos",cNome,{|oReport| ReportPrint(oReport, aProduto)},"Rela��o de Produtos Encontrados no Wizard de Produtos")
	oReport:SetPortrait()    
	oReport:SetTotalInLine(.F.)
	
	oReport:ShowParamPage()

	oReport:lParamPage := .F.
	
	// Definições da secao PROD

	oSection1:= TRSection():New(oReport, "Relação de Produtos Importados pelo Wizard de Produtos", {""}, , .F., .T.)
	TRCell():New( oSection1,	"CODPROD",			"",	"C�d. Prod.",				"@R",	15)
	TRCell():New( oSection1,	"CODBAR",			"",	"C�d. Bar.",				"@R",	20)
	TRCell():New( oSection1,	"DESCRICAO",		"",	"Descri��o",				"@R",	70)
	TRCell():New( oSection1,	"UNIDADE",			"",	"Unidade",					"@!",	10)
	TRCell():New( oSection1,	"CODFORNECEDOR",	"",	"C�d. For",					"@!",	10)
	TRCell():New( oSection1,	"FORNECEDOR",		"",	"Fornecedor",				"@!",	60)
	TRCell():New( oSection1,	"STATUS",			"",	"Status",					"@!",	10)
	
			
	TRFunction():New(oSection1:Cell("CODPROD"),"Total de Produtos Cadastrados: ","COUNT",,,,,.F.,.T.)
		
	oReport:SetTotalInLine(.F.)
	
	oSection1:SetPageBreak(.T.)
	oSection1:SetTotalText(" ")	
	
Return (oReport)

// Função de Impressão do Relatório

Static Function ReportPrint(oReport, aProduto)
	
	Local oSection1 := oReport:Section(1)	
	Local lPrim 	:= .T.	
	Local i         :=  1
	
	
	while ( i<= len(aProdAlt) )  		
		CODPROD		:= aProduto[i,1]
		DESCRICAO	:= aProduto[i,2]
		UNIDADE		:= aProduto[i,3]
		STATUS		:= aProduto[i,4]
		
		CODFORNECEDOR := Posicione("SB1",1,xFilial("SB1")+CODPROD,"B1_PROC")
		LOJAFORNECEDOR:= Posicione("SB1",1,xFilial("SB1")+CODPROD,"B1_LOJPROC")
		FORNECEDOR	  := Posicione("SA2",1,xFilial("SB1")+CODFORNECEDOR+LOJAFORNECEDOR,"A2_NOME")
		CODBAR		  := Posicione("SB1",1,xFilial("SB1")+CODPROD,"B1_CODBAR")
		
	   	oSection1:Init()
		
		oReport:IncMeter()	
		oSection1:Cell("CODPROD"):SetValue(CODPROD)
		oSection1:Cell("CODBAR"):SetValue(CODBAR)
		oSection1:Cell("DESCRICAO"):SetValue(DESCRICAO) 
		oSection1:Cell("UNIDADE"):SetValue(UNIDADE)
		oSection1:Cell("CODFORNECEDOR"):SetValue(CODFORNECEDOR) 
		oSection1:Cell("FORNECEDOR"):SetValue(FORNECEDOR)
		oSection1:Cell("STATUS"):SetValue(STATUS) 
		
		oSection1:Printline()
	
		oReport:ThinLine()
		
		i++     
	Enddo
	oSection1:finish()
Return