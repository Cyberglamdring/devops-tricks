# DevOps Tips and Tricks

## AWS Login

1. Download script

```bash
curl -LO https://raw.githubusercontent.com/Cyberglamdring/devops-tricks/main/aws-sts-get-token.sh
```

2. Permisisons and Alias

```bash
chmod +x aws-sts-get-token.sh && alias awslogin="$HOME/aws-sts-get-token.sh"
```

3. Usage
```bash
awslogin
```