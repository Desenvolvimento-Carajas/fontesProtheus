#include 'protheus.ch'
#include 'parmtype.ch'

User Function ACD150VE()

	Local lRet := .T.
	Local nTipo := PARAMIXB[3]
	Local cArm := PARAMIXB[1]
	Local cEnd := PARAMIXB[2]
	Local aAreaAnt := GetArea()

	// Conout("Modulo 111 "+ cModulo)
	// Conout("Funname ACD150VE 112 "+ FunName())
	// Conout("Funname ACD150VE 115  NTIPO ")
	// Conout(TYPE("nTipo"))
	// Conout(nTipo)
	
	// Conout("Funname ACD150VE 117 cArm " )
	// Conout(cArm)

	// Conout("Funname ACD150VE 121 cEnd " )
	// Conout(cEnd)

	If nTipo == 1        
	
	
		// --- Valida endereco origem // ...
		lRet := U_CAVLDNNR(cArm)
	ElseIf nTipo == 2        
		lRet := U_CAVLDNNR(cArm)
		// --- Valida endereco destino        // ...
	EndIf

	RestArea(aAreaAnt)

Return lRet

