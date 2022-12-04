create database trainee;

-- use trainee; -- para executar apenas um comando, selecione ele e aperte f5(Executar)

create schema locacao;

create table locacao.cliente(
	cd_cliente int primary key identity(1,1),			-- o int cria o cliente de forma automatica. Começa no 1 e aumenta de 1 em 1. O identity gera um código diferente a cada inserção de cliente
	nm_cliente varchar(50) not null,					-- apesar de não ser chave, nm_cliente é um campo obrigatório
);

create table locacao.classificacao(
	cd_classificacao int primary key,
	vl_locacao_diaria money not null,			
);

create table locacao.categoria(
	sg_categoria char(2) primary key,					-- char 1: possui 2 caracteres
	nm_categoria varchar(30)  not null,			
);

create table locacao.solicitacao(
	cd_solicitacao int primary key identity(1,1),
	cd_cliente int not null,							-- pode se repetir, pois um cliente pode fazer várias solicitações || o identity acontece quando nao pode repetir e o int for uma chave
	dt_solicitacao date not null,

	foreign key (cd_cliente) references 
		locacao.cliente(cd_cliente)						-- não precisa de virgula antes da exceção 
														-- independente de ser chave ou nao, por ter estrangeiro, faz a exceção
	on delete cascade									-- Ao excluir um cliente, exlui automaticamente todas as solicitações. || A ação depende da regra que quer
	on update cascade

	-- Restrições: inclusão (chave primária); exclusão e atualizar
	-- Sempre que houver atributo estrangeiro, usa exceção
);

create table locacao.filme(
	cd_filme int primary key identity(1,1),
	nm_filme varchar(50) not null,
	sg_categoria char(2),
	cd_classificacao int

	foreign key (sg_categoria) references locacao.categoria(sg_categoria)
	on delete set null									-- se exclui fica nulo
	on update cascade,									-- atualiza em cascata
	
	foreign key (cd_classificacao) references locacao.classificacao(cd_classificacao)
	on delete set null									-- se exclui um filme, fica nulo
	on update cascade									-- atualiza em cascata
);

create table locacao.solicitacao_filme(
	cd_filme int not null,							
	cd_solicitacao int not null,
	dt_devolucao_prevista date not null,
	dt_devolucao_real date,								-- não obrigatória, pois não há sentido em colocar a data real hora de inserir
	
	primary key(cd_filme, cd_solicitacao),
	foreign key(cd_filme) references locacao.filme(cd_filme)
	on delete cascade
	on update cascade,

	foreign key(cd_solicitacao) references locacao.solicitacao(cd_solicitacao)
	on delete cascade
	on update cascade
);

---------------------------------------

begin transaction;
-- insere dentro da tabela categoria os seguintes valores
insert into locacao.categoria (sg_categoria, nm_categoria)
values ('D', 'Drama'), ('A', 'Aventura'), ('FC', 'Ficção Científica'), ('C', 'Comédia'), ('R', 'Romance');	
commit;

insert into locacao.categoria(sg_categoria, nm_categoria)
values ('F', 'Fantasia');

select * from locacao.categoria;			-- mostra a tabela

--------------- PRÁTICA ---------------

begin transaction;
insert into locacao.cliente(nm_cliente)
values 
	('André'), ('Carol'), ('Gusta'), ('Ketty'), ('Math');			-- como o identity cria os códigos automaticamente, não precisa incluir os códigos aqui
commit;
select * from locacao.cliente;

-----
begin transaction;
insert into locacao.classificacao(cd_classificacao, vl_locacao_diaria)
values	
	(001, 1.50),
	(002, 3.00),
	(003, 4.50);
commit;
select * from locacao.classificacao;

-----
begin transaction;
insert into locacao.filme(nm_filme, sg_categoria, cd_classificacao)
values 
	('Harry Potter e a Pedra filosofal', 'F', 002), 
	('Star Wars: O Ataque dos Clones', 'FC', 002),  
	('Pantera Negra', 'A', 003), 
	('As Estrelas Além do Tempo', 'D', 003),  
	('O Galinho Chicken Little', 'C', 001);
commit;
select * from locacao.filme;

-----
begin transaction;
insert into locacao.solicitacao(cd_cliente, dt_solicitacao)
values 
	(1, '2022-12-01'),
	(1, '2022-12-09'),
	(2, '2022-12-03'),
	(2, '2022-12-06'),
	(3, '2022-12-09'),
	(4, '2022-11-30'),
	(4, '2022-12-03'),
	(4, '2022-12-13'),
	(5, '2022-12-13'),
	(5, '2022-12-17');
commit;
select * from locacao.solicitacao;

-----
begin transaction;
insert into locacao.solicitacao_filme(cd_filme, cd_solicitacao, dt_devolucao_prevista, dt_devolucao_real)
values 
	(1, 1, '2022-12-08', '2022-12-02'),
	(3, 1, '2022-12-08', '2022-12-02'),
	(3, 2, '2022-12-16', '2022-12-10'),
	(5, 2, '2022-12-16', '2022-12-10'),
	(1, 3, '2022-12-10', '2022-12-06'),
	(5, 3, '2022-12-10', '2022-12-06'),
	(4, 4, '2022-12-13', '2022-12-13'),
	(5, 4, '2022-12-13', '2022-12-13'),
	(1, 5, '2022-12-16', '2022-12-17'),
	(4, 5, '2022-12-16', '2022-12-17'),

	(1, 6, '2022-12-07', '2022-12-07'),
	(2, 6, '2022-12-07', '2022-12-03'),
	(3, 7, '2022-12-03', '2022-12-06'),
	(4, 7, '2022-12-03', '2022-12-06'),
	(5, 8, '2022-12-20', '2022-12-18'),
	(2, 8, '2022-12-20', '2022-12-18'),
	(5, 9, '2022-12-20', '2022-12-18'),
	(2, 10, '2022-12-16', '2022-12-17'),
	(3, 11, '2022-12-24', '2022-12-22'),
	(1, 11, '2022-12-24', '2022-12-22');
commit;
select * from locacao.solicitacao_filme;



alter table locacao.classificacao
add nm_Classificacao varchar(30) not null;

