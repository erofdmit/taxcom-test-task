import json
import sqlite3
from typing import List
import os
import chardet

PATH = os.path.curdir

# Функция для автоматического определения кодировки файла.
def detect_encoding(file_path: str) -> str:
    with open(file_path, 'rb') as file:
        result = chardet.detect(file.read())
        return result['encoding']

# Функция для чтения текстового файла с поддержкой различных разделителей.
def read_txt_file(file_path: str, delimiter: str = ',') -> List[List[str]]:
    file_path_in_sys = os.path.join(PATH, file_path)
    encoding = detect_encoding(file_path_in_sys)
    data = []
    with open(file_path_in_sys, 'r', encoding=encoding) as file:
        for line in file:
            # Удаляем лишние пробелы и кавычки, затем разделяем по указанному разделителю.
            row = [item.strip().strip('"') for item in line.strip().split(delimiter)]
            # Поменяем местами id и наименование в файле, если обнаружено, что ID содержит текст
            if row[0].isdigit() == False:
                row[0], row[1] = row[1], row[0]
            data.append(row)
    return data

# Функция для объединения и сортировки списков по второму столбцу.
def merge_and_sort(list1: List[List[str]], list2: List[List[str]]) -> List[dict]:
    merged_list = list1 + list2
    # Сортировка по второму столбцу (name)
    sorted_list = sorted(merged_list, key=lambda x: x[1])
    # Преобразование в формат списка словарей для записи в JSON и БД
    result = [{"id": row[0], "name": row[1], "additional_info": row[2] if len(row) > 2 else None} for row in sorted_list]
    return result

def save_to_json(data: List[dict], json_path: str) -> None:
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json.dump(data, json_file, ensure_ascii=False, indent=4)

def save_to_database(data: List[dict], db_path: str) -> None:
    conn = sqlite3.connect(db_path)
    cursor = conn.cursor()

    create_table_query = '''
    CREATE TABLE IF NOT EXISTS items (
        id TEXT PRIMARY KEY,
        name TEXT,
        additional_info TEXT
    );
    '''
    cursor.execute(create_table_query)

    for row in data:
        cursor.execute(
            '''
            INSERT INTO items (id, name, additional_info) VALUES (?, ?, ?)
            ON CONFLICT(id) DO UPDATE SET 
                name = excluded.name,
                additional_info = excluded.additional_info;
            ''',
            (row['id'], row['name'], row['additional_info'])
        )

    conn.commit()
    conn.close()



def main():
    file1_data = read_txt_file('Тестовый файл1.txt', delimiter=',')
    file2_data = read_txt_file('Тестовый файл2.txt', delimiter=';')

    merged_data = merge_and_sort(file1_data, file2_data)

    save_to_json(merged_data, 'result.json')
    
    save_to_database(merged_data, 'database.db')

if __name__ == "__main__":
    main()
