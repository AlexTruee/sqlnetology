import psycopg2 as ps


def create_db(conn, cur):
    cur.execute("""
        CREATE TABLE IF NOT EXISTS client(
            id SERIAL PRIMARY KEY,
            firstname VARCHAR(20),
            lastname VARCHAR(20),
            email VARCHAR(40) NOT NULL);
        """)
    cur.execute("""
        CREATE TABLE IF NOT EXISTS phone(
            id SERIAL PRIMARY KEY,
            client_id INTEGER NOT NULL REFERENCES client(id),
            phone VARCHAR(20) NOT NULL);
        """)
    conn.commit()


def add_client(cur, first_name, last_name, email, phone=None):
    if first_name is None or last_name is None or email is None:
        print('Не заполнено основное поле Имя/Фамилия/Почта')
        return

    cur.execute("""
        INSERT INTO client(firstname, lastname, email) VALUES(%s, %s, %s) RETURNING id, firstname;
        """, (first_name, last_name, email))
    new_client = cur.fetchone()
    if phone is not None:
        cur.execute("""
            INSERT INTO phone(client_id, phone) VALUES(%s, %s);
            """, (new_client[0], phone))
        # cur.fetchone() Почему при использовании выдает ошибку.
        # В тоже время без нее информация также доабвдяется в базу
    print(f'Добавили клиента {new_client[1]}')


def get_phone(cur, phone):
    cur.execute("""
        SELECT DISTINCT cl.firstname, cl.lastname, ph.phone
        FROM phone AS ph
        LEFT JOIN client cl ON cl.id = ph.client_id
        WHERE phone=%s;
        """, (phone,))
    get_phone = cur.fetchone()
    return get_phone


def add_phone(con, cur, client_id, phone):
    # Проверка телефона в БД
    find_phone = get_phone(cur, phone)
    if find_phone is not None:
        print(f'Такой номер уже существует "{find_phone[0]} {find_phone[1]}"')
    else:
        print(find_phone, phone)
        cur.execute("""
            INSERT INTO phone(client_id, phone) VALUES(%s, %s);
            """, (client_id, phone))
        con.commit()


def change_client(con, cur, client_id, first_name=None, last_name=None, email=None, phone=None):
    if first_name is not None:
        cur.execute("""
            UPDATE client SET firstname=%s WHERE id=%s
            """, (first_name, client_id))
    if last_name is not None:
        cur.execute("""
            UPDATE client SET lastname=%s WHERE id=%s
            """, (last_name, client_id))
    if email is not None:
        cur.execute("""
            UPDATE client SET email=%s WHERE id=%s
            """, (email, client_id))
    if phone is not None:
        add_phone(con, cur, client_id, phone)

    cur.execute("""
        SELECT * FROM client;
        """)
    cur.fetchall()


def delete_phone(cur, phone):
    cur.execute("""
        DELETE FROM phone WHERE phone=%s;
        """, (phone,))
    print('Телефон удален из БД')


def delete_client(cur, client_id):
    cur.execute("""
        DELETE FROM phone WHERE client_id=%s;
        """, (client_id,))
    cur.execute("""
        DELETE FROM client WHERE id=%s;
        """, (client_id,))
    print('Клиент удален из БД')


def find_client(cur, first_name=None, last_name=None, email=None, phone=None):
    if phone is not None:
        cur.execute("""
            SELECT cl.id, cl.firstname, cl.lastname FROM client cl
            JOIN phone ph ON ph.client_id = cl.id
            WHERE ph.phone=%s;
            """, (phone,))
    else:
        cur.execute("""
            SELECT id, firstname, lastname FROM client 
            WHERE firstname=%s OR lastname=%s OR email=%s;
            """, (first_name, last_name, email))

    print(cur.fetchall())


if __name__ == "__main__":
    with ps.connect(database='clients_db', user='postgres', password='root') as con:
        with con.cursor() as _cur:

            # create_db(con, _cur)

            # add_client(_cur, 'Иван', 'Иванов', 'iivanov@mail.com', '735222221434')
            # add_client(_cur, 'Мария', 'Дазон', 'mdazon@mail.com')
            # add_client(_cur, 'Крис', 'Кельми', 'criskel@mail.com', '+79227597389')
            # add_client(_cur, 'Вася', None, None)
            # add_client(_cur, 'Максим', 'Петров', 'mpetr@mail.com')

            # add_phone(con, _cur, '3', '234-45-45')
            # add_phone(con, _cur, '1', '+79227597389')

            # change_client(con, _cur, '3', 'Семен')
            # change_client(con, _cur, '11', None, None, 'criskel@gmail.com')
            # change_client(con, _cur, '12', None, None, None, '+7-999-345-76-76')

            # delete_phone(_cur, '234-45-45')
            # delete_phone(_cur, '1', '777-45-34')

            #delete_client(_cur, 10)

            # find_client(_cur, 'Мария')
            # find_client(_cur, None, None, 'mpetr@mail.com')
            # find_client(_cur, None, None, None, '+79227597389')



