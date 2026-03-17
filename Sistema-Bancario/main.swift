struct Conta{
    var numero: Int
    var titular: String
    var senha: String
    var saldo: Double
}
func menu_global(_ opc:Int)-> Int{
    switch(opc){
        case 1: 
            criar_conta()
        case 2:
            
        }

}

func criar_conta()-> Conta?{
    print("Par")
    guard let nome = readLine(), !nome.isEmpty else {
        print("Erro: Nome inválido.")
        return nil
    }
}
while (opc!=3){
    print("Menu:\n1: Criar Conta\n2: Logar\n3: Finalizar Programa\n")
    if let opcaostr = readLine(), let opcao = Int(opcaostr), opcao<4 && opcao>0 {
        menu_global(opcao)
    }
    else {
            print("Valor inválido.")
    }
}