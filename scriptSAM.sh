#!/bin/bash
echo " 
   _____                       _                        _       _   _      
  / ____|                    | |     /\               | |     | | (_)     
 | (___  _ __ ___   __ _ _ __| |_   /  \   _ __   __ _| |_   _| |_ _  ___ 
  \___ \| _  _ \ / _ | __| __| / /\ \ | _ \ / _ | | | | | __| |/ __|
  ____) | | | | | | (_| | |  | |_ / ____ \| | | | (_| | | |_| | |_| | (__ 
 |_____/|_| |_| |_|\__,_|_|   \__/_/    \_\_| |_|\__,_|_|\__, |\__|_|\___|
                 __  __            _     _                __/ |           
                |  \/  |          | |   (_)              |___/            
                | \  / | __ _  ___| |__  _ _ __   ___                     
                | |\/| |/ _ |/ __| _ \| | _ \ / _ \                    
                | |  | | (_| | (__| | | | | | | |  __/                    
                |_|  |_|\__,_|\___|_| |_|_|_| |_|\___|                               
"
sleep 2
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Olá :D seja bem-vindo!"
sleep 2
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Sou a Samira! Assistente da Smart Analytic Machine(SAM) Muito prazer!!!"
sleep 2
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Estou aqui para te ajudar a instalar a aplicação Smart Analytic Machine!"
sleep 2
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Gostaria de fazer a instalação? (y/n)"
sleep 2
read resp1
if [ $resp1 = "y" ]
then 
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Legal! Você aceitou instalar a aplicação Smart Analytic Machine!"
        sleep 2
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Irei preparar o ambiente na sua máquina!"
        sleep 2
        sudo apt update && sudo apt upgrade -y
        clear
        sudo usermod -a -G sudo ubuntu
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Antes de instalar irei verificar se você possui os recursos para a nossa aplicação"
        sleep 1
        echo "Analisando."
        sleep 1
        echo "Analisando.."
        sleep 1
        echo "Analisando..."
        sleep 2

        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Verificando Java..."
        sleep 1
        java --version
        if [ $? -eq 0 ]
        then
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Legal!"
                sleep 2
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Java já esta instalado!"
                sleep 2
        else 
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Java não instalado!"
                sleep 2
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Instalando o Java..."
                sleep 2
                sudo apt install openjdk-17-jdk openjdk-17-jre -y
        fi
        
        clear
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Verificando Docker..."
        sleep 2
        docker --version
        if [ $? -eq 0 ]
        then 
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Legal!"
                sleep 2
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Docker já está instalado!"
                sleep 2
        else 
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Docker não instalado!"
                sleep 2
                echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Instalando o Docker..."
                sleep 2
                sudo apt install docker.io -y             
        fi

        clear
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Configurando Docker..."
        sleep 1
        sudo systemctl start docker
        sudo systemctl enable docker
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Criando banco de dados local..."
        sudo docker pull mysql:8
        sudo docker run -d -p 3306:3306 --name BancoSAM -e "MYSQL_DATABASE=sam" -e "MYSQL_ROOT_PASSWORD=Gfgrupo1" mysql:8
        sleep 20
        sudo docker ps -a
        sudo docker exec -i BancoSAM mysql -uroot -pGfgrupo1 -e "USE sam;
        CREATE TABLE tbPermissao (
    idPermissao INT PRIMARY KEY AUTO_INCREMENT,
    tipoPermissao VARCHAR(100) NOT NULL,
    sigla CHAR(4) NOT NULL
);

CREATE TABLE tbEmpresa (
    idEmpresa INT PRIMARY KEY AUTO_INCREMENT,
    funcionalEmpresa VARCHAR(13) NOT NULL,
    razaoSocial VARCHAR(120) NOT NULL,
    responsavelLegal VARCHAR(120) NOT NULL,
    CEP CHAR(8) NOT NULL,
    numero INT NOT NULL,
    cnpj VARCHAR(14) UNIQUE NOT NULL
);

CREATE TABLE tbAlerta (
    idAlerta INT PRIMARY KEY AUTO_INCREMENT,
    tipoAlerta VARCHAR(45) NOT NULL,
    CONSTRAINT chkTipoAlerta CHECK (tipoAlerta IN ('Amarelo', 'Vermelho')),
    descricaoAlerta VARCHAR(255) NOT NULL
);

CREATE TABLE tbUnidade (
    idUnidade INT PRIMARY KEY AUTO_INCREMENT,
    nome VARCHAR(45) NOT NULL,
    sigla CHAR(5) NOT NULL
);

CREATE TABLE tbTipoComponente (
    idTipoComponente INT PRIMARY KEY AUTO_INCREMENT,
    tipoComponente VARCHAR(45) NOT NULL
);

CREATE TABLE tbComponente (
    idComponente INT PRIMARY KEY AUTO_INCREMENT,
    nomeComponente VARCHAR(55) NOT NULL,
    capacidadeComponente VARCHAR(45) NOT NULL,
    fkTipoComponente INT,
    CONSTRAINT fkTipoComponente FOREIGN KEY (fkTipoComponente) REFERENCES tbTipoComponente(idTipoComponente)
);

CREATE TABLE tbAlertaComponente (
    idAlertaComponente INT PRIMARY KEY AUTO_INCREMENT,
    fkTipoComponente INT,
    FOREIGN KEY (fkTipoComponente) REFERENCES tbTipoComponente(idTipoComponente),
    fkAlerta INT,
    CONSTRAINT fkAlerta FOREIGN KEY (fkAlerta) REFERENCES tbAlerta(idAlerta),
    perAlerta DOUBLE NOT NULL
);

CREATE TABLE tbMaquina (
    idMaquina INT PRIMARY KEY AUTO_INCREMENT,
    nSerie VARCHAR(45) NOT NULL,
    statusMaquina VARCHAR(25) NOT NULL,
    CONSTRAINT chkStatusMaquina CHECK (statusMaquina IN ('Ativo', 'Inativo', 'Manutenção')),
    modeloMaquina VARCHAR(45) NOT NULL,
    tipoDisco VARCHAR(45) NOT NULL,
    CONSTRAINT chkTipoDisco CHECK (tipoDisco IN ('SSD', 'HD')),
    marca VARCHAR(45) NOT NULL,
    tipoMaquina VARCHAR(45) NOT NULL,
    CONSTRAINT chkTipoMaquina CHECK (tipoMaquina IN ('Notebook', 'Desktop')),
    dataManutencao DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    sistemaOperacional VARCHAR(45) NOT NULL,
    CONSTRAINT chkSo CHECK (sistemaOperacional IN ('Linux', 'Windows')),
    arquiteturaCPU INT NOT NULL DEFAULT 64
);

CREATE TABLE tbUsuario (
    idUsuario INT PRIMARY KEY AUTO_INCREMENT,
    hostName VARCHAR(45),
    nomeUsuario VARCHAR(120) NOT NULL UNIQUE,
    emailUsuario VARCHAR(120) NOT NULL UNIQUE,
    CONSTRAINT chkEmailUsuario CHECK(emailUsuario LIKE '%@%'),
    senhaUsuario VARCHAR(45) NOT NULL,
    statusUsuario VARCHAR(25) DEFAULT 'Disponível',
    CHECK (statusUsuario IN ('Disponível', 'Indisponível')),
    fkEmpresa INT,
    CONSTRAINT fkEmpresa FOREIGN KEY (fkEmpresa) REFERENCES tbEmpresa(idEmpresa),
    fkPermissao INT,
    CONSTRAINT fkPermissao FOREIGN KEY (fkPermissao) REFERENCES tbPermissao(idPermissao),
    fkMaquina INT,
    FOREIGN KEY (fkMaquina) REFERENCES tbMaquina(idMaquina)
);

CREATE TABLE tbLog (
    idLog INT PRIMARY KEY AUTO_INCREMENT,
    dataLog DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    tituloLog VARCHAR(45) NOT NULL,
    descricaoLog VARCHAR(255) NOT NULL,
    solucaoLog VARCHAR(255) NOT NULL,
    tipoAlerta VARCHAR(45) NOT NULL,
        CONSTRAINT chkTipoAlertaL CHECK(tipoAlerta IN('Amarelo','Vermelho')),
     tipoComponente VARCHAR(45) NOT NULL,
     fkUsuario INT,
     CONSTRAINT fkUsuario FOREIGN KEY(fkUsuario) REFERENCES tbUsuario(idUsuario)
);

CREATE TABLE tbConfig (
    idConfig INT PRIMARY KEY AUTO_INCREMENT,
    fkMaquina INT,
     CONSTRAINT fkMaquina FOREIGN KEY(fkMaquina) REFERENCES tbMaquina(idMaquina),
     fkComponente INT,
     FOREIGN KEY (fkComponente) REFERENCES tbComponente(idComponente)
);

CREATE TABLE tbLeitura (
    idLeitura INT PRIMARY KEY AUTO_INCREMENT,
    leitura VARCHAR(100) NOT NULL,
     dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
     fkConfig INT,
     CONSTRAINT fkConfig FOREIGN KEY(fkConfig) REFERENCES tbConfig(idConfig),
     fkAlertaComponente INT,
     CONSTRAINT fkAlertaComponente FOREIGN KEY (fkAlertaComponente) REFERENCES tbAlertaComponente(idAlertaComponente)
);

CREATE TABLE tbUnidadeComponente (
    idUnidadeComponente INT PRIMARY KEY AUTO_INCREMENT,
    fkTipoComponente INT,
    CONSTRAINT fkUnidadeComponenteTipo FOREIGN KEY (fkTipoComponente) REFERENCES tbTipoComponente(idTipoComponente),
    fkUnidade INT,
    CONSTRAINT fkUnidadeComponenteUnidade FOREIGN KEY (fkUnidade) REFERENCES tbUnidade(idUnidade)
);

INSERT INTO tbPermissao VALUES
    (NULL, 'ADMINISTRADOR', 'ADM'),
    (NULL, 'ATENDENTE', 'ATN'),
    (NULL, 'SUPORTE', 'NOC');

INSERT INTO tbEmpresa VALUES
    (NULL, '1010101010106', 'CSU', 'Ricardo', '06315200', 12, '12345678901234'),
    (NULL, '2020202020207', 'Infinit', 'Nicholas', '06315100', 1, '32345678901234'),
    (NULL, '3030303030308', 'ABC Company', 'Laura', '06315300', 3, '92345678901234'),
    (NULL, '4040404040409', 'XYZ Corp', 'Daniel', '06315400', 4, '52345678901234'),
    (NULL, '5050505050501', 'Tech Solutions', 'Gabriela', '06315500', 5, '72345678901234'),
    (NULL, '6060606060602', 'Acme Inc.', 'Luiz', '06315600', 6, '82345678901235'),
    (NULL, '7070707070703', 'Inovação Ltda', 'Mariana', '06315700', 7, '62345678901236'),
    (NULL, '8080808080804', 'Global Corp', 'Ana', '06315800', 8, '42345678901237'),
    (NULL, '9090909090905', 'Tech Solutions', 'Rodrigo', '06315900', 9, '22345678901238'),
    (NULL, '1111111111116', 'ABC Company', 'Carolina', '06316000', 11, '82345678901239');

INSERT INTO tbAlerta VALUES
    (NULL, 'Vermelho', 'Máquina apresenta falhas críticas.'),
    (NULL, 'Amarelo', 'Máquina prestes a travar.');

INSERT INTO tbUnidade VALUES
    (NULL, 'Gigabytes', 'GB'),
    (NULL, 'Gigahertz', 'GHz'),
    (NULL, 'Megabits por segundo', 'MBPS');   

INSERT INTO tbTipoComponente VALUES 
    (NULL, 'Memória RAM'),
    (NULL, 'Disco Rígido'),
    (NULL, 'Placa de Rede'),
    (NULL, 'CPU');

INSERT INTO tbComponente VALUES
    (NULL, 'Ram Kingston', '4', 1),
    (NULL, 'Ram Corsair', '4', 1),
    (NULL, 'Ram G.Skill', '4', 1),
    (NULL, 'Disco rígido Seagate Barracuda', '2', 2),
    (NULL, 'Disco rígido Western Digital', '2', 2),
    (NULL, 'Disco rígido Toshiba', '2', 2),
    (NULL, 'Placa de rede TP-Link', '400', 3),
    (NULL, 'Placa de rede D-Link', '400', 3),
    (NULL, 'Placa de rede Intel', '400', 3),
    (NULL, 'CPU Intel Core i7', '3.6', 4),
    (NULL, 'CPU AMD Ryzen 7', '3.6', 4),
    (NULL, 'CPU Intel Core i9', '3.6', 4);

INSERT INTO tbAlertaComponente VALUES
    (NULL, 1, 1, 32.4), 
    (NULL, 1, 2, 22.3), 
    (NULL, 2, 1, 45.1), 
    (NULL, 2, 2, 19.8),
    (NULL, 3, 1, 55.7),
    (NULL, 3, 2, 18.6),
    (NULL, 4, 1, 60.2),
    (NULL, 4, 2, 12.9),
    (NULL, 1, 2, 60.2),
    (NULL, 1, 1, 60.2);
    

INSERT INTO tbMaquina (nSerie, statusMaquina, modeloMaquina, tipoDisco, marca, tipoMaquina, sistemaOperacional, arquiteturaCPU) VALUES
    ('001', 'Ativo', 'Modelo A', 'SSD', 'Marca 1', 'Notebook', 'Linux', 64),
    ('002', 'Ativo', 'Modelo B', 'HD', 'Marca 2', 'Desktop', 'Windows', 32),
    ('003', 'Ativo', 'Modelo C', 'SSD', 'Marca 3', 'Notebook', 'Linux', 32),
    ('004', 'Ativo', 'Modelo D', 'SSD', 'Marca 4', 'Desktop', 'Windows', 64),
    ('005', 'Ativo', 'Modelo E', 'HD', 'Marca 5', 'Notebook', 'Linux', 64),
    ('006', 'Ativo', 'Modelo F', 'HD', 'Marca 6', 'Notebook', 'Windows', 32),
    ('007', 'Ativo', 'Modelo G', 'HD', 'Marca 7', 'Desktop', 'Linux', 32);
    
INSERT INTO tbUsuario VALUES
 (NULL, 'host01', 'Leonardo', 'leo@gmail.com', 'senha123', 'Disponível', 1, 1, 1),
 (NULL, 'host02', 'Alexander', 'ale@gmail.com', 'senha123', 'Disponível', 2, 2, 2),
 (NULL, 'host03', 'Eduardo', 'edu@gmail.com', 'senha123', 'Disponível', 3, 1, 3),
 (NULL, 'host04', 'Giovana', 'giovana@gmail.com', 'senha123', 'Disponível', 4, 1, 4),
 (NULL, 'host05', 'Isabella', 'isabella@gmail.com', 'senha123', 'Disponível', 5, 1, 5),
 (NULL, 'host06', 'grupo', 'grupo@gmail.com', 'senha123', 'Disponível', 6, 1, 6),
 (NULL, 'host07', 'Gabriel', 'gabs@gmail.com', 'senha123', 'Disponível', 7, 1, 7);

INSERT INTO tbLog VALUES
(NULL, NOW(), 'Erro de Sistema', 'O sistema apresentou falhas', 'Reiniciar', 'Vermelho', 'CPU', 1),
(NULL, NOW(), 'Erro de Sistema', 'O sistema apresentou falha', 'Reiniciar', 'Vermelho', 'CPU', 2),
(NULL, NOW(), 'Erro de Sistema', 'O sistema apresentou falha', 'Reiniciar', 'Vermelho', 'CPU', 3),
(NULL, NOW(), 'Sistema em Alerta', 'Tome cuidado', 'Reiniciar', 'Amarelo', 'CPU', 3);

INSERT INTO tbConfig VALUES
    (NULL, 1, 1), (NULL, 1, 4), (NULL, 1, 7), (NULL, 1, 10),
    (NULL, 2, 2), (NULL, 2, 5), (NULL, 2, 8), (NULL, 2, 11),
    (NULL, 3, 3), (NULL, 3, 6), (NULL, 3, 9), (NULL, 3, 12),
    (NULL, 4, 1), (NULL, 4, 4), (NULL, 4, 7), (NULL, 4, 10),
    (NULL, 5, 1), (NULL, 5, 4), (NULL, 5, 7), (NULL, 5, 10),
    (NULL, 6, 1), (NULL, 6, 4), (NULL, 6, 7), (NULL, 6, 10),
    (NULL, 7, 1), (NULL, 7, 4), (NULL, 7, 7), (NULL, 7, 10);

INSERT INTO tbLeitura (leitura, dataHoraLeitura, fkConfig, fkAlertaComponente) VALUES
    ('70.3', NOW(), 1, 1),
    ('70.3', NOW(), 2, 1),
    ('70.3', NOW(), 3, 1),
    ('70.3', NOW(), 4, 1),
    ('1.2', NOW(), 5, 2),
    ('1.2', NOW(), 6, 2),
    ('1.2', NOW(), 7, 2),
    ('1.2', NOW(), 8, 2),
    ('6.35', NOW(), 9, 3),
    ('6.35', NOW(), 10, 3),
    ('6.35', NOW(), 11, 3),
    ('6.35', NOW(), 12, 3),
    ('15.25', NOW(), 13, 4),
    ('15.25', NOW(), 14, 4),
    ('15.25', NOW(), 15, 4),
    ('15.25', NOW(), 16, 4),
    ('90.28', NOW(), 17, 5),
    ('90.28', NOW(), 18, 5),
    ('90.28', NOW(), 19, 5),
    ('90.28', NOW(), 20, 5),
    ('30.18', NOW(), 21, 6),
    ('30.18', NOW(), 22, 6),
    ('30.18', NOW(), 23, 6),
    ('30.18', NOW(), 24, 6),
    ('30.18', NOW(), 25, 7),
    ('30.18', NOW(), 26, 7),
    ('30.18', NOW(), 27, 7),
    ('30.18', NOW(), 28, 7);
    
INSERT INTO tbUnidadeComponente VALUES
    (NULL, 1, 1),
    (NULL, 2, 1),
    (NULL, 3, 3), 
    (NULL, 4, 2);
"
    sleep 10
        clear
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Banco de dados criado!"
        sleep 2
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Agora irei instalar a aplicação..."
        sleep 2
        mkdir sam && cd sam/
        git clone https://github.com/Grupo1-2ADSB/aplicacao-java.git
        cd aplicacao-java/smart-analytic-machine/target
        sudo chmod 777 smart-analytic-machine-1.0-SNAPSHOT-jar-with-dependencies.jar
        sudo chmod +x smart-analytic-machine-1.0-SNAPSHOT-jar-with-dependencies.jar
        sleep 2
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Instalação feita com sucesso!"
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Abrindo aplicação..."
        java -jar smart-analytic-machine-1.0-SNAPSHOT-jar-with-dependencies.jar
else 
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Você ja possui nossa aplicação? (y/n)"
read resp2
        if [ $resp2 = "y" ]
        then
        sudo docker start BancoSAM
        echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Abrindo aplicação..."
        cd sam/aplicacao-java/smart-analytic-machine/target
        java -jar smart-analytic-machine-1.0-SNAPSHOT-jar-with-dependencies.jar
        else 
        sleep 2
        fi
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Você NÃO ACEITOU a instalação :("
sleep 1
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Caso mude de idéia ou erro de digitação, execute novamento o script e siga os passos ;)"
sleep 1
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Caso tenha alguma dúvida, entre em contato conosco!"
sleep 1
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) smartanalyticmachine.azurewebsites.net"
echo "$(tput setaf 44)[Assistant Samira]:$(tput setaf 7) Até! ;D"
fi