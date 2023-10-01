/usr/bin/env/python3

import sys
import argparse
from password_strength import PasswordStats

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

def analyze_password_strength(passwords):
    password_analysis = {}

    for password in passwords:
        stats = PasswordStats(password)
        password_analysis[password] = {
            'strength': stats.strength(),
            'length': stats.length,
            'numbers': stats.numbers,
            'nonletters': stats.length - stats.letters,
            'uppercase_letters': stats.letters_uppercase,
            'lowercase_letters': stats.letters_lowercase,
            'nonalphanumeric': stats.length - stats.letters - stats.numbers
        }

    return password_analysis

def output_to_file(file_path, content):
    with open(file_path, 'w') as file:
        file.write(content)

def main():
    parser = argparse.ArgumentParser(description='Process some passwords.')
    parser.add_argument('-i','--input_file_path', help='The path to the input file.')
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
        password_analysis = analyze_password_strength(recovered_passwords)
        for password, analysis in password_analysis.items():
            output += f'Password: {password}\n'
            output += f'Strength: {analysis["strength"]}\n'
            output += f'Length: {analysis["length"]}\n'
            output += f'Numbers: {analysis["numbers"]}\n'
            output += f'Non-letter characters: {analysis["nonletters"]}\n'
            output += f'Uppercase letters: {analysis["uppercase_letters"]}\n'
            output += f'Lowercase letters: {analysis["lowercase_letters"]}\n'
            output += f'Non-alphanumeric characters: {analysis["nonalphanumeric"]}\n'
            output += '\n'

    if args.output_file_path:
        output_to_file(args.output_file_path, output)
    else:
        print(output)

if __name__ == '__main__':
    main()
