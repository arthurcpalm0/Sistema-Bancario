/*
Sistema Bancario em Swift.
Login de admin:
Número: 1000
Senha: Admin

O terminal mostra o número aleatório após a criação da conta.
*/



// Criação da struct conta contendo os dados de cada conta.
struct Conta{
    var numero: Int
    var titular: String
    var senha: String
    var saldo: Double
}
// Menu global que inclui os casos do menu
func menu_global(_ opc: Int, _ listacontas: inout [Conta])-> Int{
    switch(opc){
        case 1: 
            // Chamada da função cadastro que gera uma tupla contendo todos os dados menos o número já que esse é feito numa função separada, a função pode retornar nil.
            if let dados = cadastro(){
               // Chamada da função que gera um número aleatório
               let num = gerar_numero()
               // Chamada da função que leva os dados do cadastro e o numero aleatório para o formato de struct.
               let nova_conta = criar_conta(num, dados.nome, dados.senha, dados.saldo)
               // Chamada mostrar dados, nesse caso serve para o usuário saber seu número (que é aleatório).
               mostrar_dados(nova_conta)
               // Chamada da função que salva a conta no banco de dados.
               salvar_conta(&listacontas, nova_conta)
            }
            else {
                print("Erro ao realizar o cadastro.")
            }
            return 0
        case 2:
            // Chamada da função que faz o login, caso o login esteja incorreto retorna nil.
            if var usuario = dig_login(listacontas){
                // Criação da variavel que regula o loop.
                var opcaologado = 0
                repeat {
                    print("\nOlá, \(usuario.titular)")
                    if usuario.numero == 1000{
                        print("\n1: Listar contas.\n2: Remover conta.\n3: Logout")
                        if let opcaologadoStr = readLine(), let opcaologado2 = Int(opcaologadoStr), opcaologado2>0 && opcaologado2<4{
                            opcaologado = menu_admin(opcaologado2, &listacontas)
                        }
                        else {
                            print("Opção inválida.")
                        }
                    }
                    else {
                        print("\n1: Ver Saldo/Dados.\n2: Depositar.\n3: Transferir.\n4:Alterar senha.\n5: Logout")
                        if let opcaologadoStr = readLine(), let opcaologado2 = Int(opcaologadoStr), opcaologado2>0 && opcaologado2<6{
                            opcaologado = menu_logado(opcaologado2,&usuario, &listacontas)
                        }
                        else{
                            print("Opção inválida")
                        }
                    }
                } while opcaologado == 0
            }
            else{
                print("Login inválido.")
            }
            return 0
        case 3:
            print ("\nAdeus.")
            return 1
        default:
            return 0
    }

}
// Menu com os casos de admin.
func menu_admin(_ opc: Int, _ listacontas: inout [Conta])-> Int{
    switch (opc){
        case 1: 
            // Função que lista contas e seus dados (menos senha).
            listar_contas(listacontas)
            return 0
        case 2:
            print("Qual conta deseja remover? (Digite o número da conta.)")
            // Condição que valida se a conta existe e se o número maior que 1000 (Conta de admin não pode ser removida).
            if let numStr = readLine(), let num = Int(numStr), num>1000, validar(num, listacontas) != nil{
                // Chamada da função que remove a conta a partir do parametro num.
                remover_conta(num, &listacontas)
            }
            else {
                print("Número inválido.")
            }
            return 0
        case 3:
            print("\nAdeus, Admin.")
            return 1
        default:
            return 0
    }
}

