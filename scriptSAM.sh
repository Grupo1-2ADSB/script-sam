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
        sudo usermod -aG sudo ubuntu
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
                echo "Docker já está instalado!"
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
        sudo docker pull mysql:5.7
        sudo docker run -d -p 3306:3306 --name BancoSAM -e "MYSQL_DATABASE=sam" -e "MYSQL_ROOT_PASSWORD=Gfgrupo1" mysql:5.7
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
    descricaoAlerta VARCHAR(255) NOT NULL,
    perAlerta DOUBLE NOT NULL
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
    CONSTRAINT fkAlerta FOREIGN KEY (fkAlerta) REFERENCES tbAlerta(idAlerta)
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
    fkUsuario INT,
    CONSTRAINT fkUsuario FOREIGN KEY (fkUsuario) REFERENCES tbUsuario(idUsuario)
);

CREATE TABLE tbConfig (
    idConfig INT PRIMARY KEY AUTO_INCREMENT,
    fkMaquina INT,
    CONSTRAINT fkMaquina FOREIGN KEY (fkMaquina) REFERENCES tbMaquina(idMaquina),
    fkComponente INT,
	FOREIGN KEY (fkComponente) REFERENCES tbComponente(idComponente)
);

CREATE TABLE tbLeitura (
    idLeitura INT PRIMARY KEY AUTO_INCREMENT,
    leitura DOUBLE NOT NULL,
    dataHoraLeitura DATETIME DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fkConfig INT,
    CONSTRAINT fkConfig FOREIGN KEY (fkConfig) REFERENCES tbConfig(idConfig),
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

INSERT INTO tbPermissao VALUES (NULL, 'ADMINISTRADOR', 'ADM');
INSERT INTO tbPermissao VALUES (NULL, 'ATENDENTE', 'ATN');
INSERT INTO tbPermissao VALUES (NULL, 'SUPORTE', 'NOC');

INSERT INTO tbEmpresa VALUES
	(NULL, '1010101010106', 'CSU', 'Ricardo', '06315200', 12, '12345678901234'),
	(NULL, '2020202020207', 'Infinit', 'Marcia', '06315100', 1, '32345678901234');

INSERT INTO tbAlerta VALUES
	(NULL, 'Vermelho', 'Máquina apresenta falhas críticas.', 32.4),
	(NULL, 'Amarelo', 'Máquina prestes a travar.', 22.3);

INSERT INTO tbUnidade (nome, sigla) VALUES
	('Gigabytes', 'GB'),
	('Terabytes', 'TB'),
	('Megahertz', 'MHz'),
	('Gigahertz', 'GHz'),
	('Megabits por segundo', 'MBPS'),
	('Rotação por segundo', 'RPM');

INSERT INTO tbTipoComponente (tipoComponente) VALUES 
	('Memória RAM'),
	('Disco Rígido'),
	('Placa de Rede'),
	('CPU');

INSERT INTO tbComponente VALUES 
	(NULL, 'Ram', '4GB', 1),
	(NULL, 'Disco rígido Seagate Barracuda', '2TB', 2);

INSERT INTO tbAlertaComponente (fkTipoComponente, fkAlerta) VALUES
	(1, 1), 
	(1, 2), 
	(2, 1), 
	(2, 2),
	(3, 1),
	(3, 2);

INSERT INTO tbMaquina (nSerie, statusMaquina, modeloMaquina, tipoDisco, marca, tipoMaquina, sistemaOperacional, arquiteturaCPU) VALUES 
	('001', 'Ativo', 'Modelo A', 'SSD', 'Marca 1', 'Notebook', 'Linux', 64),
	('002', 'Inativo', 'Modelo B', 'HD', 'Marca 2', 'Desktop', 'Windows', 32);

INSERT INTO tbUsuario VALUES (NULL, 'host1', 'Marcio', 'marcio@gmail.com', 'senha123', 'Disponível', 1, 1, 1);
INSERT INTO tbUsuario VALUES (NULL, 'host02', 'Joana', 'joana@gmail.com', 'senha123', 'Disponível', 2, 2, 2);

INSERT INTO tbConfig VALUES
	(NULL,  1, 1),
	(NULL,  2, 2);

INSERT INTO tbLeitura VALUES
	(NULL, 0.25, NOW(), 1, 1),
	(NULL, 50.17, NOW(), 2, 2);

INSERT INTO tbUnidadeComponente (fkTipoComponente, fkUnidade) VALUES
	(1, 1), 
	(1, 2), 
	(2, 1),
	(2, 2), 
	(2, 6),
	(3, 5), 
	(4, 3), 
	(4, 4); 
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