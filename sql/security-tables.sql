-- Tables for e-mailed password reset links and login rate limiting.
-- Safe to run on an existing install.  If you use a table_prefix, adjust
-- the table names (e.g. gift_password_resets, gift_login_failures).

CREATE TABLE IF NOT EXISTS `password_resets` (
  `userid` int(11) NOT NULL,
  `token_hash` char(64) NOT NULL,
  `created` datetime NOT NULL,
  `expires` datetime NOT NULL,
  PRIMARY KEY (`userid`),
  UNIQUE KEY `token_hash` (`token_hash`)
);

CREATE TABLE IF NOT EXISTS `login_failures` (
  `id` int(11) NOT NULL auto_increment,
  `username` varchar(20) NOT NULL,
  `ip` varchar(45) NOT NULL,
  `attempted` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `username_attempted` (`username`, `attempted`),
  KEY `ip_attempted` (`ip`, `attempted`)
);
