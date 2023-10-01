#!/usr/bin/env/python3

import sys
import argparse

def parse_passwords(file_path):
    passwords = {}
    recovered_passwords = []

    with open(file_path, 'r') as file:
        for line in file:
            line = line.strip()
            parts = line.split(':')
            username = parts[0]
            password_hash = parts[1]
            password = parts[2] if len(parts) > 2 else None

            if password:
                recovered_passwords.append(password)

            if password_hash not in passwords:
                passwords[password_hash] = []
            passwords[password_hash].append(username)

    return passwords, recovered_passwords

def find_shared_passwords(passwords):
    shared_passwords = {}

    for password_hash, usernames in passwords.items():
        if len(usernames) > 1:
            shared_passwords[password_hash] = usernames

    return shared_passwords

def output_to_file(file_path, content):
    with open(file_path, 'w') as file:
        file.write(content)

def main():
    parser = argparse.ArgumentParser(description='Process some passwords.')
    parser.add_argument('-i','--input_file_path', required=True, help='The path to the input file.')
    parser.add_argument('-o', '--output_file_path', help='The path to the output file (optional).')

    args = parser.parse_args()

    file_path = args.input_file_path
    
    passwords, recovered_passwords = parse_passwords(file_path)

    output = 'Parsed passwords:\n'
    for password_hash, usernames in passwords.items():
        output += f'Password Hash: {password_hash}\n'
        output += f'Usernames:\n'
        for username in usernames:
            output += f'- {username}\n'
        output += '\n'

    shared_passwords = find_shared_passwords(passwords)

    output += 'Users with the same password:\n'
    for password_hash, usernames in shared_passwords.items():
        output += f'Password Hash: {password_hash}\n'
        output += f'Usernames:\n'
        for username in usernames:
            output += f'- {username}\n'
        output += '\n'

    output += 'Recovered passwords:\n'
    if len(recovered_passwords) == 0:
        output += 'No recovered passwords found.\n'
    else:
        for password in recovered_passwords:
            output += f'{password}\n'

    if args.output_file_path:
        output_to_file(args.output_file_path, output)
    else:
        print(output)

if __name__ == '__main__':
    main()
