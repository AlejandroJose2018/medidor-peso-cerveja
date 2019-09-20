### Descrição geral 

Trabalho final de IoT

A ideia principal era a criação de um medidor de peso para cervejas de garrafa. Sua aplicação seria voltada para bares/restaurantes avisando ao garçom quando uma cerveja está acabando para que ele entregue outra. 

O produto final foi um prótotipo utilizando o arduino Wemos D1 R1 com comunicação WiFi para transmissão de dados. A princípio utilizamos um potenciômetro para **simular** o peso da garrafa.

Nesse repositório você encontra o código base para a comunicação do sensor e também para o aplicativo mobile que avisa o garçom.

### Etapas

- O Wemos se conecta à uma rede Wi-Fi;
- Faz a medição do potenciômetro através da porta analógica A0;
- Após medição realiza uma requisição HTTP PUT para enviar os dados coletados à uma API;
- A API faz a consistência dos dados;
- O Aplicativo Mobile faz a leitura dos dados da API e emite um alerta ao garçom caso o **peso** da garrafa fique abaixo do esperado, ou seja, a garrafa vazia.

### Grupo
- [Lucas de Sousa Medeiros](https://github.com/bylucasxdx)
- [Lucas Henrique Duarte Pereira](https://github.com/lucashdp)
- [Prince Sanis Silva de Souza](https://github.com/princesanis)
- [Wellington Jesus da Conceição](https://github.com/weto)