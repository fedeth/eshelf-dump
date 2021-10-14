# README

This is an old dump of the dead startup eShelf. It could be helpful to scaffold new apps based on the same stack and features:  
- RoR
- Pure Vue injected compoents
- Devise gem based on multy entities auth system
- Postgres trigrams & TSvectors weighted research 
- Stripe payments
- Ajax API
- External API ( to AWS services: SES, S3... )
  

## Troubleshoots

### Solve psql version incompatibility error

```bash
$ sudo yum install -y bison-devel readline-devel zlib-devel openssl-devel wget
$ sudo yum groupinstall -y 'Development Tools'
$ wget http://ftp.postgresql.org/pub/source/xx.x.x/postgresql-xx.x.x.tar.bz2
$ bzip2 -d postgresql-xx.x.x.tar.bz2
$ tar -xvf postgresql-xx.x.x.tar
$ cd postgresql-xx.x.x
$ ./configure
$ gmake
$ sudo gmake install
# path = /usr/local/pgsql/bin/pg_dump

$ /usr/local/pgsql/bin/pg_dump -h eshelf-dev-db.cbfyvxgttlqi.eu-west-2.rds.amazonaws.com -U eshelf --no-owner ebdb | gzip > dump.sql.gz

$ scp -i ~/.ssh/ec2eshelistance.pem ec2-user@3.10.176.159:/var/app/dump.sql.gz /home/user/path/file/


# fedeth
```
