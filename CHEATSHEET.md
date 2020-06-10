# Cheatsheet

A reference document for me to use for commonly addressed settings and
configurations that I haven't quite memorized.

## VIM

#### Inserting comments to the end of a block of text:

```bash
C-v
Shift-}
Shift-i
#
Esc
```

#### To take comments out:

```bash
C-v
j # To where you want to uncomment
x
```

#### Copy and pasting a block of text:

```bash
# Move cursor to first line in block of text
y # To yank
} # To move to end of text block
# Move cursor to where you want to paste
p # To paste
```

#### Delete up till next character (usefull for deleting extra spaces due to
paste issues):

```bash
d W 
# or
d E
```

#### Place you in insert mode at the right indentation

```bash
S
```

#### Jump to the matching bracket/brace

```bash
%
```

#### Indent or unindent a line

```bash
>> #Indents
<< #Unindents
```

#### Fix indentation in the whoe file

```bash
=G
```


## Git

#### Generating a new SSH Key pair

```bash
ssh-keygen -t ed25519 -C "<comments, e.g. email address>"

# You'll see something similar to:
Generating public/private ed25519 key pair.
Enter file in which to save the key (/home/user/.ssh/id_ed25519):

# You can leave the default values and leave the password blank.
# A new public/private keypair will be generated in your home directory
# under ~/.ssh/
```

#### Adding your private key to the ssh-agent

```bash
# Start the ssh-agent in the background
$ eval $(ssh-agent -s)
> Agent pid 59566

# Add your Private key (the one that doesn't have .pub appended)
$ ssh-add ~/.ssh/id_ed25519

# Now you can add the public key to your github account.
```

## openssl

#### Create a hash for a password

```bash
$ openssl passwd -1
Password:
Verifying - Password:
$1$Zab6uDzA$faRXjGkNPDQOraL9FCo/s1
```

#### View contents of PKI issued .crt

```bash
$ openssl x509 -in CA-R-1_Whole\ Foods\ Internal\ Root\ CA.crt -inform
DER -text
```

#### Convert der format to pem

```bash
$ openssl x509 -inform der -in CA-ISSUE4-I.cer -out CA-ISSUE4-I.pem
```

#### View content of .der certificate

```bash
$ openssl x509 -in CA-ISSUE4-I.cer -inform der -text
```

#### Convert p7b certs to der format

```bash
$ openssl pkcs7 -in <incert>.p7b -inform DER -out result.pem -print_certs
```

#### Convert pem and key to pfx

```bash
$ openssl pkcs12 -export -inkey your_private_key.key -in result.pem -name
my_name -out final_result.pfx
```

#### Look at content of pfx cert

```bash
$ openssl pkcs12 -info -in keyStore.pfx
```

#### Convert PFX to PEM

```bash
$ openssl pkcs12 -in certificate.pfx -out certificate.pem -nodes
```

#### Convert PEM to DER

```bash
$ openssl x509 -outform der -in certificate.pem -out certificate.der
```

#### PFX to cert and key

##### Export the private key:

```bash
$ openssl pkcs12 -in certname.pfx -nocerts -out key.pem -nodes
```

##### Export the certificate:

```bash
$ openssl pkcs12 -in certname.pfx -nokeys -out cert.pem
```

##### Remove the passphrase from the private key:

```bash
$ openssl rsa -in key.pem -out server.key
```

#### View output of .pem file

```bash
$ openssl x509 -in acs.qacafe.com.pem -text
```

#### Use openssl to connect to server and see certificates:

```bash
$ openssl s_client -showcerts -CAfile ESB-cerd1617-client-EMS.cert
-connect $(hostname):17233
```

#### Grab the certificate and place it into a file

```bash
$ openssl x509 -in <(openssl s_client -connect cerd1682:18090 -prexit
2>/dev/null) > cerd1682wfmpvt.crt
```

## Keystores and Keytool

#### Import a new certificate into the keystore

```bash
$ keytool -import -trustcacerts -keystore
$JAVA_HOME/jre/lib/security/cacerts -storepass changeit -alias Root
-import -file Trustedcaroot.txt
```

#### List the certs in a keystore

```bash
$ keytool -list -v -keystore $JAVA_HOME/jre/lib/security/cacerts
```

#### Delete a cert from a keystore

```bash
$ keytool -delete -alias aliasToRemove -keystore cacerts
```
