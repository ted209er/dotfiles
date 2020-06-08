# Cheatsheet

A reference document for me to use for commonly addressed settings and
configurations that I haven't quite memorized.

## VIM

Inserting comments to the end of a block of text:

```bash
C-v
Shift-}
Shift-i
#
Esc
```

To take comments out:

```bash
C-v
j # To where you want to uncomment
x
```

Copy and pasting a block of text:

```bash
# Move cursor to first line in block of text
y # To yank
} # To move to end of text block
# Move cursor to where you want to paste
p # To paste
```

Delete up till next character (usefull for deleting extra spaces due to
paste issues):

```bash
d W 
# or
d E
```

## Git

Generating a new SSH Key pair
```bash
ssh-keygen -t ed25519 -C "<comments, e.g. email address>"

# You'll see something similar to:
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/user/.ssh/id_ed25519):

# You can leave the default values and leave the password blank.
# A new public/private keypair will be generated in your home directory
# under ~/.ssh/
```

Adding your private key to the ssh-agent

```bash
# Start the ssh-agent in the background
$ eval $(ssh-agent -s)
> Agent pid 59566

# Add your Private key (the one that doesn't have .pub appended)
$ ssh-add ~/.ssh/id_ed25519

# Now you can add the public key to your github account.
```
