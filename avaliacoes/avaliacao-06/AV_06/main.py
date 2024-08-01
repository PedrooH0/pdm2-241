from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import sqlite3
from typing import List

app = FastAPI()

# Defina o modelo de dados para o aluno
class Aluno(BaseModel):
    aluno_nome: str
    endereco: str

# Crie uma conexão com o banco de dados
def get_db_connection():
    conn = sqlite3.connect('dbalunos.db')
    conn.row_factory = sqlite3.Row
    return conn

# Crie a tabela tb_aluno se ela não existir
def create_table():
    conn = get_db_connection()
    conn.execute('''
        CREATE TABLE IF NOT EXISTS tb_aluno
        (id INTEGER PRIMARY KEY, aluno_nome TEXT, endereco TEXT)
    ''')
    conn.close()

create_table()

# Endpoint para criar um novo aluno
@app.post("/alunos/")
async def criar_aluno(aluno: Aluno):
    try:
        conn = get_db_connection()
        conn.execute("INSERT INTO tb_aluno (aluno_nome, endereco) VALUES (?, ?)",
                     (aluno.aluno_nome, aluno.endereco))
        conn.commit()
        return {"mensagem": "Aluno criado com sucesso"}
    except sqlite3.Error as e:
        raise HTTPException(status_code=500, detail=f"Erro ao criar aluno: {e}")
    finally:
        conn.close()

# Endpoint para listar todos os alunos
@app.get("/alunos/")
async def listar_alunos():
    try:
        conn = get_db_connection()
        alunos = conn.execute("SELECT * FROM tb_aluno").fetchall()
        return [{"id": aluno["id"], "aluno_nome": aluno["aluno_nome"], "endereco": aluno["endereco"]} for aluno in alunos]
    except sqlite3.Error as e:
        raise HTTPException(status_code=500, detail=f"Erro ao listar alunos: {e}")
    finally:
        conn.close()

# Endpoint para listar um aluno específico
@app.get("/alunos/{aluno_id}")
async def listar_um_aluno(aluno_id: int):
    try:
        conn = get_db_connection()
        aluno = conn.execute("SELECT * FROM tb_aluno WHERE id = ?", (aluno_id,)).fetchone()
        if aluno is None:
            raise HTTPException(status_code=404, detail="Aluno não encontrado")
        return {"id": aluno["id"], "aluno_nome": aluno["aluno_nome"], "endereco": aluno["endereco"]}
    except sqlite3.Error as e:
        raise HTTPException(status_code=500, detail=f"Erro ao listar aluno: {e}")
    finally:
        conn.close()

# Endpoint para atualizar um aluno
@app.put("/alunos/{aluno_id}")
async def atualizar_aluno(aluno_id: int, aluno: Aluno):
    try:
        conn = get_db_connection()
        conn.execute("UPDATE tb_aluno SET aluno_nome = ?, endereco = ? WHERE id = ?",
                     (aluno.aluno_nome, aluno.endereco, aluno_id))
        conn.commit()
        return {"mensagem": "Aluno atualizado com sucesso"}
    except sqlite3.Error as e:
        raise HTTPException(status_code=500, detail=f"Erro ao atualizar aluno: {e}")
    finally:
        conn.close()

# Endpoint para excluir um aluno
@app.delete("/alunos/{aluno_id}")
async def excluir_aluno(aluno_id: int):
    try:
        conn = get_db_connection()
        conn.execute("DELETE FROM tb_aluno WHERE id = ?", (aluno_id,))
        conn.commit()
        return {"mensagem": "Aluno excluído com sucesso"}
    except sqlite3.Error as e:
        raise HTTPException(status_code=500, detail=f"Erro ao excluir aluno: {e}")
    finally:
        conn.close()