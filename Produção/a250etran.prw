#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TopConn.ch'

/*/{Protheus.doc A250ETRAN
     Ponto de Entrada utilizado para gravar o campo D3_XFLGPRO = N onde o Job irá processar o custo do produto pai.
    @type  Static Function
    @author Alexander
    @since 23/08/2019
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/

user function A250ETRAN()

	Local _aAReaSD3 := SD3->(GetARea())
	Local lComposto := .F.

	lComposto :=  StaticCall(ProjetMVC,IsComp,SD3->D3_COD,"P")
	
	if lComposto
	
		RecLock("SD3",.F.)
		SD3->D3_XFLGPRO := "N"
		SD3->(MsUnLock())
	
	Endif
	
	RestArea(_aAReaSD3)

Return	