variable "numero_exemplo" {
    description = "Exemplo variavel numero"
    type = number
    default = 123
}

variable "lista_exemplo" {
    description = "Exemplo variavel lista"
    type = list
    default = ["a", "b", "c"]
}

variable "map_exemplo" {
    description = "Exemplo variavel map"
    type = map(string)

    default = {
        chave1 = "valor1"
        chave2 = "valor2"
        chave3 = "valor3"
    }
}

variable "object_example" {
    description = "Exemplo variavel objeto"
    type = object({
        nome = string
        idade = number
        tags = list(string)
        ativo = bool
    })

    default = {
        nome = "Teste"
        idade = 123
        tags = ["a", "b", "c"]
        ativo = true
    }
}
