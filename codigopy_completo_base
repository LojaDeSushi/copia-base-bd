import mysql.connector as sql
from mysql.connector import Error
import crypto
import datetime

config = { #define as configurações de conexões
    'host': 'localhost',
    'user': 'root',
    'password': '1324',
    'database': 'banco1',
    'raise_on_warnings': True
}

def conecta(config): #conecta ao banco 
    try: 
        return sql.connect(**config) 
    except Error:
        print(f"Deu erro: {Error}")
        return None

conex = conecta(config)

#-------------------------------------base---------------------------------------
#Se já existe um cliente com o nome e telefone:
def BuscaId(nome, tel): #usa o nome e telefone para achar o id_cliente
    conex = conecta(config)
    cursor = conex.cursor()
    verf = ("select id_cliente from cliente where nome_cliente = %s and tel_cliente = %s ")
    cursor.execute(verf, (nome, tel))
    resul = cursor.fetchone()
    cursor.close()
    conex.close()
    if resul is None:
        return None
    return resul[0]

#Busca conta
def BuscaConta(nome, tel):
    resultado = BuscaId(nome, tel)
    if resultado is None:
        print("cliente sem cadastro\n")
        return
    conex = conecta(config)
    cursor = conex.cursor()

    verf = "select id_conta from conta where id_conta = %s"
    cursor.execute(verf, (resultado,))
    resul = cursor.fetchone()
    cursor.close()
    conex.close()
    if resul is None:
        return None
    return resul[0]

#Novo cliente: 
#Usamos Nome, data, telefone, rua, cidade e bairro
#id auto_incrementado
def NovoCliente(nome, nasc, tel, rua, cidade, bairro, estado): #cria um cliente novo
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        resultado = BuscaId(nome, tel)

        if resultado is None:
            inser = "insert into cliente (nome_cliente, idade_cliente, tel_cliente, rua, cidade, bairro, estado) values (%s, %s, %s, %s, %s, %s, %s)"
            cursor.execute(inser, (nome, nasc, tel, rua, cidade, bairro, estado,))
            id_cliente = cursor.lastrowid
        else:
            id_cliente = resultado

        cont = "insert into conta (id_conta) values (%s)"
        cursor.execute(cont, (id_cliente,))
        conex.commit()
        print(f"Cliente {nome} seja bem vindo!\n")
    except Error as erro:
        conex.rollback()
        print(f"Ihh erro {erro}")
    finally:
        cursor.close()
        conex.close()

#Nova Conta Web:
#Usamos nome e telefone para verificar a existência 
#login e senha criados
def NovoWeb(login, senha, nome, tel): #usado para criar o web de um cliente já existente
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        resultado = BuscaId(nome, tel)
        if resultado is None:
            print("cliente sem cadastro\n") #verifica se tem cliente
            return
        
        Id_conta = BuscaConta(nome, tel) #pega o id_conta

        verf = ("select id_cliente from clienteweb where id_cliente = %s") #verifica se já existe uma conta web
        cursor.execute(verf, (resultado,))
        resul = cursor.fetchone()

        if resul is None: #se não tiver web
            status = 'Novo'
            cod = "insert into clienteweb (login, senha, id_cliente, status_web) values (%s, %s, %s, %s);" #cria web
            Vddsenha = crypto.SenHash(senha)
            cursor.execute(cod, (login, Vddsenha, resultado, status))
            Ncar = "insert into carrinho (id_conta) values (%s)"
            cursor.execute(Ncar, (Id_conta,))
            print("Cliente web cadastrado e conta criada\n")
        else: 
            print("Ja tem uma conta web\n")
            car = "select id_carrinho from carrinho where id_conta = %s" #verifica se tem um carrinho
            cursor.execute(car, (Id_conta,))
            result = cursor.fetchone()
            if result is None:
                Ncar = "insert into carrinho (id_conta) values (%s)"
                cursor.execute(Ncar, (Id_conta,))
        conex.commit()
        
    except Error as erro:
        conex.rollback()
        print(f"Ihh deu erro: {erro}\n")
    finally:
        cursor.close()
        conex.close()

