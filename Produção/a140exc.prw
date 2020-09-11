#Include "Protheus.Ch"

/*/{Protheus.doc} A140EXC
Descri��o: P.E. - Valida a Exclus�o de uma pr� nota.
@author Rafael Nastri - RVN
@since 24/09/2017
@version undefined
@type function
/*/
User Function A140EXC()
	Local lRet	:= .T.
	Local aArea	:= GetArea()

	//N�o deixa excluir pr� nota recusada.
	If SF1->F1_STATUS =='X'
		lRet := .F.
		Help(,,"Help","A140EXC",'Pr� Nota Recusada. N�o � permitdo exclus�o.',1,0)
	EndIf

	RestArea(aArea)
Return(lRet)