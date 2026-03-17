struct Conta{
    var numero: Int
    var titular: String
    var senha: String
    var saldo: Double
}
func menu_global(_ opc:Int)-> Int{
    switch(opc){
        case 1: 
            if let dados = cadastro(){
               var num = gerar_numero()
               var nova_conta = criar_conta(num, dados.nome, dados.senha, dados.saldo)
               mostrar_dados(nova_conta)
               salvar_conta(&listacontas, nova_conta)
            }
            else {
                print("Erro ao realizar o cadastro.")
            }
            return 0
        case 2:
            if let usuario = dig_login(listacontas){
                while opcl!=5{
                    print("Olá, \(usuario.titular)\n")
                    print("\n1: Ver Saldo/Dados\n2: Depositar\n3: Transferir\n4:Alterar senha\n5: Logout")
                    if let opcaolStr = readLine(), opcaol = Int(opcaolStr),opcaol>0 && opcaol<6{
                        opcl = menu_logado(opcaol,usuario)
                    }
                    else{
                        print("\n Opção inválida")
                    }
                }
            }
            else{
                print("Login invalido.")
            }
        }

}

// Fazer um menu só para admin (apagar)

func menu_logado(_ opc: Int, _ usuario: Conta){
    switch (opc){
        case 1: 
            mostrar_dados(usuario)
        case 2:

    }
}

func dig_login(listacontas: Conta)-> Conta{
    print("\nIngresse o número da conta: ")
    guard let usuario = readLine(), !usuario.isEmpty() else{
        return nil
    }
    guard let senha = readLine(), !senha.isEmpty() else{
        return nil
    }
    for conta in listacontas{
        if usuario==conta.numero{
            if senha==conta.senha{
                return Conta
            }
        }
    }
    return nil
}


func mostrar_dados(_ conta){
    print("\nNúmero: \(conta.numero)\n")
    print("Titular: \(conta.titular)\n")
    print("Saldo: R$ \(conta.saldo)\n")
    print("Senha: ")
    for i in conta.senha{
        print("*")
    }
}

func criar_conta(_ num: int, _ titular: String, _ senha: String, _ saldo: Double ) -> Conta{
    return Conta(numero: num, titular: titular, senha: senha, saldo: saldo)
}

func cadastro()-> (nome: String, senha: String, saldo: Double)? {
    print("Para criar sua conta, digite os seguintes dados.\n")
    print("Nome: ")
    guard let nome = readLine(), !nome.isEmpty else {
        print("\nErro: Nome inválido.")
        return nil
    }
    print("\nSenha: ")
    guard let senha = readLine(), !senha.isEmpty else{
        ("\nErro: Senha Inválida")
        return nil
    }
    print("\nSaldo inicial: ")
    guard let saldoStr = readLine(), let saldo = double(saldoStr) else{
        ("\nErro: Saldo Inválido")
        return nil
    }
    return (nome, senha, saldo)
}

func gerar_numero() -> Int{
    let numero = Int.random(in: 1001...9999)
    return numero
}

func salvar_conta(_ listacontas: inout Conta, _ nova_conta: Conta){
    listacontas.append(nova_conta)
}

var listacontas: [Conta] = [
    Conta(numero: 1000, titular: "Admin", senha: "Admin", saldo: 1000.0)
    ]
do {
    print("Menu:\n1: Criar Conta\n2: Logar\n3: Finalizar Programa\n")
    if let opcaostr = readLine(), let opcao = Int(opcaostr), opcao<4 && opcao>0 {
       opc = menu_global(opcao)
    }
    else {
            print("Valor inválido.")
    }
} while opc!=3