#Inserir produto
#usa nome, descrição, valor e quantidades 
def BuscaProd(nome):
    conex = conecta(config)
    cursor = conex.cursor()
    verf = ("select id_produto from produto where nome_produto = %s")
    cursor.execute(verf, (nome,))
    resul = cursor.fetchone()
    cursor.close()
    conex.close()
    if resul is None:
        return None
    return resul[0]

def NovoProdu(nome, descricao, valor, quanti):
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        resultado = BuscaProd(nome)
        if resultado is not None:
            print(f"Produto cadastrado com id de {resultado}\n")
            atua = "update produto set quanti_pro = quanti_pro + %s where id_produto = %s"
            cursor.execute(atua, (quanti, resultado))
        else:
            cod = "insert into produto (nome_produto, descricao_pro, valor, quanti_pro) values (%s, %s, %s, %s)"
            cursor.execute(cod, (nome, descricao, valor, quanti,))
            print("produto cadastrado!\n")
        conex.commit()
    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()
    
#Item no carrinho
def AddItemCarr(nomeCli, tel, NomePro, quant):
    Id_conta = BuscaConta(nomeCli, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        car = "select id_carrinho from carrinho where id_conta = %s"
        cursor.execute(car, (Id_conta,))
        result = cursor.fetchone()
        Id_car = result[0] if result is not None else None

        Id_prod = BuscaProd(NomePro) 
        if Id_prod is None:
            print("Produto nao encontrado\n")
            return

        tam = "select quanti_pro from produto where id_produto = %s"
        cursor.execute(tam, (Id_prod,))
        tam = cursor.fetchone()[0]

        verf = "select quanti_item from itemcarrinho where id_produto = %s"
        cursor.execute(verf, (Id_prod,))
        resul = cursor.fetchone()
        tem = resul[0] if resul is not None else None

        if tem is None:
            if(tam >= quant):
                add = "insert into itemcarrinho (id_carrinho, id_produto, quanti_item) values (%s, %s, %s)"
                cursor.execute(add, (Id_car, Id_prod, quant,))
                print(f" {quant} produto(s) {NomePro} foram adicionados ao carrinho\n")
            else:
                print(f"Não temos {quant} produtos no estoque, colocaremos {tam}\n")
                add = "insert into itemcarrinho (id_carrinho, id_produto, quanti_item) values (%s, %s, %s)"
                cursor.execute(add, (Id_car, Id_prod, tam,))
                print(f" {tam} produto(s) {NomePro} foram adicionados ao carrinho\n")
        else:
            if tam >= quant:
                tem += quant
                mais = "update itemcarrinho set quanti_item = %s where id_produto = %s and id_carrinho = %s"
                cursor.execute(mais, (tem, Id_prod, Id_car,))
                print(f" ja tinha antes, agora tem {tem} produtos {NomePro}\n")
            else:
                mais = "update itemcarrinho set quanti_item = %s where id_produto = %s and id_carrinho = %s"
                cursor.execute(mais, (tam, Id_prod, Id_car,))
                print(f"Nao temos {tem} produtos colocaremos o max possível, agora tem {tam} produtos {NomePro}\n")
        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#visualizar carrinho
def visuCar(nomeCli, tel):
    Id_conta = BuscaConta(nomeCli, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        car = "select id_carrinho from carrinho where id_conta = %s"
        cursor.execute(car, (Id_conta,))
        result = cursor.fetchone()
        Id_car = result[0] if result is not None else None

        if Id_car is None:
            print("Nao possui carrinho\n")
            return
        
        carr = "select id_produto, quanti_item from itemcarrinho where id_carrinho = %s"
        cursor.execute(carr,(Id_car,))
        result = cursor.fetchall()
    
        print("Seu carrinho tem: ")
        for itens in result:
            teste = "select nome_produto from produto where id_produto = %s"
            cursor.execute(teste, (itens[0],))
            produt = cursor.fetchone()[0]
            print(f"{itens[1]} {produt}")

    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#transferir do carrinho para o pedido
def Pedido(nome, tel):
    Id_conta = BuscaConta(nome, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        car = "select id_carrinho from carrinho where id_conta = %s"
        cursor.execute(car, (Id_conta,))
        id_carrinho = cursor.fetchone()[0]
        dia = datetime.datetime.now()

        num = "select count(*) from pedido where id_conta = %s"
        cursor.execute(num, (Id_conta,))
        numP = cursor.fetchone()[0] + 1

        cria = "insert into pedido (id_conta, dia_pedido, num_pedido, status) values (%s, %s, %s, %s)"
        cursor.execute(cria, (Id_conta, dia, numP, 'Processos',))
        id_pedido = cursor.lastrowid

        trans = "select id_produto, quanti_item from itemcarrinho where id_carrinho = %s"
        cursor.execute(trans, (id_carrinho,))
        resul = cursor.fetchall()
        if not resul: #depois mudar 
            print("O carrinho está vazio\n")
            conex.rollback()
            return

        total = 0
        for produto in resul:
            coloca = "insert into itempedido (id_pedido, id_produto, quanti_item) values (%s, %s, %s)"
            cursor.execute(coloca, (id_pedido, produto[0], produto[1]))
            preco = "select valor from produto where id_produto = %s"
            cursor.execute(preco, (produto[0],))
            resulta = cursor.fetchone()
            total += resulta[0] * produto[1]

        valor = "update pedido set total_pedido = %s, status = %s where id_pedido = %s"
        cursor.execute(valor, (total, "Confirmado",id_pedido,))
        print("Pedido criado\n")
        print(f"O total deu {total} reais\n")

        dell = "delete from itemcarrinho where id_carrinho = %s"
        cursor.execute(dell, (id_carrinho,))
        print("Carrinho esvaziado\n")

        
        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

    Pagamento(nome, tel, numP)

#visualizar carrinho
def visuPedi(nomeCli, tel):
    Id_conta = BuscaConta(nomeCli, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        car = "select id_pedido, total_pedido, status, num_pedido from pedido where id_conta = %s"
        cursor.execute(car, (Id_conta,))
        result = cursor.fetchall()
        if not result:
            print("Nenhum pedido\n")
            return
        for pedido in result:
            ped = "select id_produto, quanti_item from itempedido where id_pedido = %s"
            cursor.execute(ped,(pedido[0],))
            resultado = cursor.fetchall()

            print(f"Seu pedido n° {pedido[3]} tem: ")
            for itens in resultado:
                teste = "select nome_produto from produto where id_produto = %s"
                cursor.execute(teste, (itens[0],))
                produt = cursor.fetchone()[0]
                print(f"{itens[1]} {produt}")
            print(f"Total: {pedido[1]} dinheiros")
            print(f"O status do seu pedido eh {pedido[2]}")

            pag = "select metodo_pag, valor_pag from pagamento where id_pedido = %s"
            cursor.execute(pag, (pedido[0],))
            print("O pedido foi pago: ")
            tipos = cursor.fetchall()
            for i in tipos:
                print(f"{i[0]} -> {i[1]} | ")
            
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#cancelar pedido admim e cliente
def Cancela(nome, tel, numP):
    id_conta = BuscaConta(nome, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        ped = "select id_pedido, status from pedido where id_conta = %s and num_pedido = %s"
        cursor.execute(ped, (id_conta, numP,))
        result = cursor.fetchone()
        if not result:
            print("pedido nao existe\n")
            return
        elif result[1] == 'Entregue' or result[1] == 'Cancelado':
            print("Pedido entregue ou cancelado\n")
            return

        ped = "select id_produto, quanti_item from itempedido where id_pedido = %s"
        cursor.execute(ped,(result[0],))
        resultado = cursor.fetchall()

        if result[1] in ['Confirmado', 'Pago', 'Em transito']:
            for itens in resultado:
                muda = "update produto set quanti_pro = quanti_pro + %s where id_produto = %s"
                cursor.execute(muda, (itens[1], itens[0]))
            
        up = "update pedido set status = 'Cancelado' where id_pedido = %s"
        cursor.execute(up, (result[0],))
        print(f"Pedido de numero {numP} foi cancelado\n")
        
        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#Muda status Admin apenas
def MudaStatus(nome, tel, numP):
    id_conta = BuscaConta(nome, tel)
    ordem = {
    'Processos': 'Confirmado',
    'Confirmado': 'Pago',
    'Pago': 'Em transito',
    'Em transito': 'Entregue'
    }
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        ped = "select id_pedido, status from pedido where id_conta = %s and num_pedido = %s"
        cursor.execute(ped, (id_conta, numP,))
        result = cursor.fetchone()
        if not result:
            print("pedido nao existe\n")
            return
        elif result[1] == 'Entregue' or result[1] == 'Cancelado':
            print("Pedido entregue ou cancelado\n")
            return
        
        prox = ordem[result[1]]
        atua = "update pedido set status = %s where id_pedido = %s"
        cursor.execute(atua, (prox, result[0],))
        print(f"pedido de numero {numP} foi atualizado para {prox}\n")
        if prox == 'Confirmado':
            ped = "select id_produto, quanti_item from itempedido where id_pedido = %s"
            cursor.execute(ped,(result[0],))
            resultado = cursor.fetchall()
            for itens in resultado:
                retira = "update produto set quanti_pro = quanti_pro - %s where id_produto = %s"
                cursor.execute(retira, (itens[1], itens[0],))

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#pagamentos
def Pagamento(nome, tel, numP):
    Id_conta = BuscaConta(nome, tel)
    conex = conecta(config)
    quant = int(input("Quantos pagamentos deseja fazer? 1, 2 ou 3?: "))
    pag = []
    for i in range(quant):
        tipo = input(f"O {i+1}° pagamento vai ser qual tipo?: Pix, Cartão ou Boleto?: ")
        if tipo not in ['Pix', 'Cartão', 'Boleto']:
            print("Tipo inválido\n")
            return
        pag.append(tipo)
    try:
        cursor = conex.cursor()
        car = "select id_pedido, total_pedido, status from pedido where id_conta = %s and num_pedido = %s"
        cursor.execute(car, (Id_conta, numP))
        result = cursor.fetchone()
        if not result:
            print("Nenhum pedido achado\n")
            return
        if result[2] in ['Cancelado', 'Entregue']:
            print("Não pode mais alterar o pagamento")
            return
        
        diaP = datetime.datetime.now()
        
        for i in range(quant):
            valorpag = int(input(f"O {i+1}° tipo de pagamento vai pagar quanto?: "))
            t += valorpag
            if t > result[1] or t < 1:
                print("Valor inválido\n")
                return
            pagamento = "insert into pagamento (id_pedido, metodo_pag, valor_pag, data_pag) values (%s, %s, %s, %s)"
            cursor.execute(pagamento, (result[0], pag[i], valorpag, diaP,))

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#remover item do carrinho
def RemoveItemCar(nome, tel, NomeP, quant):
    id_conta = BuscaConta(nome, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        car = "select id_carrinho from carrinho where id_conta = %s"
        cursor.execute(car, (id_conta,))
        id_car = cursor.fetchone()
        if not id_car:
            print("Carrinho vazio\n")
            return
        id_car = id_car[0]

        id_prod = BuscaProd(NomeP)
        if id_prod is None:
            print("Produto nao encontrado\n")
            return

        it = "select quanti_item from itemcarrinho where id_produto = %s and id_carrinho = %s"
        cursor.execute(it, (id_prod, id_car,))
        quantidade = cursor.fetchone()
        if quantidade is None:
            print(f"Nao tem {NomeP} no carrinho\n")
            return
        quantidade = quantidade[0]
        
        if quant >= quantidade:
            remove = "delete from itemcarrinho where id_produto = %s and id_carrinho = %s"
            cursor.execute(remove, (id_prod, id_car,))
            print(f"{NomeP} foi removido do carrinho")
        elif quant < quantidade:
            atua = "update itemcarrinho set quanti_item = quanti_item - %s where id_produto = %s and id_carrinho = %s"
            cursor.execute(atua, (quant, id_prod, id_car,))
            print(f"{NomeP} agora tem {quantidade - quant}\n")

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#atualizar cliente
def atualizaCliente(nome, tel, Ntel=None, Nrua=None, Ncidade=None, Nbairro=None, Nestado=None):
    id_cliente = BuscaId(nome, tel)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        campos = []
        valores = []

        if Ntel is not None:
            campos.append("tel_cliente = %s")
            valores.append(Ntel)
        if Nrua is not None:
            campos.append("rua = %s")
            valores.append(Nrua)
        if Ncidade is not None:
            campos.append("cidade = %s")
            valores.append(Ncidade)
        if Nbairro is not None:
            campos.append("bairro = %s")
            valores.append(Nbairro)
        if Nestado is not None:
            campos.append("estado = %s")
            valores.append(Nestado)

        if not campos:
            print("Nenhuma alteração feita\n")
            return

        valores.append(id_cliente)
        atua = f"update cliente set {', '.join(campos)} where id_cliente = %s"
        cursor.execute(atua, tuple(valores))

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()
    
#atualiza produto
def atualizaProd(nomeP, Nnome=None, Ndescricao=None, Nvalor=None, Nquanti=None):
    id_produto = BuscaProd(nomeP)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        campos = []
        valores = []

        if Nnome is not None:
            campos.append("nome_produto = %s")
            valores.append(Nnome)
        if Ndescricao is not None:
            campos.append("descricao_pro = %s")
            valores.append(Ndescricao)
        if Nvalor is not None:
            campos.append("valor = %s")
            valores.append(Nvalor)
        if Nquanti is not None:
            campos.append("quanti_pro = %s")
            valores.append(Nquanti)

        if not campos:
            print("Nenhuma alteração feita\n")
            return

        valores.append(id_produto)
        atua = f"update produto set {', '.join(campos)} where id_produto = %s"
        cursor.execute(atua, tuple(valores))

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#deletar cliente
def mataCliente(nome, tel):
    id_cliente = BuscaId(nome, tel)
    conex = conecta(config)
    try:
        cursor= conex.cursor()
        if id_cliente is None:
            print("Esse cliente nao existe\n")
            return
        
        mata = "Delete from cliente where id_cliente = %s"
        cursor.execute(mata, (id_cliente,))
        print(f"o cliente {nome} de id = {id_cliente} foi retirado do sistema\n")

        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()
    
#deleta produto
def mataProduto(nomeP):
    id_prod = BuscaProd(nomeP)
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        if id_prod is None:
            print("Esse produto nao existe\n")
            return
        
        deleta = "Delete from produto where id_produto = %s"
        cursor.execute(deleta, (id_prod,))
        print(f"O produto {nomeP} e id = {id_prod} foi retirado do sistema\n")


        conex.commit()
    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#consultas ao banco de dados
#quantidade de usuários, id nome e cidade
def Usuarios():
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        quant = "select count(*) from cliente"
        cursor.execute(quant)
        quantidade = cursor.fetchone()[0]
        print(f"Seu sistema tem {quantidade} usuarios:")
        usu = "select * from cliente"
        cursor.execute(usu)
        result = cursor.fetchall()
        for i in result:
            print(f"Id = {i[0]} | nome = {i[1]} | cidade = {i[5]}")

    except Error as e:
        conex.rollback()
        print(f"ihh erro {e}\n")
    finally:
        cursor.close()
        conex.close()

#pagamento mais usado 
#usei procedure
def PagamentoMais():
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        cursor.execute("call MetodoMais()")
        dados = cursor.fetchall()
        if not dados:
            print("Nenhum pagamento feito\n")
            return
        for i in dados:
            print(f"Metodo mais usado: {i[0]} | quantidade: {i[1]}")

    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()

#Filtro de usuários por bairro, cidade, estado
def FiltraLocal(Bairro=None, Cidade=None, Estado=None):
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        campos = []
        valores = []

        if Bairro is not None:
            campos.append("bairro = %s")
            valores.append(Bairro)
        if Cidade is not None:
            campos.append("cidade = %s")
            valores.append(Cidade)
        if Estado is not None:
            campos.append("estado = %s")
            valores.append(Estado)
        if not campos:
            print("Nenhum filtro aplicado\n")
            Usuarios()
            return
        
        usu = f"select * from cliente where {' and '.join(campos)}"
        cursor.execute(usu, tuple(valores))
        result = cursor.fetchall()
        print(f"Filtrado por {valores}")
        for i in result:
            print(f"Id = {i[0]} | nome = {i[1]} ")


    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()

#Média anual de venda (por valor)
#procedure
def MediAnual():
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        cursor.execute("call MediaPedidosAno()")
        dados = cursor.fetchall()
        if not dados:
            print("Nao teve vendas\n")
            return
        for i in dados:
            print(f"Ano: {i[0]} | Media de valor: {i[1]}")

    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()
    
#Mes e ano com maior num de vendas
#procedure
def M_A_Vendas():
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        cursor.execute("call MaiorVendasM_A()")
        dados = cursor.fetchall()
        if not dados:
            print("Nao teve vendas\n")
            return
        for i in dados:
            print(f"Ano: {i[0]} | Mes: {i[1]} | Pedidos feitos: {i[2]}")

    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()

#clientes com compras todos os meses de um ano x
#procedure
def ClienteAnual(ano):
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        cursor.execute("call ClienteAnual(%s)", (ano,))
        dados = cursor.fetchall()
        if not dados:
            print(f"Nao houve clientes com compras todos os meses no ano {ano}")
            return
        for i in dados:
            cli = "select nome_cliente from cliente where id_cliente = %s"
            cursor.execute(cli, (i[0],))
            nome = cursor.fetchone()
            print(f"Cliente: {nome[0]} | id: {i[0]} ")

    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()

#Produto mais vendido CONSULTA EXTRA
#procedure
def ProdutoMais():
    conex = conecta(config)
    try:
        cursor = conex.cursor()
        cursor.execute("call ProdutoMais()")
        dados = cursor.fetchall()
        if not dados:
            print("Nao houve venda\n")
            return
        
        j = 1
        for i in dados:
            print(f" {j}° Produto: {i[0]} | Quantidade: {i[1]} ")
            j += 1
    except Error as e:
        print(f"ihh erro {e}")
    finally:
        cursor.close()
        conex.close()


#--------------------------------------------------main teste------------------------------------------------------------------------

#for i in range (2):
    #nomeprod = input("Qual nome do produto?: ")
    #descricao = input("Descricao: ")
    #valor = input("Valor: ")
    #quanti = input("Quanti: ")

    #NovoProdu(nomeprod, descricao, valor, quanti)

#Pro = input("Qual: ")
#quant = int(input("quant: "))

nome = "Giulia"
#nasc = input("Qual seu aniversario, AAAA-MM-DD :")
tel = 989933867
#Cidade = "petropolis"
#Bairro  = "Centro"
#rua = input("Rua: ")
Estado = "rio de janeiro"
#login = input("login: ")
#senha = input("senha: ")

#NovoCliente(nome, nasc, tel, rua, cidade, bairro, estado)
#NovoWeb(login, senha, nome, tel)

#AddItemCarr(nome, tel, Pro, quant)

#visuCar(nome, tel)

#Pedido(nome, tel)

#visuPedi(nome, tel)

#Usuarios()

#PagamentoMais()

#FiltraLocal(Estado=Estado)

#MediAnual()

#M_A_Vendas()

#ClienteAnual(2026)

#ProdutoMais()
