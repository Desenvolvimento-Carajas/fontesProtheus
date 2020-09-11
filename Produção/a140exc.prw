#Include "Protheus.Ch"

/*/{Protheus.doc} A140EXC
Descrição: P.E. - Valida a Exclusão de uma pré nota.
@author Rafael Nastri - RVN
@since 24/09/2017
@version undefined
@type function
/*/
User Function A140EXC()
	Local lRet	:= .T.
	Local aArea	:= GetArea()

	//Não deixa excluir pré nota recusada.
	If SF1->F1_STATUS =='X'
		lRet := .F.
		Help(,,"Help","A140EXC",'Pré Nota Recusada. Não é permitdo exclusão.',1,0)
	EndIf

	RestArea(aArea)
Return(lRet)