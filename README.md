# autonmap

![autonmap](https://github.com/user-attachments/assets/79b6301c-f5ed-4a1e-aa26-776361616793)

`autonmap` é um script Bash desenvolvido para agilizar a varredura de redes utilizando o `nmap`, uma poderosa ferramenta para análise de segurança e testes de penetração. Este script oferece diversas opções de varredura, incluindo detecção de versões, varredura abrangente, scripts de vulnerabilidade e técnicas de evasão para evitar a detecção.

## Features

- **Validação de Entrada via Regex**: Utiliza expressões regulares para determinar se a entrada do usuário é um endereço IP ou um domínio.
- **Resolução DNS via Tor**: Resolve nomes de domínio utilizando o `tor-resolve` para maior privacidade.
- **Detecção de Versões**: Identifica as versões dos serviços em execução nas portas abertas.
- **Varredura Abrangente**: Inclui detecção de SO, detecção de versão, varredura com scripts e traceroute.
- **Scripts de Vulnerabilidade**: Utiliza scripts do `nmap` para identificar vulnerabilidades conhecidas.
- **Técnicas de Evasão**: Oferece opções para evitar a detecção por sistemas de defesa.
- **Varredura Completa de Portas**: Examina todas as portas de 1 a 65535.
- **Suporte ao Proxychains**: Permite executar varreduras através de proxies para ocultar a origem.

## Compatibilidade

- **Debian** (Testado no Kali, Debian e Ubuntu)
- **Arch** (Testado no Arch Linux e Manjaro)
- **Red Hat** (Testado no Fedora e Rocky Linux 9)

### Solução para Arch Linux

No Arch Linux, o pacote `bat` instala o executável como `bat` e não como `batcat`, que é o nome esperado pelo script. Para resolver esse problema, basta criar um link simbólico executando o seguinte comando:

```bash
sudo ln -s /usr/bin/bat /usr/local/bin/batcat
```

## Como Usar

1. **Clone o repositório**:
   ```bash
   git clone https://github.com/alexzerabr/autonmap.git && cd autonmap

2. **Torne o install.sh executável**:
   ```bash
   chmod +x install.sh 
   ```

3. **Execute o install.sh**:
   ```bash
   ./install.sh
   ```

4. **Utilize o script**:
   ```bash
   autonmap
   ```

5. **For hints**:
   ```bash
   autonmap --help
   ```

## Opções de Varredura:

- **[1]** `nmap -sV`: Detecção de versões.
- **[2]** `nmap -A`: Varredura abrangente.
- **[3-9]**: Varreduras utilizando scripts de vulnerabilidade e técnicas de evasão.

## O install.sh instala automaticamente:  

- **nmap**: Garante que o `nmap` esteja instalado em seu sistema.
- **Proxychains**: Necessário para as opções que utilizam proxychains.
- **Tor**: Necessário para a resolução DNS via Tor.

## Aviso Legal

Este script é destinado apenas para fins educacionais e de pesquisa. O autor não se responsabiliza por qualquer uso indevido desta ferramenta. Utilize-a com responsabilidade e sempre com autorização explícita.

## Contribuições

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou enviar pull requests.

## License

Este projeto está licenciado sob a [MIT License](LICENSE).

---

Created by Alexzera.
