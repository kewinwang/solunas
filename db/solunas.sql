-- phpMyAdmin SQL Dump
-- version 2.6.3-pl1
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Erstellungszeit: 19. Februar 2007 um 15:03
-- Server Version: 4.1.13
-- PHP-Version: 5.0.4
--
-- Datenbank: `solunas_production`
--

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `addons`
--

CREATE TABLE `addons` (
  `id` int(10) NOT NULL auto_increment,
  `room_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  `name` varchar(255) NOT NULL default '',
  `price` double(5,2) NOT NULL default '0.00',
  `onetime` tinyint(1) NOT NULL default '0',
  `force_cart` tinyint(1) NOT NULL default '0',
  `per_person` tinyint(1) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `addons_contracts`
--

CREATE TABLE `addons_contracts` (
  `contract_id` int(11) NOT NULL default '0',
  `addon_id` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `contracts`
--

CREATE TABLE `contracts` (
  `id` int(10) NOT NULL auto_increment,
  `total` float(6,2) NOT NULL default '0.00',
  `arrival` date NOT NULL default '0000-00-00',
  `departure` date NOT NULL default '0000-00-00',
  `adults` int(3) NOT NULL default '0',
  `children` int(3) NOT NULL default '0',
  `cc_number` varchar(100) NOT NULL default '',
  `cc_expire_date` varchar(20) NOT NULL default '',
  `cc_cvv` varchar(10) NOT NULL default '',
  `room_id` int(10) NOT NULL default '0',
  `customer_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  `pending` smallint(1) NOT NULL default '0',
  `unconfirmed` smallint(1) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `customers`
--

CREATE TABLE `customers` (
  `id` int(10) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL default '',
  `street` varchar(200) NOT NULL default '',
  `city` varchar(100) NOT NULL default '',
  `zip` varchar(50) NOT NULL default '',
  `country` varchar(200) NOT NULL default '',
  `telefone` varchar(100) NOT NULL default '',
  `fax` varchar(100) NOT NULL default '',
  `email` varchar(100) NOT NULL default '',
  `user_id` int(10) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `documents`
--

CREATE TABLE `documents` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `name` varchar(200) NOT NULL default '',
  `rhtml` text NOT NULL,
  `created_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `documents_rooms`
--

CREATE TABLE `documents_rooms` (
  `document_id` int(11) NOT NULL default '0',
  `room_id` int(11) NOT NULL default '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `globalize_countries`
--

CREATE TABLE `globalize_countries` (
  `id` int(11) NOT NULL auto_increment,
  `code` char(2) default NULL,
  `english_name` varchar(255) default NULL,
  `date_format` varchar(255) default NULL,
  `currency_format` varchar(255) default NULL,
  `currency_code` char(3) default NULL,
  `thousands_sep` char(2) default NULL,
  `decimal_sep` char(2) default NULL,
  `currency_decimal_sep` char(2) default NULL,
  `number_grouping_scheme` varchar(255) default NULL,
  PRIMARY KEY  (`id`),
  KEY `globalize_countries_code_index` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `globalize_languages`
--

CREATE TABLE `globalize_languages` (
  `id` int(11) NOT NULL auto_increment,
  `iso_639_1` char(2) default NULL,
  `iso_639_2` char(3) default NULL,
  `iso_639_3` char(3) default NULL,
  `rfc_3066` varchar(255) default NULL,
  `english_name` varchar(255) default NULL,
  `english_name_locale` varchar(255) default NULL,
  `english_name_modifier` varchar(255) default NULL,
  `native_name` varchar(255) default NULL,
  `native_name_locale` varchar(255) default NULL,
  `native_name_modifier` varchar(255) default NULL,
  `macro_language` tinyint(1) default NULL,
  `direction` varchar(255) default NULL,
  `pluralization` varchar(255) default NULL,
  `scope` char(1) default NULL,
  PRIMARY KEY  (`id`),
  KEY `globalize_languages_iso_639_1_index` (`iso_639_1`),
  KEY `globalize_languages_iso_639_2_index` (`iso_639_2`),
  KEY `globalize_languages_iso_639_3_index` (`iso_639_3`),
  KEY `globalize_languages_rfc_3066_index` (`rfc_3066`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `globalize_translations`
--

CREATE TABLE `globalize_translations` (
  `id` int(11) NOT NULL auto_increment,
  `type` varchar(255) default NULL,
  `tr_key` varchar(255) default NULL,
  `table_name` varchar(255) default NULL,
  `item_id` int(11) default NULL,
  `facet` varchar(255) default NULL,
  `language_id` int(11) default NULL,
  `pluralization_index` int(11) default NULL,
  `text` text character set utf8 collate utf8_unicode_ci,
  PRIMARY KEY  (`id`),
  KEY `globalize_translations_tr_key_index` (`tr_key`,`language_id`),
  KEY `globalize_translations_table_name_index` (`table_name`,`item_id`,`language_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `notes`
--

CREATE TABLE `notes` (
  `id` int(10) NOT NULL auto_increment,
  `note` text NOT NULL,
  `customer_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `prices`
--

CREATE TABLE `prices` (
  `id` int(10) NOT NULL auto_increment,
  `price` text NOT NULL,
  `adults` int(2) NOT NULL default '0',
  `children` int(2) NOT NULL default '0',
  `room_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `properties`
--

CREATE TABLE `properties` (
  `id` int(10) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL default '',
  `city` varchar(255) NOT NULL default '',
  `country` varchar(255) NOT NULL default '',
  `user_id` int(10) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `rooms`
--

CREATE TABLE `rooms` (
  `id` int(10) NOT NULL auto_increment,
  `name` varchar(200) NOT NULL default '',
  `days_of_week` text NOT NULL,
  `minimum_stay` text NOT NULL,
  `property_id` int(10) NOT NULL default '0',
  `user_id` int(10) NOT NULL default '0',
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  KEY `fk_property_rooms` (`property_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Tabellenstruktur für Tabelle `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL default '',
  `hashed_password` varchar(40) default NULL,
  `admin` int(1) NOT NULL default '0',
  `homepage` varchar(255) NOT NULL default '',
  `email` varchar(255) NOT NULL default '',
  `datestring` varchar(20) NOT NULL default '',
  `currency` varchar(100) NOT NULL default '',
  `language` varchar(10) NOT NULL default '',
  `creditcard` tinyint(1) NOT NULL default '0',
  `header` text NOT NULL,
  `footer` text NOT NULL,
  `confirmed` smallint(1) NOT NULL default '0',
  `premium` smallint(1) NOT NULL default '0',
  `calendar_symbols` text NOT NULL,
  `calendar_colors` text NOT NULL,
  `created_at` timestamp NOT NULL default CURRENT_TIMESTAMP on update CURRENT_TIMESTAMP,
  `updated_at` timestamp NOT NULL default '0000-00-00 00:00:00',
  PRIMARY KEY  (`id`),
  UNIQUE KEY `name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

