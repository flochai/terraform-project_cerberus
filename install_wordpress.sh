#!/bin/bash
set -euo pipefail

# ===== Required environment =====
: "${DB_HOST:?DB_HOST not set}"
: "${DB_NAME:?DB_NAME not set}"
: "${DB_USER:?DB_USER not set}"
: "${DB_PASSWORD:?DB_PASSWORD not set}"

WORDPRESS_DIR="/var/www/html"
APACHE_USER="apache"
APACHE_GROUP="apache"

# ===== Packages =====
yum update -y
yum install -y httpd wget unzip curl \
  php php-{common,cli,mbstring,gd,mysqlnd,xml,json,intl,zip,bcmath} \
  mysql

# ===== Services =====
systemctl enable --now httpd

# ===== Apache docroot prep =====
mkdir -p "$WORDPRESS_DIR"
chown -R ec2-user:$APACHE_GROUP /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 2775 {} \;
find /var/www -type f -exec chmod 0664 {} \;

# (Optional) phpinfo for quick sanity (delete later)
echo "<?php phpinfo(); ?>" > "$WORDPRESS_DIR/phpinfo.php"

# ===== Wait for RDS to be reachable =====
echo "Waiting for RDS at ${DB_HOST}..."
for i in {1..60}; do
  if mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "SELECT 1" >/dev/null 2>&1; then
    echo "RDS is reachable."
    break
  fi
  echo "RDS not reachable yet, retrying... ($i/60)"
  sleep 5
done

# ===== Create database if needed (using the provided user; on RDS this is typically the master user) =====
mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" \
  -e "CREATE DATABASE IF NOT EXISTS \`$DB_NAME\` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"

# ===== WordPress =====
cd /tmp
wget -q https://wordpress.org/latest.zip
unzip -q -o latest.zip
rsync -a wordpress/ "$WORDPRESS_DIR"/

# wp-config
if [[ ! -f "$WORDPRESS_DIR/wp-config.php" ]]; then
  cp "$WORDPRESS_DIR/wp-config-sample.php" "$WORDPRESS_DIR/wp-config.php"
fi

# Set DB settings (host is your RDS endpoint)
sed -i "s/database_name_here/$DB_NAME/" "$WORDPRESS_DIR/wp-config.php"
sed -i "s/username_here/$DB_USER/" "$WORDPRESS_DIR/wp-config.php"
sed -i "s/password_here/$DB_PASSWORD/" "$WORDPRESS_DIR/wp-config.php"
sed -i "s/localhost/$DB_HOST/" "$WORDPRESS_DIR/wp-config.php"

# Ensure modern charset
sed -i "s/define( *'DB_CHARSET'.*/define('DB_CHARSET', 'utf8mb4');/" "$WORDPRESS_DIR/wp-config.php"
sed -i "s/define( *'DB_COLLATE'.*/define('DB_COLLATE', '');/" "$WORDPRESS_DIR/wp-config.php"

# Add unique salts
WP_SALTS=$(curl -fsSL https://api.wordpress.org/secret-key/1.1/salt/ || true)
if [[ -n "$WP_SALTS" ]]; then
  perl -0777 -pe "s/define\('AUTH_KEY'.*?define\('NONCE_SALT'.*?;\n/$WP_SALTS\n/s" \
    -i "$WORDPRESS_DIR/wp-config.php"
fi

# Permissions for WP
chown -R ec2-user:$APACHE_GROUP "$WORDPRESS_DIR"
find "$WORDPRESS_DIR" -type d -exec chmod 755 {} \;
find "$WORDPRESS_DIR" -type f -exec chmod 644 {} \;

# Restart Apache
systemctl restart httpd

echo
echo "**************************************************************************************"
echo "***      WordPress installed. Using RDS at ${DB_HOST} (DB: ${DB_NAME}).            ***"
echo "**************************************************************************************"
echo