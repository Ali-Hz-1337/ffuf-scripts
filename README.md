
# ffuf-basic-auth

**ffuf-basic-auth** is a Bash script designed to generate `username:password` combinations for HTTP Basic Authentication. It is specifically built to work seamlessly with tools like [ffuf](https://github.com/ffuf/ffuf) for brute-force testing.

---

## Features

- Generate `username:password` combinations from:
  - A single username and a single password.
  - A list of usernames and a single password.
  - A single username and a list of passwords.
  - Two separate lists of usernames and passwords.
- Outputs combinations in a format compatible with tools like `ffuf`.
- Enables direct piping to `ffuf` for real-time brute-force testing.
- Includes error handling for common user input mistakes.

---

## Installation

### Prerequisites

Ensure the following tools are installed on your system:
- **Bash**: Installed by default on most Linux systems.
- **ffuf**: You can install it by following the [ffuf installation guide](https://github.com/ffuf/ffuf).

### Cloning the Repository

1. Clone the repository:
   ```bash
   git clone https://github.com/Ali-Hz-1337/ffuf-scripts.git
   ```
2. Navigate to the project directory:
   ```bash
   cd ffuf-scripts
   ```
3. Make the script executable:
   ```bash
   chmod +x ffuf-basic-auth.sh
   ```

---

## Usage

Run the script with the following syntax:

```bash
./ffuf_basicauth.sh -u <username> -p <password> -U <usernames.txt> -P <passwords.txt>
```

### Options

| Option | Description                                              |
|--------|----------------------------------------------------------|
| `-u`   | A single username.                                       |
| `-p`   | A single password.                                       |
| `-U`   | Path to the usernames wordlist file.                     |
| `-P`   | Path to the passwords wordlist file.                     |

### Example Commands

1. **Generate combinations from two wordlists:**

   ```bash
   ./ffuf_basicauth.sh -U usernames.txt -P passwords.txt
   ```

2. **Generate combinations from a single username and a password wordlist:**

   ```bash
   ./ffuf_basicauth.sh -u admin -P passwords.txt
   ```

3. **Generate combinations from a username wordlist and a single password:**

   ```bash
   ./ffuf_basicauth.sh -U usernames.txt -p password
   ```

4. **Generate a combination from a single username and a single password:**

   ```bash
   ./ffuf_basicauth.sh -u admin -p password
   ```

5. **Use the output directly with ffuf for brute-force testing:**

   ```bash
   ./ffuf_basicauth.sh -U usernames.txt -P passwords.txt | ffuf -w -:FUZZ -u https://example.com/login -H "Authorization: Basic FUZZ" -enc FUZZ:b64encode -c -mc all
   ```

---

## Output Format

The script generates output in the following format:

```
username1:password1
username1:password2
...
usernameN:passwordM
```

This format ensures compatibility with most tools that process `username:password` combinations.