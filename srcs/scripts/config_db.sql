create user "USER"@"HOST" identified by "PASS";
grant all privileges on *.* to "USER"@"HOST";
flush privileges;
