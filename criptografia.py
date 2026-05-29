import hashlib as hash
import bcrypt as cry


#def SenHash(senha):
#   bytesSenha = senha.encode('utf-8')
#    objhash = hash.sha256(bytesSenha)
#    Senhahash = objhash.hexdigest()
#    return Senhahash

def SenHash(senha):
    senhaBytes = senha.encode('utf-8')
    salzin = cry.gensalt()
    senhahash = cry.hashpw(senhaBytes, salzin)
    return senhahash

def Confia(SenhaDig, HashCerto):
    senhaByte = SenhaDig.encode('utf-8')
    if cry.checkpw(senhaByte, HashCerto):
        print("Senha certinha!!")
        return True
    else:
        print("Senha errada!")
        return False



