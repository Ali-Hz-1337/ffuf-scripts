#!/bin/bash

#################################################################################
# Description:  Generate HTTP basic authentication username:password
#               credential combinations from provided wordlists or single inputs.
#               Designed for use with tools like ffuf for brute-force testing.
#################################################################################

# Function to display usage instructions
usage() {
    cat << EOF
Usage: $(basename "$0") -u <username> -p <password> -U <usernames.txt> -P <passwords.txt>

Options:
  -u    Single username
  -p    Single password
  -U    Path to the usernames wordlist file
  -P    Path to the passwords wordlist file

Examples:
  1. Generate combinations from two wordlists:
     ./$(basename "$0") -U usernames.txt -P passwords.txt

  2. Generate combinations from a single username and a password wordlist:
     ./$(basename "$0") -u admin -P passwords.txt

  3. Generate combinations from a username wordlist and a single password:
     ./$(basename "$0") -U usernames.txt -p password

  4. Generate combinations from a single username and a single password:
     ./$(basename "$0") -u admin -p password

Use with ffuf:
  ./$(basename "$0") -U usernames.txt -P passwords.txt | ffuf -w -:FUZZ -u https://example.com/login -H "Authorization: Basic FUZZ" -enc FUZZ:b64encode -c -mc all
EOF
    exit 1
}

# Parse command-line arguments
while getopts ":u:p:U:P:" opt; do
    case $opt in
        u) SINGLE_USERNAME="$OPTARG" ;;
        p) SINGLE_PASSWORD="$OPTARG" ;;
        U) USERNAME_WORDLIST="$OPTARG" ;;
        P) PASSWORD_WORDLIST="$OPTARG" ;;
        *) usage ;;
    esac
done

# Validate input arguments
if [[ -n "$SINGLE_USERNAME" && -n "$USERNAME_WORDLIST" ]]; then
    echo "Error: Provide either a single username (-u) or a username wordlist (-U), not both." >&2
    usage
fi

if [[ -n "$SINGLE_PASSWORD" && -n "$PASSWORD_WORDLIST" ]]; then
    echo "Error: Provide either a single password (-p) or a password wordlist (-P), not both." >&2
    usage
fi

if [[ -z "$SINGLE_USERNAME" && -z "$USERNAME_WORDLIST" ]]; then
    echo "Error: Either -u (single username) or -U (username wordlist) must be provided." >&2
    usage
fi

if [[ -z "$SINGLE_PASSWORD" && -z "$PASSWORD_WORDLIST" ]]; then
    echo "Error: Either -p (single password) or -P (password wordlist) must be provided." >&2
    usage
fi

# Check if files exist and are readable
if [[ -n "$USERNAME_WORDLIST" && ! -f "$USERNAME_WORDLIST" ]]; then
    echo "Error: Usernames file '$USERNAME_WORDLIST' not found or not readable." >&2
    exit 1
fi

if [[ -n "$PASSWORD_WORDLIST" && ! -f "$PASSWORD_WORDLIST" ]]; then
    echo "Error: Passwords file '$PASSWORD_WORDLIST' not found or not readable." >&2
    exit 1
fi

# Generate username:password combinations
if [[ -n "$USERNAME_WORDLIST" && -n "$PASSWORD_WORDLIST" ]]; then
    # echo "Generating combinations from username and password lists..."
    awk 'NR==FNR{user[NR]=$0; next} {for (i=1;i<=length(user);i++) {printf "%s:%s\n", user[i], $0}}' "$USERNAME_WORDLIST" "$PASSWORD_WORDLIST"
    elif [[ -n "$USERNAME_WORDLIST" && -n "$SINGLE_PASSWORD" ]]; then
    # echo "Generating combinations from username list and single password..."
    while read -r username; do
        printf "%s:%s\\n" "$username" "$SINGLE_PASSWORD"
    done < "$USERNAME_WORDLIST"
    elif [[ -n "$SINGLE_USERNAME" && -n "$PASSWORD_WORDLIST" ]]; then
    # echo "Generating combinations from single username and password list..."
    while read -r password; do
        printf "%s:%s\\n" "$SINGLE_USERNAME" "$password"
    done < "$PASSWORD_WORDLIST"
    elif [[ -n "$SINGLE_USERNAME" && -n "$SINGLE_PASSWORD" ]]; then
    # echo "Generating combination from single username and single password..."
    printf "%s:%s\\n" "$SINGLE_USERNAME" "$SINGLE_PASSWORD"
else
    echo "Error: Invalid combination of inputs. Check usage instructions." >&2
    usage
fi

exit 0