func menu_logado(_ opc: Int, _ usuario: inout Conta, _ listacontas: inout [Conta]) -> Int{
    switch (opc){
        case 1:
            // Chamada da função que mostra os dados do usuário, porem censura a senha.
            mostrar_dados(usuario)
            return 0
        case 2:
            print("\nQuanto deseja depositar? (Saldo atual: \(usuario.saldo))")
            // Condição que verifica que o deposito seja válido e maior que 0.
            if let depStr = readLine(), let dep = Double(depStr), dep>0{
                // Função void que altera a struct e acrescenta o dinheiro.
                depositar(dep, &usuario)
                // Função que sincroniza esses dados com o banco de dados.
                sincronizar_conta(&listacontas, usuario)
                print("Novo saldo: \(usuario.saldo)")
            }
            else{
                print("Opção inválida.")
            }
            return 0
        case 3:
            print("A qual conta deseja transferir? (Digite o numero da conta.)")
            if let numStr = readLine(), let num = Int(numStr), num>1000{
                if var usuario2 = validar(num,listacontas){
                    // Condicional que verifica se o destinatário não é a mesma conta que está mandando o dinheiro, caso seja, o programa recomenda usar a opção de depositar.
                    if usuario2.numero != usuario.numero {
                        print("Quanto dinheiro deseja transferir?")
                        if let dinheiroStr = readLine(), let dinheiro = Double(dinheiroStr), dinheiro>0 && dinheiro<usuario.saldo{
                            // Chamada da função que deposita o dinheiro na conta do destinatário.
                            depositar(dinheiro, &usuario2)
                            // Chamada da função que sincroniza os dados da conta do destinatário no banco de dados.
                            sincronizar_conta(&listacontas, usuario2)
                            // Chamada da função que reduz o dinheiro da conta transferindo o saldo.
                            subtrair_dinheiro(dinheiro, &usuario)
                            // Chamada da função que sincroniza a conta transferindo o saldo no banco de dados.
                            sincronizar_conta(&listacontas, usuario)
                        }
                        else{
                            print("Quantia inválida.")
                        }
                    }
                    else {
                        print("Se deseja depositar dinheiro na sua conta, por favor selecione a opção depositar.")
                    }
                }
                else{
                    print("Conta não existe.")
                }
            }
            else {
                print("Número de conta inválido.")
            }
            return 0
        case 4:
            print("Digite sua senha antiga: ")
            if let senhaAntiga = readLine(), !senhaAntiga.isEmpty{
                if senhaAntiga == usuario.senha{
                    // Chamada da função que altera a senha.
                    alterar_senha(&usuario)
                    // Chamada da função que sincroniza a nova senha no banco de dados.
                    sincronizar_conta(&listacontas, usuario)
                }
                else {
                    print("Senha não coincide.")
                }
            }
            else{
                print("Senha inválida.")
            }
            return 0
        case 5:
            print("Adeus, \(usuario.titular).")
            return 1
        default:
            return 0
    }
}
// Função que remove a conta do banco de dados.
func remover_conta(_ num: Int, _ listacontas: inout [Conta]){
    // O comando where retorna o index de onde o numero da conta passada pelo usuário é igual ao número da conta no banco de dados. 
    listacontas.removeAll(where: {conta in return conta.numero == num})
}
// Função que mostra a lista de contas.
func listar_contas(_ listacontas: [Conta]){
    for conta in listacontas{
        print("Número da conta: \(conta.numero), Titular da conta: \(conta.titular), Saldo da conta: \(conta.saldo)")
    }
}
// Função que altera senha (Função extra).
func alterar_senha(_ usuario: inout Conta){
    print("Ingresse sua nova senha: ")
    if let novasenha = readLine(), !novasenha.isEmpty{
        usuario.senha = novasenha
    }
    else{
        print("Senha inválida.")
    }
}
// Função que decrementa o dinheiro da conta de quem efetua a transferência.
func subtrair_dinheiro(_ dinheiro: Double, _ usuario: inout Conta){
    usuario.saldo -= dinheiro
}
// Função que valida se a conta existe, se sim, retorna a conta.
func validar(_ num: Int?, _ listacontas: [Conta]) -> Conta?{
    for conta in listacontas{
        if conta.numero==num{
            return conta
        }
    }
    return nil
}
// Função que deposita dinheiro em caso de deposito ou transferência.
func depositar(_ deposito: Double, _ usuario: inout Conta){
    usuario.saldo += deposito
}
// Função onde o usuário digita o login e retorna nil em caso de erro. Também retorna a conta.
func dig_login(_ listacontas: [Conta])-> Conta?{
    print("Ingresse o número da conta: ")
    guard let usuarioStr = readLine(), let usuario = Int(usuarioStr) else{
        return nil
    }
    print("Ingresse a senha: ")
    guard let senha = readLine(), !senha.isEmpty else{
        return nil
    }
    for conta in listacontas{
        if usuario==conta.numero{
            if senha==conta.senha{
                return conta
            }
        }
    }
    return nil
}

// Função que mostra os dados e censura as senhas.
func mostrar_dados(_ conta: Conta){
    print("\nNúmero: \(conta.numero) ")
    print("Titular: \(conta.titular) ")
    print("Saldo: R$ \(conta.saldo) ")
    print("Senha: ", terminator: "")
    for i in conta.senha{
        print("*", terminator:"")
    }
    print("\n")
}
// Função que retorna os dados da função cadastro e a função gerar_numero no formato da struct Conta.
func criar_conta(_ num: Int, _ titular: String, _ senha: String, _ saldo: Double ) -> Conta{
    return Conta(numero: num, titular: titular, senha: senha, saldo: saldo)
}
// Função que gera o cadastro no formato de tupla já que não há inclusão do número, então preferi só gerar a struct depois.
func cadastro()-> (nome: String, senha: String, saldo: Double)? {
    print("Para criar sua conta, digite os seguintes dados.")
    print("Nome: ")
    guard let nome = readLine(), !nome.isEmpty else {
        print("Erro: Nome inválido.")
        return nil
    }
    print("Senha: ")
    guard let senha = readLine(), !senha.isEmpty else{
        print ("Erro: Senha Inválida")
        return nil
    }
    print("Saldo inicial: ")
    guard let saldoStr = readLine(), let saldo = Double(saldoStr) else{
        print ("Erro: Saldo Inválido")
        return nil
    }
    return (nome, senha, saldo)
}
// Função que gera o número aleatório.
func gerar_numero() -> Int{
    let numero = Int.random(in: 1001...9999)
    return numero
}
// Função que adiciona a conta a lista.
func salvar_conta(_ listacontas: inout [Conta], _ nova_conta: Conta){
    listacontas.append(nova_conta)
}
// Função que sincroniza os dados da conta no banco de dados.
func sincronizar_conta(_ listacontas: inout [Conta], _ usuario: Conta){
    if let index = listacontas.firstIndex(where: { conta in return conta.numero == usuario.numero}){
        listacontas[index] = usuario
    }
}
// Função onde começa a execução do programa, também fiz essa função para não ter variaveis globais.
func main(){
    var listacontas: [Conta] = [
        Conta(numero: 1000, titular: "Admin", senha: "Admin", saldo: 1000.0)
        ]
    var opcao = 0
    repeat {
        print("\nMenu:\n1: Criar Conta\n2: Logar\n3: Finalizar Programa")
        if let opcaoStr = readLine(), let opcao2 = Int(opcaoStr), opcao2<4 && opcao2>0 {
        opcao = menu_global(opcao2, &listacontas)
        }
        else {
                print("Valor inválido.")
        }
    } while opcao==0
}
// Execução do programa.
main()