variable "objeto_com_erro" {
    description = "Objeto de exemplo com erro"
    type = object({
      nome = string
      idade = number
      tags = list(string)
      ativo = bool 
    })

    default = {
        nome = "Erro"
        idade = 42
        tags = ["a", "b", "c"]
        ativo = "invalido"
    }
}