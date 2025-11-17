# APBD 2025.2 — Projeto Olist (PostgreSQL)

Repositório do projeto colaborativo da disciplina **Administração e Banco de Dados (APBD)**.

Aqui manteremos scripts SQL, modelo de dados, consultas, otimizações e documentação referentes à implementação do banco Olist no PostgreSQL.

---

## 🎯 Objetivo
Criar o banco de dados Olist, importar os datasets, configurar integridade, gerar consultas analíticas, otimizar o desempenho, implementar auditoria e definir uma estratégia de backup.

---

## 🗂 Estrutura planejada

modelo/                     
│── → DER e documentação de modelagem

ddl/                        
│── → Scripts CREATE TABLE, PK, UNIQUE e constraints

dml/                        
│── → Carga dos CSVs, limpeza e ajustes pós-carga
    └── carga/ → scripts de importação

dcl/                        
│── → Usuários e permissões

dql/                        
│── → Consultas analíticas
    └── consultas/ → consultas

otimizacao/                 
│── → Índices, EXPLAIN ANALYZE, ajustes de performance
    ├── explain_antes/
    └── explain_depois/

auditoria/                  
│── → Tabelas e triggers de auditoria

backup/                     
│── → Estratégias e scripts de backup
    └── scripts_backup/

docs/                       
│── → Relatório final e documentação
    └── evidencias/ → prints e resultados

