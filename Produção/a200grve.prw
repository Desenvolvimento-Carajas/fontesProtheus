#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} A200GRE()

@description Rotina Responsável por atualizar o campo de processamento na Tabela SB1 fazendo que o componente pai tenha seu custo reprocessado.

@param ParamIxb[2] - Visualizar
@param ParamIxb[3] - Incluir
@param ParamIxb[4] - Alterar
@param ParamIxb[5] - Excluir

@owner Carajás
@since 14/08/2019

/*/


user function A200GRVE()

	Local cQuery  := ""
	Local ExpN1 := ParamIxb[1]
	
	
	If ExpN1 == 2 // Visualizar
	
	// Tratamento na Visualização
	
	ElseIF ExpN1 == 3 //Inclusão
	
	 	cQuery := " UPDATE  "+RetSQLName("SB1")+"  SET B1_FLGCAD = 'N' "
		cQuery += " WHERE B1_FILIAL = '"+XFILIAL("SB1")+"' "
		cQuery += " AND B1_COD = '"+cProduto+"' " "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		
		TCSQLExec(cQuery)
		TcSqlExec("COMMIT")
	
	ElseIF ExpN1 == 4 //Alteração
	
	 	cQuery := " UPDATE  "+RetSQLName("SB1")+"  SET B1_FLGCAD = 'N' "
		cQuery += " WHERE B1_FILIAL = '"+XFILIAL("SB1")+"' "
		cQuery += " AND B1_COD = '"+cProduto+"' " "
		cQuery += " AND D_E_L_E_T_ = ' ' "
		
		TCSQLExec(cQuery)
		TcSqlExec("COMMIT")
	
	ElseIF ExpN1 == 5 //Exclusão
	
	//Tratamento na Exclusão
	
	EndIf
	

return